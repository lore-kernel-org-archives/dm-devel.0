From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/13] Correct persistent symlink for cciss
Date: Wed, 16 Jan 2013 13:14:07 +0100
Message-ID: <1358338456-1234-5-git-send-email-hare@suse.de>
References: <1358338456-1234-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358338456-1234-1-git-send-email-hare@suse.de>
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

cciss devices have the prefix 'cciss', so we should generate the
correct one from kpartx_id, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/kpartx_id |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
index 81f32bf..fa21b5b 100644
--- a/kpartx/kpartx_id
+++ b/kpartx/kpartx_id
@@ -79,6 +79,9 @@ if [ -n "$dmdeps" ] ; then
 	*\(94,*)
             echo "DM_TYPE=dasd"
 	    ;;
+	*\(104,* | *\(105,* | *\(106,* | *\(107,* | *\(108,* | *\(109,* | *\(110,* | *\(112,*)
+	    echo "DM_TYPE=cciss"
+	    ;;
 	*\(9*)
             echo "DM_TYPE=raid"
 	    ;;
-- 
1.7.4.2
