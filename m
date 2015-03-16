From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 33/78] Do not treat 'transport-offline' paths as
	'offline'
Date: Mon, 16 Mar 2015 13:36:20 +0100
Message-ID: <1426509425-15978-34-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

'transport-offline' status is entered whenever the transport has
detected an offline device, but the SCSI midlayer still has
references to it.
Once the last reference drops the SCSI midlayer will properly
deregister the device and multipath will be updating the status.
But until then we should treat this device as simply 'path down',
and not marking it offline.
After all, some transports like FC will be entering the
'transport-offline' state after fast_io_fail triggered, and
might revert back to 'running' after reconfiguration.

References: bnc#888378

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index cf37813..899cbd5 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -957,8 +957,7 @@ path_offline (struct path * pp)
 
 	condlog(3, "%s: path state = %s", pp->dev, buff);
 
-	if (!strncmp(buff, "offline", 7) ||
-	    !strncmp(buff, "transport-offline", 17)) {
+	if (!strncmp(buff, "offline", 7)) {
 		pp->offline = 1;
 		return PATH_DOWN;
 	}
-- 
1.8.4.5
