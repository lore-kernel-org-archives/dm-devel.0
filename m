From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Remove might_sleep from wait_event_cmd
Date: Wed, 4 Feb 2015 08:30:25 +1100
Message-ID: <20150204083025.00facfb7@notabene.brown>
References: <alpine.LRH.2.02.1502020935580.13510@file01.intranet.prod.int.rdu2.redhat.com>
	<20150203091253.60ded1d7@notabene.brown>
	<20150203110630.GK26304@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cI+Gv=0XJoPZX3y8I6=dXJx"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150203110630.GK26304@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--Sig_/cI+Gv=0XJoPZX3y8I6=dXJx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Feb 2015 12:06:30 +0100 Peter Zijlstra <peterz@infradead.org> wro=
te:

> On Tue, Feb 03, 2015 at 09:12:53AM +1100, NeilBrown wrote:
> > I support this patch.
>=20
> It should hopefully already be en-route to tip.

Hopefully that means it will be in 3.19-final...

Thanks, I'll drop my __wait_event_cmd patch then.

NeilBrown

>=20
> > However in case it doesn't get in, I've queued up a patch to change rai=
d5.c
> > to use __wait_event_cmd instead...
>=20
> So those primitives are useful in their own; their typical use would be
> when you already know @cond to be false and want to avoid the extra
> invocation.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


--Sig_/cI+Gv=0XJoPZX3y8I6=dXJx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNE98Tnsnt1WYoG5AQIzvg/+J85LWi6KNf+v7RkUYEmJaMxmJyxfeKHo
n/3j+L3DBVBxA4pLaizsE77jYqVBV5MLJ6td6dDZFpW2V9lfI1LVfUmvEpNYwqcL
UAh2yZfhO3UR3LafaFzVuxSBUEtW1YsejzEuKuxzwLKlGPJd0WcUlxdveYZRe2IB
fSwPKVs8AFZ/uFuICSPqrReqIPt8DUHtGI79P+n+McIMmfBaOrcO55OJSCU7lQ3g
Xg52wGZMnoTg1+Fx5Q+lNqmopnmh3bxuFF8kWaT+G2q/BnIh542DyMst0yCszxkh
ziiPo0Kk/l7YEOcucRXo7zyLQ0PdcBIo5vXPyZPM9vruR9gD6YzWPSTvinvXVp66
LGx4ZV9NqfFm9prL3+LMErlgW09F0b3WfykZWlT0LNhxkEKwrtt5J6pjrXBUk7dJ
27R+uMtWKkbkS9bIwxVLKKttf9cekAP3lfj9WRKL3Wyy7jfrRv1nZCqvYrZuTBfg
W1L6LJjrXzvEG5HOJl7w8TRDevdmc0PCVOFSQKovLiOAv1Psv05ZS41hiaB8uZkV
Ib7t+E55oHGJDqkwXX9upnxC75iC/Gd75/Ehse9NyFfGxdtn84U5FuWL9Q1GVXtI
EbqcPgK7NwxJtRclUoeEcs4VKlJ67Uazc6S2lzAq9iAix5m2Ze23F/7adoWorX9k
heKxf2rzAWA=
=TZG5
-----END PGP SIGNATURE-----

--Sig_/cI+Gv=0XJoPZX3y8I6=dXJx--
