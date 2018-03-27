From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/2] libmultipath: hwhandler auto-detection for
	ALUA
Date: Tue, 27 Mar 2018 23:50:52 +0200
Message-ID: <20180327215053.3631-2-mwilck@suse.com>
References: <20180327215053.3631-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180327215053.3631-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

If the hardware handler isn't explicitly set, infer ALUA support
from the pp->tpgs attribute. Likewise, if ALUA is selected, but
not supported by the hardware, fall back to no hardware handler.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/propsel.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 93974a482336..dc24450eb775 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -43,10 +43,13 @@ do {									\
 		goto out;						\
 	}								\
 } while(0)
+
+static char default_origin[] = "(setting: multipath internal)";
+
 #define do_default(dest, value)						\
 do {									\
 	dest = value;							\
-	origin = "(setting: multipath internal)";			\
+	origin = default_origin;					\
 } while(0)
 
 #define mp_set_mpe(var)							\
@@ -373,16 +376,20 @@ static int get_dh_state(struct path *pp, char *value, size_t value_len)
 
 int select_hwhandler(struct config *conf, struct multipath *mp)
 {
-	char *origin;
+	const char *origin;
 	struct path *pp;
 	/* dh_state is no longer than "detached" */
 	char handler[12];
+	static char alua_name[] = "1 alua";
+	static const char tpgs_origin[]= "(setting: autodetected from TPGS)";
 	char *dh_state;
 	int i;
+	bool all_tpgs = true;
 
 	dh_state = &handler[2];
 	if (mp->retain_hwhandler != RETAIN_HWHANDLER_OFF) {
 		vector_foreach_slot(mp->paths, pp, i) {
+			all_tpgs = all_tpgs && (pp->tpgs > 0);
 			if (get_dh_state(pp, dh_state, sizeof(handler) - 2) > 0
 			    && strcmp(dh_state, "detached")) {
 				memcpy(handler, "1 ", 2);
@@ -397,6 +404,14 @@ int select_hwhandler(struct config *conf, struct multipath *mp)
 	mp_set_conf(hwhandler);
 	mp_set_default(hwhandler, DEFAULT_HWHANDLER);
 out:
+	if (all_tpgs && !strcmp(mp->hwhandler, DEFAULT_HWHANDLER) &&
+		origin == default_origin) {
+		mp->hwhandler = alua_name;
+		origin = tpgs_origin;
+	} else if (!all_tpgs && !strcmp(mp->hwhandler, alua_name)) {
+		mp->hwhandler = DEFAULT_HWHANDLER;
+		origin = tpgs_origin;
+	}
 	mp->hwhandler = STRDUP(mp->hwhandler);
 	condlog(3, "%s: hardware_handler = \"%s\" %s", mp->alias, mp->hwhandler,
 		origin);
-- 
2.16.1
