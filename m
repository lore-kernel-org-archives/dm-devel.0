From: Gris Ge <fge@redhat.com>
Subject: [PATCH 2/4] multipath-tools: libdmmp: Allow log function
	as NULL.
Date: Tue, 21 Nov 2017 22:09:15 +0800
Message-ID: <20171121140917.18298-3-fge@redhat.com>
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

 * Do nothing when user set log function to NULL.
 * Update document to reflect so.

Signed-off-by: Gris Ge <fge@redhat.com>
---
 libdmmp/libdmmp.c         | 3 +++
 libdmmp/libdmmp/libdmmp.h | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index b4e7f08f..74cdb0a6 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -89,6 +89,9 @@ void _dmmp_log(struct dmmp_context *ctx, int priority, const char *file,
 {
 	va_list args;
 
+	if (ctx->log_func == NULL)
+		return;
+
 	va_start(args, format);
 	ctx->log_func(ctx, priority, file, line, func_name, format, args);
 	va_end(args);
diff --git a/libdmmp/libdmmp/libdmmp.h b/libdmmp/libdmmp/libdmmp.h
index 72b79b97..6e233e4f 100644
--- a/libdmmp/libdmmp/libdmmp.h
+++ b/libdmmp/libdmmp/libdmmp.h
@@ -258,7 +258,8 @@ DMMP_DLL_EXPORT int dmmp_context_log_priority_get(struct dmmp_context *ctx);
  *	Pointer of 'struct dmmp_context'.
  *	If this pointer is NULL, your program will be terminated by assert.
  * @log_func:
- *	Pointer of log handler function.
+ *	Pointer of log handler function. If set to NULL, all log will be
+ *	ignored.
  *
  * Return:
  *	void
-- 
2.15.0
