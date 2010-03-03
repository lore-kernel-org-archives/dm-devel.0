From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] blkdev: fix merge_bvec_fn return value checks
Date: Wed, 3 Mar 2010 14:16:13 -0500
Message-ID: <20100303191613.GB18480@redhat.com>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
 <20100228184634.GI5768@kernel.dk>
 <874okyf4iw.fsf@openvz.org>
 <170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
 <87wrxtkzwu.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87wrxtkzwu.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Mar 03 2010 at  1:45pm -0500,
Dmitry Monakhov <dmonakhov@openvz.org> wrote:

> Mike Snitzer <snitzer@redhat.com> writes:
>=20
> > On Tue, Mar 2, 2010 at 10:49 PM, Dmitry Monakhov <dmonakhov@openvz.=
org> wrote:
> >> Jens Axboe <jens.axboe@oracle.com> writes:
> >>
> >>> On Sat, Feb 27 2010, Dmitry Monakhov wrote:
> >>>> merge_bvec_fn() returns bvec->bv_len on success. So we have to c=
heck
> >>>> against this value. But in case of fs_optimization merge we comp=
are
> >>>> with wrong value. This patch must be included in
> >>>> =A0b428cd6da7e6559aca69aa2e3a526037d3f20403
> >>>> But accidentally i've forgot to add this in the initial patch.
> >>>> To make things straight let's replace all such checks.
> >>>> In fact this makes code easy to understand.
> >>>
> >>> Agree, applied.
> >> Ohh.. as you already know this patch break dm-layer. Sorry.
> >> This is because dm->merge may return more than requested. So corre=
ct
> >> check must test against less what requested. Correct patch attache=
d.
> >
> > Yes, it is quite common for dm_merge_bvec() to return greater than =
the
> > requested length.
> >
> > But dm_merge_bvec() returning a maximum length, rather than request=
ed,
> > isn't special.  All the other blk_queue_merge_bvec() callers' merge
> > functions appear to return "maximum amount of bytes we can accept a=
t
> > this offset" too.
> What for? Does it allow us to make some optimization?

I wasn't suggesting the behavior of the current merge functions
returning maximum is important or useful.  I was just pointing out what
the interface is and that dm_merge_bvec() is no different than the
others.

> For example like follows:
> bio_add_pageS(bio, **pages) {
>    /* call merge_fn only one untill all space exhausted */           =
    =20
>    ret =3D merge_fn()  (this returns huge value (1024*1024))
>    while (ret) {=20
>           bio->bi_io_vec[bio->bi_vcnt - 1].bv_page =3D page;
>           ...
>           ret -=3D PAGE_SIZE;
>           bio->bi_vcnt++;
>    }
> }
> IMHO the answer is *NO*, this code will unlikely to work.

Conversely, I see no value in imposing that these 'q->merge_bvec_fn'
functions return at most the requested length.  Can't even really see i=
t
making the __bio_add_page() code more readable.

> > __bio_add_page() only needs to care about whether the
> > 'q->merge_bvec_fn' return is _less than_ the requested length.

Linux has all sorts of internal interfaces that are "odd"... the curren=
t
'q->merge_bvec_fn' interface included.  But odd is not a problem (nor i=
s
it "broken") unless you make changes that don't consider how the curren=
t
interface is defined.

But I digress...

Mike
