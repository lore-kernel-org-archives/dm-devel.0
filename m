From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove "c" from __cpluscplus,
	misspelled
Date: Tue, 24 Apr 2018 15:03:40 +0200
Message-ID: <20180424130340.5067-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, DM ML <dm-devel@redhat.com>
List-Id: dm-devel.ids

found by cppcheck(http://cppcheck.sf.net/):
[libmpathcmd/mpath_cmd.h:24]: (error) Invalid number of character '{' when these macros are defined: '__cpluscplus'.

Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathcmd/mpath_cmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index b57b708..3df2c97 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -20,7 +20,7 @@
 #ifndef LIB_MPATH_CMD_H
 #define LIB_MPATH_CMD_H
 
-#ifdef __cpluscplus
+#ifdef __cplusplus
 extern "C" {
 #endif
 
-- 
2.17.0
