From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 30/30] fixup "libmultipath: merge hwentries
	inside a conf file"
Date: Mon, 18 Jun 2018 11:54:36 +0200
Message-ID: <20180618095436.22352-2-mwilck@suse.com>
References: <20180615180332.GL3103@octiron.msp.redhat.com>
	<20180618095436.22352-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180618095436.22352-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The previous patch "libmultipath: merge hwentries inside a conf file"
meant to enable checking for duplicate entries not only between different
"sections" of the configuration (i.e. built-in hwtable, multipath.conf,
config dir files), but also inside every section except the built-in
table. This patch fixes a bug to actually implement this new behavior.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c | 3 ---
 tests/hwtable.c       | 3 +--
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 28b76dd2..50826a1d 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -527,9 +527,6 @@ factorize_hwtable (vector hw, int n, const char *table_desc)
 
 restart:
 	vector_foreach_slot(hw, hwe1, i) {
-		if (i == n)
-			break;
-		j = n;
 		/* drop invalid device configs */
 		if (i >= n && (!hwe1->vendor || !hwe1->product)) {
 			condlog(0, "device config in %s missing vendor or product parameter",
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 3488640d..42127adf 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -661,8 +661,7 @@ static void test_broken_hwe(const struct hwt_state *hwt)
 
 	/* foo:bar doesn't match, as hwentry is ignored */
 	pp = mock_path(vnd_foo.value, prd_bar.value);
-	TEST_PROP_BROKEN("prio", prio_name(&pp->prio), prio_emc.value,
-			 DEFAULT_PRIO);
+	TEST_PROP(prio_name(&pp->prio), DEFAULT_PRIO);
 
 	/* boo:bar doesn't match */
 	pp = mock_path(vnd_boo.value, prd_bar.value);
-- 
2.17.1
