From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: REQ_PRIO use
Date: Tue, 20 Nov 2018 01:39:07 -0800
Message-ID: <20181120093907.GA32682@infradead.org>
References: <BN3PR0401MB1640F33FA8F3FFF251DF8266E7D90@BN3PR0401MB1640.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <BN3PR0401MB1640F33FA8F3FFF251DF8266E7D90@BN3PR0401MB1640.namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

We have two places that check the flag, the writeback tracking
code:

block/blk-wbt.c:#define REQ_HIPRIO      (REQ_SYNC | REQ_META | REQ_PRIO)
block/blk-wbt.c:        if ((rw & REQ_HIPRIO) || wb_recent_wait(rwb) || current_is_kswapd())

and bcache:

drivers/md/bcache/request.c:        !(bio->bi_opf & REQ_PRIO))
drivers/md/bcache/request.c:        !(bio->bi_opf & REQ_PRIO) &&

the original idea was that not all I/O is a priority we should not
blindly boost priority for metadata.  Of course wbt actually ignores
and it and we may just give in and just check REQ_META, except for
the fact that f2fs now actually submits REQ_PRIO requests without
REQ_META..
