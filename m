From: Mike Snitzer <snitzer@redhat.com>
Subject: Linux >= 4.2 dm_any_congested bug due to bad data from vfs/mm? [was:
 Bug in dm_any_congested?]
Date: Tue, 10 Nov 2015 12:27:41 -0500
Message-ID: <20151110172740.GA5450@redhat.com>
References: <CAEp_DRAcgXsjEPttRnVoDYo97ZeeQ6heiBZhGMkppOUxTnOxjA@mail.gmail.com>
 <56420188.7030406@redhat.com>
 <CAEp_DRC652rPdLzmBbn_H9L5RhK1mMbtuXB=CcJhNxsvshQm3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEp_DRC652rPdLzmBbn_H9L5RhK1mMbtuXB=CcJhNxsvshQm3A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?Qm/FoXRqYW4gxaBrdWZjYSBAIFRlb24uc2k=?= <bostjan@teon.si>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

[Cc'ing LKML and linux-fsdevel to cast a wider net and raise awareness]

On Tue, Nov 10 2015 at 10:02am -0500,
Bo=C5=A1tjan =C5=A0kufca @ Teon.si <bostjan@teon.si> wrote:

> On 10 November 2015 at 15:39, Zdenek Kabelac <zkabelac@redhat.com> wr=
ote:
> > Dne 10.11.2015 v 14:14 Bo=C5=A1tjan =C5=A0kufca @ Teon.si napsal(a)=
:
> >>
> >> Hi all,
> >>
> >> HW is a bit dated, but had no problems with it up to now, and SW r=
aid
> >> is used here. Kernel was 4.2.4.
> >>
> >> Is this the right mlist for such bug?
> >
> >
> > Hi
> >
> > Yes the issue is known - but source is not fully known.
> > I've opened public BZ: https://bugzilla.redhat.com/1279941
> > There is some potential fix - but unclear what it solves:
> > http://git.kernel.org/linus/ad5f498f610
>=20
> So 4.1.13 is ok in this respect, or is this unknown ATM?
>=20
> Does it depend on underlying storage at all, or not? MD does not seem
> to be listed in stack trace.

We don't yet have a reliable reproducer.  So if your test proves to
reliably reproduce the issue for you then we may be able to make much
quicker progress.

While the bug manifests as a crash in dm_any_congested (either NULL
pointer or GPF) it _seems_ that the problem is further up the stack in
the vfs and/or mm (by passing garbage into dm_any_congested via call to
queue->backing_dev_info.congested_fn).  But all possibilities are still
on the table... again not much to go on yet.

Please feel free to test using the 4.4 stable@ commit Zdenek referenced
(but I'm skeptical it'll fix this issue if you aren't reactivating
volumes or anything): http://git.kernel.org/linus/ad5f498f610

Also, you're welcome to update this BZ as you collect additional info:
https://bugzilla.redhat.com/1279941

Thanks,
Mike
