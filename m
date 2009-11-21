From: Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
Subject: [PATCH] multipath-toosl: Use current name of the divice
 node ($name)
Date: Sat, 21 Nov 2009 21:29:52 +0100
Message-ID: <20091121202952.GA7011@bogon.sigxcpu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

instead of the kernel's name ($kernel). Otherwise we might end up
looking at a wrong or nonexistant node.
---
 kpartx/kpartx.rules |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index f32c718..425afd8 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -27,9 +27,9 @@ ENV{DM_PART}=="?*", \
 
 # Create dm tables for partitions
 ENV{DM_STATE}=="ACTIVE", ENV{DM_UUID}=="mpath-*", \
-        RUN+="/sbin/kpartx -a -p -part /dev/$kernel"
+        RUN+="/sbin/kpartx -a -p -part /dev/$name"
 ENV{DM_STATE}=="ACTIVE", ENV{DM_UUID}=="dmraid-*", \
-        RUN+="/sbin/kpartx -a -p -part /dev/$kernel"
+        RUN+="/sbin/kpartx -a -p -part /dev/$name"
 
 LABEL="kpartx_end"
 
-- 
1.6.5.3
