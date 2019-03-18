From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 04/10] libmultipath: constify
	sysfs_get_timeout()
Date: Mon, 18 Mar 2019 12:24:39 +0100
Message-ID: <20190318112445.6636-5-mwilck@suse.com>
References: <20190318112445.6636-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190318112445.6636-1-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 libmultipath/discovery.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6b4a420b..270dedc9 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -256,7 +256,7 @@ ssize_t sysfs_get_inquiry(struct udev_device * udev,
 }
 
 int
-sysfs_get_timeout(struct path *pp, unsigned int *timeout)
+sysfs_get_timeout(const struct path *pp, unsigned int *timeout)
 {
 	const char *attr = NULL;
 	const char *subsys;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 7cacbb6c..a9a28add 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -43,7 +43,7 @@ int store_pathinfo (vector pathvec, struct config *conf,
 		    struct udev_device *udevice, int flag,
 		    struct path **pp_ptr);
 int sysfs_set_scsi_tmo (struct multipath *mpp, int checkint);
-int sysfs_get_timeout(struct path *pp, unsigned int *timeout);
+int sysfs_get_timeout(const struct path *pp, unsigned int *timeout);
 int sysfs_get_host_pci_name(const struct path *pp, char *pci_name);
 int sysfs_get_iscsi_ip_address(const struct path *pp, char *ip_address);
 int sysfs_get_host_adapter_name(const struct path *pp,
-- 
2.21.0
