# Registro de Equipamentos

Interface web para registro de equipamentos em manutenção, organizada por cliente.

- **Serviços:** lista de todos os registros, com filtros por cliente, prioridade e orçamento.
- **Clientes:** criação e edição de perfis; cada perfil tem seus próprios registros.
- **Registro em 4 etapas:** Ocorrências, Serviços, Peças e Orçamento (Aprovado, Recusado, Análise).
- **Prioridade de atendimento:** definida pelo prazo do local e pela dependência do equipamento (Prioridade 1 a 4).
- **Sugestões de apoio:** rascunhos opcionais por palavra-chave, sempre revisados pelo operador.

## Limitações

- Sem banco de dados: os dados ficam em memória e somem ao recarregar a página.
- Sem login real: "Entrar" em um perfil apenas seleciona o cliente.

## Uso

Página única (`index.html`), sem dependências de build. Abra o arquivo no navegador ou acesse a versão publicada no GitHub Pages.
