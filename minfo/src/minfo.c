#include <pthread.h>
#include "hub.h"
#include "radio-msg.h"
#include "radio-receiver.h"
#include "radio-transmitter.h"

void* runRadioInThread(void* hub_void)
{
  Hub* hub = (Hub*)hub_void;
  runRadio(hub);
  pthread_exit(0);
}

int main()
{
  Hub* hub = newHub();
  pthread_t radioThread;
  pthread_create(&radioThread, 0, runRadioInThread, (void*)hub);
  int status = runHub(hub);
  if (status != 0) {
    RadioMsg msg;
    msg.type = RMSG_STOP;
    sendRadioMsg(msg);
  }
  // TODO: Get status from pthread
  pthread_join(radioThread, 0);
  return status;
}
