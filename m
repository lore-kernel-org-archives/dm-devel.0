From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] DM Regression in 4.16-rc1 - read() returns data when it shouldn't
Date: Thu, 15 Feb 2018 19:52:03 +1100
Message-ID: <87mv0aprd8.fsf@notabene.neil.brown.name>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com> <871shnqp9l.fsf@notabene.neil.brown.name> <20180214230526.GA25114@redhat.com> <87y3jvp13k.fsf@notabene.neil.brown.name> <1df6de2e-bfd3-84c4-cffb-83b6299c6d23@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1df6de2e-bfd3-84c4-cffb-83b6299c6d23@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 15 2018, Milan Broz wrote:

> On 02/15/2018 01:07 AM, NeilBrown wrote:
>>=20
>> And looking again at the code, it doesn't seem so bad.  I was worried
>> about reassigning ci.io->orig_bio after calling
>> __split_and_process_non_flush(), but the important thing is to set it
>> before the last dec_pending() call, and the code gets that right.
>>=20
>> I think I've found the problem though:
>>=20
>> 			/* done with normal IO or empty flush */
>> 			bio->bi_status =3D io_error;
>>=20
>> When we have chained bios, there are multiple sources for error which
>> need to be merged into bi_status:  all bios that were chained to this
>> one, and this bio itself.
>>=20
>> __bio_chain_endio uses:
>>=20
>> 	if (!parent->bi_status)
>> 		parent->bi_status =3D bio->bi_status;
>>=20
>> so the new status won't over-ride the old status (unless there are
>> races....), but dm doesn't do that - I guess it didn't have to worry
>> about chains before.
>>=20
>> So this:
>>=20
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index d6de00f367ef..68136806d365 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -903,7 +903,8 @@ static void dec_pending(struct dm_io *io, blk_status=
_t error)
>>  			queue_io(md, bio);
>>  		} else {
>>  			/* done with normal IO or empty flush */
>> -			bio->bi_status =3D io_error;
>> +			if (io_error)
>> +				bio->bi_status =3D io_error;
>>  			bio_endio(bio);
>>  		}
>>  	}
>>=20
>
> Hi,
>
> well, it indeed fixes the reported problem, thanks.
> But I just tested the first (dm.c) change above.
>
> The important part is also that if the error is hits bio later, it will p=
roduce
> short read (and not fail of the whole operation), this can be easily test=
ed if we switch
> the error and the zero target in that reproducer
>   //system("echo -e \'0 10000000 error\'\\\\n\'10000000 1000000 zero\' | =
dmsetup create test");
>   system("echo -e \'0 10000000 zero\'\\\\n\'10000000 1000000 error\' | dm=
setup create test");
>
> So it seems your patch works.

Excellent - thanks.

>
> I am not sure about this part though:
>
>> should fix it.  And __bio_chain_endio should probably be
>>=20
>> diff --git a/block/bio.c b/block/bio.c
>> index e1708db48258..ad77140edc6f 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -312,7 +312,7 @@ static struct bio *__bio_chain_endio(struct bio *bio)
>>  {
>>  	struct bio *parent =3D bio->bi_private;
>>=20=20
>> -	if (!parent->bi_status)
>> +	if (bio->bi_status)
>>  		parent->bi_status =3D bio->bi_status;
>
> Shouldn't it be
> 	if (!parent->bi_status && bio->bi_status)
>   		parent->bi_status =3D bio->bi_status;
> ?

That wouldn't hurt, but I don't see how it would help.
It would still be racy as two chained bios could complete at
the same time, so ->bi_status much change between test and set.

>
> Maybe one rephrased question: what about priorities for errors (bio statu=
ses)?
>
> For example, part of a bio fails with EILSEQ (data integrity check error,=
 BLK_STS_PROTECTION),
> part with EIO (media error, BLK_STS_IOERR). What should be reported for p=
arent bio?
> (I would expect I always get EIO here because this is hard, uncorrectable=
 error.)

If there was a well defined ordering, then we could easily write to code
ensure the highest priority status wins, but I don't think there is any
such ordering.
Certainly dec_pending() in dm.c already faces the possibility that it will
be called multiple times with different errors, but doesn't consider any
ordering (except relating to BLK_STS_DM_REQUEUE), when assigning a
status code to io->status.

>
> Anyway, thanks for the fix!

And thanks for the report.

NeilBrown

>
> Milan
>
>
>>  	bio_put(bio);
>>  	return parent;
>>=20
>> to remove the chance that a race will hide a real error.
>>=20
>> Milan: could you please check that the patch fixes the dm-crypt bug?
>> I've confirmed that it fixes your test case.
>> When you confirm, I'll send a proper patch.
>>=20
>> I guess I should audit all code that assigns to ->bi_status and make
>> sure nothing ever assigns 0 to it.
>>=20
>> Thanks,
>> NeilBrown
>>=20
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlqFSjMACgkQOeye3VZi
gbmKphAAwB5Bx2lmTrp0osTARvvg4RmPHG4IZxGHV2FNgtWpKL/UNiVQ0u5/SFNu
Qfcl+nbZtRPtubyFDdg1rT6fOIeY3os2T0l9x96lvUBLIk+uS0Eudzwp/I/+bvyy
Y4nemyIu3J/v8GAU/rlEZc+L2h+MBhOfkhz9Bmvl931S6/9SEzbIE/mbM/U62Gwv
9pgZ88/PXGYv3Q2LUgTI0OiK3PjIrzd+/D+W5tWAlY93DoFGzZIhLYnwECATNZiS
mChlrp1TGxA7MHyv+yLEd47vHQWdSoAaDyeY/PE4/lWTn+u5anktf4hCi8KoikJl
t1GThrzE2ODlDPfHEp4PxUPVraoM61qWprQx5C1VJxUW9/bKgglOe5cteebeycCf
0razMri9t52XheASOl86vhDMHRkKV5aoIGuKfFpNLLsDywW5cPlvt2ib38I/xXDm
1r3YpMd63fJ8lLN9+6tW6YzBsjZwVuN7H5vHAbo+gA92/Rms7tehuuLfvWkSIJk2
x8PE1Oyc6/zpl/cXTUOBPQI8k7H+G3Oeq2SzCWGp3mVZMJPPEJFdN4xefH4Wm09M
zxY8494eNIOH2QArib67Vpljpvnjc/ooQSYGKJsUQgH+lYJR4vkhaIFE8BY1Y9qI
gdaDTRWvXakdtOKFszDGV53yXtYDcBpcWtNUMLSy3sJ3OPfRyus=
=wHvr
-----END PGP SIGNATURE-----
--=-=-=--
