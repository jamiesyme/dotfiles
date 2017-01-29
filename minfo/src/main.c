#include "hub.h"
#include "radio.h"

int main()
{
  Hub* hub = newHub();
  // TODO: Run radio as thread
  //runRadio(hub);
  int status = runHub(hub);
  return status;
}
