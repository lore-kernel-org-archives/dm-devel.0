From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm integrity: reinitialize __bi_remaining when reusing bio
Date: Tue, 25 Feb 2020 20:22:31 -0500
Message-ID: <20200226012231.GA12308@redhat.com>
References: <20200225170744.10485-1-dg@emlix.com>
 <20200225191222.GA3908@infradead.org>
 <a932a297-266e-4dee-f030-40ecbc9899ca@emlix.com>
 <20200225220254.GA13356@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200225220254.GA13356@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 25 2020 at  5:02pm -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Feb 25, 2020 at 08:54:07PM +0100, Daniel Gl=F6ckner wrote:
> > bio_reset will reset too many fields. As you can see in the context o=
f
> > the diff, dm-integrity expects f.ex. the values modified by bio_advan=
ce
> > to stay intact and the transfer should of course use the same disk an=
d
> > operation.
> >=20
> > How about doing the atomic_set in bio_remaining_done (in block/bio.c)
> > where the BIO_CHAIN flag is cleared once __bi_remaining hits zero?
> > Or is requeuing a bio without bio_reset really a no-go? In that case =
a
> > one-liner won't do...
>
> That tends to add a overhead to the fast path for a rather exotic
> case.  I'm having a bit of a hard time understanding the dm-integrity
> code due to it's annoyingly obsfucated code, but it seems like it
> tries to submit a bio again after it came out of a ->end_io handler.

Yeah, the dm-integrity code has always been complex and it has only
gotten moreso.  I'm struggling with it too.

This case that Daniel has seen a BUG_ON with is when there is a need to
finish a partially completed bio (as reflected by the per-bio-data's
internal accounting managed by dm-integrity).

> That might have some other problems, but if we only want to paper
> over the remaining count a isngle call to bio_inc_remaining might be al=
l
> you need.

bio_inc_remaining() is really meant to be paired with bio_chain().  They
are pretty tightly coupled these days.  We removed __bio_inc_remaining()
once we weened all (ab)users many releases ago.  Definitely don't want
an open-coded equivalent buried in an obscure dm-integrity usecase.

Could be bio_split() + generic_make_request() recursion is a way
forward -- but that'd likely require some extra work in dm-integrity.
All the additional code in dm_integrity_map_continue() makes me think I
could easily be missing something.

Mikulas, if you could look closer at this issue and see what your best
suggestion would be that'd be appreciated.

Thanks,
Mike
