From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/11] block: use block_bio class for getrq and sleeprq
Date: Wed, 1 Jul 2020 08:18:58 +0200
Message-ID: <20200701061858.GB28483@lst.de>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com> <20200629234314.10509-11-chaitanya.kulkarni@wdc.com> <20200630051332.GG27033@lst.de> <BYAPR04MB4965E849D99120B59011CEF5866C0@BYAPR04MB4965.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BYAPR04MB4965E849D99120B59011CEF5866C0@BYAPR04MB4965.namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "jack@suse.czi" <jack@suse.czi>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "mingo@redhat.com" <mingo@redhat.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "bvanassche@acm.org" <bvanassche@acm.org>, "fangguoju@gmail.com" <fangguoju@gmail.com>, "colyli@suse.de" <colyli@suse.de>
List-Id: dm-devel.ids

On Wed, Jul 01, 2020 at 04:45:03AM +0000, Chaitanya Kulkarni wrote:
> On 6/29/20 10:13 PM, Christoph Hellwig wrote:
> > On Mon, Jun 29, 2020 at 04:43:13PM -0700, Chaitanya Kulkarni wrote:
> >> The only difference in block_get_rq and block_bio was the last param
> >> passed  __entry->nr_sector & bio->bi_iter.bi_size respectively. Since
> >> that is not the case anymore replace block_get_rq class with block_bio
> >> for block_getrq and block_sleeprq events, also adjust the code to handle
> >> null bio case in block_bio.
> > To me it seems like keeping the NULL bio case separate actually is a
> > little simpler..
> > 
> > 
> 
> Keeping it separate will have an extra event class and related
> event(s) for only handling null bio case.
> 
> Also the block_get_rq class uses 4 comparisons with ?:.
> This patch reduces it to only one comparison in fast path.
> 
> With above explanation does it make sense to get rid of the
> blk_get_rq ?

Without this we don't need the request_queue argument to the bio
class, as we can derive it from the bio, and don't have any
conditionals at all.  I'd rather keep the special case with a 
queue and an optional bio separate.
