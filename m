From: kbuild test robot <fengguang.wu@intel.com>
Subject: [dm:dm-fallocate 22/22] DockBook: block/blk-lib.c:331:
 warning: Excess function parameter 'gfp_mask' description in
 'blkdev_ensure_space_exists'
Date: Wed, 13 Apr 2016 06:02:04 +0800
Message-ID: <201604130603.JDkNZW27%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, kbuild-all@01.org
List-Id: dm-devel.ids


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-fallocate
head:   c79eaa33c66f54e2e41c12bc7de505365b43401d
commit: c79eaa33c66f54e2e41c12bc7de505365b43401d [22/22] block: wire blkdev_fallocate() to block_device_operations' reserve_space
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   lib/crc32.c:148: warning: No description found for parameter 'tab)[256]'
   lib/crc32.c:148: warning: Excess function parameter 'tab' description in 'crc32_le_generic'
   lib/crc32.c:293: warning: No description found for parameter 'tab)[256]'
   lib/crc32.c:293: warning: Excess function parameter 'tab' description in 'crc32_be_generic'
   lib/crc32.c:1: warning: no structured comments found
>> block/blk-lib.c:331: warning: Excess function parameter 'gfp_mask' description in 'blkdev_ensure_space_exists'

vim +331 block/blk-lib.c

   315	}
   316	EXPORT_SYMBOL(blkdev_issue_zeroout);
   317	
   318	/**
   319	 * blkdev_ensure_space_exists - preallocate a block range
   320	 * @bdev:	blockdev to preallocate space for
   321	 * @sector:	start sector
   322	 * @nr_sects:	number of sectors to preallocate
   323	 * @gfp_mask:	memory allocation flags (for bio_alloc)
   324	 * @flags:	FALLOC_FL_* to control behaviour
   325	 *
   326	 * Description:
   327	 *    Ensure space exists, or is preallocated, for the sectors in question.
   328	 */
   329	int blkdev_ensure_space_exists(struct block_device *bdev, sector_t sector,
   330			sector_t nr_sects, unsigned long flags)
 > 331	{
   332		sector_t res;
   333		const struct block_device_operations *ops = bdev->bd_disk->fops;
   334	
   335		if (!ops->reserve_space)
   336			return -EOPNOTSUPP;
   337	
   338		// FIXME: check with Brian Foster on whether it makes sense to
   339		// use BDEV_RES_GET/BDEV_RES_MOD instead of BDEV_RES_PROVISION?

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--EeQfGwPcQSOJBaQU
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--EeQfGwPcQSOJBaQU--
