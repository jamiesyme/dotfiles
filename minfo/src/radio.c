#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>

#include "hub.h"
#include "radio.h"


Radio* newRadio()
{
  return 0;
}

void freeRadio(Radio* radio)
{
  free(radio);
}

void runRadio(Radio* radio, Hub* hub)
{
  int serverSocket = socket(PF_INET, SOCK_STREAM, 0);

  struct sockaddr_in serverAddr;
  serverAddr.sin_family = AF_INET;
  serverAddr.sin_port = htons(6006);
  serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");

  bind(serverSocket, (struct sockaddr*)&serverAddr, sizeof serverAddr);

  listen(serverSocket, 20);

  int quit = 0;
  while (quit == 0) {
    struct sockaddr_in clientAddr;
    socklen_t clientAddrSize = sizeof clientAddr;
    int clientSocket = accept(serverSocket,
                              (struct sockaddr*)&clientAddr,
                              &clientAddrSize);
    printf("Connected!\n");
    quit = 1;
  }
}
