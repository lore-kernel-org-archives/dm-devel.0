From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: mpath_ctl observation + some novice questions
Date: Thu, 15 Sep 2005 15:42:09 +0100
Message-ID: <20050915144209.GL5254@agk.surrey.redhat.com>
References: <20050915132538.GA27752@locust.cns.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050915132538.GA27752@locust.cns.vt.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 15, 2005 at 09:25:38AM -0400, Ray Stell wrote:
> I'm not a developer, but I thought I'd throw out this observation.
> 
> environment:
>  - rhas4 U2 Beta - Linux pecan 2.6.9-16.EL #1 Mon Aug 15 19:58:49 EDT 2005 i686 i686 i386 GNU/Linux
>  - multipath-tools-0.4.5.49.  

RPM (which?) or built from source tarball?

> The cpu got eaten up by mpath_ctl and remains that way until reboot:

The latest RPM is device-mapper-multipath-0.4.5-6.0.RHEL4
which contains a patch (attached) that should fix this.

(uxsock.c where this code came from may also have similar issues)

Alasdair
-- 
agk@redhat.com


--- multipath-tools-0.4.5.49/multipath/mpath_faker.c	2005-08-01 22:07:57.000000000 +0100
+++ multipath-tools-0.4.5.49.1/multipath/mpath_faker.c	2005-09-02 22:55:55.000000000 +0100
@@ -8,17 +8,22 @@
 #include "uxsock.h"
 
 /*
- * keep writing until its all sent
+ * keep writing until it's all sent
  */
-int write_all(int fd, const void *buf, size_t len)
+size_t write_all(int fd, const void *buf, size_t len)
 {
 	size_t total = 0;
+
 	while (len) {
-		int n = write(fd, buf, len);
+		ssize_t n = write(fd, buf, len);
 		if (n < 0) {
+			if ((errno == EINTR) || (errno == EAGAIN))
+				continue;
 			perror("failed to send message to multipathd");
 			return total;
 		}
+		if (!n)
+			return total;
 		buf = n + (char *)buf;
 		len -= n;
 		total += n;
@@ -30,19 +35,25 @@ int write_all(int fd, const void *buf, s
 /*
  * keep reading until its all read
  */
-int read_all(int fd, void *buf, size_t len)
+size_t read_all(int fd, void *buf, size_t len)
 {
 	size_t total = 0;
+
 	while (len) {
-		int n = read(fd, buf, len);
+		ssize_t n = read(fd, buf, len);
 		if (n < 0) {
+			if ((errno == EINTR) || (errno == EAGAIN))
+				continue;
 			perror("failed to receive message from multipathd");
 			return total;
 		}
+		if (!n)
+			return total;
 		buf = n + (char *)buf;
 		len -= n;
 		total += n;
 	}
+
 	return total;
 }
 
@@ -57,7 +68,7 @@ int main(int argc, char **argv)
 {
 	int sock;
 	struct sockaddr_un sun;
-	int len;
+	size_t len;
 	char reply[6];
 
 	if (argc == 1 || (!strcmp(argv[1], "-h")) ||
@@ -103,6 +114,6 @@ int main(int argc, char **argv)
 		exit(1);
 	}
 	close(sock);
+
 	return 0;
 }
-	
