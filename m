From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 18/19] libmultipath/foreign/nvme: show ANA state
Date: Wed, 19 Dec 2018 00:19:30 +0100
Message-ID: <20181218231931.10762-19-mwilck@suse.com>
References: <20181218231931.10762-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181218231931.10762-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Obtain the ana_state attribute from the kernel and
use it to display information about path state and
"priority" of native NVMe multipath.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign/nvme.c | 43 +++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 11849889..bda9bcc4 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -204,12 +204,6 @@ nvme_pg_rel_paths(const struct gen_pathgroup *gpg, const struct _vector *v)
 	/* empty */
 }
 
-static int snprint_nvme_pg(const struct gen_pathgroup *gmp,
-			   char *buff, int len, char wildcard)
-{
-	return snprintf(buff, len, N_A);
-}
-
 static int snprint_hcil(const struct nvme_path *np, char *buf, int len)
 {
 	unsigned int nvmeid, ctlid, nsid;
@@ -249,6 +243,23 @@ static int snprint_nvme_path(const struct gen_path *gp,
 	case 'o':
 		sysfs_attr_get_value(np->ctl, "state", fld, sizeof(fld));
 		return snprintf(buff, len, "%s", fld);
+	case 'T':
+		if (sysfs_attr_get_value(np->udev, "ana_state", fld,
+					 sizeof(fld)) > 0)
+			return snprintf(buff, len, "%s", fld);
+		break;
+	case 'p':
+		if (sysfs_attr_get_value(np->udev, "ana_state", fld,
+					 sizeof(fld)) > 0) {
+			rstrip(fld);
+			if (!strcmp(fld, "optimized"))
+				return snprintf(buff, len, "%d", 50);
+			else if (!strcmp(fld, "non-optimized"))
+				return snprintf(buff, len, "%d", 10);
+			else
+				return snprintf(buff, len, "%d", 0);
+		}
+		break;
 	case 's':
 		snprintf(fld, sizeof(fld), "%s",
 			 udev_device_get_sysattr_value(np->ctl,
@@ -286,12 +297,30 @@ static int snprint_nvme_path(const struct gen_path *gp,
 					udev_device_get_sysname(pci));
 		/* fall through */
 	default:
-		return snprintf(buff, len, "%s", N_A);
 		break;
 	}
+	return snprintf(buff, len, "%s", N_A);
 	return 0;
 }
 
+static int snprint_nvme_pg(const struct gen_pathgroup *gmp,
+			   char *buff, int len, char wildcard)
+{
+	const struct nvme_pathgroup *pg = const_gen_pg_to_nvme(gmp);
+	const struct nvme_path *path = nvme_pg_to_path(pg);
+
+	switch (wildcard) {
+	case 't':
+		return snprint_nvme_path(nvme_path_to_gen(path),
+					 buff, len, 'T');
+	case 'p':
+		return snprint_nvme_path(nvme_path_to_gen(path),
+					 buff, len, 'p');
+	default:
+		return snprintf(buff, len, N_A);
+	}
+}
+
 static int nvme_style(const struct gen_multipath* gm,
 		      char *buf, int len, int verbosity)
 {
-- 
2.19.2
