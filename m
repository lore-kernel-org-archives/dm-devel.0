From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:for-next 1/4] drivers/md/dm.c:1757:36: error:
 passing argument 2 of 'dm_mq_init_request_queue' from incompatible pointer
 type
Date: Fri, 10 Jun 2016 15:18:03 -0400
Message-ID: <20160610191803.GA30231@redhat.com>
References: <201606110159.BUvhrj8S%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201606110159.BUvhrj8S%fengguang.wu@intel.com>
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
Cc: dm-devel@redhat.com, kbuild-all@01.org
List-Id: dm-devel.ids

On Fri, Jun 10 2016 at  2:00pm -0400,
kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   b18ef3eb063790f62f2630015a116cb495cb143f
> commit: 3fa1ee95f14c676ef9d8f53516f31f1bdcb194f1 [1/4] dm: move request-based code out to dm-rq.[hc]
> config: i386-defconfig (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
> reproduce:
>         git checkout 3fa1ee95f14c676ef9d8f53516f31f1bdcb194f1
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> Note: the dm/for-next HEAD b18ef3eb063790f62f2630015a116cb495cb143f builds fine.
>       It only hurts bisectibility.
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/md/dm.c: In function 'dm_setup_md_queue':
> >> drivers/md/dm.c:1757:36: error: passing argument 2 of 'dm_mq_init_request_queue' from incompatible pointer type [-Werror=incompatible-pointer-types]
>       r = dm_mq_init_request_queue(md, t);
>                                        ^
>    In file included from drivers/md/dm.c:9:0:
>    drivers/md/dm-rq.h:52:5: note: expected 'struct dm_target *' but argument is of type 'struct dm_table *'
>     int dm_mq_init_request_queue(struct mapped_device *md, struct dm_target *immutable_tgt);
>         ^~~~~~~~~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
> 
> vim +/dm_mq_init_request_queue +1757 drivers/md/dm.c
> 
>   1751			if (r) {
>   1752				DMERR("Cannot initialize queue for request-based mapped device");
>   1753				return r;
>   1754			}
>   1755			break;
>   1756		case DM_TYPE_MQ_REQUEST_BASED:
> > 1757			r = dm_mq_init_request_queue(md, t);
>   1758			if (r) {
>   1759				DMERR("Cannot initialize queue for request-based dm-mq mapped device");
>   1760				return r;
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


I fixed this up, sorry for the noise.
