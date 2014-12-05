From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm thin: optimize away writing all zeroes to
	unprovisioned blocks
Date: Fri, 5 Dec 2014 13:33:42 -0500
Message-ID: <20141205183342.GA27397@redhat.com>
References: <alpine.DEB.2.00.1409301121470.26721@ware.dreamhost.com>
	<alpine.DEB.2.02.1412032237010.12556@ware.dreamhost.com>
	<alpine.DEB.2.02.1412032318290.29609@ware.dreamhost.com>
	<20141204153358.GA19315@redhat.com> <5481EB1C.4000202@kernel.dk>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5481EB1C.4000202@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Eric Wheeler <ewheeler@ewheeler.net>, dm-devel@redhat.com, ejt@redhat.com, LVM2 development <lvm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 05 2014 at 12:27pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 12/04/2014 08:33 AM, Mike Snitzer wrote:
> >
> >Here is a revised patch that is more like I'd expect to land upstream.
> >Jens are you OK with us adding bio_is_zero_filled to block/bio.c?  If so
> >should I split it out as a separate patch for you to pick up or just
> >carry it as part of the patch that lands in linux-dm.git?
> 
> Yeah I'm fine with adding that helper.

Good to know, thanks.

> I do wonder what the performance impact is on this for dm. Have you
> tried a (worst case) test of writing blocks that are zero filled, but
> with the last byte not being a zero?

I haven't tested that yet, but I share your concern.  Does fio offer the
ability to slap down a specific pattern like this?  If not is there a
logical place to extend fio to enable this?

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
