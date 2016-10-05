From: Masatake YAMATO <yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Re: your dm patch for strace
Date: Wed, 05 Oct 2016 19:28:28 +0900 (JST)
Message-ID: <20161005.192828.566127461630656590.yamato@redhat.com>
References: <alpine.LRH.2.02.1608250823130.24332@file01.intranet.prod.int.rdu2.redhat.com>
	<20160912171029.GA5263@altlinux.org>
	<alpine.LRH.2.02.1610021751280.29417@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: strace development list <strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <alpine.LRH.2.02.1610021751280.29417-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=strace-devel>
List-Post: <mailto:strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/strace-devel>,
	<mailto:strace-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, strace-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: dm-devel.ids

I tested the patch and it works fine.
Could you add following patch if you approve?

commit bae7528fa92283726caac1ec7a6c306274f8899d
Author: Masatake YAMATO <yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Mon Aug 22 17:44:55 2016 +0900

    dm-ioctl: add a lvm private flag
    
    When I run "dmsetup ls" under dm-ioctl patched strace,
    "strange DM_???" are found in its output.
    
        # ./strace -e ioctl dmsetup ls > /dev/null
        ioctl(3, DM_VERSION, {version=4.0.0, flags=0x4 /* DM_??? */}, ...
        ioctl(3, DM_LIST_DEVICES, {version=4.0.0, flags=0x4 /* DM_??? */}, ...
        ...
    
    Associated definion for DM_??? is in lvm2 source tree. This commit
    imports the definion to dm-ioctl list.
    
    Signed-off-by: Masatake YAMATO <yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

diff --git a/xlat/dm_flags.in b/xlat/dm_flags.in
index ab4285c..1e7132b 100644
--- a/xlat/dm_flags.in
+++ b/xlat/dm_flags.in
@@ -1,5 +1,7 @@
 DM_READONLY_FLAG
 DM_SUSPEND_FLAG
+/* Defined in lvm2/libdm/ioctl/libdm-iface.c */
+DM_EXISTS_FLAG 0x00000004
 DM_PERSISTENT_DEV_FLAG
 DM_STATUS_TABLE_FLAG
 DM_ACTIVE_PRESENT_FLAG

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
