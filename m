From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: fix errors in auto generated
	man pages
Date: Mon, 12 Mar 2018 21:52:43 +0100
Message-ID: <20180312205243.10892-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Gris Ge <fge@redhat.com>, device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

dmmp_path_blk_name_get.3:
<standard input>:14: warning: macro `nvme0n1'.' not defined

dmmp_mpath_kdev_name_get.3:
<standard input>:15: warning: macro `dm-1'.' not defined

Cc: Gris Ge <fge@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libdmmp/libdmmp/libdmmp.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libdmmp/libdmmp/libdmmp.h b/libdmmp/libdmmp/libdmmp.h
index e157982..6e6610d 100644
--- a/libdmmp/libdmmp/libdmmp.h
+++ b/libdmmp/libdmmp/libdmmp.h
@@ -389,7 +389,7 @@ DMMP_DLL_EXPORT const char *dmmp_mpath_name_get(struct dmmp_mpath *dmmp_mp);
  * dmmp_mpath_kdev_name_get() - Retrieve kernel DEVNAME of certain mpath.
  *
  * Retrieve DEVNAME name used by kernel uevent of specified mpath.
- * Example: 'dm-1'.
+ * For example: 'dm-1'.
  *
  * @dmmp_mp:
  *	Pointer of 'struct dmmp_mpath'.
@@ -553,8 +553,8 @@ DMMP_DLL_EXPORT void dmmp_path_array_get(struct dmmp_path_group *dmmp_pg,
 /**
  * dmmp_path_blk_name_get() - Retrieve block name.
  *
- * Retrieve block name of certain path. The example of block names are 'sda',
- * 'nvme0n1'.
+ * Retrieve block name of certain path. The example of block names are "sda",
+ * "nvme0n1".
  *
  * @dmmp_p:
  *	Pointer of 'struct dmmp_path'.
-- 
2.14.3
