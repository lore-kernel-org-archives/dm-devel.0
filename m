From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] Fix lintian complaint about bad whatis entry
Date: Fri, 15 Jun 2018 16:17:40 +0200
Message-ID: <20180615141740.2118-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: DM-DEV ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Vincent McIntyre <vincent.mcintyre@csiro.au>
List-Id: dm-devel.ids

From: Vincent McIntyre <vincent.mcintyre@csiro.au>

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEV ML <dm-devel@redhat.com>
Signed-off-by: Vincent McIntyre <vincent.mcintyre@csiro.au>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathpersist/mpath_persistent_reserve_in.3  | 2 +-
 libmpathpersist/mpath_persistent_reserve_out.3 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmpathpersist/mpath_persistent_reserve_in.3 b/libmpathpersist/mpath_persistent_reserve_in.3
index 5ed0779..4691bde 100644
--- a/libmpathpersist/mpath_persistent_reserve_in.3
+++ b/libmpathpersist/mpath_persistent_reserve_in.3
@@ -12,7 +12,7 @@
 .SH NAME
 .\" ----------------------------------------------------------------------------
 .
-mpath_persistent_reserve_in
+mpath_persistent_reserve_in \- send PRIN command to DM device
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index e11eb57..55b00b0 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -12,7 +12,7 @@
 .SH NAME
 .\" ----------------------------------------------------------------------------
 .
-mpath_persistent_reserve_out
+mpath_persistent_reserve_out \- send PROUT command to DM device
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.1.4
