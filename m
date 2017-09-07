From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH/rfc] dm: revise 'rescue' strategy for md->bs
	allocations
Date: Thu, 07 Sep 2017 13:19:59 +1000
Message-ID: <87fubzb3fk.fsf@notabene.neil.brown.name>
References: <878ti0fefq.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1708312233010.32309@file01.intranet.prod.int.rdu2.redhat.com>
	<87inh3dqp3.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1709011947200.22293@file01.intranet.prod.int.rdu2.redhat.com>
	<87a82be2zf.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1709041249100.9535@file01.intranet.prod.int.rdu2.redhat.com>
	<874lsgd84f.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1709061853240.19771@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3305993925035553581=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1709061853240.19771@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

--===============3305993925035553581==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 06 2017, Mikulas Patocka wrote:

> On Wed, 6 Sep 2017, NeilBrown wrote:
>
>> Thanks for the extra explanation.  I've thought some more about this I c=
an
>> see a way forward that I am comfortable with.  Please let me know what
>> you think.
>> I haven't tested this patch yet, but I believe that applying it first wi=
ll
>> clear the way for my other patch to work without reintroducing
>> deadlocks.
>>=20
>> Thanks,
>> NeilBrown
>
> What's the purpose of this patch? If the current code that offloads bios=
=20
> on current->bio_list to a rescue thread works, why do you want to change=
=20
> it?

That is a fair question.

My primary reason is that I don't like the 'rescue' functionality built
in to biosets, and I want to get rid of it together with all uses for
BIOSET_NEED_RESCUER.  I think this functionality is unnecessary and adds
complexity.  It superficially seems like it should fix any deadlock
issue created by the ordering that generic_make_request() requires, but
as you discovered with dm-snap, it isn't sufficient by itself.  So it is
an incomplete solution that mostly isn't necessary, and I don't think it
is good design to keep such things around.

I also like uniformity where practical.  The block layer provides a
simple coherent infrastructure for splitting requests when needed, and
if simple guidelines are following concerning how the resulting bios are
submitted to generic_make_request(), then deadlocks can be avoided.
Most device use this common infrastructure, the exceptions being dm and
bcache (though I really haven't wrapped my mind around bcache yet so I
cannot say much in concrete terms about what it does).
So I would like dm to handle over-large bios by allocating from the
=2D>bio_split pool, cloning, bio_chain and generic_make_request().

On reflection, I think that just this change might address all your
deadlock issues.  We might be able to get rid of the dm_offload stuff
completely, though I'm not 100% sure yet.

So in brief:
1/ use same approach to bio splitting everywhere - an approach that is
   resistant to deadlocks.
2/ discard the incomplete and unnecessary BIOSET_NEED_RESCUER
   functionality.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmwuuAACgkQOeye3VZi
gbn9NQ//en8xFShX9ufo1Ep7C9JIzeeLOHalZvMIwwDCUq0su8IkfwVYZfCn53Zi
+CNfWvUz6Mh51UQknzSiDZ5ZoKD+cUW2grlRQF+b3wlZV5bNwr+QMVKg6IyZ/qbX
eZ2SIMZCXTSJXdWX1aKQm/KwZ6+LPRoCSIn9KgDBH1vseKEs/RSXrBpFVMqCTuDG
siIuyAZCd0nBTJLTCR3RwriuU80yNgBBTni0fEQvwgJCSc4yv3g8cUMOuyWgjnyS
edhcpzXXU7MgXysgHjYQuSSLi26qqzRzB783hpmmmcMCuYOELhGdStugLLPI9UAT
VAXHMsxE/eh0ebACysIJ+QxEND4THiwqXNRKaLtTiNAGwuD65O89y20CC80eW2T3
HAecZp/YXJE1idlZq78ZGx5Q3cgly9xleqwk7bkh3j+XYlmtSBY+PQpsktPdHKKk
8xWlsdP3krPAqTgAmer1dwSzXiOg5r5n6fdETog0qRtLFZJMvpkzMR3new1EnLed
0pWdcRpMOnwK7Ft2+54Pq7LFp+efdF7fvge/HL1yyT+mteUNTs9DII857XDJ5Y5L
cXlxlBQoLqa9D38udEyqHXCIXiAHiyFPxxzdVsJmrgflsJGFskkowkYvYjhdUDwG
X/LXhfQE4VHuZ4bQBEji6SIg2urKCoU4F4GM2MHmeTs5CPa1rHE=
=Xjma
-----END PGP SIGNATURE-----
--=-=-=--


--===============3305993925035553581==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3305993925035553581==--
