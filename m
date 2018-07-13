From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 05/10] libmutipath: remove unused IDE bus type
Date: Fri, 13 Jul 2018 14:39:10 -0500
Message-ID: <1531510755-16046-6-git-send-email-bmarzins@redhat.com>
References: <1531510755-16046-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1531510755-16046-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index ca14315..0a2623a 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -58,7 +58,6 @@ enum failback_mode {
 enum sysfs_buses {
 	SYSFS_BUS_UNDEF,
 	SYSFS_BUS_SCSI,
-	SYSFS_BUS_IDE,
 	SYSFS_BUS_CCW,
 	SYSFS_BUS_CCISS,
 	SYSFS_BUS_NVME,
-- 
2.7.4
