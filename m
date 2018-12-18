From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] dm: give req_size precisely given by user
Date: Tue, 18 Dec 2018 23:47:59 +0000
Message-ID: <20181218234800.1587C218A2@mail.kernel.org>
References: <20181218172537.12300-1-jaegeuk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181218172537.12300-1-jaegeuk@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org, dm-devel@redhat.com, Jaegeuk Kim <jaegeuk@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 9491ae4aade6 mm: don't cap request size based on read-ahead setting.

The bot has tested the following trees: v4.19.10, v4.14.89, 

v4.19.10: Failed to apply! Possible dependencies:
    5f832a395859 ("scsi: sd_zbc: Fix sd_zbc_check_zones() error checks")
    a2d6b3a2d390 ("block: Improve zone reset execution")
    a91e138022bc ("block: Introduce blkdev_nr_zones() helper")
    bf5054569653 ("block: Introduce blk_revalidate_disk_zones()")
    d2e428e49eec ("scsi: sd_zbc: Reduce boot device scan and revalidate time")
    e76239a3748c ("block: add a report_zones method")

v4.14.89: Failed to apply! Possible dependencies:
    08e18eab0c57 ("block: add bi_blkg to the bio for cgroups")
    30e5e929c7bf ("nvme: don't pass struct nvme_ns to nvme_config_discard")
    5238dcf4136f ("block: replace bio->bi_issue_stat with bio-specific type")
    53cfdc10a95d ("blk-throttle: fix null pointer dereference while throttling writeback IOs")
    5d47c89f29ea ("dm: clear all discard attributes in queue_limits when discards are disabled")
    8b904b5b6b58 ("block: Use blk_queue_flag_*() in drivers instead of queue_flag_*()")
    a2d6b3a2d390 ("block: Improve zone reset execution")
    b889bf66d001 ("blk-throttle: track read and write request individually")
    bf5054569653 ("block: Introduce blk_revalidate_disk_zones()")
    c8b5fd031a30 ("mmc: block: Factor out mmc_setup_queue()")
    d70675121546 ("block: introduce blk-iolatency io controller")
    e447a0151f7c ("zram: set BDI_CAP_STABLE_WRITES once")
    ed754e5deeb1 ("nvme: track shared namespaces")


How should we proceed with this patch?

--
Thanks,
Sasha
