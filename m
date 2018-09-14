From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/5] libmultipath: nvme: shorter topology output
Date: Fri, 14 Sep 2018 14:51:00 +0200
Message-ID: <20180914125103.1154-2-mwilck@suse.com>
References: <20180914125103.1154-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180914125103.1154-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The nvme foreign code maps the NVMe subsys NQN to the "%n"
wildcard ("alias"). Some real-world devices use very lengthy
expressions for the subsys NQN (counted 95 characters on one
system here), making the "multipath -ll" output hardly readable
for humans. Use a shorter and more concise printout instead,
based on the WWID only.

The subsys NQN is still available via the "%n" wildcard:
"multipathd show maps format %n".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign/nvme.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index fca3235f..8887a755 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -286,10 +286,18 @@ static int snprint_nvme_path(const struct gen_path *gp,
 	return 0;
 }
 
+static int nvme_style(const struct gen_multipath* gm,
+		      char *buf, int len, int verbosity)
+{
+	int n = snprintf(buf, len, "%%w [%%G]:%%d %%s");
+
+	return (n < len ? n : len - 1);
+}
+
 static const struct gen_multipath_ops nvme_map_ops = {
 	.get_pathgroups = nvme_mp_get_pgs,
 	.rel_pathgroups = nvme_mp_rel_pgs,
-	.style = generic_style,
+	.style = nvme_style,
 	.snprint = snprint_nvme_map,
 };
 
-- 
2.18.0
