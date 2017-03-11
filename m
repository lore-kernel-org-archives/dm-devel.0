From: Gris Ge <fge@redhat.com>
Subject: [PATCH] multipath-tools: libdmmp: Fix incorrect use of
	__attribute__
Date: Sat, 11 Mar 2017 22:12:14 +0800
Message-ID: <20170311141214.31039-1-fge@redhat.com>
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
To: dm-devel@redhat.com
Cc: Gris Ge <fge@redhat.com>
List-Id: dm-devel.ids

According to https://gcc.gnu.org/onlinedocs/gcc/Type-Attributes.html ,
type attributes should be placed immediately after the struct, union or
enum keyword.

Signed-off-by: Gris Ge <fge@redhat.com>
---
 libdmmp/libdmmp/libdmmp.h | 8 ++++----
 libdmmp/libdmmp_private.h | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/libdmmp/libdmmp/libdmmp.h b/libdmmp/libdmmp/libdmmp.h
index 3fc8e6f..0679158 100644
--- a/libdmmp/libdmmp/libdmmp.h
+++ b/libdmmp/libdmmp/libdmmp.h
@@ -73,18 +73,18 @@ extern "C" {
  */
 DMMP_DLL_EXPORT const char *dmmp_log_priority_str(int priority);
 
-DMMP_DLL_EXPORT struct dmmp_context;
+struct DMMP_DLL_EXPORT dmmp_context;
 
-DMMP_DLL_EXPORT struct dmmp_mpath;
+struct DMMP_DLL_EXPORT dmmp_mpath;
 
-DMMP_DLL_EXPORT struct dmmp_path_group;
+struct DMMP_DLL_EXPORT dmmp_path_group;
 
 #define DMMP_PATH_GROUP_STATUS_UNKNOWN	0
 #define DMMP_PATH_GROUP_STATUS_ENABLED	1
 #define DMMP_PATH_GROUP_STATUS_DISABLED	2
 #define DMMP_PATH_GROUP_STATUS_ACTIVE	3
 
-DMMP_DLL_EXPORT struct dmmp_path;
+struct DMMP_DLL_EXPORT dmmp_path;
 
 #define DMMP_PATH_STATUS_UNKNOWN	0
 //#define DMMP_PATH_STATUS_UNCHECKED	1
diff --git a/libdmmp/libdmmp_private.h b/libdmmp/libdmmp_private.h
index e23c995..3e813cb 100644
--- a/libdmmp/libdmmp_private.h
+++ b/libdmmp/libdmmp_private.h
@@ -47,7 +47,8 @@ extern "C" {
 
 #define _DMMP_PATH_GROUP_ID_UNKNOWN	0
 
-DMMP_DLL_LOCAL struct _num_str_conv {
+struct DMMP_DLL_LOCAL _num_str_conv;
+struct _num_str_conv {
 	const uint32_t value;
 	const char *str;
 };
-- 
2.12.0
