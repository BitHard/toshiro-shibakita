Docker: Utilização prática no cenário de Microsserviços
Denilson Bonatti, Instrutor - Digital Innovation One

Muito se tem falado de containers e consequentemente do Docker no ambiente de desenvolvimento. Mas qual a real função de um container no cenários de microsserviços? Qual a real função e quais exemplos práticos podem ser aplicados no dia a dia? Essas são algumas das questões que serão abordadas de forma prática pelo Expert Instructor Denilson Bonatti nesta Live Coding. IMPORTANTE: Agora nossas Live Codings acontecerão no canal oficial da dio._ no YouTube. Então, já corre lá e ative o lembrete! Pré-requisitos: Conhecimentos básicos em Linux, Docker e AWS.

Alterações
No projeto será criado um script (bash) para rodar todos os container. Inclusive como tem somente fins didáticos até o banco será incluído na inicialização do container e os valores neste caso não serão persistidos. O script sobe três containers e distribui as requisições e armazena no mesmo banco de dados. Comando para rodar e realizar inserções automáricas: "while true; do curl -s http://localhost:4500 && echo; sleep 1; done"