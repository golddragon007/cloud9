docker-system-prune:
  cmd.run:
    - name: docker system prune -a -f

docker-container-prune:
  cmd.run:
    - name: docker system prune -a -f

docker-volume-prune:
  cmd.run:
    - name: sudo docker volume prune -f