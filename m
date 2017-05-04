From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] [PATCH] dm-region-hash: fix strange usage of mempool_alloc.
Date: Thu, 04 May 2017 11:22:11 +1000
Message-ID: <87fuglpgak.fsf@notabene.neil.brown.name>
References: <87efx1xb9h.fsf@notabene.neil.brown.name> <alpine.LRH.2.02.1704210847510.31816@file01.intranet.prod.int.rdu2.redhat.com> <87k26ar38n.fsf@notabene.neil.brown.name> <alpine.LRH.2.02.1705031412260.21503@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1705031412260.21503@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, May 03 2017, Mikulas Patocka wrote:

> On Mon, 24 Apr 2017, NeilBrown wrote:
>>=20
>> I had a look at how the allocation 'dm_region' objects are used,
>> and it would take a bit of work to make it really safe.
>> My guess is __rh_find() should be allowed to fail, and the various
>> callers need to handle failure.
>> For example, dm_rh_inc_pending() would be given a second bio_list,
>> and would move any bios for which rh_inc() fails, onto that list.
>> Then do_writes() would merge that list back into ms->writes.
>> That way do_mirror() would not block indefinitely and forward progress
>> could be assured ... maybe.
>> It would take more work than I'm able to give at the moment, so
>> I'm happy to just drop this patch.
>>=20
>> Thanks,
>> NeilBrown
>
> I think that the only way how to fix this would be to preallocate the all=
=20
> the regions when the target is created.
>
> But, with the default region size 512kiB, it would cause high memory=20
> consumption (approximatelly 1GB of RAM for 20TB device).

Two reflections:
 1/ This is close to what md/bitmap does.
   It actually uses a 2-level array for the 'pending' field from
   dm_region, combined with something similar to 'state'.
   The top level is allocated when the device is created.
   Entries in this table are either
     - pointers to a second-level array for 2048 regions
     - entries for 2 giant regions, 1024 times the normal size.

   So if we cannot allocate a page when we need that second level,
    we just use an enormous region and so risk resync taking a bit
    longer if there is a crash.

 2/ Even though md does pre-alloc to a degree, I'm not convinced that it
    is necessary.
    We only need a region to be recorded when it is actively being
    written to, or when it is being recovered.
    We could, in theory, have just one region that is written to and one
    region that is being recovered.  If a writes request arrives for a
    different region it blocks until the current region has no active
    requests.  Then that region is forgotten and the new region
    activated, and the new write allowed to proceed.
    Obviously this would be horribly slow, but it should be
    deadlock-free.
    Using a mempool instead of a single region would then allow multiple
    regions to be active in parallel, which would improve throughput
    without affecting the deadlock status.

    Maybe I'll try to code it and see what happens ... maybe not.

NeilBrown

=20

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkKgkMACgkQOeye3VZi
gbmsyRAApIY5YOnaQ0TgF75eLUZmCOJPtxiviizBwuDEayP271WhnWjvVWRKl1HY
oe2+krhXNMDQ+gJ4/nEes7b41Y54KHyYVIvm7ezvl4BQBF5YL2xmBQHgfEa+PiwM
0dgLU/6qaz1l7AqjeLDef4uAFD/YIOdCDdtdrQzRQ3RjjXVHsmbF5D/7gfbPHEgk
JilzDjFpkWVXIsCKZYg1uQGeCvrjQIAxI7mVZ5Jm8MzsCEbN6CM1LCSoXJNVmxL3
6qHYo1/GHCt2tBaQ55vRZRV/ybpJJoPCZrMtRlTlX/lnyYl6VQPcw1yXARC582pC
aFNHyUIVL/Onw4AAUpcl9VBKL6yeFsBxX5f+ogMQ7hRMm6ffarUCMsgtRuMas342
CinC4qlDAagfTLNva39byNLXsA/N6rKUAlqKAYpbNQLNHeBmmuEd+CjnfDW0Beoh
5TZJExXifqAMyHi0ZHOeo+E+VoQi5d1LlbOwCDxMzg7yY1wKn4dS3mdcsJneaoX9
hHxgqeEJJVibMNDLciQtZfG2Jgp0xhLLgWFsST9RwbVci59C5YVAyQVBRuJOVIiB
LCzht26peCOLHiXzobzBV/DXSuwmHmxQRCjtsZaJmYrvt3c+MsHuveHrAHSAInz7
cP4IhXFUo8FUhBSjSx5pWjtz4Zewc3SWOvPpHLuKUkzUad87Dac=
=H7wy
-----END PGP SIGNATURE-----
--=-=-=--
