From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] dm: update table type check for dax
Date: Wed, 29 Jun 2016 04:33:22 +0800
Message-ID: <201606290444.S7wFsdHl%fengguang.wu@intel.com>
References: <1467142636-21094-2-git-send-email-toshi.kani@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1467142636-21094-2-git-send-email-toshi.kani-ZPxbGqLxI0U@public.gmane.org>
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
Cc: snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Hi,

[auto build test ERROR on dm/for-next]
[also build test ERROR on v4.7-rc5 next-20160628]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Toshi-Kani/Support-DAX-for-device-mapper-dm-linear-devices/20160629-034110
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: x86_64-randconfig-s1-06290340 (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   drivers/md/dm-ioctl.c: In function 'is_valid_type':
>> drivers/md/dm-ioctl.c:1273:42: error: 'DM_TYPE_DAX_BIO_BASED' undeclared (first use in this function)
         (cur == DM_TYPE_BIO_BASED && new == DM_TYPE_DAX_BIO_BASED))
                                             ^~~~~~~~~~~~~~~~~~~~~
   drivers/md/dm-ioctl.c:1273:42: note: each undeclared identifier is reported only once for each function it appears in

vim +/DM_TYPE_DAX_BIO_BASED +1273 drivers/md/dm-ioctl.c

  1267		return dm_table_complete(table);
  1268	}
  1269	
  1270	static bool is_valid_type(unsigned cur, unsigned new)
  1271	{
  1272		if (cur == new ||
> 1273		    (cur == DM_TYPE_BIO_BASED && new == DM_TYPE_DAX_BIO_BASED))
  1274			return true;
  1275	
  1276		return false;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
