From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 24/31] kpartx.rules: respect
	DM_UDEV_LOW_PRIORITY_FLAG
Date: Sun,  3 Sep 2017 00:38:53 +0200
Message-ID: <20170902223900.7339-25-mwilck@suse.com>
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

kpartx.rules increased link priority unconditionally, but for
explicitly marked low prio devices that shouldn't be done.
Fix that. Also, use "+=" for OPTIONS, as most other rules do.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index ea34e449..efd21a29 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -12,7 +12,7 @@ ENV{DM_UUID}!="?*", GOTO="kpartx_end"
 # with 0 dependencies
 IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
 
-OPTIONS="link_priority=50"
+ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
 
 ENV{DM_UUID}=="?*", ENV{DM_TYPE}=="?*" \
 	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
-- 
2.14.0
