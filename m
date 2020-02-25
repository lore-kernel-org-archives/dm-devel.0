From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH] dm integrity: reinitialize __bi_remaining
 when reusing bio
Date: Tue, 25 Feb 2020 11:12:22 -0800
Message-ID: <20200225191222.GA3908@infradead.org>
References: <20200225170744.10485-1-dg@emlix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200225170744.10485-1-dg@emlix.com>
Sender: linux-block-owner@vger.kernel.org
To: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 25, 2020 at 06:07:44PM +0100, Daniel Glöckner wrote:
> In cases where dec_in_flight has to requeue the integrity_bio_wait work
> to transfer the rest of the data, the __bi_remaining field of the bio
> might already have been decremented to zero. Reusing the bio without
> reinitializing that counter to 1 can then result in integrity_end_io
> being called too early when the BIO_CHAIN flag is set, f.ex. due to
> blk_queue_split. In our case this triggered the BUG() in
> blk_mq_end_request when the hardware signalled completion of the bio
> after integrity_end_io had modified it.
> 
> Signed-off-by: Daniel Glöckner <dg@emlix.com>

Drivers have no business poking into these internals.  If a bio is
reused the caller needs to use bio_reset instead.
