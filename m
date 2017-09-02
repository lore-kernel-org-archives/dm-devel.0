From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 27/31] kpartx.rules: generate type-name links
	only for multipath devices
Date: Sun,  3 Sep 2017 00:38:56 +0200
Message-ID: <20170902223900.7339-28-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

... and their partitions. This rule generates irritiating symlinks
like /dev/disk/by-id/raid-${VG}-${LV} for LVM LVs otherwise.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index b05181a8..6c8f4d53 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -14,7 +14,7 @@ IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
 
 ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
 
-ENV{DM_UUID}=="?*", ENV{DM_TYPE}=="?*" \
+ENV{DM_UUID}=="*mpath-*", ENV{DM_TYPE}=="?*" \
 	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
 
 # Create persistent links for multipath tables
-- 
2.14.0
