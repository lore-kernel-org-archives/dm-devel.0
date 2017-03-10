From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2] blk: improve order of bio handling in generic_make_request()
Date: Fri, 10 Mar 2017 16:19:14 +1100
Message-ID: <87varhg14d.fsf@notabene.neil.brown.name>
References: <87h93blz6g.fsf@notabene.neil.brown.name> <71562c2c-97f4-9a0a-32ec-30e0702ca575@profitbricks.com> <87lgsjj9w8.fsf@notabene.neil.brown.name> <a674456d-fb93-437e-c50e-195e7a035ba4@kernel.dk> <87r328j00i.fsf@notabene.neil.brown.name> <87d1dphhuy.fsf@notabene.neil.brown.name> <58be6551-4aa7-72ee-1616-a1545606d029@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <58be6551-4aa7-72ee-1616-a1545606d029@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jack Wang <jinpu.wang@profitbricks.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>, Pavel Machek <pavel@ucw.cz>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 09 2017, Jens Axboe wrote:

> On 03/09/2017 09:32 PM, NeilBrown wrote:
>>=20
>> I started looking further at the improvements we can make once
>> generic_make_request is fixed, and realised that I had missed an
>> important detail in this patch.
>> Several places test current->bio_list, and two actually edit the list.
>> With this change, that cannot see the whole lists, so it could cause a
>> regression.
>>=20
>> So I've revised the patch to make sure that the entire list of queued
>> bios remains visible, and change the relevant code to look at both
>> the new list and the old list.
>>=20
>> Following that there are some patches which make the rescuer thread
>> optional, and then starts removing it from some easy-to-fix places.
>
> Neil, note that the v2 patch is already in Linus tree as of earlier
> today. You need to rebase the series, and if we need fixups on
> top of v2, then that should be done separately and with increased
> urgency.

I had checked linux-next, but not the latest from Linus.
I see it now - thanks!
I'll rebase (and ensure nothing gets mangled)

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljCN1IACgkQOeye3VZi
gbltXg//Zbeb62tldNtuxeqOa3GMxyPR+uaZPEYSsGNyKM1hKmTKdfhQOSJFVFw/
C7k/M4OkGaBpcS4magcXtc10o586ERDbiYgOGCOph3EAVqRoFOxDfbOA5IyEiszn
JzPUi82wgrF4ay4llbQ6VrsRie67+RMLsB29x9KV1t9kzToEwAU3p2xuBat++RL1
QiGCetAk8amRotOVt92Gwivk6+eaM+dTkDSr3cF2oW91FXqQaDqIAW7AnWYPD9qm
byJKj2BKJy/Ns2s75wooquJcg5quzz5PQSW9WGmeGn2YJvYu/w9wBtjsIzBC4/LT
iUswAiYMPA3mpG/fCMbzAeoixuAR7eISPwi7/tFbMiuGmhvefveZRxJquWr0kdwL
0rAQB3c44xq4gIjHYrKUo8Sy1ExHEG85gvIoecInZjZQ5PM9pyESw1924pAT95Sz
qxGtuSLL+7e8G6fvs2LnsWFpNZ7S0337Sg0xYkuwlTaMN187iRRwzkDnM5By6KiL
Lty2j8B4j/2gaJBHge+D6FasYgsTOQeYIhI6UUpgWquEUS0OWUymlDmmXDXzbUaB
45M+BKrJuiJ5Z1QdpCa308twhweYMNpCkg9yFcZLbDUSR/Yms7sASY/Na+TBL++x
GRPDgSlWVTYozA/UA7PUyNkaP+xYhxh9Z8KnGE+XlNztyakVfdo=
=d7VM
-----END PGP SIGNATURE-----
--=-=-=--
