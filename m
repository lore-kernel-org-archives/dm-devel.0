From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Mon, 31 May 2010 19:52:08 +0200
Message-ID: <1275328328.3291.126.camel@edumazet-laptop>
References: <20100531160425.GA20344@basil.fritz.box>
	 <1275323695.3291.122.camel@edumazet-laptop>
	 <20100531174611.GF10766@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100531174611.GF10766@basil.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: herbert@gondor.apana.org.au, dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
List-Id: dm-devel.ids

Le lundi 31 mai 2010 =C3=A0 19:46 +0200, Andi Kleen a =C3=A9crit :
> On Mon, May 31, 2010 at 06:34:55PM +0200, Eric Dumazet wrote:
>=20
> Yes seems like I'm behind on per cpu innovations.
>=20
> > Since commit e0fdb0e050eae331, we have a __percpu annotation so tha=
t
> > sparse can be augmented. This would also make the comment unnecessa=
ry...
>=20
> I think the comment is still necessary.
>=20
> >=20
> > > +       __get_cpu_var(io_wq_cpu) =3D current;
> >=20
> > 	this_cpu_write(io_wq_cpu, current)
>=20
> And this one looks more ugly than before and does not seem
> to generate better code, so I decided to skip it.

This is because you whould use __this_cpu_write() in this context of
course ;)

generated code : one instruction
