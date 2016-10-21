From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 14/15] libmultipath/checkers: Make the compiler
 check the checker function prototypes
Date: Fri, 21 Oct 2016 11:46:36 -0700
Message-ID: <88aefcc1-b052-1cf7-a7b9-aea4043c08bf@sandisk.com>
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

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 libmultipath/checkers.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 4fb97c9..fedc330 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -142,4 +142,10 @@ char * checker_message (struct checker *);
 void checker_clear_message (struct checker *c);
 void checker_get (char *, struct checker *, char *);
 
+/* Functions exported by path checker dynamic libraries (.so) */
+int libcheck_check(struct checker *);
+int libcheck_init(struct checker *);
+void libcheck_free(struct checker *);
+void libcheck_repair(struct checker *);
+
 #endif /* _CHECKERS_H */
-- 
2.10.1
