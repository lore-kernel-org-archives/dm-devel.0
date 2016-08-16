From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] libmultipath, multipathd: Rework SIGPIPE handling
Date: Tue, 16 Aug 2016 13:08:03 -0700
Message-ID: <10ceb0f0-3009-6a5c-073a-78f4c0ab61db@sandisk.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Gris Ge <fge@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

The behavior we want is as follows:
* If stdout or stderr is closed then SIGPIPE causes termination.
* Sending data to a socket that has been closed by the receiver
  does not cause multipathd to stop.

Hence unblock SIGPIPE and use MSG_NOSIGNAL when sending data over
a socket.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Gris Ge <fge@redhat.com>
---
 libmpathcmd/mpath_cmd.c |  4 ++--
 libmultipath/uxsock.c   | 17 ++---------------
 multipathd/main.c       |  8 +-------
 3 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index c058479..667a2dc 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -33,7 +33,7 @@ static ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout)
 			return -1;
 		} else if (!pfd.revents & POLLIN)
 			continue;
-		n = read(fd, buf, len);
+		n = recv(fd, buf, len, 0);
 		if (n < 0) {
 			if ((errno == EINTR) || (errno == EAGAIN))
 				continue;
@@ -56,7 +56,7 @@ static size_t write_all(int fd, const void *buf, size_t len)
 	size_t total = 0;
 
 	while (len) {
-		ssize_t n = write(fd, buf, len);
+		ssize_t n = send(fd, buf, len, MSG_NOSIGNAL);
 		if (n < 0) {
 			if ((errno == EINTR) || (errno == EAGAIN))
 				continue;
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index 775e278..880257f 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -81,7 +81,7 @@ size_t write_all(int fd, const void *buf, size_t len)
 	size_t total = 0;
 
 	while (len) {
-		ssize_t n = write(fd, buf, len);
+		ssize_t n = send(fd, buf, len, MSG_NOSIGNAL);
 		if (n < 0) {
 			if ((errno == EINTR) || (errno == EAGAIN))
 				continue;
@@ -138,20 +138,7 @@ ssize_t read_all(int fd, void *buf, size_t len, unsigned int timeout)
  */
 int send_packet(int fd, const char *buf)
 {
-	int ret = 0;
-	sigset_t set, old;
-
-	/* Block SIGPIPE */
-	sigemptyset(&set);
-	sigaddset(&set, SIGPIPE);
-	pthread_sigmask(SIG_BLOCK, &set, &old);
-
-	ret = mpath_send_cmd(fd, buf);
-
-	/* And unblock it again */
-	pthread_sigmask(SIG_SETMASK, &old, NULL);
-
-	return ret;
+	return mpath_send_cmd(fd, buf);
 }
 
 /*
diff --git a/multipathd/main.c b/multipathd/main.c
index 54abfef..2be6cb2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2125,18 +2125,12 @@ sigusr2 (int sig)
 static void
 signal_init(void)
 {
-	sigset_t set;
-
-	sigemptyset(&set);
-	sigaddset(&set, SIGPIPE);
-	pthread_sigmask(SIG_SETMASK, &set, NULL);
-
 	signal_set(SIGHUP, sighup);
 	signal_set(SIGUSR1, sigusr1);
 	signal_set(SIGUSR2, sigusr2);
 	signal_set(SIGINT, sigend);
 	signal_set(SIGTERM, sigend);
-	signal(SIGPIPE, SIG_IGN);
+	signal_set(SIGPIPE, sigend);
 }
 
 static void
-- 
2.9.2
