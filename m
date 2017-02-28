From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:for-next 23/25] drivers/md/dm-raid.c:3469:3:
 error: 'else' without a previous 'if'
Date: Tue, 28 Feb 2017 16:51:01 -0500
Message-ID: <20170228215100.GA2184@redhat.com>
References: <201703010550.FcLgVNXo%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201703010550.FcLgVNXo%fengguang.wu@intel.com>
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

wow, oops, fixed

On Tue, Feb 28 2017 at  4:25pm -0500,
kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   b08c607678274dd6e0245c6e2b77ea0692f03b00
> commit: a482ed76823e7d2ab358ae7f140c5866c837e2ab [23/25] dm raid: fix raid "check" regression due to improper cleanup in raid_message()
> config: i386-randconfig-x002-201709 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         git checkout a482ed76823e7d2ab358ae7f140c5866c837e2ab
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    drivers/md/dm-raid.c: In function 'raid_message':
> >> drivers/md/dm-raid.c:3465:3: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
>       if (!strcasecmp(argv[0], "check"))
>       ^~
>    drivers/md/dm-raid.c:3467:4: note: ...this statement, but the latter is misleadingly indented as if it is guarded by the 'if'
>        set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
>        ^~~~~~~
> >> drivers/md/dm-raid.c:3469:3: error: 'else' without a previous 'if'
>       else if (!strcasecmp(argv[0], "repair")) {
>       ^~~~
> 
> vim +3469 drivers/md/dm-raid.c
> 
> be83651f Jonathan Brassow  2013-04-24  3459  		return -EBUSY;
> be83651f Jonathan Brassow  2013-04-24  3460  	else if (!strcasecmp(argv[0], "resync"))
> 3a1c1ef2 Heinz Mauelshagen 2016-05-19  3461  		; /* MD_RECOVERY_NEEDED set below */
> 3a1c1ef2 Heinz Mauelshagen 2016-05-19  3462  	else if (!strcasecmp(argv[0], "recover"))
> be83651f Jonathan Brassow  2013-04-24  3463  		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> 3a1c1ef2 Heinz Mauelshagen 2016-05-19  3464  	else {
> be83651f Jonathan Brassow  2013-04-24 @3465  		if (!strcasecmp(argv[0], "check"))
> be83651f Jonathan Brassow  2013-04-24  3466  			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> a482ed76 Mike Snitzer      2017-02-28  3467  			set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
> a482ed76 Mike Snitzer      2017-02-28  3468  			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> 105db599 Mike Snitzer      2017-01-06 @3469  		else if (!strcasecmp(argv[0], "repair")) {
> be83651f Jonathan Brassow  2013-04-24  3470  			set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
> be83651f Jonathan Brassow  2013-04-24  3471  			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> 105db599 Mike Snitzer      2017-01-06  3472  		} else
> 
> :::::: The code at line 3469 was first introduced by commit
> :::::: 105db5991240cb2675f193589130ef0c8a4f70fe dm raid: cleanup awkward branching in raid_message() option processing
> 
> :::::: TO: Mike Snitzer <snitzer@redhat.com>
> :::::: CC: Mike Snitzer <snitzer@redhat.com>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
