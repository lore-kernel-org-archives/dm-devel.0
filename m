From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:for-next 2/3] drivers/md/dm-mpath.c:821:37:
 error: passing argument 1 of 'strcmp' from incompatible pointer type
Date: Mon, 17 Sep 2018 12:25:01 -0400
Message-ID: <20180917162501.GA30382@redhat.com>
References: <201809180017.4eexn37t%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201809180017.4eexn37t%fengguang.wu@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kbuild test robot <lkp@intel.com>
Cc: dm-devel@redhat.com, kbuild-all@01.org
List-Id: dm-devel.ids

On Mon, Sep 17 2018 at 12:16pm -0400,
kbuild test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   9c01fc7e4f3b269a5550014c16ba2fa15b90fc45
> commit: 560e9814d061de1dce3328630846025d653dea7d [2/3] dm mpath: fix attached_handler_name leak and dangling hw_handler_name pointer
> config: x86_64-randconfig-x019-201837 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         git checkout 560e9814d061de1dce3328630846025d653dea7d
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    drivers/md/dm-mpath.c: In function 'setup_scsi_dh':
> >> drivers/md/dm-mpath.c:821:37: error: passing argument 1 of 'strcmp' from incompatible pointer type [-Werror=incompatible-pointer-types]
>        if (m->hw_handler_name && strcmp(attached_handler_name, m->hw_handler_name)) {
>                                         ^~~~~~~~~~~~~~~~~~~~~
>    In file included from include/linux/bitmap.h:9:0,
>                     from include/linux/cpumask.h:12,
>                     from arch/x86/include/asm/cpumask.h:5,
>                     from arch/x86/include/asm/msr.h:11,
>                     from arch/x86/include/asm/processor.h:21,
>                     from arch/x86/include/asm/cpufeature.h:5,
>                     from arch/x86/include/asm/thread_info.h:53,
>                     from include/linux/thread_info.h:38,
>                     from arch/x86/include/asm/preempt.h:7,
>                     from include/linux/preempt.h:81,
>                     from include/linux/spinlock.h:51,
>                     from include/linux/wait.h:9,
>                     from include/linux/wait_bit.h:8,
>                     from include/linux/fs.h:6,
>                     from include/linux/highmem.h:5,
>                     from include/linux/bio.h:21,
>                     from include/linux/device-mapper.h:11,
>                     from drivers/md/dm-mpath.c:8:
>    include/linux/string.h:44:12: note: expected 'const char *' but argument is of type 'char **'
>     extern int strcmp(const char *,const char *);
>                ^~~~~~
>    drivers/md/dm-mpath.c: In function 'parse_path':
> >> drivers/md/dm-mpath.c:891:24: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>      attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
>                            ^
>    cc1: some warnings being treated as errors
> 
> vim +/strcmp +821 drivers/md/dm-mpath.c

Fixed, sorry for the noise.
