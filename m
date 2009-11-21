From: Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
Subject: [PATCH]: multipath-tools: fix udev rule for dmraid
Date: Sat, 21 Nov 2009 18:10:10 +0100
Message-ID: <20091121171010.GA14931@bogon.sigxcpu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
attach patch fixes the udev rule for dmraid by not abusing the mpath
prefix. It also drops the superflous path from kpartx_id.
Cheers,
 -- Guido

--wac7ysb48OaltWcw
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-Fix-udev-rules-for-dmraid.patch"

From: Hannes Reinecke <hare@suse.de>
Date: Tue, 24 Jun 2008 16:38:37 +0200
Subject: [PATCH] Fix udev rules for dmraid

The kpartx_id program is located under /lib/udev, so we don't need to
call it with the full pathname.
And we should also create persistent links for dmraid tables.
---
 kpartx/kpartx.rules |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index f32c718..5a62d57 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -9,7 +9,7 @@ ACTION=="remove", GOTO="kpartx_end"
 
 ENV{DM_TABLE_STATE}!="LIVE", GOTO="kpartx_end"
 
-ENV{DM_UUID}=="?*", IMPORT{program}=="/lib/udev/kpartx_id %M %m $env{DM_UUID}"
+ENV{DM_UUID}=="?*", IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
 
 OPTIONS="link_priority=50"
 
@@ -18,7 +18,7 @@ ENV{DM_UUID}=="mpath-*", \
 	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
 
 # Create persistent links for dmraid tables
-ENV{DM_UUID}=="mpath-*", \
+ENV{DM_UUID}=="dmraid-*", \
         SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
 
 # Create persistent links for partitions
-- 

--wac7ysb48OaltWcw
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--wac7ysb48OaltWcw--
