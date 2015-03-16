From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/78] kpartx.rules: do not call blkid
Date: Mon, 16 Mar 2015 13:36:01 +0100
Message-ID: <1426509425-15978-15-git-send-email-hare@suse.de>
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

blkid is already called by the device-mapper rules, no need
to do it ourselves.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/kpartx.rules | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 5c0d0ff..226e44a 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -12,12 +12,6 @@ ENV{DM_DEPS}=="0", GOTO="kpartx_end"
 
 ENV{DM_UUID}=="?*", IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
 
-ENV{DM_ACTION}=="PATH_FAILED", ENV{DM_NR_VALID_PATHS}=="0", \
-	GOTO="blkid_end"
-ENV{DM_UUID}=="mpath-*", IMPORT{program}="/sbin/blkid -o udev -p $tempnode"
-ENV{DM_PART}=="?*", IMPORT{program}="/sbin/blkid -o udev -p $tempnode"
-LABEL="blkid_end"
-
 OPTIONS="link_priority=50"
 
 # Create persistent links for multipath tables
-- 
1.8.4.5
