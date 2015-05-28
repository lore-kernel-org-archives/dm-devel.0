From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:dm-4.1-for-ejt 33/33]
 drivers/md/dm-thin.c:1543:25: error: 'BIO_CHAIN' undeclared
Date: Thu, 28 May 2015 13:41:15 -0400
Message-ID: <20150528174115.GA23716@redhat.com>
References: <201505290001.JuTn0HF0%fengguang.wu@intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201505290001.JuTn0HF0%fengguang.wu@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Joe Thornber <ejt@redhat.com>, kbuild-all@01.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, May 28 2015 at 12:46pm -0400,
kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-4.1-for-ejt
> head:   b8112c1e5d7658f3f6a300f6efeb5fae6ec135eb
> commit: b8112c1e5d7658f3f6a300f6efeb5fae6ec135eb [33/33] dm thin: range discard support
> config: x86_64-rhel (attached as .config)
> reproduce:
>   git checkout b8112c1e5d7658f3f6a300f6efeb5fae6ec135eb
>   # save the attached .config to linux build tree
>   make ARCH=x86_64 
> 
> All error/warnings:
> 
>    drivers/md/dm-thin.c: In function '__bio_inc_remaining':
> >> drivers/md/dm-thin.c:1543:25: error: 'BIO_CHAIN' undeclared (first use in this function)
>      bio->bi_flags |= (1 << BIO_CHAIN);
>                             ^
>    drivers/md/dm-thin.c:1543:25: note: each undeclared identifier is reported only once for each function it appears in
> >> drivers/md/dm-thin.c:1545:17: error: 'struct bio' has no member named '__bi_remaining'
>      atomic_inc(&bio->__bi_remaining);
>                     ^
> 
> vim +/BIO_CHAIN +1543 drivers/md/dm-thin.c
> 
>   1537	 * FIXME: DM local hack to defer parent bios's end_io until we
>   1538	 * _know_ all chained sub range discard bios have completed.
>   1539	 * Will go away once late bio splitting lands upstream!
>   1540	 */
>   1541	static inline void __bio_inc_remaining(struct bio *bio)
>   1542	{
> > 1543		bio->bi_flags |= (1 << BIO_CHAIN);
>   1544		smp_mb__before_atomic();
> > 1545		atomic_inc(&bio->__bi_remaining);
>   1546	}
>   1547	
>   1548	static void break_up_discard_bio(struct thin_c *tc, dm_block_t begin, dm_block_t end,

I fixed this up.. but this is a temporary branch for Joe... please move
along, nothing to see here :)
