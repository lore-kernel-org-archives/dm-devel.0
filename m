From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 03/33] Add support for "multipath=off" and
	"nompath" on kernel cmdline
Date: Tue, 28 Feb 2017 17:22:59 +0100
Message-ID: <20170228162329.14517-4-mwilck@suse.com>
References: <20170228162329.14517-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170228162329.14517-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.de>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.de>

Add support for disabling multipathd startup from the kernel command line.
This is useful for debugging purposes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.rules     | 5 +++++
 multipathd/multipathd.service | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index c8fb7e68..86defc0c 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -3,6 +3,11 @@ SUBSYSTEM!="block", GOTO="end_mpath"
 ACTION!="add|change", GOTO="end_mpath"
 KERNEL!="sd*|dasd*", GOTO="end_mpath"
 
+IMPORT{cmdline}="nompath"
+ENV{nompath}=="?*", GOTO="end_mpath"
+IMPORT{cmdline}="multipath"
+ENV{multipath}=="off", GOTO="end_mpath"
+
 ENV{DEVTYPE}!="partition", GOTO="test_dev"
 IMPORT{parent}="DM_MULTIPATH_DEVICE_PATH"
 ENV{DM_MULTIPATH_DEVICE_PATH}=="1", ENV{ID_FS_TYPE}="none", \
diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index 126012b8..fd66cf62 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -6,6 +6,8 @@ Before=local-fs-pre.target blk-availability.service
 After=multipathd.socket systemd-udev-trigger.service systemd-udev-settle.service
 DefaultDependencies=no
 Conflicts=shutdown.target
+ConditionKernelCommandLine=!nompath
+ConditionKernelCommandLine=!multipath=off
 
 [Service]
 Type=notify
-- 
2.11.0
