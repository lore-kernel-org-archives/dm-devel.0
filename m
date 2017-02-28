From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 12/33] libmultipath/discovery: do not cache
	'access_state' sysfs attribute
Date: Tue, 28 Feb 2017 17:23:08 +0100
Message-ID: <20170228162329.14517-13-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>

When reading the 'access_state' sysfs attribute we should not be
using libudev as this will cache the value, causing us to lose
any update to the attribute.


Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/discovery.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index bd8ab557..4d4fc895 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -210,8 +210,6 @@ declare_sysfs_get_str(devtype);
 declare_sysfs_get_str(vendor);
 declare_sysfs_get_str(model);
 declare_sysfs_get_str(rev);
-declare_sysfs_get_str(access_state);
-declare_sysfs_get_str(preferred_path);
 
 int
 sysfs_set_max_sectors_kb(struct multipath *mpp)
@@ -527,10 +525,10 @@ sysfs_get_asymmetric_access_state(struct path *pp, char *buff, int buflen)
 	if (!parent)
 		return -1;
 
-	if (sysfs_get_access_state(parent, buff, buflen) <= 0)
+	if (sysfs_attr_get_value(parent, "access_state", buff, buflen) <= 0)
 		return -1;
 
-	if (sysfs_get_preferred_path(parent, value, 16) <= 0)
+	if (sysfs_attr_get_value(parent, "preferred_path", value, 16) <= 0)
 		return 0;
 
 	preferred = strtoul(value, &eptr, 0);
-- 
2.11.0
