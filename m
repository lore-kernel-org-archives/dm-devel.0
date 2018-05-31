From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 4/4] dm-writecache: use new API for flushing
Date: Wed, 30 May 2018 23:39:19 -0400
Message-ID: <20180531033919.GA88973@redhat.com>
References: <CAPcyv4jwLsCNvNhgvv2DDSZuQsQXYEpKUU_5w1pTnyKj-uDBbQ@mail.gmail.com>
 <alpine.LRH.2.02.1805280922190.13486@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jXV4aZ6wqqjVPL8J4LxwTtXnzQCLZ0Wk5oB4_0uxpg7g@mail.gmail.com>
 <alpine.LRH.2.02.1805300903220.1090@file01.intranet.prod.int.rdu2.redhat.com>
 <20180530131623.GB2106@redhat.com>
 <alpine.LRH.2.02.1805300919070.11327@file01.intranet.prod.int.rdu2.redhat.com>
 <20180530132647.GB5157@redhat.com>
 <alpine.LRH.2.02.1805300929500.11327@file01.intranet.prod.int.rdu2.redhat.com>
 <20180530135421.GA81788@redhat.com>
 <alpine.LRH.2.02.1805300959460.16696@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1805300959460.16696-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids

On Wed, May 30 2018 at 10:09P -0400,
Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
 
> And what about this?
> #define WC_MODE_PMEM(wc)                        ((wc)->pmem_mode)
> 
> The code that I had just allowed the compiler to optimize out 
> persistent-memory code if we have DM_WRITECACHE_ONLY_SSD defined - and you 
> deleted it.
> 
> Most architectures don't have persistent memory and the dm-writecache 
> driver could work in ssd-only mode on them. On these architectures, I 
> define
> #define WC_MODE_PMEM(wc)                        false
> - and the compiler will just automatically remove the tests for that 
> condition and the unused branch. It does also eliminate unused static 
> functions.

Here is the patch that I just folded into the rebased version of
dm-writecache now in the dm-4.18 branch.

(I rebased ontop of Jens' latest block tree for 4.18 that now includes
the mempool_init changes, etc.)

---
 drivers/md/dm-writecache.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index fcbfaf7c27ec..691b5ffb799f 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -34,13 +34,21 @@
 #define BITMAP_GRANULARITY	PAGE_SIZE
 #endif
 
+#if defined(CONFIG_ARCH_HAS_PMEM_API) && IS_ENABLED(CONFIG_DAX_DRIVER)
+#define DM_WRITECACHE_HAS_PMEM
+#endif
+
+#ifdef DM_WRITECACHE_HAS_PMEM
 #define pmem_assign(dest, src)					\
 do {								\
 	typeof(dest) uniq = (src);				\
 	memcpy_flushcache(&(dest), &uniq, sizeof(dest));	\
 } while (0)
+#else
+#define pmem_assign(dest, src)	((dest)) = (src))
+#endif
 
-#if defined(__HAVE_ARCH_MEMCPY_MCSAFE) && defined(CONFIG_ARCH_HAS_PMEM_API)
+#if defined(__HAVE_ARCH_MEMCPY_MCSAFE) && defined(DM_WRITECACHE_HAS_PMEM)
 #define DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
 #endif
 
@@ -87,8 +95,13 @@ struct wc_entry {
 #endif
 };
 
+#ifdef DM_WRITECACHE_HAS_PMEM
 #define WC_MODE_PMEM(wc)			((wc)->pmem_mode)
 #define WC_MODE_FUA(wc)				((wc)->writeback_fua)
+#else
+#define WC_MODE_PMEM(wc)			false
+#define WC_MODE_FUA(wc)				false
+#endif
 #define WC_MODE_SORT_FREELIST(wc)		(!WC_MODE_PMEM(wc))
 
 struct dm_writecache {
@@ -1857,7 +1870,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	if (!strcasecmp(string, "s")) {
 		wc->pmem_mode = false;
 	} else if (!strcasecmp(string, "p")) {
-#if defined(CONFIG_ARCH_HAS_PMEM_API) && IS_ENABLED(CONFIG_DAX_DRIVER)
+#ifdef DM_WRITECACHE_HAS_PMEM
 		wc->pmem_mode = true;
 		wc->writeback_fua = true;
 #else
-- 
2.15.0
