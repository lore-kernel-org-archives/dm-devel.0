From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: StorageWorks multipath support
Date: Sat, 18 Jun 2005 19:35:12 +0200
Message-ID: <1119116112.1515.59.camel@zezette>
References: <20050615085634.GA16446@averon.dyndns.org>
	<20050615131520.GC11423@marowsky-bree.de>
	<20050615134536.GC16446@averon.dyndns.org>
	<20050615135337.GG11423@marowsky-bree.de>
	<20050615140740.GD16446@averon.dyndns.org>
	<20050615142052.GT4195@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ubR7AQNTwwB6qZBElFN4"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050615142052.GT4195@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--=-ubR7AQNTwwB6qZBElFN4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On mer, 2005-06-15 at 15:20 +0100, Alasdair G Kergon wrote:
> On Wed, Jun 15, 2005 at 04:07:40PM +0200, christophe varoqui wrote:
> > Can you elaborate on what you have in mind ?
>  
> Listen on a socket in the filesystem?  [cf. what screen does]
> And have a separate helper program that sends messages down it
> similar to the uevent messages.
> 
Would the following do what you want ?

The client is wrapped in the daemon.
You can call it through :
- multipathd -k"$cmd" : one shot
- multipathd -k : interactive

The synthax is somewhat rude :/

- lp : list paths
- lm : list maps
- ap $path : add path checker, $path is in the "sdb" form
- rp $path : remove path checker
- am $map : add map event thread, $map is in the "dm-0" form
- rm $map : remove map event thread

For your pleasure, here is a sample session ...

xa-s05:~/scm/test/multipathd# ./multipathd -k
lp

       sdc: state 2,   2/ 28 XX..........................
       sde: state 2,   2/ 28 XX..........................
       sdb: state 2,   9/ 28 XXXXXXXXX...................
       sdd: state 2,  27/ 28 XXXXXXXXXXXXXXXXXXXXXXXXXXX.

rp sdd
ok

lp

       sdc: state 2,  18/ 28 XXXXXXXXXXXXXXXXXX..........
       sde: state 2,  18/ 28 XXXXXXXXXXXXXXXXXX..........
       sdb: state 2,  25/ 28 XXXXXXXXXXXXXXXXXXXXXXXXX...

ap sdd
ok

lp

       sdc: state 2,  12/ 28 XXXXXXXXXXXX................
       sde: state 2,  12/ 28 XXXXXXXXXXXX................
       sdb: state 2,  19/ 28 XXXXXXXXXXXXXXXXXXX.........
       sdd: state 2,   7/  7 XXXXXXX



Let me know if I should commit this as a foundation.

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

--=-ubR7AQNTwwB6qZBElFN4
Content-Disposition: attachment; filename=uxsock.patch
Content-Type: text/x-patch; name=uxsock.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

libmultipath/Makefile: needs update
libmultipath/dmparser.c: needs update
libmultipath/util.c: needs update
libmultipath/util.h: needs update
multipathd/Makefile: needs update
multipathd/main.c: needs update
Index: libmultipath/Makefile
===================================================================
--- 3675ec950a3806374cce8caa81ff064c0513b382/libmultipath/Makefile  (mode:100644)
+++ uncommitted/libmultipath/Makefile  (mode:100644)
@@ -10,7 +10,7 @@
        hwtable.o blacklist.o util.o dmparser.o config.o \
        structs.o cache.o discovery.o propsel.o dict.o \
        pgpolicies.o debug.o regex.o defaults.o uevent.o \
-       switchgroup.o
+       switchgroup.o uxsock.o
 
 CFLAGS = -pipe -g -Wall -Wunused -Wstrict-prototypes
 
Index: libmultipath/dmparser.c
===================================================================
--- 3675ec950a3806374cce8caa81ff064c0513b382/libmultipath/dmparser.c  (mode:100644)
+++ uncommitted/libmultipath/dmparser.c  (mode:100644)
@@ -16,45 +16,6 @@
 #define WORD_SIZE 64
 
 static int
-get_word (char * sentence, char ** word)
-{
-	char * p;
-	int len;
-	int skip = 0;
-	
-	while (*sentence ==  ' ') {
-		sentence++;
-		skip++;
-	}
-	if (*sentence == '\0')
-		return 0;
-
-	p = sentence;
-
-	while (*p !=  ' ' && *p != '\0')
-		p++;
-
-	len = (int) (p - sentence);
-
-	if (!word)
-		return skip + len;
-
-	*word = MALLOC(len + 1);
-
-	if (!*word) {
-		condlog(0, "get_word : oom\n");
-		return 0;
-	}
-	strncpy(*word, sentence, len);
-	condlog(4, "*word = %s, len = %i", *word, len);
-
-	if (*p == '\0')
-		return 0;
-
-	return skip + len;
-}
-
-static int
 merge_words (char ** dst, char * word, int space)
 {
 	char * p;
Index: libmultipath/util.c
===================================================================
--- 3675ec950a3806374cce8caa81ff064c0513b382/libmultipath/util.c  (mode:100644)
+++ uncommitted/libmultipath/util.c  (mode:100644)
@@ -4,6 +4,9 @@
 #include <sys/stat.h>
 #include <unistd.h>
 
+#include "debug.h"
+#include "memory.h"
+
 #define PARAMS_SIZE 255
 
 int
@@ -49,3 +52,42 @@
 	return 0;
 }
 
+int
+get_word (char * sentence, char ** word)
+{
+	char * p;
+	int len;
+	int skip = 0;
+	
+	while (*sentence ==  ' ') {
+		sentence++;
+		skip++;
+	}
+	if (*sentence == '\0')
+		return 0;
+
+	p = sentence;
+
+	while (*p !=  ' ' && *p != '\0')
+		p++;
+
+	len = (int) (p - sentence);
+
+	if (!word)
+		return skip + len;
+
+	*word = MALLOC(len + 1);
+
+	if (!*word) {
+		condlog(0, "get_word : oom\n");
+		return 0;
+	}
+	strncpy(*word, sentence, len);
+	condlog(4, "*word = %s, len = %i", *word, len);
+
+	if (*p == '\0')
+		return 0;
+
+	return skip + len;
+}
+
Index: libmultipath/util.h
===================================================================
--- 3675ec950a3806374cce8caa81ff064c0513b382/libmultipath/util.h  (mode:100644)
+++ uncommitted/libmultipath/util.h  (mode:100644)
@@ -4,6 +4,8 @@
 int strcmp_chomp(char *, char *);
 void basename (char * src, char * dst);
 int filepresent (char * run);
+int get_word (char * sentence, char ** word);
+
 
 #define safe_sprintf(var, format, args...)	\
 	snprintf(var, sizeof(var), format, ##args) >= sizeof(var)
Index: multipathd/Makefile
===================================================================
--- 3675ec950a3806374cce8caa81ff064c0513b382/multipathd/Makefile  (mode:100644)
+++ uncommitted/multipathd/Makefile  (mode:100644)
@@ -26,9 +26,8 @@
 #
 # object files
 #
-OBJS = main.o copy.o log.o log_pthread.o pidfile.o \
-       $(MULTIPATHLIB)-glibc.a \
-       $(CHECKERSLIB)-glibc.a \
+OBJS = main.o copy.o log.o log_pthread.o pidfile.o uxlsnr.o uxclnt.o \
+       $(MULTIPATHLIB)-glibc.a $(CHECKERSLIB)-glibc.a \
 
 
 #
Index: multipathd/main.c
===================================================================
--- 3675ec950a3806374cce8caa81ff064c0513b382/multipathd/main.c  (mode:100644)
+++ uncommitted/multipathd/main.c  (mode:100644)
@@ -53,9 +53,12 @@
 #include "copy.h"
 #include "clone_platform.h"
 #include "pidfile.h"
+#include "uxlsnr.h"
+#include "uxclnt.h"
 
 #define FILE_NAME_SIZE 256
 #define CMDSIZE 160
+#define MAX_REPLY_LEN 1000
 
 #define CALLOUT_DIR "/var/cache/multipathd"
 
@@ -561,6 +564,115 @@
 	return 0;
 }
 
+static char *
+show_paths (struct paths * allpaths)
+{
+	int i, j, k;
+	struct path * pp;
+	char * c;
+	char * reply;
+
+	reply = MALLOC(MAX_REPLY_LEN);
+
+	if (!reply)
+		return NULL;
+
+	c = reply;
+	c += sprintf(c, "\n");
+
+	vector_foreach_slot(allpaths->pathvec, pp, i) {
+		c += sprintf(c, "%10s: ", pp->dev);
+		c += sprintf(c, "state %i, ", pp->state);
+
+		j = pp->tick;
+		k = pp->checkint - pp->tick;
+		c += sprintf(c, "%3i/%3i ", j, pp->checkint);
+
+		while (j-- > 0)
+			c += sprintf(c, "X");
+
+
+		while (k-- > 0)
+			c += sprintf(c, ".");
+
+		c += sprintf(c, "\n");
+	}
+
+	return reply;
+}
+
+static char *
+show_maps (struct paths * allpaths)
+{
+	int i, j, k;
+	struct multipath * mpp;
+	char * c;
+	char * reply;
+
+	reply = MALLOC(MAX_REPLY_LEN);
+
+	if (!reply)
+		return NULL;
+
+	c = reply;
+	c += sprintf(c, "\n");
+
+	vector_foreach_slot(allpaths->mpvec, mpp, i) {
+		c += sprintf(c, "%20s: ", mpp->alias);
+
+		j = mpp->failback_tick;
+		k = mpp->pgfailback - mpp->failback_tick;
+		c += sprintf(c, "%3i/%3i ", j, mpp->pgfailback);
+
+		while (j-- > 0)
+			c += sprintf(c, "X");
+
+
+		while (k-- > 0)
+			c += sprintf(c, ".");
+
+		c += sprintf(c, "\n");
+	}
+
+	return reply;
+}
+
+char *
+uxsock_trigger (char * str, void * trigger_data)
+{
+	struct paths * allpaths;
+	char * reply = NULL;
+
+	allpaths = (struct paths *)trigger_data;
+
+	lock(allpaths->lock);
+
+	if (*str == 'l' && *(str + 1) == 'p')
+		reply = show_paths(allpaths);
+
+	else if (*str == 'l' && *(str + 1) == 'm')
+		reply = show_maps(allpaths);
+
+	else if (*str == 'r' && *(str + 1) == 'p')
+		uev_remove_path(str + 3, allpaths);
+
+	else if (*str == 'a' && *(str + 1) == 'p')
+		uev_add_path(str + 3, allpaths);
+
+	else if (*str == 'r' && *(str + 1) == 'm')
+		uev_remove_map(str + 3, allpaths);
+
+	else if (*str == 'a' && *(str + 1) == 'm')
+		uev_add_map(str + 3, allpaths);
+
+	if (!reply)
+		asprintf(&reply, "ok\n");
+
+	unlock(allpaths->lock);
+
+	return reply;
+}
+
 int 
 uev_trigger (struct uevent * uev, void * trigger_data)
 {
@@ -622,6 +734,14 @@
 	return NULL;
 }
 
+static void *
+uxlsnrloop (void * ap)
+{
+	uxsock_listen(&uxsock_trigger, ap);
+
+	return NULL;
+}
+
 static void
 strvec_free (vector vec)
 {
@@ -1045,7 +1165,7 @@
 static int
 child (void * param)
 {
-	pthread_t check_thr, uevent_thr;
+	pthread_t check_thr, uevent_thr, uxlsnr_thr;
 	pthread_attr_t attr;
 	struct paths * allpaths;
 
@@ -1120,8 +1240,10 @@
 	
 	pthread_create(&check_thr, &attr, checkerloop, allpaths);
 	pthread_create(&uevent_thr, &attr, ueventloop, allpaths);
+	pthread_create(&uxlsnr_thr, &attr, uxlsnrloop, allpaths);
 	pthread_join(check_thr, NULL);
 	pthread_join(uevent_thr, NULL);
+	pthread_join(uxlsnr_thr, NULL);
 
 	return 0;
 }
@@ -1156,7 +1278,7 @@
 	if (!conf)
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":dv:")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dv:k::")) != EOF ) {
 	switch(arg) {
 		case 'd':
 			logsink = 0;
@@ -1168,6 +1290,9 @@
 
 			conf->verbosity = atoi(optarg);
 			break;
+		case 'k':
+			uxclnt(optarg);
+			exit(0);
 		default:
 			;
 		}
Index: multipathd/uxclnt.c
===================================================================
--- /dev/null  (tree:3675ec950a3806374cce8caa81ff064c0513b382)
+++ uncommitted/multipathd/uxclnt.c  (mode:100644)
@@ -0,0 +1,69 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdarg.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <sys/poll.h>
+
+#include <uxsock.h>
+
+/*
+ * process the client 
+ */
+static void process(int fd)
+{
+	char line[1000];
+	char *reply;
+
+	while (fgets(line, sizeof(line), stdin)) {
+		size_t len = strlen(line);
+
+		if (line[len-1] == '\n') {
+			line[len-1] = 0;
+			len--;
+		}
+		
+		if (send_packet(fd, line, strlen(line)) != 0) break;
+		if (recv_packet(fd, &reply, &len) != 0) break;
+
+		printf("%*.*s\n", (int)len, (int)len, reply);
+		free(reply);
+	}
+}
+
+static void process_req(int fd, char * inbuf)
+{
+	char *reply;
+	size_t len;
+
+	send_packet(fd, inbuf, strlen(inbuf));
+	recv_packet(fd, &reply, &len);
+
+	printf("%*.*s\n", (int)len, (int)len, reply);
+	free(reply);
+}
+	
+/*
+ * entry point
+ */
+int uxclnt(char * inbuf)
+{
+	int fd;
+
+	fd = ux_socket_connect(SOCKET_NAME);
+	if (fd == -1) {
+		perror("ux_socket_connect");
+		exit(1);
+	}
+
+	if (inbuf)
+		process_req(fd, inbuf);
+	else
+		process(fd);
+	
+	return 0;
+}
Index: multipathd/uxclnt.h
===================================================================
--- /dev/null  (tree:3675ec950a3806374cce8caa81ff064c0513b382)
+++ uncommitted/multipathd/uxclnt.h  (mode:100644)
@@ -0,0 +1 @@
+int uxclnt(char * inbuf);
Index: multipathd/uxlsnr.c
===================================================================
--- /dev/null  (tree:3675ec950a3806374cce8caa81ff064c0513b382)
+++ uncommitted/multipathd/uxlsnr.c  (mode:100644)
@@ -0,0 +1,148 @@
+/*
+ * A simple domain socket listener
+ * Original author : tridge@samba.org, January 2002
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdarg.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <sys/poll.h>
+
+#include <memory.h>
+#include <debug.h>
+#include <vector.h>
+#include <structs.h>
+#include <uxsock.h>
+
+#define SLEEP_TIME 5000
+
+struct client {
+	int fd;
+	struct client *next, *prev;
+};
+
+static struct client *clients;
+static unsigned num_clients;
+
+/*
+ * handle a new client joining
+ */
+static void new_client(int ux_sock)
+{
+	struct client *c;
+	struct sockaddr addr;
+	socklen_t len = sizeof(addr);
+	int fd;
+
+	fd = accept(ux_sock, &addr, &len);
+	
+	if (fd == -1)
+		return;
+
+	/* put it in our linked list */
+	c = (struct client *)MALLOC(sizeof(*c));
+	memset(c, 0, sizeof(*c));
+	c->fd = fd;
+	c->next = clients;
+	clients = c;
+	num_clients++;
+}
+
+/*
+ * kill off a dead client
+ */
+static void dead_client(struct client *c)
+{
+	close(c->fd);
+	if (c->prev) c->prev->next = c->next;
+	if (c->next) c->next->prev = c->prev;
+	if (c == clients) clients = c->next;
+	FREE(c);
+	num_clients--;
+}
+
+/*
+ * entry point
+ */
+void * uxsock_listen(char * (*uxsock_trigger)(char *, void * trigger_data),
+			void * trigger_data)
+{
+	int ux_sock;
+	size_t len;
+	char *inbuf;
+	struct pollfd *polls = NULL;
+	char *reply;
+
+	ux_sock = ux_socket_listen(SOCKET_NAME);
+
+	if (ux_sock == -1) {
+		condlog(0, "ux_socket_listen error");
+		exit(1);
+	}
+
+	while (1) {
+		struct client *c;
+		int i, poll_count;
+
+		/* setup for a poll */
+		polls = REALLOC(polls, (1+num_clients) * sizeof(*polls));
+		polls[0].fd = ux_sock;
+		polls[0].events = POLLIN;
+
+		/* setup the clients */
+		for (i=1, c = clients; c; i++, c = c->next) {
+			polls[i].fd = c->fd;
+			polls[i].events = POLLIN;
+		}
+
+		/* most of our life is spent in this call */
+		poll_count = poll(polls, i, SLEEP_TIME);
+		
+		if (poll_count == -1) {
+			/* something went badly wrong! */
+			condlog(0, "poll");
+			exit(1);
+		}
+
+		if (poll_count == 0)
+			continue;
+
+		/* see if a client wants to speak to us */
+		for (i=1, c = clients; c; i++) {
+			struct client *next = c->next;
+
+			if (polls[i].revents & POLLIN) {
+				if (recv_packet(c->fd, &inbuf, &len) != 0) {
+					dead_client(c);
+				} else {
+					condlog(4, "Got request [%*.*s]",
+						(int)len, (int)len, inbuf);
+					reply = uxsock_trigger(inbuf,
+							trigger_data);
+
+					if (reply) {
+						if (send_packet(c->fd, reply,
+							strlen(reply)) != 0) {
+							dead_client(c);
+						}
+						FREE(reply);
+					}
+					FREE(inbuf);
+				}
+			}
+			c = next;
+		}
+
+		/* see if we got a new client */
+		if (polls[0].revents & POLLIN) {
+			new_client(ux_sock);
+		}
+	}
+
+	return NULL;
+}
Index: multipathd/uxlsnr.h
===================================================================
--- /dev/null  (tree:3675ec950a3806374cce8caa81ff064c0513b382)
+++ uncommitted/multipathd/uxlsnr.h  (mode:100644)
@@ -0,0 +1,4 @@
+void * uxsock_listen(char * (*uxsock_trigger)
+			(char *, void * trigger_data),
+			void * trigger_data);
+

--=-ubR7AQNTwwB6qZBElFN4
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-ubR7AQNTwwB6qZBElFN4--
