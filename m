From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] dm: use cloned bio as head, not remainder, in __split_and_process_bio()
Date: Wed, 29 Nov 2017 09:18:23 +1100
Message-ID: <87fu8yxd1s.fsf@notabene.neil.brown.name>
References: <20171121013533.GA14520@redhat.com> <20171121121049.GA17014@redhat.com> <20171121124311.GA17243@redhat.com> <20171121194709.GA18903@redhat.com> <alpine.LRH.2.02.1711211613000.10766@file01.intranet.prod.int.rdu2.redhat.com> <20171121225119.GA19630@redhat.com> <alpine.LRH.2.02.1711212009040.28456@file01.intranet.prod.int.rdu2.redhat.com> <87bmjv0xos.fsf@notabene.neil.brown.name> <alpine.LRH.2.02.1711221250090.21196@file01.intranet.prod.int.rdu2.redhat.com> <878tewzjz3.fsf@notabene.neil.brown.name> <20171127142344.GA25881@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171127142344.GA25881@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 27 2017, Mike Snitzer wrote:

> On Thu, Nov 23 2017 at  5:52pm -0500,
> NeilBrown <neilb@suse.com> wrote:
>
>>=20
>> When we use bio_clone_bioset() to split off the front part of a bio
>> and chain the two together and submit the remainder to
>> generic_make_request(), it is important that the newly allocated
>> bio is used as the head to be processed immediately, and the original
>> bio gets "bio_advance()"d and sent to generic_make_request() as the
>> remainder.
>>=20
>> If the newly allocated bio is used as the remainder, and if it then
>> needs to be split again, then the next bio_clone_bioset() call will
>> be made while holding a reference a bio (result of the first clone)
>> from the same bioset.  This can potentially exhaust the bioset mempool
>> and result in a memory allocation deadlock.
>>=20
>> So the result of the bio_clone_bioset() must be attached to the new
>> dm_io struct, and the original must be resubmitted.  The current code
>> is backwards.
>>=20
>> Note that there is no race caused by reassigning cio.io->bio after alrea=
dy
>> calling __map_bio().  This bio will only be dereferenced again after
>> dec_pending() has found io->io_count to be zero, and this cannot happen
>> before the dec_pending() call at the end of __split_and_process_bio().
>>=20
>> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>=20
>> Hi,
>>  I think this should resolve the problem Mikulas noticed that the
>>  bios form a deep chain instead of a wide tree.
>
> I'm inclined to just fold this into the original commit.
> I'd update that header to make mention of the details captured in this
> header.
>
> Would you be OK with that?

Perfectly OK with that.  Thanks for asking.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlod4LAACgkQOeye3VZi
gbneKRAAgXVUcPT+apK6tA6PTsinSjWRyXYx31ecX3cAa96/oABJl6RsTMTXLqEq
00OjYTaYxFn/hc2AnEDlRErrFi1VGkFljo9XTAabf6Hy3c3rJOEbVj9l7mvJx0cW
3CaiXu92L2Cco2qwGeDOK2MIis2Oqzdz+PRaEe+66H0pRPEQAjw0xUU/B540/qeK
8qwoIQ6Imwpcn52gI3r7qw1oGsSByvyW1ddLwgexQhRIE718KGLb+W7o+NgKGY8i
neIClEPJcRVmIedOaqBqONQ5bRhknXP4PhAiNm5zrC9N6MsUFnFeQr3NgKXxkSle
96h3fhslAozpY87V/8uCO4mNs0uv2B5rc0D7KkSoeHIXPXaCb3ewFDczPuq6wDNf
dZF8jhPKCKGYAh7Yhvh0soWGdccXo/ydIe+xZk2v9kdseDIMegZbIC8eeKxfYLsq
+5nUFCcbdCXCqTpWEjOL0QzMjPWEoCvc2hC8D+xhXyIckU6c66RgWeGOBJDBQGeT
LEMtn5I/Hw3WJVvfUh/8HHOUexzNnvbp1lLdfcxW87WLcj2nruPS4T2nb6xO7J9F
f/NgrTD9KzCLrNJa5AXic9wg1AvWo1eXYXEAlzMdaM+NmRTgX7lg7xtsUoOSJ6Cs
4kc5Vh8/WcESaQ3xxjrjCqfesJooiAGHa/0AVV6cUcPWgQXDask=
=hRw5
-----END PGP SIGNATURE-----
--=-=-=--
