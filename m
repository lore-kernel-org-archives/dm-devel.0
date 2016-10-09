From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/21] xlat: Add values for dm_flags
Date: Sun, 9 Oct 2016 16:29:41 +0300
Message-ID: <20161009132941.GA2290@obsidian>
References: <20161005.192828.566127461630656590.yamato@redhat.com>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161005.192828.566127461630656590.yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=strace-devel>
List-Post: <mailto:strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Otherwise build fails on some old distros which lack DM_DATA_OUT_FLAG
and other flags (excerpt from RHEL 5 build log):

[   66s] dm.c: In function 'dm_known_ioctl':
[   66s] dm.c:311: error: 'DM_DATA_OUT_FLAG' undeclared (first use in this function)
[   66s] dm.c:311: error: (Each undeclared identifier is reported only once
[   66s] dm.c:311: error: for each function it appears in.)

Curiously, EXISTS flags had been present in v1 of DM interface, but was
removed in v4.

* xlat/dm_flags.in: Add values for DM_*_FLAG constants (obtained from
<linux/dm-ioctl.h>).
---
 xlat/dm_flags.in |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/xlat/dm_flags.in b/xlat/dm_flags.in
index 1e7132b..fa734c8 100644
--- a/xlat/dm_flags.in
+++ b/xlat/dm_flags.in
@@ -1,19 +1,19 @@
-DM_READONLY_FLAG
-DM_SUSPEND_FLAG
+DM_READONLY_FLAG             (1 << 0)
+DM_SUSPEND_FLAG              (1 << 1)
 /* Defined in lvm2/libdm/ioctl/libdm-iface.c */
-DM_EXISTS_FLAG 0x00000004
-DM_PERSISTENT_DEV_FLAG
-DM_STATUS_TABLE_FLAG
-DM_ACTIVE_PRESENT_FLAG
-DM_INACTIVE_PRESENT_FLAG
-DM_BUFFER_FULL_FLAG
-DM_SKIP_BDGET_FLAG
-DM_SKIP_LOCKFS_FLAG
-DM_NOFLUSH_FLAG
-DM_QUERY_INACTIVE_TABLE_FLAG
-DM_UEVENT_GENERATED_FLAG
-DM_UUID_FLAG
-DM_SECURE_DATA_FLAG
-DM_DATA_OUT_FLAG
-DM_DEFERRED_REMOVE
-DM_INTERNAL_SUSPEND_FLAG
+DM_EXISTS_FLAG               (1 << 2)
+DM_PERSISTENT_DEV_FLAG       (1 << 3)
+DM_STATUS_TABLE_FLAG         (1 << 4)
+DM_ACTIVE_PRESENT_FLAG       (1 << 5)
+DM_INACTIVE_PRESENT_FLAG     (1 << 6)
+DM_BUFFER_FULL_FLAG          (1 << 8)
+DM_SKIP_BDGET_FLAG           (1 << 9)
+DM_SKIP_LOCKFS_FLAG          (1 << 10)
+DM_NOFLUSH_FLAG              (1 << 11)
+DM_QUERY_INACTIVE_TABLE_FLAG (1 << 12)
+DM_UEVENT_GENERATED_FLAG     (1 << 13)
+DM_UUID_FLAG                 (1 << 14)
+DM_SECURE_DATA_FLAG          (1 << 15)
+DM_DATA_OUT_FLAG             (1 << 16)
+DM_DEFERRED_REMOVE           (1 << 17)
+DM_INTERNAL_SUSPEND_FLAG     (1 << 18)
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
