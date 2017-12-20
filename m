From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 1/2] dm-unstripe: unstripe RAID 0/dm-striped device
Date: Wed, 20 Dec 2017 11:09:47 -0500
Message-ID: <20171220160947.GB18363@redhat.com>
References: <20171218172809.5826-2-scott.bauer@intel.com>
 <201712201815.9AIAEPWE%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201712201815.9AIAEPWE%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: Scott Bauer <scott.bauer@intel.com>, kbuild-all@01.org, dm-devel@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, keith.busch@intel.com, jonathan.derrick@intel.com
List-Id: dm-devel.ids

On Wed, Dec 20 2017 at  5:21am -0500,
kbuild test robot <lkp@intel.com> wrote:

> Hi Scott,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on dm/for-next]
> [also build test ERROR on v4.15-rc4]
> [cannot apply to next-20171220]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Scott-Bauer/dm-unstripe/20171220-121845
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> config: arm-allyesconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (Debian 7.2.0-11) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/md/dm-unstripe.o: In function `set_ctr':
> >> dm-unstripe.c:(.text+0x438): undefined reference to `__aeabi_uldivmod'
>    dm-unstripe.c:(.text+0x450): undefined reference to `__aeabi_uldivmod'
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


These reports are no longer relevant given the code has changed since
v4. In particular these 64-bit divide and mod in v4 no longer exist:

+       u64 tot_sec, mod;
...
+       tot_sec = i_size_read(bbdev->bd_inode) >> SECTOR_SHIFT;
+       mod = tot_sec % target->chunk_sectors;
+
+       if (ti->len == 1)
+               ti->len = (tot_sec / tot_drives) - mod;
