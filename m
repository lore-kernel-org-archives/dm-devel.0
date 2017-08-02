From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] dm: enable opt-out of device-mapper dax support
Date: Wed, 2 Aug 2017 09:40:26 +0800
Message-ID: <201708020927.f9cVCYCl%fengguang.wu@intel.com>
References: <150161113411.34055.9762658795237184307.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <150161113411.34055.9762658795237184307.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Hi Dan,

[auto build test ERROR on dm/for-next]
[also build test ERROR on v4.13-rc3 next-20170801]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/dm-enable-opt-out-of-device-mapper-dax-support/20170802-063827
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: sparc64-defconfig (attached as .config)
compiler: sparc64-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=sparc64 

All errors (new ones prefixed by >>):

>> ERROR: "dax_write_cache" [drivers/md/dm-mod.ko] undefined!
>> ERROR: "dax_write_cache_enabled" [drivers/md/dm-mod.ko] undefined!

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
