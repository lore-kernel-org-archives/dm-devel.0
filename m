From: Wuchongyun <wu.chongyun@h3c.com>
Subject: multipath-tools: release uxsocket and resource when
	cancel thread
Date: Wed, 29 Nov 2017 09:35:44 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A3414FA363@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, Changwei Ge <ge.changwei@h3c.com>
List-Id: dm-devel.ids

Hi ,

Issue description: 
when multipathd initilaze and call uxsock_listen to create unix domain socket, but return -1 and the errno is 98 
and then the uxsock_listen return null. After multipathd startup we can't receive any multipathd commands to 
finish the new multipath creation anymore!

We found that uxlsnr thread's cleanup function not close the sockets and also not release the clients when 
cancel thread, the domain socket will be release by the system. In any special environment like themachine's 
load is very heavy, the system may not close the old domain socket when we try to create and bind the domain
socket may return 98 (Address already in use).

And also we make some experiments:
In uxsock_cleanup if we close the ux_sock first and then immdediately call ux_socket_listen to create new ux_sock
and initialization will be OK; If we don't close the ux_sock and call ux_socket_listen will return -1 and errno = 98.

So we believe that close uxsocket and release clients when cancel thread might making new starting multipathd 
thread can create uxsocket successfully, and might receiving multipathd commands properly.
And also this path can fix clients' memory leak.

Thanks,
Chongyun

Signed-off-by: wu chongyun <wu.chongyun@h3c.com>
---
multipathd/uxlsnr.c |   16 +++++++++++++++-
1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 98ac25a..de6950b 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -139,6 +139,20 @@ void check_timeout(struct timespec start_time, char *inbuf,

 void uxsock_cleanup(void *arg)
{
+       struct client *client_loop;
+       struct client *client_tmp;
+       int ux_sock = (int)arg;
+
+       /*
+       * no need to protect clients, 
+       * because all operations to clients are only from one thread(uxlsnr)
+       */
+       list_for_each_entry_safe(client_loop, client_tmp, &clients, node) {
+                dead_client(client_loop);
+       }
+
+       close(ux_sock);
+
       cli_exit();
       free_polls();
}
@@ -162,7 +176,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
                return NULL;
       }

-        pthread_cleanup_push(uxsock_cleanup, NULL);
+       pthread_cleanup_push(uxsock_cleanup, (void*)ux_sock);

        condlog(3, "uxsock: startup listener");
       polls = (struct pollfd *)MALLOC((MIN_POLLS + 1) * sizeof(struct pollfd));
-- 
1.7.9.5
