-- Registro de Equipamentos: esquema do banco (Supabase / Postgres)
-- Rode este arquivo uma vez em: Supabase > SQL Editor > New query > Run.
-- Pode ser rodado de novo sem apagar dados.

create table if not exists public.clientes (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  nome        text not null check (length(trim(nome)) > 0),
  perfil      text not null check (length(trim(perfil)) > 0),
  contato     text not null default '',
  observacao  text not null default '',
  criado_em   timestamptz not null default now()
);

-- Um mesmo usuário não repete o nome de um cliente (sem diferenciar maiúsculas).
create unique index if not exists clientes_nome_unico on public.clientes (user_id, lower(nome));

create table if not exists public.servicos (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null default auth.uid() references auth.users(id) on delete cascade,
  cliente_id     uuid not null references public.clientes(id) on delete restrict,
  os_num         bigint generated always as identity,
  equipamento    text not null check (length(trim(equipamento)) > 0),
  setor          text not null default '',
  orcamento      text not null check (orcamento in ('aprovado', 'recusado', 'analise')),
  prazo          text not null check (prazo in ('curto', 'normal')),
  dependencia    text not null check (dependencia in ('sim', 'nao')),
  cadeia         jsonb not null,   -- ocorrências, serviços e peças marcados
  criado_em      timestamptz not null default now(),
  atualizado_em  timestamptz not null default now()
);

create index if not exists servicos_cliente_idx on public.servicos (cliente_id);
create index if not exists servicos_user_idx on public.servicos (user_id);

-- Acesso: cada usuário enxerga e altera somente o que é dele.
alter table public.clientes enable row level security;
alter table public.servicos enable row level security;

revoke all on public.clientes, public.servicos from anon;
grant select, insert, update, delete on public.clientes, public.servicos to authenticated;

drop policy if exists clientes_select on public.clientes;
drop policy if exists clientes_insert on public.clientes;
drop policy if exists clientes_update on public.clientes;
drop policy if exists clientes_delete on public.clientes;

create policy clientes_select on public.clientes for select to authenticated
  using (user_id = (select auth.uid()));
create policy clientes_insert on public.clientes for insert to authenticated
  with check (user_id = (select auth.uid()));
create policy clientes_update on public.clientes for update to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy clientes_delete on public.clientes for delete to authenticated
  using (user_id = (select auth.uid()));

drop policy if exists servicos_select on public.servicos;
drop policy if exists servicos_insert on public.servicos;
drop policy if exists servicos_update on public.servicos;
drop policy if exists servicos_delete on public.servicos;

create policy servicos_select on public.servicos for select to authenticated
  using (user_id = (select auth.uid()));
-- Ao gravar, o cliente informado precisa ser do mesmo usuário.
create policy servicos_insert on public.servicos for insert to authenticated
  with check (
    user_id = (select auth.uid())
    and exists (select 1 from public.clientes c where c.id = cliente_id and c.user_id = (select auth.uid()))
  );
create policy servicos_update on public.servicos for update to authenticated
  using (user_id = (select auth.uid()))
  with check (
    user_id = (select auth.uid())
    and exists (select 1 from public.clientes c where c.id = cliente_id and c.user_id = (select auth.uid()))
  );
create policy servicos_delete on public.servicos for delete to authenticated
  using (user_id = (select auth.uid()));
