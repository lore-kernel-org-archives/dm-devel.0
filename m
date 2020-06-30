From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/11] block: get rid of blk_trace_request_get_cgid()
Date: Tue, 30 Jun 2020 07:12:02 +0200
Message-ID: <20200630051202.GD27033@lst.de>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com> <20200629234314.10509-8-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200629234314.10509-8-chaitanya.kulkarni@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, jack@suse.czi, rdunlap@infradead.org, sagi@grimberg.me, mingo@redhat.com, rostedt@goodmis.org, snitzer@redhat.com, agk@redhat.com, axboe@kernel.dk, paolo.valente@linaro.org, ming.lei@redhat.com, bvanassche@acm.org, fangguoju@gmail.com, colyli@suse.de, hch@lst.de
List-Id: dm-devel.ids

On Mon, Jun 29, 2020 at 04:43:10PM -0700, Chaitanya Kulkarni wrote:
> Now that we have done cleanup we can safely get rid of the
> blk_trace_request_get_cgid() and replace it with
> blk_trace_bio_get_cgid().

To me the helper actually looks useful compared to open coding the
check in a bunch of callers.
