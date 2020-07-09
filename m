From: mwilck@suse.com
Subject: [PATCH 14/35] libmultipath: rlookup_binding(): remove
	newline in log message
Date: Thu,  9 Jul 2020 12:15:59 +0200
Message-ID: <20200709101620.6786-15-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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

This clutters the log. The corresponding message in lookup_binding()
doesn't have a newline, either.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c | 2 +-
 tests/alias.c        | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 14401ca..35f1beb 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -215,7 +215,7 @@ rlookup_binding(FILE *f, char *buff, const char *map_alias)
 		}
 		if (strcmp(alias, map_alias) == 0){
 			condlog(3, "Found matching alias [%s] in bindings file."
-				"\nSetting wwid to %s", alias, wwid);
+				" Setting wwid to %s", alias, wwid);
 			strlcpy(buff, wwid, WWID_SIZE);
 			return 0;
 		}
diff --git a/tests/alias.c b/tests/alias.c
index 30414db..22ffd55 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -552,7 +552,7 @@ static void rl_match_a(void **state)
 
 	buf[0] = '\0';
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
-	expect_condlog(3, "Found matching alias [MPATHa] in bindings file.\n"
+	expect_condlog(3, "Found matching alias [MPATHa] in bindings file. "
 		       "Setting wwid to WWID0\n");
 	rc = rlookup_binding(NULL, buf, "MPATHa");
 	assert_int_equal(rc, 0);
@@ -617,7 +617,7 @@ static void rl_match_b(void **state)
 	will_return(__wrap_fgets, "MPATHa WWID0\n");
 	will_return(__wrap_fgets, "MPATHz WWID26\n");
 	will_return(__wrap_fgets, "MPATHb WWID2\n");
-	expect_condlog(3, "Found matching alias [MPATHb] in bindings file.\n"
+	expect_condlog(3, "Found matching alias [MPATHb] in bindings file. "
 		       "Setting wwid to WWID2\n");
 	rc = rlookup_binding(NULL, buf, "MPATHb");
 	assert_int_equal(rc, 0);
-- 
2.26.2
