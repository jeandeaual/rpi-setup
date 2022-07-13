# Raspberry Pi Setup Tasks

## Dependencies

- Python
- [Poetry](https://python-poetry.org/docs/#installation)

## Pre-Requisites

To run the Ansible playbooks, first install the Ansible via Poetry, then install
the collections and roles dependencies:

```sh
poetry install --no-root --only=main
poetry run ansible-galaxy install -r requirements.yaml
poetry shell
```

## Tasks

- Setup the PoE HAT+ fan curves:

  ```sh
  ansible-playbook -i inventory/inventory.yaml playbooks/enable-poe-hat-plus.yaml
  ```

- Setup the PoE HAT+ fan curves:

  ```sh
  ansible-playbook -i inventory/inventory.yaml playbooks/enable-poe-hat.yaml
  ```

- Rename the default user, change the password and setup SSH key login:

  ```sh
  ansible-playbook -i inventory/inventory.yaml playbooks/rename-user.yaml
  ```

- Reboot all devices:

  ```sh
  ansible all -i inventory/inventory.yaml -m ansible.builtin.reboot --become
  ```

- Poweroff all devices:

  ```sh
  ansible all -i inventory/inventory.yaml -m community.general.shutdown --become
  ```
