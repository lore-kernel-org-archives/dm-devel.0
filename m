From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH] dm integrity: reinitialize __bi_remaining
 when reusing bio
Date: Tue, 25 Feb 2020 14:02:54 -0800
Message-ID: <20200225220254.GA13356@infradead.org>
References: <20200225170744.10485-1-dg@emlix.com>
 <20200225191222.GA3908@infradead.org>
 <a932a297-266e-4dee-f030-40ecbc9899ca@emlix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a932a297-266e-4dee-f030-40ecbc9899ca@emlix.com>
Sender: linux-block-owner@vger.kernel.org
To: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 25, 2020 at 08:54:07PM +0100, Daniel Glöckner wrote:
> bio_reset will reset too many fields. As you can see in the context of
> the diff, dm-integrity expects f.ex. the values modified by bio_advance
> to stay intact and the transfer should of course use the same disk and
> operation.
> 
> How about doing the atomic_set in bio_remaining_done (in block/bio.c)
> where the BIO_CHAIN flag is cleared once __bi_remaining hits zero?
> Or is requeuing a bio without bio_reset really a no-go? In that case a
> one-liner won't do...

That tends to add a overhead to the fast path for a rather exotic
case.  I'm having a bit of a hard time understanding the dm-integrity
code due to it's annoyingly obsfucated code, but it seems like it
tries to submit a bio again after it came out of a ->end_io handler.
That might have some other problems, but if we only want to paper
over the remaining count a isngle call to bio_inc_remaining might be all
you need.
