From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 25/78] multipath.rules: fixup race condition with
	systemd
Date: Mon, 16 Mar 2015 13:36:12 +0100
Message-ID: <1426509425-15978-26-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

systemd will call 'fsck' on any device, even if no device
type is found. This might cause a race between the mount call
and any fsck call on the device-mapper device.
So for multipath we should arbitrary set the device type to
'none', as then systemd with detect a missing 'fsck.none'
command and skip fsck here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/multipath.rules | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index 56056bf..c76e6b8 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -4,10 +4,11 @@ SUBSYSTEM!="block", GOTO="end_mpath"
 ENV{MPATH_SBIN_PATH}="/sbin"
 TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
 
-SUBSYSTEM=="block", ACTION=="add|change", KERNEL=="sd*[!0-9]|dasd*[!0-9]", \
+SUBSYSTEM=="block", ACTION=="add|change", KERNEL=="sd*|dasd*", \
 	ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
 	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -u %k", \
 	ENV{DM_MULTIPATH_DEVICE_PATH}="1" \
+	ENV{ID_FS_TYPE}="none" \
 	ENV{SYSTEMD_READY}="0"
 
 LABEL="end_mpath"
-- 
1.8.4.5
