From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/13] Check for !SUSPENDED in kpartx rules
Date: Wed, 16 Jan 2013 13:14:05 +0100
Message-ID: <1358338456-1234-3-git-send-email-hare@suse.de>
References: <1358338456-1234-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358338456-1234-1-git-send-email-hare@suse.de>
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

Read-only devices appear as DM_STATE=READONLY, so we should
invert the check in kpartx rules to have kpartx run on
readonly devices, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/kpartx.rules |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 64863a0..febac90 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -22,7 +22,7 @@ ENV{DM_PART}=="?*", \
         SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}-part$env{DM_PART}"
 
 # Create dm tables for partitions
-ENV{DM_STATE}=="ACTIVE", ENV{DM_UUID}=="mpath-*", \
+ENV{DM_STATE}!="SUSPENDED", ENV{DM_UUID}=="mpath-*", \
         RUN+="/sbin/kpartx -u -p -part /dev/$name"
 
 LABEL="kpartx_end"
-- 
1.7.4.2
