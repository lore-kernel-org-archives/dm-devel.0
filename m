From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] dm-region-hash: fix strange usage
	of	mempool_alloc.
Date: Mon, 24 Apr 2017 11:41:44 +1000
Message-ID: <87k26ar38n.fsf@notabene.neil.brown.name>
References: <87efx1xb9h.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1704210847510.31816@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2349559117665736951=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1704210847510.31816@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--===============2349559117665736951==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 21 2017, Mikulas Patocka wrote:

> On Mon, 10 Apr 2017, NeilBrown wrote:
>
>> mempool_alloc() should only be called with GFP_ATOMIC when
>> it is not safe to wait. Passing __GFP_NOFAIL to kmalloc()
>> says that it is safe to wait indefinitely.  So this code is
>> inconsistent.
>>=20
>> Clearly it is OK to wait indefinitely in this code, and
>> mempool_alloc() is able to do that.  So just use
>> mempool_alloc, and allow it to sleep.  If no memory is
>> available it will wait for something to be returned to the
>> pool, and will retry a normal allocation regularly.
>
> The region hash code is buggy anyway, because it may allocate more entrie=
s=20
> than the size of the pool and not give them back.
>
> That kmalloc was introduced in the commit c06aad854 to work around a=20
> deadlock due to incorrect mempool usage.
>
> Your patch slightly increases the probability of the deadlock because=20
> mempool_alloc does all allocations with __GFP_NOMEMALLOC, so it uses=20
> higher limit than kmalloc(GFP_NOIO).
>

Thanks for the review.

I had a look at how the allocation 'dm_region' objects are used,
and it would take a bit of work to make it really safe.
My guess is __rh_find() should be allowed to fail, and the various
callers need to handle failure.
For example, dm_rh_inc_pending() would be given a second bio_list,
and would move any bios for which rh_inc() fails, onto that list.
Then do_writes() would merge that list back into ms->writes.
That way do_mirror() would not block indefinitely and forward progress
could be assured ... maybe.
It would take more work than I'm able to give at the moment, so
I'm happy to just drop this patch.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlj9V9gACgkQOeye3VZi
gbkdJRAAkQY4gC4RXu13vbfJZF3f+w5s9lk+i39sya0loTTa0pFvTNu0JzR/IT2o
x1iecaPmvSELsbIrT/gnBivtkI5laNDAMCiPfiZ5EY5AybCYtDrivXb1Ctt4pl0P
6FcCi8wpCWuike1W9+cbQzHppPNhugj/wrEBlbbL7rhE310pDb158eRU2VTYD68k
vYBiyoSuqUYS9fHiMsqOOkMrHnK+Q1kcINtpnuDN10a7djwAdEKAUyDffYTrutXC
0sbmR0n39WpFzlipS9IPOvjJ3qem7BGwj3EXQ7Uxcf99XmdZC01yGHgdRlqrmK2I
EO2aWIKSH5gWI6NA8JqkEIGXle5yVjyEx9z7FSGgl9bhGTiB8Z8nR59kYUOZzu4o
bMmzX6fgZviif7lLgzG+yp0AVpLZiw8X5qxKWke7+WsY5TXUTRB151BeOClAIAji
aHsLP4DiNTuIaZS9BC3U0X5QiIIh6kjK819gh955YVVjmuj4ac7kXCc0MYWuZmSg
hooL41Kea+Zzd66GlUdJPezs8K5u5ydawrFJqMvo9kRlECQtogpoNQhsL7T91MyP
u3qJotxm5b3zTwSt0utZwM+9LafYJn1X1mtDSxDxEpdqf2rgtSpjmKdNthRia65c
dcazQQ4a4XaHaEi/6GUrjdddlQwwirMbv4KUqDeIaqQU6vy8r5U=
=JbgB
-----END PGP SIGNATURE-----
--=-=-=--


--===============2349559117665736951==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2349559117665736951==--
