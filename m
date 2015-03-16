From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 54/78] multipathd: Use standard lists for CLI
	handling
Date: Mon, 16 Mar 2015 13:36:41 +0100
Message-ID: <1426509425-15978-55-git-send-email-hare@suse.de>
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

We already have standard list handling macros in list.h, so
we should be using them for CLI, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/list.h   |  2 ++
 libmultipath/uxsock.c |  2 +-
 multipathd/uxlsnr.c   | 40 ++++++++++++++++++++++++++--------------
 3 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/libmultipath/list.h b/libmultipath/list.h
index 7a3cf16..a0d8184 100644
--- a/libmultipath/list.h
+++ b/libmultipath/list.h
@@ -8,6 +8,8 @@
 #ifndef _LIST_H
 #define _LIST_H
 
+#include <stddef.h>
+
 /**
  * container_of - cast a member of a structure out to the containing structure
  *
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index af0798c..300d657 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -210,7 +210,7 @@ int recv_packet(int fd, char **buf, size_t *len, unsigned int timeout)
 	}
 	(*buf) = MALLOC(*len);
 	if (!*buf)
-		return -1;
+		return -ENOMEM;
 	ret = read_all(fd, *buf, *len, timeout);
 	if (ret != *len) {
 		FREE(*buf);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index f20982f..7b13190 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -39,11 +39,11 @@
 struct timespec sleep_time = {5, 0};
 
 struct client {
+	struct list_head node;
 	int fd;
-	struct client *next, *prev;
 };
 
-static struct client *clients;
+LIST_HEAD(clients);
 static unsigned num_clients;
 struct pollfd *polls;
 volatile sig_atomic_t reconfig_sig = 0;
@@ -67,10 +67,10 @@ static void new_client(int ux_sock)
 	/* put it in our linked list */
 	c = (struct client *)MALLOC(sizeof(*c));
 	memset(c, 0, sizeof(*c));
+	INIT_LIST_HEAD(&c->node);
 	c->fd = fd;
-	c->next = clients;
-	if (c->next) c->next->prev = c;
-	clients = c;
+
+	list_add_tail(&c->node, &clients);
 	num_clients++;
 }
 
@@ -80,9 +80,8 @@ static void new_client(int ux_sock)
 static void dead_client(struct client *c)
 {
 	close(c->fd);
-	if (c->prev) c->prev->next = c->next;
-	if (c->next) c->next->prev = c->prev;
-	if (c == clients) clients = c->next;
+	c->fd = -1;
+	list_del_init(&c->node);
 	FREE(c);
 	num_clients--;
 }
@@ -151,7 +150,7 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
 	sigdelset(&mask, SIGHUP);
 	sigdelset(&mask, SIGUSR1);
 	while (1) {
-		struct client *c;
+		struct client *c, *tmp;
 		int i, poll_count;
 
 		/*
@@ -168,9 +167,13 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
 		polls[0].events = POLLIN;
 
 		/* setup the clients */
-		for (i=1, c = clients; c; i++, c = c->next) {
+		i = 1;
+		list_for_each_entry(c, &clients, node) {
 			polls[i].fd = c->fd;
 			polls[i].events = POLLIN;
+			if (i > num_clients)
+				break;
+			i++;
 		}
 
 		/* most of our life is spent in this call */
@@ -191,12 +194,22 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
 			continue;
 
 		/* see if a client wants to speak to us */
-		for (i=1, c = clients; c; i++) {
-			struct client *next = c->next;
-
+		for (i = 1; i < num_clients + 1; i++) {
 			if (polls[i].revents & POLLIN) {
 				struct timeval start_time;
 
+				c = NULL;
+				list_for_each_entry(tmp, &clients, node) {
+					if (tmp->fd == polls[i].fd) {
+						c = tmp;
+						break;
+					}
+				}
+				if (!c) {
+					condlog(3, "cli%d: invalid fd %d",
+						i, polls[i].fd);
+					continue;
+				}
 				if (gettimeofday(&start_time, NULL) != 0)
 					start_time.tv_sec = 0;
 
@@ -223,7 +236,6 @@ void * uxsock_listen(int (*uxsock_trigger)(char *, char **, int *, void *),
 					FREE(inbuf);
 				}
 			}
-			c = next;
 		}
 
 		/* see if we got a new client */
-- 
1.8.4.5
