#include "radio-msg.h"
#include "radio-transmitter.h"

int main()
{
  RadioMsg msg;
  msg.type = RMSG_STOP;
  sendRadioMsg(msg);

  return 0;
}
