From: John Kingman <kingman@storagegear.com>
Subject: multipath-tools sector size bug
Date: Wed, 4 Jul 2007 14:55:14 -0500 (CDT)
Message-ID: <Pine.LNX.4.61.0707041445410.30226@Dirk.kingmandom.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

I encountered a problem with the sg_read() routine in readsector0.c
while testing an InfiniBand target having 4096 byte sectors.  The
sg_read() routine assumes that sectors are 512 bytes long.

A patch for the problem follows.

John Kingman

--- readsector0.c.orig	2006-03-13 05:07:45.000000000 -0600
+++ readsector0.c	2007-07-03 14:20:14.000000000 -0500
@@ -51,7 +51,11 @@
 	int res;
 	int rd_opcode[] = {0x8, 0x28, 0xa8, 0x88};
 	int sz_ind;
-	
+	struct stat filestatus;
+
+	if (fstat(sg_fd, &filestatus) != 0) 
+		return PATH_DOWN;
+	bs = (filestatus.st_blksize > 4096)? 4096: filestatus.st_blksize;
 	memset(rdCmd, 0, cdbsz);
 	sz_ind = 1;
 	rdCmd[0] = rd_opcode[sz_ind];
@@ -97,7 +101,7 @@
 extern int
 readsector0 (struct checker * c)
 {
-	unsigned char buf[512];
+	unsigned char buf[4096];
 	int ret;
 
 	ret = sg_read(c->fd, &buf[0]);
