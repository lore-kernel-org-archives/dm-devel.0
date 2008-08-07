From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao
	<fernando@oss.ntt.co.jp>
Subject: Re: RFC: I/O bandwidth controller
Date: Thu, 07 Aug 2008 13:38:15 +0900
Message-ID: <1218083895.3803.202.camel@sebastian.kern.oss.ntt.co.jp>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	 <1217870433.20260.101.camel@nimitz>
	 <1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20080806.151824.104049463.ryov@valinux.co.jp>
	 <1218004892.3950.12.camel@sebastian.kern.oss.ntt.co.jp>
	 <1218037688.10907.85.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753775AbYHGEir@vger.kernel.org>
In-Reply-To: <1218037688.10907.85.camel@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, xen-devel@lists.xensource.com, uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@sourceware.org, virtualization@lists.linux-foundation.org, ngupta@google.com, righi.andrea@gmail.com
List-Id: dm-devel.ids

On Wed, 2008-08-06 at 08:48 -0700, Dave Hansen wrote:
> On Wed, 2008-08-06 at 15:41 +0900, Fernando Luis V=C3=A1zquez Cao wro=
te:
> > > I agree with your plan.
> > > We keep bio-cgroup improving and porting to the latest kernel.
> > Having more users of bio-cgroup would probably help to get it merge=
d, so
> > we'll certainly send patches as soon as we get our cfq prototype in
> > shape.
>=20
> I'm confused.  Are these two of the competing controllers?  Or are th=
e
> complementary in some way?
Sorry, I did not explain myself correctly. I was not referring to a new
IO _controller_, I was just trying to say that the traditional IO
_schedulers_ already present in the mainstream kernel would benefit fro=
m
proper IO tracking too. As an example, the current implementation of CF=
Q
assumes that all IO is generated in the IO context of the current task,
which in only true in the synchronous path. This renders CFQ almost
unusable for controlling of asynchronous and buffered IO. Of course CFQ
is not to blame here, since it has no way to tell who the real
originator of the IO was (CFQ just sees IO requests coming from pdflush
and other kernel threads).

However, once we have a working IO tracking infrastructure in place, th=
e
existing IO _schedulers_ could be modified so that they use it to
determine the real owner/originator of asynchronous and buffered IO.
This can be done without turning IO schedulers into IO resource
controllers. If we can demonstrate that a IO tracking infrastructure
would also be beneficial outside the cgroups arena, it should be easier
to get it merged.
