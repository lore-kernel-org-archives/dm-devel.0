From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/11] multipathd: Update manpage
Date: Fri, 13 Dec 2013 13:14:10 +0100
Message-ID: <1386936854-8399-8-git-send-email-hare@suse.de>
References: <1386936854-8399-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386936854-8399-1-git-send-email-hare@suse.de>
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

Some aliases for CLI command arguments were missing from the
manpage.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 multipathd/multipathd.8 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index ccc5f54..17bf650 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -83,16 +83,16 @@ Add a path to the list of monitored paths. $path is as listed in /sys/block (e.g
 .B remove|del path $path
 Stop monitoring a path. $path is as listed in /sys/block (e.g. sda).
 .TP
-.B add map $map
+.B add map|multipath $map
 Add a multipath device to the list of monitored devices. $map can either be a device-mapper device as listed in /sys/block (e.g. dm-0) or it can be the alias for the multipath device (e.g. mpath1) or the uid of the multipath device (e.g. 36005076303ffc56200000000000010aa). 
 .TP
-.B remove|del map $map
+.B remove|del map|multipath $map
 Stop monitoring a multipath device.
 .TP
 .B resize map|multipath $map
 Resizes map $map to the given size
 .TP 
-.B switch|switchgroup map $map group $group
+.B switch|switchgroup map|multipath $map group $group
 Force a multipath device to switch to a specific path group. $group is the path group index, starting with 1.
 .TP
 .B reconfigure
-- 
1.8.1.4
