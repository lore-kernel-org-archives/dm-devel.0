From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [dm-devel] Re: dm-ioband: Test results.
Date: Tue, 21 Apr 2009 21:06:14 +0900 (JST)
Message-ID: <20090421.210614.112619728.ryov@valinux.co.jp>
References: <e98e18940904161324p9833457vdf699d66bb323591@mail.gmail.com>
	<20090420.172959.193682665.ryov@valinux.co.jp>
	<e98e18940904200207y62eca680t7cf938049375f4b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756151AbZDUMG2@vger.kernel.org>
In-Reply-To: <e98e18940904200207y62eca680t7cf938049375f4b3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: nauman@google.com
Cc: vgoyal@redhat.com, fernando@oss.ntt.co.jp, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Nauman,

> >> >> > General thoughts about dm-ioband
> >> >> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> >> > - Implementing control at second level has the advantage tha =
one does not
> >> >> > =A0 have to muck with IO scheduler code. But then it also has=
 the
> >> >> > =A0 disadvantage that there is no communication with IO sched=
uler.
> >> >> >
> >> >> > - dm-ioband is buffering bio at higher layer and then doing F=
IFO release
> >> >> > =A0 of these bios. This FIFO release can lead to priority inv=
ersion problems
> >> >> > =A0 in certain cases where RT requests are way behind BE requ=
ests or
> >> >> > =A0 reader starvation where reader bios are getting hidden be=
hind writer
> >> >> > =A0 bios etc. These are hard to notice issues in user space. =
I guess above
> >> >> > =A0 RT results do highlight the RT task problems. I am still =
working on
> >> >> > =A0 other test cases and see if i can show the probelm.
> >>
> >> Ryo, I could not agree more with Vivek here. At Google, we have ve=
ry
> >> stringent requirement for latency of our RT requests. If RT reques=
ts
> >> get queued in any higher layer (behind BE requests), all bets are =
off.
> >> I don't find doing IO control at two layer for this particular rea=
son.
> >> The upper layer (dm-ioband in this case) would have to make sure t=
hat
> >> RT requests are released immediately, irrespective of the state (F=
IFO
> >> queuing and tokens held). And the lower layer (IO scheduling layer=
)
> >> has to do the same. This requirement is not specific to us. I have
> >> seen similar comments from filesystem folks here previously, in th=
e
> >> context of metadata updates being submitted as RT. Basically, the
> >> semantics of RT class has to be preserved by any solution that is
> >> build on top of CFQ scheduler.
> >
> > I could see the priority inversion by running Vivek's script and I
> > understand how RT requests has to be handled. I'll create a patch
> > which makes dm-ioband cooperates with CFQ scheduler. However, do yo=
u
> > think we need some kind of limitation on processes which belong to =
the
> > RT class to prevent the processes from depleting bandwidth?
>=20
> If you are talking about starvation that could be caused by RT tasks,
> you are right. We need some mechanism to introduce starvation
> prevention, but I think that is an issue that can be tackled once we
> decide where to do bandwidth control.
>=20
> The real question is, once you create a version of dm-ioband that
> co-operates with CFQ scheduler, how that solution would compare with
> the patch set Vivek has posted? In my opinion, we need to converge to
> one solution as soon as possible, so that we can work on it together
> to refine and test it.

I think I can do some help for your work. but I want to continue the
development of dm-ioband, because dm-ioband actually works well and
I think it has some advantages against other IO controllers.
  - It can use without cgroup.
  - It can control bandwidth on a per partition basis.
  - The driver module can be replaced without stopping the system.

Thanks,
Ryo Tsuruta
