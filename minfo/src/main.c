#include "hub.h"

int main()
{
  Hub* hub = newHub();
  int status = runHub(hub);
  if (status != 0) {
    return status;
  }
  return 0;
}
