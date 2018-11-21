From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: RFC: REQ_PRIO use
Date: Wed, 21 Nov 2018 02:37:28 +0000
Message-ID: <BN3PR0401MB16403A8178DCF6FD0E45BBCBE7DA0@BN3PR0401MB1640.namprd04.prod.outlook.com>
References: <BN3PR0401MB1640F33FA8F3FFF251DF8266E7D90@BN3PR0401MB1640.namprd04.prod.outlook.com>
	<20181120093907.GA32682@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2018/11/20 18:39, Christoph Hellwig wrote:
> We have two places that check the flag, the writeback tracking
> code:
> 
> block/blk-wbt.c:#define REQ_HIPRIO      (REQ_SYNC | REQ_META | REQ_PRIO)
> block/blk-wbt.c:        if ((rw & REQ_HIPRIO) || wb_recent_wait(rwb) || current_is_kswapd())
> 
> and bcache:
> 
> drivers/md/bcache/request.c:        !(bio->bi_opf & REQ_PRIO))
> drivers/md/bcache/request.c:        !(bio->bi_opf & REQ_PRIO) &&
> 
> the original idea was that not all I/O is a priority we should not
> blindly boost priority for metadata.  Of course wbt actually ignores
> and it and we may just give in and just check REQ_META, except for
> the fact that f2fs now actually submits REQ_PRIO requests without
> REQ_META..

OK. I will dig further.

But the fact remains that with 4.21, the actual priority boost is gone with cfq
removal. bfq, mq-deadline or kyber should add support. Or should the priority
boosting be done with generic code before the BIO is passed to the scheduler ?
That would also cover for the no scheduler case ("none") and allow propagating
an effective ioprio down to the device if the device driver has that feature
enabled.

-- 
Damien Le Moal
Western Digital Research
