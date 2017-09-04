From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH/rfc] dm: revise 'rescue' strategy for md->bs
	allocations
Date: Mon, 04 Sep 2017 10:12:20 +1000
Message-ID: <87a82be2zf.fsf@notabene.neil.brown.name>
References: <878ti0fefq.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1708312233010.32309@file01.intranet.prod.int.rdu2.redhat.com>
	<87inh3dqp3.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1709011947200.22293@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3652424883034656819=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1709011947200.22293@file01.intranet.prod.int.rdu2.redhat.com>
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

--===============3652424883034656819==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 01 2017, Mikulas Patocka wrote:

> On Fri, 1 Sep 2017, NeilBrown wrote:
>
>> On Thu, Aug 31 2017, Mikulas Patocka wrote:
>>=20
>> >>=20
>> >> Note that only current->bio_list[0] is offloaded.  current->bio_list[=
1]
>> >> contains bios that were scheduled *before* the current one started, so
>> >
>> > These bios need to be offloaded too, otherwise you re-introduce this=20
>> > deadlock: https://www.redhat.com/archives/dm-devel/2014-May/msg00089.h=
tml
>>=20
>> Thanks for the link.
>> In the example the bio that is stuck was created in step 4.  The call
>> to generic_make_request() will have placed it on current->bio_list[0].
>> The top-level generic_make_request call by Process A is still running,
>> so nothing will have moved the bio to ->bio_list[1].  That only happens
>> after the ->make_request_fn completes, which must be after step 7.
>> So the problem bio is on ->bio_list[0] and the code in my patch will
>> pass it to a workqueue for handling.
>>=20
>> So I don't think the deadlock would be reintroduced.  Can you see
>> something that I am missing?
>>=20
>> Thanks,
>> NeilBrown
>
> Offloading only current->bio_list[0] will work in a simple case described=
=20
> above, but not in the general case.
>
> For example, suppose that we have a dm device where the first part is=20
> linear and the second part is snapshot.
>
> * We receive bio A that crosses the linear/snapshot boundary
> * DM core creates bio B, submits it to the linear target and adds it to=20
> current->bio_list[0]
> * DM core creates bio C, submits it to the snapshot target, the snapshot=
=20
> target calls track_chunk for this bio and appends the bio to=20
> current->bio_list[0]
> * Now, we return back to generic_make_request
> * We pop bio B from current->bio_list[0]
> * We execute bio_list_on_stack[1] =3D bio_list_on_stack[0], that moves bi=
o C=20
> to bio_list_on_stack[1] - and now we lose any possibility to offload bio =
C=20
> to the rescue thread
> * The kcopyd thread for the snapshot takes the snapshot lock and waits fo=
r=20
> bio C to finish

Thanks for the explanation.
I cannot find this last step in the code.  "waits for BIO C to finish"
is presumably the called to __check_for_conflicting_io().  This is
called from kcopyd in merge_callback() -> snapshot_merge_next_chunks().
What lock is held at that time?



> * We process bio B - and if processing bio B reaches something that takes=
=20
> the snapshot lock (for example an origin target for the snapshot), a=20
> deadlock will happen. The deadlock could be avoided by offloading bio C t=
o=20
> the rescue thread, but bio C is already on bio_list_on_stack[1] and so it=
=20
> won't be offloaded

I think the core issue behind this deadlock is that the same volume
can appear twice in the top-level device, in different regions.  An
outstanding request to one region can then interfere with a new request
to a different region.  That seems like a reasonable thing to do.
I cannot immediately see a generic way to handle this case that I am
happy with.  I'll keep hunting.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmsmmUACgkQOeye3VZi
gbkOThAAv/dDlpbxXxFEfOVwmEzMQ2sXtGaovD/T+hTN0w0bgsXciZYrgIuHwp8l
cIWpN3ZfsF+xOVzvu746XHJJZOrMHIB1MJSU22qIBc2DjVXbQyAHVBQnt279peV4
62xa9JniRM/EPyUNP0XIdJBAeEFpURXCkzzkSFIyErg9jE7mcW0kOrVZvbr2tbDH
4IlcpEuQ3yPKqGfV7zHcgOblTqY1q5j1kXXHwUkd9odBM/fQQUare8L6k5SFxbL3
kkosf4YObb61DbAJkcwGfP5NO+jnVRO3tbNSnu9VGcxk7SIjFvvp9A6/y4ela+Tk
iOcJyHK3w/HkSxqq/OKhaNHpQPZI8g2XpIJ5x+ia6GCyN7AdRCMX3HKeHNKR7L+X
UBcSV8c6m06qvYP2w3WMbOIUE2cmPgBGkEej10bfpGZKFYUcXXN3a1YpK1cEeTH1
J1cAy5AoOF1Aag1EsQMWEzH/Z3JTQKoAwTgWMqsNMwsJ7NOpeM0TZg09xwsH0rD4
tI+tJHT2StLGX8PJ86/JjVhkYy10NakgHtNd6pdf7oZN9tu5xcw0tbPlC/NUh1Re
GExBhSnjrTEIIuxz1q+idS2pLN8y4u9u0Mlo4jLS/HXyNdjlyCK8XHWDBnKn+LzX
jOL74nzpZa2g9XOLpyTd+umghGhsphWzCXHNRdFIhKuBFDwj7g4=
=yF/M
-----END PGP SIGNATURE-----
--=-=-=--


--===============3652424883034656819==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3652424883034656819==--
