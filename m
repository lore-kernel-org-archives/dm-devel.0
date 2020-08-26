From: mwilck@suse.com
Subject: [PATCH v2 10/10] libmultipath: validate_config_strvec():
	avoid out-of-bounds access
Date: Wed, 26 Aug 2020 11:59:07 +0200
Message-ID: <20200826095907.5576-11-mwilck@suse.com>
References: <20200826095907.5576-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200826095907.5576-1-mwilck@suse.com>
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

Always check the length of strvec before accessing elements.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/parser.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index e6753c4..ed6d5d6 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -436,14 +436,16 @@ is_sublevel_keyword(char *str)
 int
 validate_config_strvec(vector strvec, char *file)
 {
-	char *str;
+	char *str = NULL;
 	int i;
 
-	str = VECTOR_SLOT(strvec, 0);
+	if (strvec && VECTOR_SIZE(strvec) > 0)
+		str = VECTOR_SLOT(strvec, 0);
+
 	if (str == NULL) {
 		condlog(0, "can't parse option on line %d of %s",
 			line_nr, file);
-	return -1;
+		return -1;
 	}
 	if (*str == '}') {
 		if (VECTOR_SIZE(strvec) > 1)
@@ -456,7 +458,7 @@ validate_config_strvec(vector strvec, char *file)
 		return -1;
 	}
 	if (is_sublevel_keyword(str)) {
-		str = VECTOR_SLOT(strvec, 1);
+		str = VECTOR_SIZE(strvec) > 1 ? VECTOR_SLOT(strvec, 1) : NULL;
 		if (str == NULL)
 			condlog(0, "missing '{' on line %d of %s",
 				line_nr, file);
@@ -467,7 +469,7 @@ validate_config_strvec(vector strvec, char *file)
 			condlog(0, "ignoring extra data starting with '%s' on line %d of %s", (char *)VECTOR_SLOT(strvec, 2), line_nr, file);
 		return 0;
 	}
-	str = VECTOR_SLOT(strvec, 1);
+	str = VECTOR_SIZE(strvec) > 1 ? VECTOR_SLOT(strvec, 1) : NULL;
 	if (str == NULL) {
 		condlog(0, "missing value for option '%s' on line %d of %s",
 			(char *)VECTOR_SLOT(strvec, 0), line_nr, file);
-- 
2.28.0
