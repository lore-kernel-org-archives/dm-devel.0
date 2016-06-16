From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/39] libmultipath: drop unused variable 'diop'
	in libsg.c
Date: Thu, 16 Jun 2016 11:47:20 +0200
Message-ID: <1466070465-1021-15-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/checkers/libsg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/libmultipath/checkers/libsg.c b/libmultipath/checkers/libsg.c
index 0d3af1f..958ea92 100644
--- a/libmultipath/checkers/libsg.c
+++ b/libmultipath/checkers/libsg.c
@@ -19,7 +19,6 @@ sg_read (int sg_fd, unsigned char * buff, int buff_len,
 	long long start_block = 0;
 	int bs = 512;
 	int cdbsz = 10;
-	int * diop = NULL;
 
 	unsigned char rdCmd[cdbsz];
 	unsigned char *sbb = sense;
@@ -55,8 +54,6 @@ sg_read (int sg_fd, unsigned char * buff, int buff_len,
 	io_hdr.sbp = sense;
 	io_hdr.timeout = timeout * 1000;
 	io_hdr.pack_id = (int)start_block;
-	if (diop && *diop)
-	io_hdr.flags |= SG_FLAG_DIRECT_IO;
 
 retry:
 	memset(sense, 0, sense_len);
-- 
2.6.6
