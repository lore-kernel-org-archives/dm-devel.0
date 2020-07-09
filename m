From: mwilck@suse.com
Subject: [PATCH 74/74] libmultipath: dmparser: constify function
	arguments
Date: Thu,  9 Jul 2020 12:51:45 +0200
Message-ID: <20200709105145.9211-22-mwilck@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

With the previous change that avoids additions to pathvec,
the pathvec argument to disassemble_map() is const now.
Also use const for the string arguments where possible.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dmparser.c | 11 ++++++-----
 libmultipath/dmparser.h |  4 ++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index e629a89..6d9488f 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -128,10 +128,11 @@ err:
  * Call update_pathvec_from_dm() after this function to make sure
  * all data structures are in a sane state.
  */
-int disassemble_map(vector pathvec, char *params, struct multipath *mpp)
+int disassemble_map(const struct _vector *pathvec,
+		    const char *params, struct multipath *mpp)
 {
 	char * word;
-	char * p;
+	const char *p;
 	int i, j, k;
 	int num_features = 0;
 	int num_hwhandler = 0;
@@ -344,10 +345,10 @@ out:
 	return 1;
 }
 
-int disassemble_status(char *params, struct multipath *mpp)
+int disassemble_status(const char *params, struct multipath *mpp)
 {
-	char * word;
-	char * p;
+	char *word;
+	const char *p;
 	int i, j, k;
 	int num_feature_args;
 	int num_hwhandler_args;
diff --git a/libmultipath/dmparser.h b/libmultipath/dmparser.h
index 1b45df0..212fee5 100644
--- a/libmultipath/dmparser.h
+++ b/libmultipath/dmparser.h
@@ -1,3 +1,3 @@
 int assemble_map (struct multipath *, char *, int);
-int disassemble_map (vector, char *, struct multipath *);
-int disassemble_status (char *, struct multipath *);
+int disassemble_map (const struct _vector *, const char *, struct multipath *);
+int disassemble_status (const char *, struct multipath *);
-- 
2.26.2
