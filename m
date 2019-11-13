From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/9] Zoned block device enhancements and
 zone report rework
Date: Tue, 12 Nov 2019 19:16:39 -0700
Message-ID: <a0c1c1bf-d6e5-8be1-ed99-6bfed3483d1d@kernel.dk>
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20191111023930.638129-1-damien.lemoal@wdc.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
List-Id: dm-devel.ids

On 11/10/19 6:39 PM, Damien Le Moal wrote:
> This series of patches introduces changes to zoned block device handling
> code with the intent to simplify the code while optimizing run-time
> operation, particularly in the area of zone reporting.
> 
> The first patch lifts the device zone check code out of the sd driver
> and reimplements these zone checks generically as part of
> blk_revalidate_disk_zones(). This avoids zoned block device drivers to
> have to implement these checks. The second patch simplifies this
> function code for the !zoned case.
> 
> The third patch is a small cleanup of zone report processing in
> preparation for the fourth patch which removes support for partitions
> on zoned block devices. As mentioned in that patch commit message, none
> of the known partitioning tools support zoned devices and there are no
> known use case in the field of SMR disks being used with partitions.
> Dropping partition supports allows to significantly simplify the code
> for zone report as zone sector values remapping becomes unnecessary.
> 
> Patch 5 to 6 are small cleanups and fixes of the null_blk driver zoned
> mode.
> 
> The prep patch 7 optimizes zone report buffer allocation for the SCSI
> sd driver. Finally, patch 8 introduces a new interface for report zones
> handling using a callback function executed per zone reported by the
> device. This allows avoiding the need to allocate large arrays of
> blk_zone structures for the execution of zone reports. This can
> significantly reduce memory usage and pressure on the memory management
> system while significantly simplify the code all over.
> 
> Overall, this series not only reduces significantly the code size, it
> also improves run-time memory usage for zone report execution.
> 
> This series applies cleanly on the for-next block tree on top of the
> zone management operation series. It may however create a conflict with
> Christoph's reqork of disk size revalidation. Please consider this
> series for inclusion in the 5.5 kernel.

We're taking branching to new levels... I created for-5.5/zoned for this,
which is for-5.5/block + for-5.5/drivers + for-5.5/drivers-post combined.
The latter is a branch with the SCSI dependencies from Martin pulled in.

-- 
Jens Axboe
