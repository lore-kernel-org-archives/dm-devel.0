From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 26/72] libmultipath: mark unused params in
	getprio() methods
Date: Sat, 12 Oct 2019 21:28:09 +0000
Message-ID: <20191012212703.12989-27-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prioritizers/ana.c          | 3 ++-
 libmultipath/prioritizers/const.c        | 4 +++-
 libmultipath/prioritizers/datacore.c     | 3 ++-
 libmultipath/prioritizers/emc.c          | 3 ++-
 libmultipath/prioritizers/hds.c          | 3 ++-
 libmultipath/prioritizers/hp_sw.c        | 3 ++-
 libmultipath/prioritizers/iet.c          | 3 ++-
 libmultipath/prioritizers/ontap.c        | 3 ++-
 libmultipath/prioritizers/random.c       | 4 +++-
 libmultipath/prioritizers/rdac.c         | 3 ++-
 libmultipath/prioritizers/sysfs.c        | 3 ++-
 libmultipath/prioritizers/weightedpath.c | 3 ++-
 12 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/libmultipath/prioritizers/ana.c b/libmultipath/prioritizers/ana.c
index bcb1dbf8..9f7adfa5 100644
--- a/libmultipath/prioritizers/ana.c
+++ b/libmultipath/prioritizers/ana.c
@@ -202,7 +202,8 @@ static int get_ana_info(struct path * pp)
  * - ALUA's LBA-dependent state has no ANA equivalent.
  */
 
-int getprio(struct path *pp, char *args, unsigned int timeout)
+int getprio(struct path *pp, __attribute__((unused)) char *args,
+	    __attribute__((unused)) unsigned int timeout)
 {
 	int rc;
 
diff --git a/libmultipath/prioritizers/const.c b/libmultipath/prioritizers/const.c
index aad69274..059d8593 100644
--- a/libmultipath/prioritizers/const.c
+++ b/libmultipath/prioritizers/const.c
@@ -2,7 +2,9 @@
 
 #include "prio.h"
 
-int getprio(struct path * pp, char * args, unsigned int timeout)
+int getprio(__attribute__((unused)) struct path * pp,
+	    __attribute__((unused)) char * args,
+	    __attribute__((unused)) unsigned int timeout)
 {
 	return 1;
 }
diff --git a/libmultipath/prioritizers/datacore.c b/libmultipath/prioritizers/datacore.c
index 59c98164..02dc2e27 100644
--- a/libmultipath/prioritizers/datacore.c
+++ b/libmultipath/prioritizers/datacore.c
@@ -98,7 +98,8 @@ int datacore_prio (const char *dev, int sg_fd, char * args)
 	return 0;
 }
 
-int getprio(struct path * pp, char * args, unsigned int timeout)
+int getprio(struct path * pp, char * args,
+	    __attribute__((unused)) unsigned int timeout)
 {
 	return datacore_prio(pp->dev, pp->fd, args);
 }
diff --git a/libmultipath/prioritizers/emc.c b/libmultipath/prioritizers/emc.c
index a2f74875..3b63cca0 100644
--- a/libmultipath/prioritizers/emc.c
+++ b/libmultipath/prioritizers/emc.c
@@ -81,7 +81,8 @@ out:
 	return(ret);
 }
 
-int getprio (struct path * pp, char * args, unsigned int timeout)
+int getprio (struct path *pp, __attribute__((unused)) char *args,
+	     unsigned int timeout)
 {
 	return emc_clariion_prio(pp->dev, pp->fd, timeout);
 }
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index 70fb5d19..88cac5f0 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -168,7 +168,8 @@ int hds_modular_prio (const char *dev, int fd, unsigned int timeout)
 	return -1;
 }
 
-int getprio (struct path * pp, char * args, unsigned int timeout)
+int getprio (struct path * pp, __attribute__((unused)) char *args,
+	     unsigned int timeout)
 {
 	return hds_modular_prio(pp->dev, pp->fd, timeout);
 }
diff --git a/libmultipath/prioritizers/hp_sw.c b/libmultipath/prioritizers/hp_sw.c
index 6b0ed398..5b85ad2e 100644
--- a/libmultipath/prioritizers/hp_sw.c
+++ b/libmultipath/prioritizers/hp_sw.c
@@ -95,7 +95,8 @@ out:
 	return(ret);
 }
 
-int getprio (struct path * pp, char * args, unsigned int timeout)
+int getprio (struct path *pp, __attribute__((unused)) char *args,
+	     unsigned int timeout)
 {
 	return hp_sw_prio(pp->dev, pp->fd, timeout);
 }
diff --git a/libmultipath/prioritizers/iet.c b/libmultipath/prioritizers/iet.c
index a4ea61ef..e98773cf 100644
--- a/libmultipath/prioritizers/iet.c
+++ b/libmultipath/prioritizers/iet.c
@@ -138,7 +138,8 @@ int iet_prio(const char *dev, char * args)
 	return 10;
 }
 
-int getprio(struct path * pp, char * args, unsigned int timeout)
+int getprio(struct path * pp, char * args,
+	    __attribute__((unused)) unsigned int timeout)
 {
 	return iet_prio(pp->dev, args);
 }
diff --git a/libmultipath/prioritizers/ontap.c b/libmultipath/prioritizers/ontap.c
index 6505033f..262e69d2 100644
--- a/libmultipath/prioritizers/ontap.c
+++ b/libmultipath/prioritizers/ontap.c
@@ -241,7 +241,8 @@ prio_select:
 	}
 }
 
-int getprio (struct path * pp, char * args, unsigned int timeout)
+int getprio (struct path *pp, __attribute__((unused)) char *args,
+	     unsigned int timeout)
 {
 	return ontap_prio(pp->dev, pp->fd, timeout);
 }
diff --git a/libmultipath/prioritizers/random.c b/libmultipath/prioritizers/random.c
index 4a27123b..b742ac23 100644
--- a/libmultipath/prioritizers/random.c
+++ b/libmultipath/prioritizers/random.c
@@ -5,7 +5,9 @@
 
 #include "prio.h"
 
-int getprio(struct path * pp, char * args, unsigned int timeout)
+int getprio(__attribute__((unused)) struct path *pp,
+	    __attribute__((unused)) char *args,
+	    __attribute__((unused)) unsigned int timeout)
 {
 	struct timeval tv;
 
diff --git a/libmultipath/prioritizers/rdac.c b/libmultipath/prioritizers/rdac.c
index f5df0321..92a2fb85 100644
--- a/libmultipath/prioritizers/rdac.c
+++ b/libmultipath/prioritizers/rdac.c
@@ -91,7 +91,8 @@ out:
 	return(ret);
 }
 
-int getprio (struct path * pp, char * args, unsigned int timeout)
+int getprio (struct path *pp, __attribute__((unused)) char *args,
+	     unsigned int timeout)
 {
 	return rdac_prio(pp->dev, pp->fd, timeout);
 }
diff --git a/libmultipath/prioritizers/sysfs.c b/libmultipath/prioritizers/sysfs.c
index ff567df7..a6feb421 100644
--- a/libmultipath/prioritizers/sysfs.c
+++ b/libmultipath/prioritizers/sysfs.c
@@ -36,7 +36,8 @@ int get_exclusive_pref_arg(char *args)
 	return 1;
 }
 
-int getprio (struct path * pp, char * args, unsigned int timeout)
+int getprio (struct path * pp, char *args,
+	     __attribute__((unused)) unsigned int timeout)
 {
 	int prio = 0, rc, i;
 	char buff[512];
diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index e0f3efbb..916970df 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -143,7 +143,8 @@ int prio_path_weight(struct path *pp, char *prio_args)
 	return priority;
 }
 
-int getprio(struct path *pp, char *args, unsigned int timeout)
+int getprio(struct path *pp, char *args,
+	    __attribute__((unused)) unsigned int timeout)
 {
 	return prio_path_weight(pp, args);
 }
-- 
2.23.0
