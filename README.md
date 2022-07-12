# Dependencies

- Python
- [Poetry](https://python-poetry.org/docs/#installation)

# Pre-Requisites

To run the Ansible playbooks, first install the collections and roles dependencies:

```sh
poetry run ansible-galaxy install -r requirements.yaml
```

# Tasks

- Setup the PoE HAT+ fan curves:

    ```sh
    poetry run ansible-playbook -i inventory/inventory.yaml playbooks/enable-poe-hat-plus.yaml
    ```

- Setup the PoE HAT+ fan curves:

    ```sh
    poetry run ansible-playbook -i inventory/inventory.yaml playbooks/enable-poe-hat.yaml
    ```

- Rename the default user, change the password and setup SSH key login:

    ```sh
    poetry run ansible-playbook -i inventory/inventory.yaml playbooks/rename-user.yaml
    ```
