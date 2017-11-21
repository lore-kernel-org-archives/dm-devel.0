From: Gris Ge <fge@redhat.com>
Subject: [PATCH 4/4] multipath-tools: libdmmp: Add new error
	DMMP_ERR_PERMISSION_DENY
Date: Tue, 21 Nov 2017 22:09:17 +0800
Message-ID: <20171121140917.18298-5-fge@redhat.com>
References: <20171121140917.18298-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171121140917.18298-1-fge@redhat.com>
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

 * Indicate user does not have privilege to flush mpath or invoke
   reconfig.
 * Bump API version to 0.2.0 for this API addition.

Signed-off-by: Gris Ge <fge@redhat.com>
---
 libdmmp/Makefile          | 2 +-
 libdmmp/libdmmp.c         | 8 ++++++++
 libdmmp/libdmmp/libdmmp.h | 5 +++++
 libdmmp/libdmmp_misc.c    | 1 +
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index 6645a1a4..bf231ace 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -5,7 +5,7 @@
 #
 include ../Makefile.inc
 
-LIBDMMP_VERSION=0.1.0
+LIBDMMP_VERSION=0.2.0
 SONAME=$(LIBDMMP_VERSION)
 DEVLIB = libdmmp.so
 LIBS = $(DEVLIB).$(SONAME)
diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index 95f65b88..944cecd6 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -364,6 +364,14 @@ invoke:
 		}
 	}
 
+	if ((*output != NULL) &&
+	    strncmp(*output, "permission deny",
+		    strlen("permission deny")) == 0) {
+		_error(ctx, "Permission deny, need to be root");
+		rc = DMMP_ERR_PERMISSION_DENY;
+		goto out;
+	}
+
 out:
 	if (rc != DMMP_OK) {
 		free(*output);
diff --git a/libdmmp/libdmmp/libdmmp.h b/libdmmp/libdmmp/libdmmp.h
index 33b5d743..e157982e 100644
--- a/libdmmp/libdmmp/libdmmp.h
+++ b/libdmmp/libdmmp/libdmmp.h
@@ -42,6 +42,7 @@ extern "C" {
 #define DMMP_ERR_MPATH_BUSY		7
 #define DMMP_ERR_MPATH_NOT_FOUND	8
 #define DMMP_ERR_INVALID_ARGUMENT	9
+#define DMMP_ERR_PERMISSION_DENY	10
 
 /*
  * Use the syslog severity level as log priority
@@ -679,6 +680,8 @@ DMMP_DLL_EXPORT const char *dmmp_path_status_str(uint32_t path_status);
  *
  *	* DMMP_ERR_INVALID_ARGUMENT
  *
+ *	* DMMP_ERR_PERMISSION_DENY
+ *
  *	Error number could be converted to string by dmmp_strerror().
  */
 DMMP_DLL_EXPORT int dmmp_flush_mpath(struct dmmp_context *ctx,
@@ -704,6 +707,8 @@ DMMP_DLL_EXPORT int dmmp_flush_mpath(struct dmmp_context *ctx,
  *
  *	* DMMP_ERR_NO_DAEMON
  *
+ *	* DMMP_ERR_PERMISSION_DENY
+ *
  *	Error number could be converted to string by dmmp_strerror().
  */
 DMMP_DLL_EXPORT int dmmp_reconfig(struct dmmp_context *ctx);
diff --git a/libdmmp/libdmmp_misc.c b/libdmmp/libdmmp_misc.c
index 435ddfa5..69b5a202 100644
--- a/libdmmp/libdmmp_misc.c
+++ b/libdmmp/libdmmp_misc.c
@@ -49,6 +49,7 @@ static const struct _num_str_conv _DMMP_RC_MSG_CONV[] = {
 	{DMMP_ERR_MPATH_BUSY, "Specified multipath device map is in use"},
 	{DMMP_ERR_MPATH_NOT_FOUND, "Specified multipath not found"},
 	{DMMP_ERR_INVALID_ARGUMENT, "Invalid argument"},
+	{DMMP_ERR_PERMISSION_DENY, "Permission deny"},
 };
 
 _dmmp_str_func_gen(dmmp_strerror, int, rc, _DMMP_RC_MSG_CONV);
-- 
2.15.0
