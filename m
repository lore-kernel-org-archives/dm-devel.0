From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 23/31] kpartx.rules: don't rely on DM_DEPS and
	DM_TABLE_STATE
Date: Sun,  3 Sep 2017 00:38:52 +0200
Message-ID: <20170902223900.7339-24-mwilck@suse.com>
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

These tests (which were SUSE-specific anyway) are not needed
here. The kpartx invocation further down is guarded separately.
SYMLINK actions must be run in any case for consistency, and
there's no need to access the udev db here because kpartx_id
also works on otherwise broken devices.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.rules | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 64d550de..ea34e449 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -5,12 +5,12 @@
 #
 
 KERNEL!="dm-*", GOTO="kpartx_end"
-ACTION=="remove", GOTO="kpartx_end"
+ACTION!="add|change", GOTO="kpartx_end"
+ENV{DM_UUID}!="?*", GOTO="kpartx_end"
 
-ENV{DM_TABLE_STATE}!="LIVE", GOTO="kpartx_end"
-ENV{DM_DEPS}=="0", GOTO="kpartx_end"
-
-ENV{DM_UUID}=="?*", IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
+# kpartx_id is very robust, it works for suspended maps and maps
+# with 0 dependencies
+IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
 
 OPTIONS="link_priority=50"
 
-- 
2.14.0
