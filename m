From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [dm-devel] [Bcache v13 01/16] Only clone bio vecs that are in use
Date: Fri, 11 May 2012 13:29:49 -0700
Message-ID: <20120511202949.GB26298@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <cb817596299fecd01ea36e4a80203f23165bda75.1336619038.git.koverstreet@google.com>
 <20120510213556.GO23768@redhat.com>
 <CAH+dOxJ2Vi=8Oq1zDZLmqD9-a_wgM=co3+xemw4XBoiDkh_4zg@mail.gmail.com>
 <x494nrmx2ux.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x494nrmx2ux.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, tejun@google.com, agk@redhat.com, Martin Peterson <mkp@mkp.net>
List-Id: dm-devel.ids

On Fri, May 11, 2012 at 09:29:42AM -0400, Jeff Moyer wrote:
>=20
> [top posting fixed]
>=20
> Kent Overstreet <koverstreet@google.com> writes:
>=20
> > 2012/5/10 Vivek Goyal <vgoyal@redhat.com>:
> >> On Wed, May 09, 2012 at 11:08:13PM -0400, Kent Overstreet wrote:
> >>
> >> [..]
> >>> -
> >>> - =C2=A0 =C2=A0 if (bio_integrity(bio)) {
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bio_integrity_clone(c=
lone, bio, GFP_NOIO, bs);
> >>> -
> >>> +#if 0
> >>> + =C2=A0 =C2=A0 if (bio_integrity(bio))
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (idx !=3D bio=
->bi_idx || clone->bi_size < bio->bi_size)
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 bio_integrity_trim(clone,
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0bio_sector_offset(bio, idx, 0), len);
> >>> - =C2=A0 =C2=A0 }
> >>> -
> >>> +#endif
> >>
> >> Dead/debug code under "#if 0" ?
> >>
> > Oh, I never got around to figuring out what needed to be done with =
the
> > bio integrity - presumably it'll have to be handled differently
> > somehow (I'm assuming an index in the integrity bvec is intended to
> > match up with an index in the regular bvec), but I don't have any w=
ay
> > to test the integrity stuff.
>=20
> The scsi debug module supports dif/dix, so you can use that for testi=
ng.

Thanks, I'll try that.
