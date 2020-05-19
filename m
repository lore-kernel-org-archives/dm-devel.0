From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [dm:dm-5.8 47/54]
 drivers/md/dm-zoned-reclaim.c:350:18: warning: variable 'dev' set but not
 used
Date: Tue, 19 May 2020 03:24:44 +0000
Message-ID: <BY5PR04MB69001E3E05E6456E00802FD1E7B90@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <202005191101.djuJIqn4%lkp@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Bob Liu <bob.liu@oracle.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 2020/05/19 12:18, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-5.8
> head:   44eaf01834bc7414ab5298d097ed4e142a714420
> commit: 21a33c39f41e5fc4e9ecfdf958190c9dc4a86b94 [47/54] dm zoned: remove 'dev' argument from reclaim
> config: parisc-randconfig-r024-20200519 (attached as .config)
> compiler: hppa-linux-gcc (GCC) 9.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 21a33c39f41e5fc4e9ecfdf958190c9dc4a86b94
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=parisc 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
> 
> In file included from include/linux/mm.h:94,
> from include/linux/bvec.h:13,
> from include/linux/blk_types.h:10,
> from include/linux/genhd.h:19,
> from include/linux/blkdev.h:11,
> from drivers/md/dm-zoned.h:12,
> from drivers/md/dm-zoned-reclaim.c:8:
> include/asm-generic/pgtable.h: In function 'pte_clear_not_present_full':
> arch/parisc/include/asm/pgtable.h:96:9: warning: variable 'old_pte' set but not used [-Wunused-but-set-variable]
> 96 |   pte_t old_pte;              |         ^~~~~~~
> arch/parisc/include/asm/pgtable.h:322:34: note: in expansion of macro 'set_pte_at'
> 322 | #define pte_clear(mm, addr, xp)  set_pte_at(mm, addr, xp, __pte(0))
> |                                  ^~~~~~~~~~
> include/asm-generic/pgtable.h:201:2: note: in expansion of macro 'pte_clear'
> 201 |  pte_clear(mm, address, ptep);
> |  ^~~~~~~~~
> include/asm-generic/pgtable.h: In function '__ptep_modify_prot_commit':
> arch/parisc/include/asm/pgtable.h:96:9: warning: variable 'old_pte' set but not used [-Wunused-but-set-variable]
> 96 |   pte_t old_pte;              |         ^~~~~~~
> include/asm-generic/pgtable.h:640:2: note: in expansion of macro 'set_pte_at'
> 640 |  set_pte_at(vma->vm_mm, addr, ptep, pte);
> |  ^~~~~~~~~~
> drivers/md/dm-zoned-reclaim.c: In function 'dmz_do_reclaim':
>>> drivers/md/dm-zoned-reclaim.c:350:18: warning: variable 'dev' set but not used [-Wunused-but-set-variable]
> 350 |  struct dmz_dev *dev;
> |                  ^~~

It is indeed unused. I wonder why gcc 10 did not complain for me...

Hannes, can you add a patch fixing that when you resend the cache-zone series ?

> 
> vim +/dev +350 drivers/md/dm-zoned-reclaim.c
> 
>    341	
>    342	/*
>    343	 * Find a candidate zone for reclaim and process it.
>    344	 */
>    345	static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>    346	{
>    347		struct dmz_metadata *zmd = zrc->metadata;
>    348		struct dm_zone *dzone;
>    349		struct dm_zone *rzone;
>  > 350		struct dmz_dev *dev;
>    351		unsigned long start;
>    352		int ret;
>    353	
>    354		/* Get a data zone */
>    355		dzone = dmz_get_zone_for_reclaim(zmd);
>    356		if (IS_ERR(dzone))
>    357			return PTR_ERR(dzone);
>    358	
>    359		start = jiffies;
>    360		dev = dmz_zone_to_dev(zmd, dzone);
>    361		if (dmz_is_rnd(dzone)) {
>    362			if (!dmz_weight(dzone)) {
>    363				/* Empty zone */
>    364				dmz_reclaim_empty(zrc, dzone);
>    365				ret = 0;
>    366			} else {
>    367				/*
>    368				 * Reclaim the random data zone by moving its
>    369				 * valid data blocks to a free sequential zone.
>    370				 */
>    371				ret = dmz_reclaim_rnd_data(zrc, dzone);
>    372			}
>    373			rzone = dzone;
>    374	
>    375		} else {
>    376			struct dm_zone *bzone = dzone->bzone;
>    377			sector_t chunk_block = 0;
>    378	
>    379			ret = dmz_first_valid_block(zmd, bzone, &chunk_block);
>    380			if (ret < 0)
>    381				goto out;
>    382	
>    383			if (ret == 0 || chunk_block >= dzone->wp_block) {
>    384				/*
>    385				 * The buffer zone is empty or its valid blocks are
>    386				 * after the data zone write pointer.
>    387				 */
>    388				ret = dmz_reclaim_buf(zrc, dzone);
>    389				rzone = bzone;
>    390			} else {
>    391				/*
>    392				 * Reclaim the data zone by merging it into the
>    393				 * buffer zone so that the buffer zone itself can
>    394				 * be later reclaimed.
>    395				 */
>    396				ret = dmz_reclaim_seq_data(zrc, dzone);
>    397				rzone = dzone;
>    398			}
>    399		}
>    400	out:
>    401		if (ret) {
>    402			dmz_unlock_zone_reclaim(dzone);
>    403			return ret;
>    404		}
>    405	
>    406		ret = dmz_flush_metadata(zrc->metadata);
>    407		if (ret) {
>    408			DMDEBUG("(%s): Metadata flush for zone %u failed, err %d\n",
>    409				dmz_metadata_label(zmd), rzone->id, ret);
>    410			return ret;
>    411		}
>    412	
>    413		DMDEBUG("(%s): Reclaimed zone %u in %u ms",
>    414			dmz_metadata_label(zmd),
>    415			rzone->id, jiffies_to_msecs(jiffies - start));
>    416		return 0;
>    417	}
>    418	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 


-- 
Damien Le Moal
Western Digital Research
