From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/78] multipath.rules: Whitelist devices
Date: Mon, 16 Mar 2015 13:36:11 +0100
Message-ID: <1426509425-15978-25-git-send-email-hare@suse.de>
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

Currently multipath runs only on SCSI and DASD
devices (and cciss, but they are no longer supported).
So we can as well whitelist them and avoid the curious
warning about 'multipath -u /dev/loop failed'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipath/multipath.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index 5bc5068..56056bf 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -4,7 +4,7 @@ SUBSYSTEM!="block", GOTO="end_mpath"
 ENV{MPATH_SBIN_PATH}="/sbin"
 TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
 
-SUBSYSTEM=="block", ACTION=="add|change", KERNEL!="dm-*", \
+SUBSYSTEM=="block", ACTION=="add|change", KERNEL=="sd*[!0-9]|dasd*[!0-9]", \
 	ENV{DM_MULTIPATH_DEVICE_PATH}!="1", \
 	PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -u %k", \
 	ENV{DM_MULTIPATH_DEVICE_PATH}="1" \
-- 
1.8.4.5
