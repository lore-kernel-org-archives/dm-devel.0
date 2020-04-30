From: kbuild test robot <lkp@intel.com>
Subject: [dm:for-next 29/30] drivers/md/dm-ebs-target.c:190:32:
 sparse: expected restricted blk_status_t [usertype] bi_status
Date: Thu, 30 Apr 2020 10:07:10 +0800
Message-ID: <20200430020710.GG15540@xsang-OptiPlex-9020>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com, kbuild-all@lists.01.org, Damien Le Moal <DamienLeMoal@wdc.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   ddc1316e185f6ab4a74656b4879a15ec23cdec31
commit: eeb17d25430dc2b3251a5abfec6a3b9160daaef6 [29/30] dm ebs: new block size emulating target
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-191-gc51a0382-dirty
        git checkout eeb17d25430dc2b3251a5abfec6a3b9160daaef6
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
:::::: branch date: 7 hours ago
:::::: commit date: 30 hours ago

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/md/dm-ebs-target.c:190:32: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted blk_status_t [usertype] bi_status @@    got s_t [usertype] bi_status @@
>> drivers/md/dm-ebs-target.c:190:32: sparse:    expected restricted blk_status_t [usertype] bi_status
>> drivers/md/dm-ebs-target.c:190:32: sparse:    got int [assigned] r
   drivers/md/dm-ebs-target.c:423:12: sparse: sparse: symbol 'dm_ebs_init' was not declared. Should it be static?
   drivers/md/dm-ebs-target.c:433:6: sparse: sparse: symbol 'dm_ebs_exit' was not declared. Should it be static?

# https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?id=eeb17d25430dc2b3251a5abfec6a3b9160daaef6
git remote add dm https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
git remote update dm
git checkout eeb17d25430dc2b3251a5abfec6a3b9160daaef6
vim +190 drivers/md/dm-ebs-target.c

eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  146  
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  147  /* Worker funtion to process incoming bios. */
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  148  static void __ebs_process_bios(struct work_struct *ws)
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  149  {
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  150  	int r;
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  151  	bool write = false;
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  152  	sector_t block1, block2;
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  153  	struct ebs_c *ec = container_of(ws, struct ebs_c, ws);
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  154  	struct bio *bio;
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  155  	struct bio_list bios;
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  156  
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  157  	bio_list_init(&bios);
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  158  
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  159  	spin_lock_irq(&ec->lock);
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  160  	bios = ec->bios_in;
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  161  	bio_list_init(&ec->bios_in);
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  162  	spin_unlock_irq(&ec->lock);
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  163  
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  164  	/* Prefetch all read and any mis-aligned write buffers */
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  165  	bio_list_for_each(bio, &bios) {
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  166  		block1 = __sector_to_block(ec, bio->bi_iter.bi_sector);
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  167  		if (bio_op(bio) == REQ_OP_READ)
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  168  			dm_bufio_prefetch(ec->bufio, block1, __nr_blocks(ec, bio));
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  169  		else if (bio_op(bio) == REQ_OP_WRITE && !(bio->bi_opf & REQ_PREFLUSH)) {
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  170  			block2 = __sector_to_block(ec, bio_end_sector(bio));
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  171  			if (__block_mod(bio->bi_iter.bi_sector, ec->u_bs))
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  172  				dm_bufio_prefetch(ec->bufio, block1, 1);
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  173  			if (__block_mod(bio_end_sector(bio), ec->u_bs) && block2 != block1)
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  174  				dm_bufio_prefetch(ec->bufio, block2, 1);
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  175  		}
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  176  	}
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  177  
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  178  	bio_list_for_each(bio, &bios) {
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  179  		r = -EIO;
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  180  		if (bio_op(bio) == REQ_OP_READ)
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  181  			r = __ebs_rw_bio(ec, READ, bio);
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  182  		else if (bio_op(bio) == REQ_OP_WRITE) {
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  183  			write = true;
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  184  			r = __ebs_rw_bio(ec, WRITE, bio);
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  185  		} else if (bio_op(bio) == REQ_OP_DISCARD) {
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  186  			/* FIXME: (optionally) call dm_bufio_discard_buffers() once upstream. */
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  187  			r = __ebs_forget_bio(ec, bio);
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  188  		}
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  189  
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09 @190  		bio->bi_status = r;
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  191  	}
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  192  
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  193  	/*
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  194  	 * We write dirty buffers after processing I/O on them
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  195  	 * but before we endio thus addressing REQ_FUA/REQ_SYNC.
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  196  	 */
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  197  	r = write ? dm_bufio_write_dirty_buffers(ec->bufio) : 0;
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  198  
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  199  	while ((bio = bio_list_pop(&bios))) {
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  200  		/* Any other request is endioed. */
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  201  		if (unlikely(r && bio_op(bio) == REQ_OP_WRITE))
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  202  			bio_io_error(bio);
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  203  		else
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  204  			bio_endio(bio);
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  205  	}
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  206  }
eeb17d25430dc2 Heinz Mauelshagen 2020-03-09  207  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
