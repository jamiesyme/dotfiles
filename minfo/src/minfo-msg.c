#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>

int main()
{
  int sock = socket(PF_INET, SOCK_STREAM, 0);

  struct sockaddr_in addr;
  addr.sin_family = AF_INET;
  addr.sin_port = htons(6006);
  addr.sin_addr.s_addr = inet_addr("127.0.0.1");

  connect(sock, (struct sockaddr*)&addr, sizeof addr);

  return 0;
}