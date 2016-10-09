From: Eugene Syromyatnikov <evgsyr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/21] dm: Add definitions for ioctl commands not implemented
	initially
Date: Sun, 9 Oct 2016 16:29:55 +0300
Message-ID: <20161009132955.GA3024@obsidian>
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

dm.c [!DM_LIST_VERSIONS] (DM_LIST_VERSIONS): New definition.
[!DM_TARGET_MSG] (DM_TARGET_MSG): Likewise.
[!DM_DEV_SET_GEOMETRY] (DM_DEV_SET_GEOMETRY): Likewise.
---
 dm.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/dm.c b/dm.c
index 79bb7c7..66b615d 100644
--- a/dm.c
+++ b/dm.c
@@ -7,6 +7,19 @@
 
 # if DM_VERSION_MAJOR == 4
 
+/* Definitions for command which have been added later */
+
+#  ifndef DM_LIST_VERSIONS
+#   define DM_LIST_VERSIONS    _IOWR(DM_IOCTL, 0xd, struct dm_ioctl)
+#  endif
+#  ifndef DM_TARGET_MSG
+#   define DM_TARGET_MSG       _IOWR(DM_IOCTL, 0xe, struct dm_ioctl)
+#  endif
+#  ifndef DM_DEV_SET_GEOMETRY
+#   define DM_DEV_SET_GEOMETRY _IOWR(DM_IOCTL, 0xf, struct dm_ioctl)
+#  endif
+
+
 static void
 dm_decode_device(const unsigned int code, const struct dm_ioctl *ioc)
 {
-- 
1.7.10.4


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
