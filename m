From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 10/15] libmultipath: Move the definition of a
 global variable from .h to .c
Date: Fri, 21 Oct 2016 11:44:58 -0700
Message-ID: <969ce5d1-2b69-7ddf-b8e0-ba5bee08d8b3@sandisk.com>
References: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This change does not change the semantics of the code but makes
it easier for sparse to analyze the source code.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/log.c | 2 ++
 libmultipath/log.h | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/log.c b/libmultipath/log.c
index ab92e2a..debd36d 100644
--- a/libmultipath/log.c
+++ b/libmultipath/log.c
@@ -15,6 +15,8 @@
 
 #define ALIGN(len, s) (((len)+(s)-1)/(s)*(s))
 
+struct logarea* la;
+
 #if LOGDBG
 static void dump_logarea (void)
 {
diff --git a/libmultipath/log.h b/libmultipath/log.h
index 984f047..6551b5c 100644
--- a/libmultipath/log.h
+++ b/libmultipath/log.h
@@ -29,7 +29,7 @@ struct logarea {
 	char * buff;
 };
 
-struct logarea * la;
+extern struct logarea* la;
 
 int log_init (char * progname, int size);
 void log_close (void);
-- 
2.10.1
