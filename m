From: Colin Watson <cjwatson@canonical.com>
Subject: [PATCH] Honour ALUA preference indicator
Date: Fri, 12 Feb 2010 12:18:59 +0000
Message-ID: <20100212121859.GK4409@riva.ucam.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Yingying Zhao <yingying.zhao@intel.com>
List-Id: dm-devel.ids

SPC defines the preference indicator (bit 7 of the first byte returned
by REPORT TARGET PORT GROUPS) as indicating a preferred primary target
port group, and says that applications may use it to influence path
selection.  Choose TPGs with this bit set over TPGs with it unset.

This fixes failback handling with the Intel Modular Server.

Signed-off-by: Yingying Zhao <yingying.zhao@intel.com>
Signed-off-by: Colin Watson <cjwatson@canonical.com>
---
 libmultipath/prioritizers/alua.c      |   12 ++++++++++--
 libmultipath/prioritizers/alua_spc3.h |    2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index 0048a44..abf6232 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -37,6 +37,7 @@ get_alua_info(int fd)
 	};
 	int	rc;
 	int	tpg;
+	int	aas;
 
 	rc = get_target_port_group_support(fd);
 	if (rc < 0)
@@ -53,22 +54,27 @@ get_alua_info(int fd)
 	rc = get_asymmetric_access_state(fd, tpg);
 	if (rc < 0)
 		return -ALUA_PRIO_GETAAS_FAILED;
+	aas = (rc & 0x0f);
 
 	condlog(3, "aas = [%s]",
-		(rc < 4) ? aas_string[rc] : "invalid/reserved");
+		(aas < 4) ? aas_string[aas] : "invalid/reserved");
 	return rc;
 }
 
 int getprio (struct path * pp)
 {
 	int rc;
+	int aas;
+	int priopath;
 
 	if (pp->fd < 0)
 		return -ALUA_PRIO_NO_INFORMATION;
 
 	rc = get_alua_info(pp->fd);
 	if (rc >= 0) {
-		switch(rc) {
+		aas = (rc & 0x0f);
+		priopath = (rc & 0x80);
+		switch(aas) {
 			case AAS_OPTIMIZED:
 				rc = 50;
 				break;
@@ -81,6 +87,8 @@ int getprio (struct path * pp)
 			default:
 				rc = 0;
 		}
+		if (priopath)
+			rc += 80;
 	} else {
 		switch(-rc) {
 			case ALUA_PRIO_NOT_SUPPORTED:
diff --git a/libmultipath/prioritizers/alua_spc3.h b/libmultipath/prioritizers/alua_spc3.h
index bddbbdd..4bbdded 100644
--- a/libmultipath/prioritizers/alua_spc3.h
+++ b/libmultipath/prioritizers/alua_spc3.h
@@ -299,7 +299,7 @@ struct rtpg_tpg_dscr {
 static inline int
 rtpg_tpg_dscr_get_aas(struct rtpg_tpg_dscr *d)
 {
-	return (d->b0 & 0x0f);
+	return (d->b0 & 0x8f);
 }
 
 struct rtpg_data {
