From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/11] block: use block_bio class for getrq and sleeprq
Date: Tue, 30 Jun 2020 07:13:32 +0200
Message-ID: <20200630051332.GG27033@lst.de>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com> <20200629234314.10509-11-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200629234314.10509-11-chaitanya.kulkarni@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, jack@suse.czi, rdunlap@infradead.org, sagi@grimberg.me, mingo@redhat.com, rostedt@goodmis.org, snitzer@redhat.com, agk@redhat.com, axboe@kernel.dk, paolo.valente@linaro.org, ming.lei@redhat.com, bvanassche@acm.org, fangguoju@gmail.com, colyli@suse.de, hch@lst.de
List-Id: dm-devel.ids

On Mon, Jun 29, 2020 at 04:43:13PM -0700, Chaitanya Kulkarni wrote:
> The only difference in block_get_rq and block_bio was the last param
> passed  __entry->nr_sector & bio->bi_iter.bi_size respectively. Since
> that is not the case anymore replace block_get_rq class with block_bio
> for block_getrq and block_sleeprq events, also adjust the code to handle
> null bio case in block_bio.

To me it seems like keeping the NULL bio case separate actually is a
little simpler..
