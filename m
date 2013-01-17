From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/11] kpartx: Fix DASD name in kpartx_id
Date: Thu, 17 Jan 2013 15:59:27 +0100
Message-ID: <1358434773-2002-6-git-send-email-hare@suse.de>
References: <1358434773-2002-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358434773-2002-1-git-send-email-hare@suse.de>
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

The name of the DASD type is 'ccw', not 'dasd'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/kpartx_id |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
index 47fab1a..517b856 100644
--- a/kpartx/kpartx_id
+++ b/kpartx/kpartx_id
@@ -83,7 +83,7 @@ fi
 if [ -n "$dmdeps" ] ; then
     case "$dmdeps" in
 	*\(94,*)
-            echo "DM_TYPE=dasd"
+            echo "DM_TYPE=ccw"
 	    ;;
 	*\(104,* | *\(105,* | *\(106,* | *\(107,* | *\(108,* | *\(109,* | *\(110,* | *\(112,*)
 	    echo "DM_TYPE=cciss"
-- 
1.7.10.4
