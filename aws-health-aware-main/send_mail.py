import json
#import boto3

def get_mail_list(affected_org_accounts):
    mail_list = []
    account_list = []
    lista = affected_org_accounts
    with open('mail_list.json') as file:
        data = json.load(file)
    for i in data['clientes']:
        for qtd in lista:
            if i == qtd: 
                mail_list.append(data['clientes'][qtd]['recipients'])
                account_list.append(qtd)
    print(mail_list)
    return mail_list
