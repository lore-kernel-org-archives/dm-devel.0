From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/30] Specify checker_timeout in seconds
Date: Tue, 16 Jul 2013 09:13:18 +0200
Message-ID: <1373958801-103613-28-git-send-email-hare@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
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

Commit 8d3f07da changed the internal value for checker_timeout
to be in milliseconds, which wasn't reflected in the tur checker.
So better scale it back to seconds, and change the callers to
scale it to milliseconds where appropriate.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/checkers/emc_clariion.c | 2 +-
 libmultipath/checkers/hp_sw.c        | 4 ++--
 libmultipath/checkers/libsg.c        | 2 +-
 libmultipath/checkers/rdac.c         | 4 ++--
 libmultipath/checkers/tur.c          | 2 +-
 libmultipath/discovery.c             | 2 +-
 libmultipath/discovery.h             | 2 +-
 libmultipath/propsel.c               | 4 ++--
 8 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index 5d87bfd..a797734 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -114,7 +114,7 @@ int libcheck_check (struct checker * c)
 	io_hdr.dxferp = sense_buffer;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sb;
-	io_hdr.timeout = c->timeout;
+	io_hdr.timeout = c->timeout * 1000;
 	io_hdr.pack_id = 0;
 	if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
 		MSG(c, "emc_clariion_checker: sending query command failed");
diff --git a/libmultipath/checkers/hp_sw.c b/libmultipath/checkers/hp_sw.c
index b50ac0c..fe5e0f9 100644
--- a/libmultipath/checkers/hp_sw.c
+++ b/libmultipath/checkers/hp_sw.c
@@ -70,7 +70,7 @@ do_inq(int sg_fd, int cmddt, int evpd, unsigned int pg_op,
 	io_hdr.dxferp = resp;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sense_b;
-	io_hdr.timeout = timeout;
+	io_hdr.timeout = timeout * 1000;
 
 	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
 		return 1;
@@ -111,7 +111,7 @@ do_tur (int fd, unsigned int timeout)
 	io_hdr.dxfer_direction = SG_DXFER_NONE;
 	io_hdr.cmdp = turCmdBlk;
 	io_hdr.sbp = sense_buffer;
-	io_hdr.timeout = timeout;
+	io_hdr.timeout = timeout * 1000;
 	io_hdr.pack_id = 0;
 
 	if (ioctl(fd, SG_IO, &io_hdr) < 0)
diff --git a/libmultipath/checkers/libsg.c b/libmultipath/checkers/libsg.c
index 5a989d3..0d3af1f 100644
--- a/libmultipath/checkers/libsg.c
+++ b/libmultipath/checkers/libsg.c
@@ -53,7 +53,7 @@ sg_read (int sg_fd, unsigned char * buff, int buff_len,
 	io_hdr.dxferp = buff;
 	io_hdr.mx_sb_len = sense_len;
 	io_hdr.sbp = sense;
-	io_hdr.timeout = timeout;
+	io_hdr.timeout = timeout * 1000;
 	io_hdr.pack_id = (int)start_block;
 	if (diop && *diop)
 	io_hdr.flags |= SG_FLAG_DIRECT_IO;
diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
index 5f24f55..2e64dd3 100644
--- a/libmultipath/checkers/rdac.c
+++ b/libmultipath/checkers/rdac.c
@@ -74,7 +74,7 @@ int libcheck_init (struct checker * c)
 	io_hdr.dxferp = &current;
 	io_hdr.cmdp = cmd;
 	io_hdr.sbp = sense_b;
-	io_hdr.timeout = c->timeout;
+	io_hdr.timeout = c->timeout * 1000;
 
 	if (ioctl(c->fd, SG_IO, &io_hdr) < 0)
 		goto out;
@@ -150,7 +150,7 @@ retry:
 	io_hdr.dxferp = resp;
 	io_hdr.cmdp = inqCmdBlk;
 	io_hdr.sbp = sense_b;
-	io_hdr.timeout = timeout;
+	io_hdr.timeout = timeout * 1000;
 
 	if (ioctl(sg_fd, SG_IO, &io_hdr) < 0)
 		return 1;
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 6f5d4d9..b76dcec 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -116,7 +116,7 @@ tur_check(int fd, unsigned int timeout, char *msg)
 	io_hdr.dxfer_direction = SG_DXFER_NONE;
 	io_hdr.cmdp = turCmdBlk;
 	io_hdr.sbp = sense_buffer;
-	io_hdr.timeout = timeout;
+	io_hdr.timeout = timeout * 1000;
 	io_hdr.pack_id = 0;
 	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
 		TUR_MSG(msg, MSG_TUR_DOWN);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index c59dbc2..adfb1ba 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -204,7 +204,7 @@ sysfs_get_timeout(struct path *pp, unsigned int *timeout)
 		return 1;
 	}
 
-	*timeout = t * 1000;
+	*timeout = t;
 
 	return 0;
 }
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 1a614ee..d049ead 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -14,7 +14,7 @@
 #endif
 
 #ifndef DEF_TIMEOUT
-#define DEF_TIMEOUT	300000
+#define DEF_TIMEOUT	30
 #endif
 
 /*
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index cea8c1c..e47d0ca 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -347,8 +347,8 @@ select_checker(struct path *pp)
 		pp->dev, checker_name(c));
 out:
 	if (conf->checker_timeout) {
-		c->timeout = conf->checker_timeout * 1000;
-		condlog(3, "%s: checker timeout = %u ms (config file default)",
+		c->timeout = conf->checker_timeout;
+		condlog(3, "%s: checker timeout = %u s (config file default)",
 				pp->dev, c->timeout);
 	}
 	else if (pp->udev && sysfs_get_timeout(pp, &c->timeout) == 0)
-- 
1.7.12.4
