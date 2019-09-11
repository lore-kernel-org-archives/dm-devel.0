From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:for-next 29/30]
 drivers//md/dm-clone-target.c:563:14: error: implicit declaration of
 function 'vmalloc'; did you mean 'kmalloc'?
Date: Wed, 11 Sep 2019 14:22:51 -0400
Message-ID: <20190911182251.GA634@redhat.com>
References: <201909120035.YsFPOauD%lkp@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201909120035.YsFPOauD%lkp@intel.com>
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
Cc: dm-devel@redhat.com, Ilias Tsitsimpis <iliastsi@arrikto.com>, Nikos Tsironis <ntsironis@arrikto.com>, kbuild-all@01.org
List-Id: dm-devel.ids


I resolved this and pushed new code, thanks!

On Wed, Sep 11 2019 at 12:03pm -0400,
kbuild test robot <lkp@intel.com> wrote:

> tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   509818079bf1fefff4ed02d6a1b994e20efc0480
> commit: 1529a543debdf75fb26e7ecd732da0cc36f78a36 [29/30] dm: add clone target
> config: sparc64-allmodconfig (attached as .config)
> compiler: sparc64-linux-gcc (GCC) 7.4.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 1529a543debdf75fb26e7ecd732da0cc36f78a36
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=sparc64 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All error/warnings (new ones prefixed by >>):
> 
>    drivers//md/dm-clone-target.c: In function 'hash_table_init':
> >> drivers//md/dm-clone-target.c:563:14: error: implicit declaration of function 'vmalloc'; did you mean 'kmalloc'? [-Werror=implicit-function-declaration]
>      clone->ht = vmalloc(sz * sizeof(struct hash_table_bucket));
>                  ^~~~~~~
>                  kmalloc
> >> drivers//md/dm-clone-target.c:563:12: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
>      clone->ht = vmalloc(sz * sizeof(struct hash_table_bucket));
>                ^
>    drivers//md/dm-clone-target.c: In function 'hash_table_exit':
> >> drivers//md/dm-clone-target.c:579:2: error: implicit declaration of function 'vfree'; did you mean 'kfree'? [-Werror=implicit-function-declaration]
>      vfree(clone->ht);
>      ^~~~~
>      kfree
>    cc1: some warnings being treated as errors
> --
>    drivers//md/dm-clone-metadata.c: In function 'dirty_map_init':
> >> drivers//md/dm-clone-metadata.c:466:28: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
>      md->dmap[0].dirty_words = vzalloc(bitmap_size(md->nr_words));
>                                ^~~~~~~
>                                kvzalloc
> >> drivers//md/dm-clone-metadata.c:466:26: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
>      md->dmap[0].dirty_words = vzalloc(bitmap_size(md->nr_words));
>                              ^
>    drivers//md/dm-clone-metadata.c:474:26: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
>      md->dmap[1].dirty_words = vzalloc(bitmap_size(md->nr_words));
>                              ^
> >> drivers//md/dm-clone-metadata.c:478:3: error: implicit declaration of function 'vfree'; did you mean 'kvfree'? [-Werror=implicit-function-declaration]
>       vfree(md->dmap[0].dirty_words);
>       ^~~~~
>       kvfree
>    drivers//md/dm-clone-metadata.c: In function 'dm_clone_metadata_open':
> >> drivers//md/dm-clone-metadata.c:553:19: error: implicit declaration of function 'vmalloc'; did you mean 'kvmalloc'? [-Werror=implicit-function-declaration]
>      md->region_map = vmalloc(bitmap_size(md->nr_regions));
>                       ^~~~~~~
>                       kvmalloc
>    drivers//md/dm-clone-metadata.c:553:17: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
>      md->region_map = vmalloc(bitmap_size(md->nr_regions));
>                     ^
>    cc1: some warnings being treated as errors
> 
> vim +563 drivers//md/dm-clone-target.c
> 
>    549	
>    550	#define bucket_lock_irqsave(bucket, flags) \
>    551		spin_lock_irqsave(&(bucket)->lock, flags)
>    552	
>    553	#define bucket_unlock_irqrestore(bucket, flags) \
>    554		spin_unlock_irqrestore(&(bucket)->lock, flags)
>    555	
>    556	static int hash_table_init(struct clone *clone)
>    557	{
>    558		unsigned int i, sz;
>    559		struct hash_table_bucket *bucket;
>    560	
>    561		sz = 1 << HASH_TABLE_BITS;
>    562	
>  > 563		clone->ht = vmalloc(sz * sizeof(struct hash_table_bucket));
>    564		if (!clone->ht)
>    565			return -ENOMEM;
>    566	
>    567		for (i = 0; i < sz; i++) {
>    568			bucket = clone->ht + i;
>    569	
>    570			INIT_HLIST_HEAD(&bucket->head);
>    571			spin_lock_init(&bucket->lock);
>    572		}
>    573	
>    574		return 0;
>    575	}
>    576	
>    577	static void hash_table_exit(struct clone *clone)
>    578	{
>  > 579		vfree(clone->ht);
>    580	}
>    581	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
