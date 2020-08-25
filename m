From: mwilck@suse.com
Subject: [PATCH 5/5] multipath-tools tests: fix memory leak in
	vpd test
Date: Tue, 25 Aug 2020 23:24:50 +0200
Message-ID: <20200825212450.8561-5-mwilck@suse.com>
References: <20200825212450.8561-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200825212450.8561-1-mwilck@suse.com>
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

regfree() wasn't called on the re used in subst_spaces().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/vpd.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/tests/vpd.c b/tests/vpd.c
index 3cbad81..e2ec65e 100644
--- a/tests/vpd.c
+++ b/tests/vpd.c
@@ -28,13 +28,17 @@ struct vpdtest {
 	char wwid[WWID_SIZE];
 };
 
+static regex_t space_re;
 static int setup(void **state)
 {
 	struct vpdtest *vt = malloc(sizeof(*vt));
+	int rc;
 
 	if (vt == NULL)
 		return -1;
 	*state = vt;
+	rc = regcomp(&space_re, " +", REG_EXTENDED);
+	assert_int_equal(rc, 0);
 	return 0;
 }
 
@@ -44,6 +48,7 @@ static int teardown(void **state)
 
 	free(vt);
 	*state = NULL;
+	regfree(&space_re);
 	return 0;
 }
 
@@ -360,21 +365,14 @@ static char *subst_spaces(const char *src)
 {
 	char *dst = calloc(1, strlen(src) + 1);
 	char *p;
-	static regex_t *re;
 	regmatch_t match;
-	int rc;
+	int rc = 0;
 
 	assert_non_null(dst);
-	if (re == NULL) {
-		re = calloc(1, sizeof(*re));
-		assert_non_null(re);
-		rc = regcomp(re, " +", REG_EXTENDED);
-		assert_int_equal(rc, 0);
-	}
 
-	for (rc = regexec(re, src, 1, &match, 0), p = dst;
+	for (rc = regexec(&space_re, src, 1, &match, 0), p = dst;
 	    rc == 0;
-	    src += match.rm_eo, rc = regexec(re, src, 1, &match, 0)) {
+	    src += match.rm_eo, rc = regexec(&space_re, src, 1, &match, 0)) {
 		memcpy(p, src, match.rm_so);
 		p += match.rm_so;
 		*p = '_';
-- 
2.28.0
