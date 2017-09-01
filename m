From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH/rfc] dm: revise 'rescue' strategy for md->bs
	allocations
Date: Fri, 01 Sep 2017 13:48:40 +1000
Message-ID: <87inh3dqp3.fsf@notabene.neil.brown.name>
References: <878ti0fefq.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1708312233010.32309@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5054300104588878727=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1708312233010.32309@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

--===============5054300104588878727==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 31 2017, Mikulas Patocka wrote:

>>=20
>> Note that only current->bio_list[0] is offloaded.  current->bio_list[1]
>> contains bios that were scheduled *before* the current one started, so
>
> These bios need to be offloaded too, otherwise you re-introduce this=20
> deadlock: https://www.redhat.com/archives/dm-devel/2014-May/msg00089.html

Thanks for the link.
In the example the bio that is stuck was created in step 4.  The call
to generic_make_request() will have placed it on current->bio_list[0].
The top-level generic_make_request call by Process A is still running,
so nothing will have moved the bio to ->bio_list[1].  That only happens
after the ->make_request_fn completes, which must be after step 7.
So the problem bio is on ->bio_list[0] and the code in my patch will
pass it to a workqueue for handling.

So I don't think the deadlock would be reintroduced.  Can you see
something that I am missing?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmo2JoACgkQOeye3VZi
gbkbeQ//Uz9IOgPykRTvvIYmIJb7a4WRW8UEVFjmgLVAPB9Q1anZTAxkkmbz6Hrk
trKte6HXY/pjdpYs2nOQ1XwJEZnx4Tdrz3lidN1fHzzYYpAw6M7xWYz9e+a5avLF
oE93pzklASrIbbw6BwG/aD7LIv1GOAt3yXC4AlLt54m8elAGOUnPPscXI+21Zymf
CZk//b7mZG152/KT6RA9yOrr6eKQu1UE3cB3vlMU899A4EIzFQ8Tp28CvmAqhc23
ohv/bPivm0tjN34mmg18rFGFB9nskLFhVEmUzlaC7keZ8pQLSGGttBJlN9lZSMiV
LJaULQyJ1jZv/LsvJk+2l3LHGDCrmqEgQWpc6lcT3VYWtqsNUf1MuLQwYsnNoOpc
jvnfUjW+yDnkArww0eYE6xDfJJe0+USvMa5DLgXs2zwVPlrYW2LeYHcj3WFYVcpm
ii11cegG8EQwFDnJusLpde5vwSK48zo6zqsIa+LLp1kn6r4ICZ7cfIN3JMUFTInE
BxGo8fgWJrrR59ae4OSHv90vwRk4tE9dBu2xI7ClhUfbfqqLtXO5rTxDA20go4i5
X8R0vUWc9Qxg7A96ic91wJvX3VJN//8yID+JfjV+u5IkCZRRduhmM11FwhuE7/G5
0VXBlYJAYa1z9DAkY5qrsWE1UjHQbnjjjGJQsGD0L/0SLIxaT1A=
=T3FW
-----END PGP SIGNATURE-----
--=-=-=--


--===============5054300104588878727==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5054300104588878727==--
