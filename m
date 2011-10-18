From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH v2] dm mpath: maintain reference count for
 underlying devices
Date: Tue, 18 Oct 2011 22:00:48 +0900
Message-ID: <4E9D7880.60201@ce.jp.nec.com>
References: <1316181571-4691-1-git-send-email-snitzer@redhat.com>
	<4E76E5E8.9040701@ce.jp.nec.com> <20110919143411.GA7965@redhat.com>
	<4E7824CB.9030405@ce.jp.nec.com>
	<20111017201514.GA21731@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111017201514.GA21731@redhat.com>
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
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com, jbottomley@parallels.com, roland@purestorage.com, device-mapper development <dm-devel@redhat.com>, tj@kernel.org, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 10/18/11 05:15, Mike Snitzer wrote:
> FYI, this patch from Tejun should also fix the concern I had relative to
> mpath's underlying devices' request_queues:
> https://lkml.org/lkml/2011/10/16/148

Oh, that's good information.

Since the following commit, a queue can be accessed
after the device being released:

  commit f758eeabeb96f878c860e8f110f94ec8820822a9
  Author: Christoph Hellwig <hch@infradead.org>
  Date:   Thu Apr 21 18:19:44 2011 -0600

    writeback: split inode_wb_list_lock into bdi_writeback.list_lock

I.e.
  __blkdev_put
    disk->fops->release()
    ..
    bdev_inode_switch_bdi()
      bdi_lock_two()
      [access to bdev->bd_inode->i_data.backing_dev_info]

I think Tejun's patch is reasonable.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
