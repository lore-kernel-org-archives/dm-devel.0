From: mwilck@suse.com
Subject: [PATCH 1/5] multipath-tools tests: fix memory leak in
	alias test
Date: Tue, 25 Aug 2020 23:24:46 +0200
Message-ID: <20200825212450.8561-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/alias.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tests/alias.c b/tests/alias.c
index 22ffd55..5624138 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -652,6 +652,7 @@ static void al_a(void **state)
 	alias = allocate_binding(0, "WWIDa", 1, "MPATH");
 	assert_ptr_not_equal(alias, NULL);
 	assert_string_equal(alias, "MPATHa");
+	free(alias);
 }
 
 static void al_zz(void **state)
@@ -668,6 +669,7 @@ static void al_zz(void **state)
 	alias = allocate_binding(0, "WWIDzz", 26*26 + 26, "MPATH");
 	assert_ptr_not_equal(alias, NULL);
 	assert_string_equal(alias, "MPATHzz");
+	free(alias);
 }
 
 static void al_0(void **state)
-- 
2.28.0
