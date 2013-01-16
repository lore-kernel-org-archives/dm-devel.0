From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/13] kpartx.rules: Check for accessible
	device-mapper device
Date: Wed, 16 Jan 2013 13:14:06 +0100
Message-ID: <1358338456-1234-4-git-send-email-hare@suse.de>
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

We need to check for accessible device-mapper devices
right at the start, otherwise kpartx would be run on
inactive devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/kpartx.rules |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index febac90..ba5c6cb 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -8,6 +8,8 @@ KERNEL!="dm-*", GOTO="kpartx_end"
 ACTION=="remove", GOTO="kpartx_end"
 
 ENV{DM_TABLE_STATE}!="LIVE", GOTO="kpartx_end"
+ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", GOTO="kpartx_end"
+ENV{DM_DEPS}=="0", GOTO="kpartx_end"
 
 ENV{DM_UUID}=="?*", IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
 
-- 
1.7.4.2
