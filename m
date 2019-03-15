From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 5/9] libmultipath: detect_alua(): use system
	timeout
Date: Fri, 15 Mar 2019 17:11:51 +0100
Message-ID: <20190315161155.24062-6-mwilck@suse.com>
References: <20190315161155.24062-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190315161155.24062-1-mwilck@suse.com>
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

This is not the path checker - we don't need to use the
configured checker timeout here. This makes it possible to
call this function without a current (struct config *).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 270dedc9..b2a43e86 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -833,11 +833,14 @@ get_serial (char * str, int maxlen, int fd)
 }
 
 static void
-detect_alua(struct path * pp, struct config *conf)
+detect_alua(struct path * pp)
 {
 	int ret;
 	int tpgs;
-	unsigned int timeout = conf->checker_timeout;
+	unsigned int timeout;
+
+	if (sysfs_get_timeout(pp, &timeout) <= 0)
+		timeout = DEF_TIMEOUT;
 
 	if ((tpgs = get_target_port_group_support(pp, timeout)) <= 0) {
 		pp->tpgs = TPGS_NONE;
@@ -1519,7 +1522,7 @@ scsi_ioctl_pathinfo (struct path * pp, struct config *conf, int mask)
 	const char *attr_path = NULL;
 
 	if (pp->tpgs == TPGS_UNDEF)
-		detect_alua(pp, conf);
+		detect_alua(pp);
 
 	if (!(mask & DI_SERIAL))
 		return;
-- 
2.21.0
