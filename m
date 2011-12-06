From: Phillip Susi <psusi@cfl.rr.com>
Subject: [PATCH] multipath-tools: Remove bad udev rules
Date: Tue,  6 Dec 2011 11:12:58 -0500
Message-ID: <1323187978-2385-1-git-send-email-psusi@cfl.rr.com>
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
List-Id: dm-devel.ids

This sample udev rules file contains some rules relating to dmraid
that both should not be there and are broken anyhow.  They should
not be there because firstly, what is a dmraid rule doing in a
kpartx rule file, and secondly, dmraid already activates partitions
itself, so there is no need to run kpartx to do that.  The rule is
broken because it is matching on the DM_UUID starting with "dmraid-",
but this comparison is case sensitive, and it actually starts with
"DMRAID-".

Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
---
 kpartx/kpartx.rules |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 4c23dec..64863a0 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -17,10 +17,6 @@ OPTIONS="link_priority=50"
 ENV{DM_UUID}=="mpath-*", \
 	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
 
-# Create persistent links for dmraid tables
-ENV{DM_UUID}=="dmraid-*", \
-        SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
-
 # Create persistent links for partitions
 ENV{DM_PART}=="?*", \
         SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}-part$env{DM_PART}"
@@ -28,8 +24,6 @@ ENV{DM_PART}=="?*", \
 # Create dm tables for partitions
 ENV{DM_STATE}=="ACTIVE", ENV{DM_UUID}=="mpath-*", \
         RUN+="/sbin/kpartx -u -p -part /dev/$name"
-ENV{DM_STATE}=="ACTIVE", ENV{DM_UUID}=="dmraid-*", \
-        RUN+="/sbin/kpartx -u -p -part /dev/$name"
 
 LABEL="kpartx_end"
 
-- 
1.7.5.4
