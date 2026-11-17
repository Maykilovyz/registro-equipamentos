# Registro de Equipamentos

Interface web para registro de equipamentos em manutenção, organizada por cliente.

- **Serviços:** lista de todos os registros, com filtros por cliente, prioridade e orçamento.
- **Clientes:** criação e edição de perfis; cada perfil tem seus próprios registros.
- **Registro em 4 etapas:** Ocorrências, Serviços, Peças e Orçamento (Aprovado, Recusado, Análise).
- **Prioridade de atendimento:** definida pelo prazo do local e pela dependência do equipamento (Prioridade 1 a 4).
- **Sugestões de apoio:** rascunhos opcionais por palavra-chave, sempre revisados pelo operador.

## Banco de dados e login (Supabase)

Com o Supabase configurado, o sistema pede e-mail e senha e grava clientes e serviços no Postgres. Cada conta vê somente os próprios dados (regras de acesso por linha, em `supabase/schema.sql`).

1. Crie um projeto em supabase.com (plano gratuito basta).
2. Em **SQL Editor**, rode o conteúdo de `supabase/schema.sql`.
3. Em **Project Settings > API**, copie a *Project URL* e a chave *anon/publishable*.
4. Cole os dois valores em `SUPABASE_URL` e `SUPABASE_KEY`, no início do script do `index.html`.

A chave anon é pública por desenho; quem protege os dados são as regras do banco. Nunca coloque a chave `service_role` no `index.html`.

Sem essas duas linhas preenchidas, o sistema abre em **modo local**: funciona, mas não salva nada.

## Limitações

- Cada conta é isolada: não há compartilhamento de dados entre contas diferentes.
- O banco devolve até 1000 registros por consulta (limite padrão do Supabase).

## Uso

Página única (`index.html`), sem dependências de build. Abra o arquivo no navegador ou acesse a versão publicada no GitHub Pages.
