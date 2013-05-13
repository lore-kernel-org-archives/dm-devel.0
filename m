From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] bcache: Fix link errors on ARM
Date: Mon, 13 May 2013 18:37:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1305131831110.32345@file.rdu.redhat.com>
References: <5170B4C6.1030300@gmail.com>
	<Pine.LNX.4.64.1304221318350.22065@file.rdu.redhat.com>
	<5175C06B.4020805@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5175C06B.4020805@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Rob Herring <robherring2@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: dm-devel.ids



On Mon, 22 Apr 2013, Rob Herring wrote:

> On 04/22/2013 12:32 PM, Mikulas Patocka wrote:
> > 
> > 
> > On Thu, 18 Apr 2013, Rob Herring wrote:
> > 
> >> Current errors in linux-next for ARM multi-platform randconfig builds.
> >>
> >> Rob
> >>
> >> drivers/built-in.o:drivers/md/dm-cache-target.c:429: more undefined references to `__udivdi3' follow
> >> /var/lib/jenkins/jobs/linux-randconfig/workspace/drivers/md/dm-cache-target.c:429: undefined reference to `__udivdi3'
> >> /var/lib/jenkins/jobs/linux-randconfig/workspace/drivers/md/dm-cache-target.c:429: undefined reference to `__umoddi3'
> >> driversdrivers/md/dm-cache-target.c:429: more undefined references to `__udivdi3' follow
> >> drivers/md/dm-cache-target.c:429: undefined reference to `__udivdi3'
> >> drivers/md/dm-cache-target.c:429: undefined reference to `__umoddi3'
> > 
> > Hi
> > 
> > I tried to cross-compile dm-cache on linux-next for arm and there were no 
> > failures and no references to __udivdi3 and __umoddi3.
> > 
> > Please send the .config file that resulted in these faulures.
> 
> The config is attached. My guess is it might be related to CONFIG_AEABI
> not set. The compiler is "gcc version 4.6.3 (Ubuntu/Linaro
> 4.6.3-1ubuntu5)" which is ubuntu 12.04 arm cross compiler.
> 
> Rob

This is a problem in gcc-4.6. (gcc-4.7 is OK).

---

bcache: Fix link errors on ARM

gcc-4.6 on ARM has some problem, it creates a function block_div.part.8,
it references __udivdi3 and __umoddi3 and it is never called. The
references to __udivdi3 and __umoddi3 cause a link failure.

__always_inline works around the bug.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/drivers/md/dm-cache-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-cache-target.c	2013-05-14 00:03:53.276986022 +0200
+++ linux-2.6/drivers/md/dm-cache-target.c	2013-05-14 00:34:09.128986023 +0200
@@ -425,6 +425,10 @@
 	return cache->sectors_per_block_shift >= 0;
 }
 
+/* gcc on ARM generates spurious references to __udivdi3 and __umoddi3 */
+#if defined(CONFIG_ARM) && __GNUC__ == 4 && __GNUC_MINOR__ <= 6
+__always_inline
+#endif
 static dm_block_t block_div(dm_block_t b, uint32_t n)
 {
 	do_div(b, n);
