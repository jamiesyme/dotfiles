#include <arpa/inet.h>
#include <errno.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#include "hub.h"
#include "radio-msg.h"
#include "radio-receiver.h"

int readBytes(int sockFd, unsigned int min, void* buffer);

void runRadio(Hub* hub)
{
  int serverSocket;
  int clientSocket;
  struct sockaddr_in serverAddr;
  struct sockaddr_in clientAddr;
  socklen_t clientAddrSize;
  int quit;
  RadioMsg msg;

  serverSocket = socket(PF_INET, SOCK_STREAM, 0);

  serverAddr.sin_family = AF_INET;
  serverAddr.sin_port = htons(6006);
  serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");

  bind(serverSocket, (struct sockaddr*)&serverAddr, sizeof serverAddr);

  listen(serverSocket, 20);

  quit = 0;
  while (quit == 0) {
    clientAddrSize = sizeof clientAddr;
    clientSocket = accept(serverSocket,
                          (struct sockaddr*)&clientAddr,
                          &clientAddrSize);
    if (readBytes(clientSocket, sizeof msg.type, (void*)msg.type) != 0) {
      close(clientSocket);
      continue;
    }

    switch (msg.type) {
    case RMSG_SHOW_ALL:
      printf("showing all\n");
      showHubModules(hub);
      break;

    case RMSG_HIDE_ALL:
      printf("hiding all\n");
      hideHubModules(hub);
      break;

    case RMSG_STOP:
      printf("stopping\n");
      stopHub(hub);
      quit = 1;
      break;

    default:
      printf("unknown msg type - %i - ignoring\n", msg.type);
    }

    close(clientSocket);
  }

  close(serverSocket);
}

int readBytes(int sockFd, unsigned int min, void* buffer)
{
  int bytesRead = 0;
  int result;
  while (bytesRead < min) {
    result = read(sockFd, buffer + bytesRead, min - bytesRead);
    if (result < 1) {
      if (result == 0) {
        printf("failed to read from socket - socket closed\n");
        return 1;
      } else {
        printf("failed to read from socket - %i\n", errno);
        return 2;
      }
    }
    bytesRead += result;
  }
  return 0;
}
