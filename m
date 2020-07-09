From: mwilck@suse.com
Subject: [PATCH 23/35] libmultipath: make sysfs_pathinfo() static
	and use const
Date: Thu,  9 Jul 2020 12:16:08 +0200
Message-ID: <20200709101620.6786-24-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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

... for the hwtable argument.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 5d4bf7d..c692026 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1284,7 +1284,7 @@ get_vpd_sgio (int fd, int pg, int vend_id, char * str, int maxlen)
 }
 
 static int
-scsi_sysfs_pathinfo (struct path * pp, vector hwtable)
+scsi_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 {
 	struct udev_device *parent;
 	const char *attr_path = NULL;
@@ -1351,7 +1351,7 @@ scsi_sysfs_pathinfo (struct path * pp, vector hwtable)
 }
 
 static int
-nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
+nvme_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 {
 	struct udev_device *parent;
 	const char *attr_path = NULL;
@@ -1396,7 +1396,7 @@ nvme_sysfs_pathinfo (struct path * pp, vector hwtable)
 }
 
 static int
-ccw_sysfs_pathinfo (struct path * pp, vector hwtable)
+ccw_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 {
 	struct udev_device *parent;
 	char attr_buff[NAME_SIZE];
@@ -1455,7 +1455,7 @@ ccw_sysfs_pathinfo (struct path * pp, vector hwtable)
 }
 
 static int
-cciss_sysfs_pathinfo (struct path * pp, vector hwtable)
+cciss_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 {
 	const char * attr_path = NULL;
 	struct udev_device *parent;
@@ -1609,8 +1609,8 @@ path_offline (struct path * pp)
 	return PATH_DOWN;
 }
 
-int
-sysfs_pathinfo(struct path * pp, vector hwtable)
+static int
+sysfs_pathinfo(struct path *pp, const struct _vector *hwtable)
 {
 	int r = common_sysfs_pathinfo(pp);
 
-- 
2.26.2
