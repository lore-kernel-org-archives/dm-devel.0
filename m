From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 21/28] tests/hwtable: add test for local
	configuration dump
Date: Fri,  8 Jun 2018 12:20:34 +0200
Message-ID: <20180608102041.22904-22-mwilck@suse.com>
References: <20180608102041.22904-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180608102041.22904-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

This adds another test iteration in test_driver(): It now tests:

 1) with "user-supplied" configuration,
 2) using the full config dump (equivalent with "multipath -t" output),
 3) using the local config dump as implemented in the previous patch.

Again, the properties of paths and maps should be the same for all 3
scenarios. For 3), the "multipath -t" output can't be expected to be
exactly equal to the output in 1), because merging of hwentries may move the
position of a hwentry down in the hwentry list, and empty "multipath"
sections are being added.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/hwtable.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/tests/hwtable.c b/tests/hwtable.c
index 3c3caddd..08ed67d3 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -446,21 +446,42 @@ static const struct key_value npr_queue = { _no_path_retry, "queue" };
  * Dump the configuration, subistitute the dumped configuration
  * for the current one, and verify that the result is identical.
  */
-static void replicate_config(const struct hwt_state *hwt)
+static void replicate_config(const struct hwt_state *hwt, bool local)
 {
 	char *cfg1, *cfg2;
+	vector hwtable;
 	struct config *conf;
 
-	condlog(1, "--- %s: replicating configuration", __func__);
+	condlog(1, "--- %s: replicating %s configuration", __func__,
+		local ? "local" : "full");
 
 	conf = get_multipath_config();
-	cfg1 = snprint_config(conf, NULL, NULL);
+	if (!local)
+		/* "full" configuration */
+		cfg1 = snprint_config(conf, NULL, NULL);
+	else {
+		/* "local" configuration */
+		hwtable = get_used_hwes(hwt->vecs->pathvec);
+		cfg1 = snprint_config(conf, NULL, hwtable);
+	}
 
 	assert_non_null(cfg1);
 	put_multipath_config(conf);
 
 	replace_config(hwt, cfg1);
 
+	/*
+	 * The local configuration adds multipath entries, and may move device
+	 * entries for local devices to the end of the list. Identical config
+	 * strings therefore can't be expected in the "local" case.
+	 * That doesn't matter. The important thing is that, with the reloaded
+	 * configuration, the test case still passes.
+	 */
+	if (local) {
+		free(cfg1);
+		return;
+	}
+
 	conf = get_multipath_config();
 	cfg2 = snprint_config(conf, NULL, NULL);
 	assert_non_null(cfg2);
@@ -504,7 +525,11 @@ static void test_driver(void **state)
 	_conf = LOAD_CONFIG(hwt);
 	hwt->test(hwt);
 
-	replicate_config(hwt);
+	replicate_config(hwt, false);
+	reset_vecs(hwt->vecs);
+	hwt->test(hwt);
+
+	replicate_config(hwt, true);
 	reset_vecs(hwt->vecs);
 	hwt->test(hwt);
 
-- 
2.17.0
