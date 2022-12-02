# Aplicação de AHA em AWS Accounts com terraform

## Descrição
O Aws Health Aware realiza a integração da saúde da sua infraestrutura com a entrega de notificações para serviços como Slack, Teams, Chimes e Email, automatizando a entrega em tempo real de falhas em serviços AWS.

## Implementação: 
O provisionamento da infraestrutura foi realizado através do terraform disponibilizado, algumas modificações podem ser realizadas para atender as necessidades individuais de cada organização.

>O "FROM = os.environ["FROM_EMAIL"]" que encaminha os avisos é definido nas variáveis de ambiente da função lambda. <br>
>Já o RECIPIENT foi implementado com uma fução alternativa que ainda está em melhoria para atender as necessidades individuais do ambiente.

Realizamos a aplicação do AWS Health Aware, utilizando o guia fornecido pela AWS, com a seguinte infraestrutura: 

![image](https://user-images.githubusercontent.com/74078237/205191386-7742cc91-8f04-403f-8dba-d83934f84a91.png)
<sub>Fonte:https://aws.amazon.com/blogs/mt/aws-health-aware-customize-aws-health-alerts-for-organizational-and-personal-aws-accounts/</sub>



## Implementação de envio de emails para contas individualmente:

Foi realizada a implementação de uma função que retorna uma lista de email com base nas contas da organização que foram afetadas com a issue 
```python
def get_mail_list(affected_org_accounts):
    mail_list = []
    account_list = []
    accounts = affected_org_accounts
    a = "'[]"
    with open('mail_list.json') as file:
        data = json.load(file)
    for i in data['clientes']:
        for j in accounts:
            if j == i:
                b = data['clientes'][j]['recipients']
                for l in b:
                    for k in range(0,len(b)):
                        l =l.replace(a[k],"")
                    mail_list.append(str(l))
                account_list.append(j)
    print(mail_list)
    #teste = []
    #teste.append("none@domain.com.br")
    return mail_list
```
Json Exemplo:
```json
{
"clientes": {
    "account_idX": {
        "recipients": [
            "email1" 
        ]
    },
    "account_idY": {
        "recipients" : [
                "email2"
            ]
        },
    "account_idZ": {
        "recipients" : [
                "email3"
            ]
        }        
    }
}
```
A função que encaminha os emails recebe em RECIPIENT uma lista de mails retornada pela função e realiza os devidos encaminhamentos, estou estudando e implementando uma função que encaminha o email para cada ID corretamente relacionando o email com o id, a principio acredito que devo implementar uma segunda lista e realizar o encaminhamento a partir de cada um dos indices.

### To-do List:
- [x] Implementação e ajustes do TF
- [x] Ajuste das variáveis do ambiente
- [x] Teste de funcionamento da base do AHA 
- [x] Prototipação de entrega individual de incidentes (Json e Funções adicionais + cadastro de testes no SES)
- [x] Implementação e validação de funções adicionais para individual ("get_mail_list" - Após 9 dias de falha, funcuinou)
- [x] Implementação  de Json para comparação e criação de lista de mails de AccountID afetados e contato de cada um dos responsáveis por estas contas
- [ ] Validação da etapa anterior
- [ ] Implementação e verificação de emails de reais responsáveis por cada uma das contas definidas no monitoramento.
