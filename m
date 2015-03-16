From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 56/78] multipathd: lock cli client list
Date: Mon, 16 Mar 2015 13:36:43 +0100
Message-ID: <1426509425-15978-57-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/uxlsnr.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 550dcc4..61ba49a 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -44,7 +44,7 @@ struct client {
 };
 
 LIST_HEAD(clients);
-static unsigned num_clients;
+pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
 struct pollfd *polls;
 volatile sig_atomic_t reconfig_sig = 0;
 volatile sig_atomic_t log_reset_sig = 0;
@@ -64,14 +64,15 @@ static void new_client(int ux_sock)
 	if (fd == -1)
 		return;
 
-	/* put it in our linked list */
 	c = (struct client *)MALLOC(sizeof(*c));
 	memset(c, 0, sizeof(*c));
 	INIT_LIST_HEAD(&c->node);
 	c->fd = fd;
 
+	/* put it in our linked list */
+	pthread_mutex_lock(&client_lock);
 	list_add_tail(&c->node, &clients);
-	num_clients++;
+	pthread_mutex_unlock(&client_lock);
 }
 
 /*
@@ -79,11 +80,12 @@ static void new_client(int ux_sock)
  */
 static void dead_client(struct client *c)
 {
+	pthread_mutex_lock(&client_lock);
+	list_del_init(&c->node);
+	pthread_mutex_unlock(&client_lock);
 	close(c->fd);
 	c->fd = -1;
-	list_del_init(&c->node);
 	FREE(c);
-	num_clients--;
 }
 
 void free_polls (void)
@@ -150,7 +152,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 	sigdelset(&mask, SIGUSR1);
 	while (1) {
 		struct client *c, *tmp;
-		int i, poll_count;
+		int i, poll_count, num_clients;
 
 		/*
 		 * Store configuration timeout;
@@ -161,6 +163,11 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 			timeout = conf->uxsock_timeout;
 
 		/* setup for a poll */
+		pthread_mutex_lock(&client_lock);
+		num_clients = 0;
+		list_for_each_entry(c, &clients, node) {
+			num_clients++;
+		}
 		polls = REALLOC(polls, (1+num_clients) * sizeof(*polls));
 		polls[0].fd = ux_sock;
 		polls[0].events = POLLIN;
@@ -170,10 +177,9 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		list_for_each_entry(c, &clients, node) {
 			polls[i].fd = c->fd;
 			polls[i].events = POLLIN;
-			if (i > num_clients)
-				break;
 			i++;
 		}
+		pthread_mutex_unlock(&client_lock);
 
 		/* most of our life is spent in this call */
 		poll_count = ppoll(polls, i, &sleep_time, &mask);
@@ -198,12 +204,14 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 				struct timeval start_time;
 
 				c = NULL;
+				pthread_mutex_lock(&client_lock);
 				list_for_each_entry(tmp, &clients, node) {
 					if (tmp->fd == polls[i].fd) {
 						c = tmp;
 						break;
 					}
 				}
+				pthread_mutex_unlock(&client_lock);
 				if (!c) {
 					condlog(3, "cli%d: invalid fd %d",
 						i, polls[i].fd);
-- 
1.8.4.5
