From: Wuchongyun <wu.chongyun@h3c.com>
Subject: [PATCH V4] multipathd: release uxsocket and resource
 when cancel thread
Date: Wed, 17 Jan 2018 02:33:00 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A342958024@H3CMLB14-EX.srv.huawei-3com.com>
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
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: Guozhonghua <guozhonghua@h3c.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>
List-Id: dm-devel.ids

Issue description: we meet this issue: when multipathd initilaze and
call uxsock_listen to create unix domain socket, but return -1 and
the errno is 98 and then the uxsock_listen return null. After multipathd
startup we can't receive any user's multipathd commands to finish the
new multipath creation or any operations any more!

We found that uxlsnr thread's cleanup function not close the sockets
also not release the clients when cancel thread, the domain socket
will be release by the system. In any special environment like the
machine's load is very heavy or any situations, the system may not close
the old domain socket when we try to create and bind the new domain
socket may return errno:98(Address already in use).

And also we make some experiments:
in uxsock_cleanup if we close the ux_sock first and then immdediately
call ux_socket_listen to create new ux_sock and initialization will be
OK; if we don't close the ux_sock and call ux_socket_listen will return
-1 and errno = 98.

So we believe that close uxsocket and release clients  when cancel
thread can make sure of that new starting multipathd thread can
create new uxsocket successfully, also can receive multipathd commands
properly. And this path can fix clients' memory leak too.

Signed-off-by: Chongyun Wu <wu.chongyun@h3c.com>
---
 multipathd/uxlsnr.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 98ac25a..79e5b58 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -102,14 +102,21 @@ static void new_client(int ux_sock)
 /*
  * kill off a dead client
  */
-static void dead_client(struct client *c)
+static void _dead_client(struct client *c)
 {
-	pthread_mutex_lock(&client_lock);
+	int fd = c->fd;
 	list_del_init(&c->node);
-	pthread_mutex_unlock(&client_lock);
-	close(c->fd);
 	c->fd = -1;
 	FREE(c);
+	close(fd);
+}
+
+static void dead_client(struct client *c)
+{
+	pthread_cleanup_push(cleanup_lock, &client_lock);
+	pthread_mutex_lock(&client_lock);
+	_dead_client(c);
+	pthread_cleanup_pop(1);
 }
 
 void free_polls (void)
@@ -139,6 +146,18 @@ void check_timeout(struct timespec start_time, char *inbuf,
 
 void uxsock_cleanup(void *arg)
 {
+	struct client *client_loop;
+	struct client *client_tmp;
+	int ux_sock = (int)arg;
+
+	pthread_mutex_lock(&client_lock);
+	list_for_each_entry_safe(client_loop, client_tmp, &clients, node) {
+		_dead_client(client_loop);
+	}
+	pthread_mutex_unlock(&client_lock);
+
+	close(ux_sock);
+
 	cli_exit();
 	free_polls();
 }
@@ -162,7 +181,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		return NULL;
 	}
 
-	pthread_cleanup_push(uxsock_cleanup, NULL);
+	pthread_cleanup_push(uxsock_cleanup, (void *)ux_sock);
 
 	condlog(3, "uxsock: startup listener");
 	polls = (struct pollfd *)MALLOC((MIN_POLLS + 1) * sizeof(struct pollfd));
@@ -300,6 +319,5 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 	}
 
 	pthread_cleanup_pop(1);
-	close(ux_sock);
 	return NULL;
 }
-- 
1.7.9.5
