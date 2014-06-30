From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 08/12] Add missing interactive commands to
	multipathd man page
Date: Mon, 30 Jun 2014 00:13:59 -0500
Message-ID: <1404105243-5071-9-git-send-email-bmarzins@redhat.com>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

This patch adds the missing options from the multipathd.8 man page.  It
also fixes a typo in a log message from the alua prioritizer.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prioritizers/alua.c |  4 ++--
 multipathd/multipathd.8          | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index 4165ec6..b967ec7 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -119,10 +119,10 @@ int getprio (struct path * pp, char * args)
 				condlog(0, "%s: couldn't get target port group", pp->dev);
 				break;
 			case ALUA_PRIO_GETAAS_FAILED:
-				condlog(0, "%s: couln't get asymmetric access state", pp->dev);
+				condlog(0, "%s: couldn't get asymmetric access state", pp->dev);
 				break;
 			case ALUA_PRIO_TPGS_FAILED:
-				condlog(3, "%s: couln't get supported alua states", pp->dev);
+				condlog(3, "%s: couldn't get supported alua states", pp->dev);
 				break;
 		}
 	}
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 6da9d2b..358141d 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -80,6 +80,9 @@ Show all available block devices by name including the information if they are b
 .B list|show status
 Show the number of path checkers in each possible state, the number of monitored paths, and whether multipathd is currently handling a uevent.
 .TP
+.B list|show daemon
+Show the current state of the multipathd daemon
+.TP
 .B add path $path
 Add a path to the list of monitored paths. $path is as listed in /sys/block (e.g. sda).
 .TP 
@@ -107,6 +110,13 @@ Sets map $map into suspend state.
 .B resume map|multipath $map
 Resumes map $map from suspend state.
 .TP
+.B reset map|multipath $map
+Reassign existing device-mapper table(s) use use the multipath device, instead
+of its path devices.
+.TP
+.B reload map|multipath $map
+Reload a multipath device.
+.TP
 .B fail path $path
 Sets path $path into failed state.
 .TP
@@ -125,8 +135,27 @@ Disable queuing on multipathed map $map
 .B restorequeueing map|multipath $map
 Restore queuing on multipahted map $map
 .TP
+.B forcequeueing daemon
+Forces multipathd into queue_without_daemon mode, so that no_path_retry queueing
+will not be disabled when the daemon stops
+.TP
+.B restorequeueing daemon
+Restores configured queue_without_daemon mode
+.TP
+.B map|multipath $map setprstatus
+Enable persistent reservation management on $map
+.TP
+.B map|multipath $map unsetprstatus
+Disable persistent reservation management on $map
+.TP
+.B map|multipath $map getprstatus
+Get the current persistent reservation management status of $map
+.TP
 .B quit|exit
 End interactive session.
+.TP
+.B shutdown
+Stop multipathd.
 
 .SH "SYSTEMD INTEGRATION"
 When compiled with systemd support two systemd service files are
-- 
1.8.3.1
