From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] dm stripe: add DAX support
Date: Sat, 25 Jun 2016 03:58:43 +0800
Message-ID: <201606250312.OzHHesq4%fengguang.wu@intel.com>
References: <1466792610-30369-1-git-send-email-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1466792610-30369-1-git-send-email-toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Hi,

[auto build test WARNING on dm/for-next]
[also build test WARNING on v4.7-rc4 next-20160624]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Toshi-Kani/dm-stripe-add-DAX-support/20160625-022600
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: m68k-sun3_defconfig (attached as .config)
compiler: m68k-linux-gcc (GCC) 4.9.0
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=m68k 

All warnings (new ones prefixed by >>):

   drivers/md/dm-stripe.c:452:2: error: unknown field 'direct_access' specified in initializer
     .direct_access = stripe_direct_access,
     ^
   drivers/md/dm-stripe.c:452:2: warning: missing braces around initializer [-Wmissing-braces]
   drivers/md/dm-stripe.c:452:2: warning: (near initialization for 'stripe_target.list') [-Wmissing-braces]
>> drivers/md/dm-stripe.c:452:2: warning: initialization from incompatible pointer type
   drivers/md/dm-stripe.c:452:2: warning: (near initialization for 'stripe_target.list.next')

vim +452 drivers/md/dm-stripe.c

   436	
   437		blk_limits_io_min(limits, chunk_size);
   438		blk_limits_io_opt(limits, chunk_size * sc->stripes);
   439	}
   440	
   441	static struct target_type stripe_target = {
   442		.name   = "striped",
   443		.version = {1, 5, 1},
   444		.module = THIS_MODULE,
   445		.ctr    = stripe_ctr,
   446		.dtr    = stripe_dtr,
   447		.map    = stripe_map,
   448		.end_io = stripe_end_io,
   449		.status = stripe_status,
   450		.iterate_devices = stripe_iterate_devices,
   451		.io_hints = stripe_io_hints,
 > 452		.direct_access = stripe_direct_access,
   453	};
   454	
   455	int __init dm_stripe_init(void)
   456	{
   457		int r;
   458	
   459		r = dm_register_target(&stripe_target);
   460		if (r < 0)

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
