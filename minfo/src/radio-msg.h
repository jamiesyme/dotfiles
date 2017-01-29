#pragma once

typedef enum {
  RMSG_HIDE_ALL,
  RMSG_SHOW_ALL,
  RMSG_STOP
} RadioMsgType;

typedef struct RadioMsg {
  RadioMsgType type;
} RadioMsg;
