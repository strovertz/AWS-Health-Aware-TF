# Aplicação de AHA em AWS Accounts com terraform

## Descrição
O Aws Health Aware realiza a integração da saúde da sua infraestrutura com a entrega de notificações para serviços como Slack, Teams, Chimes e Email, automatizando a entrega em tempo real de falhas em serviços AWS.

## Implementação: 
O provisionamento da infraestrutura foi realizado através do terraform disponibilizado, algumas modificações podem ser realizadas para atender as necessidades individuais de cada organização.

Realizamos a aplicação do AWS Health Aware, utilizando o guia fornecido pela AWS, com a seguinte infraestrutura: 

![image](https://user-images.githubusercontent.com/74078237/205191386-7742cc91-8f04-403f-8dba-d83934f84a91.png)
<sub>Fonte:https://aws.amazon.com/blogs/mt/aws-health-aware-customize-aws-health-alerts-for-organizational-and-personal-aws-accounts/</sub>



## Implementação de envio de emails para contas individualmente:

Atualizações no código e criação de funções em Py para AWS Lambda

### To-do List:
- [x] Implementação e ajustes do TF
- [x] Ajuste das variáveis do ambiente
- [x] Teste de funcionamento da base do AHA 
- [x] Prototipação de entrega individual de incidentes (Json e Funções adicionais + cadastro de testes no SES)
- [x] Implementação e validação de funções adicionais para individual ("get_mail_list" - Após 9 dias de falha, funcuinou)
- [x] Implementação  de Json para comparação e criação de lista de mails de AccountID afetados e contato de cada um dos responsáveis por estas contas
- [ ] Validação da etapa anterior
- [ ] Implementação e verificação de emails de reais responsáveis por cada uma das contas definidas no monitoramento.
