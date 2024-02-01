from locust import HttpUser, task, between

class MyUser(HttpUser):
    wait_time = between(1, 3)  # Aguarda entre 1 e 3 segundos entre as tarefas

    @task
    def visit_homepage(self):
        self.client.get("/")
