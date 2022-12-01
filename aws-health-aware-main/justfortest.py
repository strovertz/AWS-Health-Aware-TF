import json
def get_mail_list(affected_org_accounts):
    mail_list = []
    account_list = []
    accounts = affected_org_accounts
    a = "'[]"
    print("\nLer aqui4: %s", accounts)
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
    #teste.append("gleison.pires@compasso.com.br")
    return mail_list

affected_org_accounts = ['account_idX', 'account_idY', 'account_idZ']
get_mail_list(affected_org_accounts)