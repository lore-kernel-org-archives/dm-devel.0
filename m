From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/42] Valgrind fixes for prioritizer
Date: Tue,  8 Jan 2013 14:53:50 +0100
Message-ID: <1357653259-62650-13-git-send-email-hare@suse.de>
References: <1357653259-62650-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357653259-62650-1-git-send-email-hare@suse.de>
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

Declaring an array does not zero out its contents. So we might
be reading random garbage here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/prioritizers/hds.c   |    1 +
 libmultipath/prioritizers/ontap.c |    1 +
 libmultipath/prioritizers/rdac.c  |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index b22e1df..5d75f84 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -105,6 +105,7 @@ int hds_modular_prio (const char *dev, int fd)
 	}
 
 	memset (&io_hdr, 0, sizeof (sg_io_hdr_t));
+	memset (inqBuff, 0, INQ_REPLY_LEN);
 	io_hdr.interface_id = 'S';
 	io_hdr.cmd_len = sizeof (inqCmdBlk);
 	io_hdr.mx_sb_len = sizeof (sense_buffer);
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 0d34092..026d45d 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -80,6 +80,7 @@ static int send_gva(const char *dev, int fd, unsigned char pg,
 	int ret = -1;
 
 	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
+	memset(results, 0, *results_size);
 	io_hdr.interface_id = 'S';
 	io_hdr.cmd_len = sizeof (cdb);
 	io_hdr.mx_sb_len = sizeof (sb);
diff --git a/libmultipath/prioritizers/rdac.c b/libmultipath/prioritizers/rdac.c
index 8667790..441b3b0 100644
--- a/libmultipath/prioritizers/rdac.c
+++ b/libmultipath/prioritizers/rdac.c
@@ -22,6 +22,7 @@ int rdac_prio(const char *dev, int fd)
 	int ret = 0;
 
 	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
+	memset(sense_buffer, 0, 256);
 	io_hdr.interface_id = 'S';
 	io_hdr.cmd_len = sizeof (inqCmdBlk);
 	io_hdr.mx_sb_len = sizeof (sb);
-- 
1.7.4.2
