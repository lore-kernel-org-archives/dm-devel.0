From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/11] block: rename block_bio_merge class to block_bio
Date: Tue, 30 Jun 2020 07:10:42 +0200
Message-ID: <20200630051042.GB27033@lst.de>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com> <20200629234314.10509-3-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200629234314.10509-3-chaitanya.kulkarni@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, jack@suse.czi, rdunlap@infradead.org, sagi@grimberg.me, mingo@redhat.com, rostedt@goodmis.org, snitzer@redhat.com, agk@redhat.com, axboe@kernel.dk, paolo.valente@linaro.org, ming.lei@redhat.com, bvanassche@acm.org, fangguoju@gmail.com, colyli@suse.de, hch@lst.de
List-Id: dm-devel.ids

On Mon, Jun 29, 2020 at 04:43:05PM -0700, Chaitanya Kulkarni wrote:
> There are identical TRACE_EVENTS presents which can now take an
> advantage of the block_bio_merge trace event class.
> 
> This is a prep patch which renames block_bio_merge to block_bio so
> that the next patches in this series will be able to resue it.

The changes look good, but I'd merged it with the patches adding
actual new users (which also look good to me).
