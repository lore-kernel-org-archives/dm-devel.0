From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/30] libmultipath: return PATH_DOWN for
	quiesced paths
Date: Tue, 16 Jul 2013 09:12:56 +0200
Message-ID: <1373958801-103613-6-git-send-email-hare@suse.de>
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

When a SCSI device is quiesced we cannot send any I/O requests to
it, so we should be returning 'PATH_DOWN' here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 18f72ec..04c6029 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -835,6 +835,7 @@ path_offline (struct path * pp)
 	condlog(3, "%s: path state = %s", pp->dev, buff);
 
 	if (!strncmp(buff, "offline", 7) ||
+	    !strncmp(buff, "quiesce", 7) ||
 	    !strncmp(buff, "transport-offline", 17)) {
 		pp->offline = 1;
 		return PATH_DOWN;
-- 
1.7.12.4
