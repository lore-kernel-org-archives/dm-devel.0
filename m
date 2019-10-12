From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 64/72] multipath tests: util: fix clang strlcpy
	warnings
Date: Sat, 12 Oct 2019 21:28:57 +0000
Message-ID: <20191012212703.12989-65-martin.wilck@suse.com>
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

clang erroneously thought that we were using the size of the source
for the destination, while they are equal. Trick it into accepting
the code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/util.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tests/util.c b/tests/util.c
index 4e04a480..7c486fca 100644
--- a/tests/util.c
+++ b/tests/util.c
@@ -328,11 +328,12 @@ static void test_strlcpy_5(void **state)
 {
 	char *tst;
 	int rc;
+	const int sz = sizeof(src_str);
 
-	tst = malloc(sizeof(src_str));
+	tst = malloc(sz);
 	memset(tst, 'f', sizeof(src_str));
 
-	rc = strlcpy(tst, src_str, sizeof(src_str));
+	rc = strlcpy(tst, src_str, sz);
 	assert_int_equal(rc, strlen(src_str));
 	assert_string_equal(src_str, tst);
 
@@ -344,15 +345,16 @@ static void test_strlcpy_6(void **state)
 {
 	char *tst;
 	int rc;
+	const int sz = sizeof(src_str);
 
-	tst = malloc(sizeof(src_str) + 2);
-	memset(tst, 'f', sizeof(src_str) + 2);
+	tst = malloc(sz + 2);
+	memset(tst, 'f', sz + 2);
 
-	rc = strlcpy(tst, src_str, sizeof(src_str) + 2);
+	rc = strlcpy(tst, src_str, sz + 2);
 	assert_int_equal(rc, strlen(src_str));
 	assert_string_equal(src_str, tst);
-	assert_int_equal(tst[sizeof(src_str)], 'f');
-	assert_int_equal(tst[sizeof(src_str) + 1], 'f');
+	assert_int_equal(tst[sz], 'f');
+	assert_int_equal(tst[sz + 1], 'f');
 
 	free(tst);
 }
-- 
2.23.0
