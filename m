From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 31/57] multipathd: improve uxlsnr
Date: Wed, 27 Apr 2016 13:10:32 +0200
Message-ID: <1461755458-29225-32-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Improve uxlsnr by adding a lock around the poll structure and
not reallocating memory for every poll, thereby significantly
speedup processing.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 multipathd/main.c   |  6 ++--
 multipathd/uxlsnr.c | 84 +++++++++++++++++++++++++++++++----------------------
 2 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 61b82f6..c1b94bd 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -966,8 +966,10 @@ uevqloop (void * ap)
 static void *
 uxlsnrloop (void * ap)
 {
-	if (cli_init())
+	if (cli_init()) {
+		condlog(1, "Failed to init uxsock listener");
 		return NULL;
+	}
 
 	set_handler_callback(LIST+PATHS, cli_list_paths);
 	set_handler_callback(LIST+PATHS+FMT, cli_list_paths_fmt);
@@ -1278,7 +1280,7 @@ check_path (struct vectors * vecs, struct path * pp)
 		sysfs_attr_set_value(pp->udev, "uevent", "change",
 				     strlen("change"));
 		return 0;
-	} 
+	}
 
 	/*
 	 * provision a next check soonest,
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index e5c5d90..77efa8a 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -44,6 +44,8 @@ struct client {
 	int fd;
 };
 
+#define MIN_POLLS 1023
+
 LIST_HEAD(clients);
 pthread_mutex_t client_lock = PTHREAD_MUTEX_INITIALIZER;
 struct pollfd *polls;
@@ -133,6 +135,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 	char *inbuf;
 	char *reply;
 	sigset_t mask;
+	int old_clients = MIN_POLLS;
 
 	ux_sock = ux_socket_listen(DEFAULT_SOCKET);
 
@@ -142,20 +145,22 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 	}
 
 	if (!conf) {
-		condlog(1, "configuration changed");
+		condlog(1, "uxsock: configuration changed");
 		return NULL;
 	}
 
-	timeout = conf->uxsock_timeout;
-
 	pthread_cleanup_push(uxsock_cleanup, NULL);
 
-	polls = (struct pollfd *)MALLOC(0);
+	condlog(3, "uxsock: startup listener");
+	polls = (struct pollfd *)MALLOC(MIN_POLLS + 1);
+	if (!polls) {
+		condlog(0, "uxsock: failed to allocate poll fds");
+		return NULL;
+	}
 	pthread_sigmask(SIG_SETMASK, NULL, &mask);
 	sigdelset(&mask, SIGHUP);
 	sigdelset(&mask, SIGUSR1);
 	while (1) {
-		struct pollfd *new;
 		struct client *c, *tmp;
 		int i, poll_count, num_clients;
 
@@ -173,19 +178,25 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		list_for_each_entry(c, &clients, node) {
 			num_clients++;
 		}
-		new = REALLOC(polls, (1+num_clients) * sizeof(*polls));
-		/* If we can't allocate poliing space for the new client,
-		 * close it */
-		if (!new) {
-			if (!num_clients) {
-				condlog(1, "can't listen for new clients");
-				return NULL;
+		if (num_clients != old_clients) {
+			struct pollfd *new;
+			if (num_clients < MIN_POLLS) {
+				new = REALLOC(polls, (1 + MIN_POLLS) *
+						sizeof(struct pollfd));
+			} else {
+				new = REALLOC(polls, (1+num_clients) *
+						sizeof(struct pollfd));
 			}
-			dead_client(list_entry(clients.prev,
-					       typeof(struct client), node));
-		}
-		else
+			if (!new) {
+				pthread_mutex_unlock(&client_lock);
+				condlog(0, "%s: failed to realloc %d poll fds",
+					"uxsock", 1 + num_clients);
+				pthread_yield();
+				continue;
+			}
+			num_clients = old_clients;
 			polls = new;
+		}
 		polls[0].fd = ux_sock;
 		polls[0].events = POLLIN;
 
@@ -208,8 +219,8 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 			}
 
 			/* something went badly wrong! */
-			condlog(0, "poll");
-			pthread_exit(NULL);
+			condlog(0, "uxsock: poll failed with %d", errno);
+			break;
 		}
 
 		if (poll_count == 0)
@@ -230,7 +241,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 				}
 				pthread_mutex_unlock(&client_lock);
 				if (!c) {
-					condlog(3, "cli%d: invalid fd %d",
+					condlog(4, "cli%d: new fd %d",
 						i, polls[i].fd);
 					continue;
 				}
@@ -238,24 +249,27 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 					start_time.tv_sec = 0;
 				if (recv_packet(c->fd, &inbuf, timeout) != 0) {
 					dead_client(c);
-				} else {
-					condlog(4, "Got request [%s]", inbuf);
-					uxsock_trigger(inbuf, &reply, &rlen,
-						       trigger_data);
-					if (reply) {
-						if (send_packet(c->fd,
-								reply) != 0) {
-							dead_client(c);
-						}
-						condlog(4, "Reply [%d bytes]",
-							rlen);
-						FREE(reply);
-						reply = NULL;
+					continue;
+				}
+				condlog(4, "cli[%d]: Got request [%s]",
+					i, inbuf);
+				uxsock_trigger(inbuf, &reply, &rlen,
+					       trigger_data);
+				if (reply) {
+					if (send_packet(c->fd,
+							reply) != 0) {
+						dead_client(c);
+					} else {
+						condlog(4, "cli[%d]: "
+							"Reply [%d bytes]",
+							i, rlen);
 					}
-					check_timeout(start_time, inbuf,
-						      timeout);
-					FREE(inbuf);
+					FREE(reply);
+					reply = NULL;
 				}
+				check_timeout(start_time, inbuf,
+					      timeout);
+				FREE(inbuf);
 			}
 		}
 
-- 
2.6.6
