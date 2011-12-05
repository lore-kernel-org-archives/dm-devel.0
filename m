From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm: add documentation of sysfs interface
Date: Mon,  5 Dec 2011 21:02:11 +0100
Message-ID: <1323115331-28465-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: gregkh@suse.de, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Describe attributes provided by device-mapper in /sys/block.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 Documentation/ABI/testing/sysfs-block-dm |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-block-dm

diff --git a/Documentation/ABI/testing/sysfs-block-dm b/Documentation/ABI/testing/sysfs-block-dm
new file mode 100644
index 0000000..87ca569
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-block-dm
@@ -0,0 +1,25 @@
+What:		/sys/block/dm-<num>/dm/name
+Date:		January 2009
+KernelVersion:	2.6.29
+Contact:	dm-devel@redhat.com
+Description:	Device-mapper device name.
+		Read-only string containing mapped device name.
+Users:		util-linux, device-mapper udev rules
+
+What:		/sys/block/dm-<num>/dm/uuid
+Date:		January 2009
+KernelVersion:	2.6.29
+Contact:	dm-devel@redhat.com
+Description:	Device-mapper device UUID.
+		Read-only string containing DM-UUID or empty string
+		if DM-UUID is not set.
+Users:		util-linux, device-mapper udev rules
+
+What:		/sys/block/dm-<num>/dm/suspended
+Date:		June 2009
+KernelVersion:	2.6.31
+Contact:	dm-devel@redhat.com
+Description:	Device-mapper device suspend state.
+		Contains the value 1 while the device is suspended.
+		Otherwise it contains 0. Read-only attribute.
+Users:		util-linux, device-mapper udev rules
-- 
1.7.7.3
