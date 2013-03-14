From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/6] libmultipath: return PATH_DOWN for quiesced
	paths
Date: Thu, 14 Mar 2013 15:08:43 +0100
Message-ID: <1363270128-20900-2-git-send-email-hare@suse.de>
References: <1363270128-20900-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1363270128-20900-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

When a SCSI device is quiesced we cannot send any I/O requests to
it, so we should be returning 'PATH_DOWN' here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 0b5fd1d..050264e 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -798,7 +798,8 @@ path_offline (struct path * pp)
 	condlog(3, "%s: path state = %s", pp->dev, buff);
 
 	if (!strncmp(buff, "offline", 7) ||
-	    !strncmp(buff, "transport-offline", 17)) {
+	    !strncmp(buff, "transport-offline", 17) ||
+	    !strncmp(buff, "quiesce", 7)) {
 		pp->offline = 1;
 		return PATH_DOWN;
 	}
-- 
1.7.10.4
