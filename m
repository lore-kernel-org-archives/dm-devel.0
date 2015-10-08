From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 02/18] fix memory leaks on realloc failures
Date: Thu,  8 Oct 2015 14:44:35 -0500
Message-ID: <1444333491-16265-3-git-send-email-bmarzins@redhat.com>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
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

When realloc fails, it doesn't free the existing memory.  In many places,
multipath was just forgetting about that that memory. It needs to free
up the existing memory, or to reset back to using it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dmparser.c   |  6 ++++--
 multipath/main.c          |  9 ++++++---
 multipathd/cli_handlers.c | 50 +++++++++++++----------------------------------
 multipathd/uxlsnr.c       | 19 +++++++++++++++++-
 4 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 2562ba1..2209b2d 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -20,14 +20,16 @@
 static int
 merge_words (char ** dst, char * word, int space)
 {
-	char * p;
+	char * p = *dst;
 	int len;
 
 	len = strlen(*dst) + strlen(word) + space;
 	*dst = REALLOC(*dst, len + 1);
 
-	if (!*dst)
+	if (!*dst) {
+		free(p);
 		return 1;
+	}
 
 	p = *dst;
 
diff --git a/multipath/main.c b/multipath/main.c
index f62dcb1..d761621 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -395,7 +395,7 @@ out:
 static int
 dump_config (void)
 {
-	char * c;
+	char * c, * tmp = NULL;
 	char * reply;
 	unsigned int maxlen = 256;
 	int again = 1;
@@ -403,9 +403,12 @@ dump_config (void)
 	reply = MALLOC(maxlen);
 
 	while (again) {
-		if (!reply)
+		if (!reply) {
+			if (tmp)
+				free(tmp);
 			return 1;
-		c = reply;
+		}
+		c = tmp = reply;
 		c += snprint_defaults(c, reply + maxlen - c);
 		again = ((c - reply) == maxlen);
 		if (again) {
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index dc96c45..305cd7f 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -26,11 +26,14 @@
 #define REALLOC_REPLY(r, a, m)					\
 	do {							\
 		if ((a)) {					\
+			char *tmp = (r);			\
 			(r) = REALLOC((r), (m) * 2);		\
 			if ((r)) {				\
 				memset((r) + (m), 0, (m));	\
 				(m) *= 2;			\
 			}					\
+			else					\
+				free(tmp);			\
 		}						\
 	} while (0)
 
@@ -173,7 +176,7 @@ show_config (char ** r, int * len)
 	unsigned int maxlen = INITIAL_REPLY_LEN;
 	int again = 1;
 
-	reply = MALLOC(maxlen);
+	c = reply = MALLOC(maxlen);
 
 	while (again) {
 		if (!reply)
@@ -181,54 +184,29 @@ show_config (char ** r, int * len)
 		c = reply;
 		c += snprint_defaults(c, reply + maxlen - c);
 		again = ((c - reply) == maxlen);
-		if (again) {
-			reply = REALLOC(reply, maxlen * 2);
-			if (!reply)
-				return 1;
-			memset(reply + maxlen, 0, maxlen);
-			maxlen *= 2;
+		REALLOC_REPLY(reply, again, maxlen);
+		if (again)
 			continue;
-		}
 		c += snprint_blacklist(c, reply + maxlen - c);
 		again = ((c - reply) == maxlen);
-		if (again) {
-			reply = REALLOC(reply, maxlen * 2);
-			if (!reply)
-				return 1;
-			memset(reply + maxlen, 0, maxlen);
-			maxlen *= 2;
+		REALLOC_REPLY(reply, again, maxlen);
+		if (again)
 			continue;
-		}
 		c += snprint_blacklist_except(c, reply + maxlen - c);
 		again = ((c - reply) == maxlen);
-		if (again) {
-			reply = REALLOC(reply, maxlen * 2);
-			if (!reply)
-				return 1;
-			memset(reply + maxlen, 0, maxlen);
-			maxlen *= 2;
+		REALLOC_REPLY(reply, again, maxlen);
+		if (again)
 			continue;
-		}
 		c += snprint_hwtable(c, reply + maxlen - c, conf->hwtable);
 		again = ((c - reply) == maxlen);
-		if (again) {
-			reply = REALLOC(reply, maxlen * 2);
-			if (!reply)
-				return 1;
-			memset(reply + maxlen, 0, maxlen);
-			maxlen *= 2;
+		REALLOC_REPLY(reply, again, maxlen);
+		if (again)
 			continue;
-		}
 		c += snprint_overrides(c, reply + maxlen - c, conf->overrides);
 		again = ((c - reply) == maxlen);
-		if (again) {
-			reply = REALLOC(reply, maxlen * 2);
-			if (!reply)
-				return 1;
-			memset(reply + maxlen, 0, maxlen);
-			maxlen *= 2;
+		REALLOC_REPLY(reply, again, maxlen);
+		if (again)
 			continue;
-		}
 		if (VECTOR_SIZE(conf->mptable) > 0) {
 			c += snprint_mptable(c, reply + maxlen - c,
 					     conf->mptable);
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index 61ba49a..64bd35c 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -65,6 +65,10 @@ static void new_client(int ux_sock)
 		return;
 
 	c = (struct client *)MALLOC(sizeof(*c));
+	if (!c) {
+		close(fd);
+		return;
+	}
 	memset(c, 0, sizeof(*c));
 	INIT_LIST_HEAD(&c->node);
 	c->fd = fd;
@@ -151,6 +155,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 	sigdelset(&mask, SIGHUP);
 	sigdelset(&mask, SIGUSR1);
 	while (1) {
+		struct pollfd *new;
 		struct client *c, *tmp;
 		int i, poll_count, num_clients;
 
@@ -168,7 +173,19 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, void * trigger_data)
 		list_for_each_entry(c, &clients, node) {
 			num_clients++;
 		}
-		polls = REALLOC(polls, (1+num_clients) * sizeof(*polls));
+		new = REALLOC(polls, (1+num_clients) * sizeof(*polls));
+		/* If we can't allocate poliing space for the new client,
+		 * close it */
+		if (!new) {
+			if (!num_clients) {
+				condlog(1, "can't listen for new clients");
+				return NULL;
+			}
+			dead_client(list_entry(clients.prev,
+					       typeof(struct client), node));
+		}
+		else
+			polls = new;		
 		polls[0].fd = ux_sock;
 		polls[0].events = POLLIN;
 
-- 
1.8.3.1
