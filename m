From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:for-next 7/7]
 drivers/md/dm-cache-target.c:3585:37: error: 'pool' undeclared
Date: Wed, 15 Jul 2015 12:33:58 -0400
Message-ID: <20150715163358.GB14196@redhat.com>
References: <201507160000.4vLpJf2m%fengguang.wu@intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201507160000.4vLpJf2m%fengguang.wu@intel.com>
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

On Wed, Jul 15 2015 at 12:02pm -0400,
kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   043b9e2a0558b383a685245f49bd290c37103413
> commit: 043b9e2a0558b383a685245f49bd290c37103413 [7/7] dm cache: display 'needs_check' in status if it is set
> config: i386-randconfig-x006-201528 (attached as .config)
> reproduce:
>   git checkout 043b9e2a0558b383a685245f49bd290c37103413
>   # save the attached .config to linux build tree
>   make ARCH=i386 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    drivers/md/dm-cache-target.c: In function 'cache_status':
> >> drivers/md/dm-cache-target.c:3585:37: error: 'pool' undeclared (first use in this function)
>       if (dm_cache_metadata_needs_check(pool->pmd))
>                                         ^
>    drivers/md/dm-cache-target.c:3585:37: note: each undeclared identifier is reported only once for each function it appears in
> 
> vim +/pool +3585 drivers/md/dm-cache-target.c
> 
>   3579	
>   3580			if (get_cache_mode(cache) == CM_READ_ONLY)
>   3581				DMEMIT("ro ");
>   3582			else
>   3583				DMEMIT("rw ");
>   3584	
> > 3585			if (dm_cache_metadata_needs_check(pool->pmd))
>   3586				DMEMIT("needs_check ");
>   3587			else
>   3588				DMEMIT("- ");

Cut and paste bug.. sorry for the noise.  Fixed.
