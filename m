From: Zheng Huai Cheng <zhenghch@linux.vnet.ibm.com>
Subject: [PATCH][RESEND]multipath: Allow whitespace before or
 after exit and quit command in multipathd
Date: Mon, 14 Oct 2013 16:34:43 +0800
Message-ID: <1381739683.12659.1.camel@stefan.desktop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This problem is reported by IBM internal test team. 

In multipathd interactive mode, commands allow preceding and appending
whitespace while quit and exit do not. If we have whitespace before or
after quit|exit command, multipathd won't recognize exit and quit
command and exit the interactive mode. 

This patch provide support whitespace in the quit and exit command.

Signed-off-by: Zheng Huai Cheng <zhenghch@linux.vnet.ibm.com>
---
 multipathd/uxclnt.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index 4e3ed26..b0567bd 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -37,6 +37,29 @@ static void print_reply(char *s)
                putchar(*s++);
        }   
 }
+
+static int need_quit(char *str, size_t len)
+{
+       char *ptr, *start;
+       size_t trimed_len = len;
+
+       for (ptr = str; trimed_len && isspace(*ptr);
+               trimed_len--, ptr++)
+               ;
+
+       start = ptr;
+
+       for (ptr = str + len - 1; trimed_len && isspace(*ptr);
+               trimed_len--, ptr--)
+               ;
+
+       if ((trimed_len == 4 && !strncmp(start, "exit", 4)) ||
+            (trimed_len == 4 && !strncmp(start, "quit", 4)))
+               return 1;
+
+       return 0;
+}
+
 /*
  * process the client
  */  
@@ -56,9 +79,8 @@ static void process(int fd)
                        free(line);
                        continue;
                }   
-               if (!strncmp(line, "exit", 4) && llen == 4)
-                       break;
-               if (!strncmp(line, "quit", 4) && llen == 4)
+
+               if (need_quit(line, llen))
                        break;

                if (send_packet(fd, line, llen + 1) != 0) break;
-- 
1.7.9.5
