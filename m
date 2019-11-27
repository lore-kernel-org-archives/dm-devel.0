From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 5/5] libmultipath: fix ALUA autodetection when
 paths are down
Date: Wed, 27 Nov 2019 15:05:53 +0000
Message-ID: <20191127150604.31417-6-martin.wilck@suse.com>
References: <20191127150604.31417-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191127150604.31417-1-martin.wilck@suse.com>
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
Cc: Chongyun Wu <wu.chongyun@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

If a single path was offline when detect_alua() was called,
multipathd would assume ALUA was generally unsupported.

Fix that by assuming that if at least one path has ALUA support and
no path explicitly does not have it, ALUA is supported.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

---
 libmultipath/discovery.c | 22 +++++++++++++++++++++-
 libmultipath/propsel.c   | 20 +++++++++++++++++---
 2 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 4288c9fd..5f41dcb7 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -871,6 +871,10 @@ get_serial (char * str, int maxlen, int fd)
 	return 1;
 }
 
+/*
+ * Side effect: sets pp->tpgs if it could be determined.
+ * If ALUA calls fail because paths are unreachable, pp->tpgs remains unchanged.
+ */
 static void
 detect_alua(struct path * pp)
 {
@@ -881,12 +885,28 @@ detect_alua(struct path * pp)
 	if (sysfs_get_timeout(pp, &timeout) <= 0)
 		timeout = DEF_TIMEOUT;
 
-	if ((tpgs = get_target_port_group_support(pp, timeout)) <= 0) {
+	tpgs = get_target_port_group_support(pp, timeout);
+	if (tpgs == -RTPG_INQUIRY_FAILED)
+		return;
+	else if (tpgs <= 0) {
 		pp->tpgs = TPGS_NONE;
 		return;
 	}
+
+	if (pp->fd == -1 || pp->offline)
+		return;
+
 	ret = get_target_port_group(pp, timeout);
 	if (ret < 0 || get_asymmetric_access_state(pp, ret, timeout) < 0) {
+		int state;
+
+		if (ret == -RTPG_INQUIRY_FAILED)
+			return;
+
+		state = path_offline(pp);
+		if (state == PATH_DOWN || state == PATH_PENDING)
+			return;
+
 		pp->tpgs = TPGS_NONE;
 		return;
 	}
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 27e8d68a..a5fc6ba0 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -432,12 +432,26 @@ int select_hwhandler(struct config *conf, struct multipath *mp)
 	static const char tpgs_origin[]= "(setting: autodetected from TPGS)";
 	char *dh_state;
 	int i;
-	bool all_tpgs = true;
+	bool all_tpgs = true, one_tpgs = false;
 
 	dh_state = &handler[2];
 
-	vector_foreach_slot(mp->paths, pp, i)
-		all_tpgs = all_tpgs && (path_get_tpgs(pp) > 0);
+	/*
+	 * TPGS_UNDEF means that ALUA support couldn't determined either way
+	 * yet, probably because the path was always down.
+	 * If at least one path does have TPGS support, and no path has
+	 * TPGS_NONE, assume that TPGS would be supported by all paths if
+	 * all were up.
+	 */
+	vector_foreach_slot(mp->paths, pp, i) {
+		int tpgs = path_get_tpgs(pp);
+
+		all_tpgs = all_tpgs && tpgs != TPGS_NONE;
+		one_tpgs = one_tpgs ||
+			(tpgs != TPGS_NONE && tpgs != TPGS_UNDEF);
+	}
+	all_tpgs = all_tpgs && one_tpgs;
+
 	if (mp->retain_hwhandler != RETAIN_HWHANDLER_OFF) {
 		vector_foreach_slot(mp->paths, pp, i) {
 			if (get_dh_state(pp, dh_state, sizeof(handler) - 2) > 0
-- 
2.24.0
