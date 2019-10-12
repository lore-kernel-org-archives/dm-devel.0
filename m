From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 59/72] libdmmp: fix clang -Wformat-nonliteral
	warnings
Date: Sat, 12 Oct 2019 21:28:50 +0000
Message-ID: <20191012212703.12989-60-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

clang enables -Wformat-nonliteral with our compiler flags, and
thus needs these format(printf, ...) attributes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libdmmp/libdmmp_private.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/libdmmp/libdmmp_private.h b/libdmmp/libdmmp_private.h
index 3e813cb4..ac85b63f 100644
--- a/libdmmp/libdmmp_private.h
+++ b/libdmmp/libdmmp_private.h
@@ -131,13 +131,15 @@ DMMP_DLL_LOCAL void _dmmp_path_free(struct dmmp_path *dmmp_p);
 DMMP_DLL_LOCAL void _dmmp_log(struct dmmp_context *ctx, int priority,
 			      const char *file, int line,
 			      const char *func_name,
-			      const char *format, ...);
+			      const char *format, ...)
+	__attribute__((format(printf, 6, 7)));
 DMMP_DLL_LOCAL void _dmmp_log_err_str(struct dmmp_context *ctx, int rc);
 
 DMMP_DLL_LOCAL void _dmmp_log_stderr(struct dmmp_context *ctx, int priority,
 				     const char *file, int line,
 				     const char *func_name, const char *format,
-				     va_list args);
+				     va_list args)
+	__attribute__((format(printf, 6, 0)));
 
 
 #define _dmmp_log_cond(ctx, prio, arg...) \
@@ -164,7 +166,7 @@ DMMP_DLL_LOCAL void _dmmp_log_stderr(struct dmmp_context *ctx, int priority,
 	do { \
 		if (ptr == NULL) { \
 			rc = DMMP_ERR_NO_MEMORY; \
-			_error(ctx, dmmp_strerror(rc)); \
+			_error(ctx, "%s", dmmp_strerror(rc));	\
 			goto goto_out; \
 		} \
 	} while(0)
-- 
2.23.0
