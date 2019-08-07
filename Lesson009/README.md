PS V:\vbox\ansible-web> vagrant status
Current machine states:

ansible                   running (virtualbox)
web                       running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
PS V:\vbox\ansible-web> vagrant ssh ansible
[vagrant@ansible ~]$ ansible -m ping all
 [WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

[vagrant@ansible ~]$ cd ansible/
[vagrant@ansible ansible]$ ansible -m ping all
web | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}


[vagrant@ansible ansible]$ ansible-playbook nginx.yml

PLAY [NGINX | Install and configure NGINX] *****************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************
ok: [web]

TASK [NGINX | Install EPEL Repo package from standart repo] ************************************************************************************
changed: [web]

TASK [NGINX | Install NGINX package from EPEL Repo] ********************************************************************************************
changed: [web]

TASK [NGINX | Create NGINX config file from template] ******************************************************************************************
changed: [web]

RUNNING HANDLER [restart nginx] ****************************************************************************************************************
changed: [web]

RUNNING HANDLER [reload nginx] *****************************************************************************************************************
changed: [web]

PLAY RECAP *************************************************************************************************************************************
web                        : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[vagrant@ansible ansible]$
