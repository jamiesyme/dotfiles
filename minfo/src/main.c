#include "hub.h"
#include "radio.h"

int main()
{
  Hub* hub = newHub();
  //int status = runHub(hub);
  //if (status != 0) {
  //  return status;
  //}
  Radio* radio = newRadio();
  runRadio(radio, hub);
  return 0;
}
