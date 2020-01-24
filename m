From: Stefan Bader <stefan.bader@canonical.com>
Subject: Re: [PATCH 1/1] blk/core: Gracefully handle unset make_request_fn
Date: Fri, 24 Jan 2020 08:04:07 +0200
Message-ID: <c733639c-421d-19af-81fd-61d7b2ad019e@canonical.com>
References: <20200123091713.12623-1-stefan.bader@canonical.com>
 <20200123091713.12623-2-stefan.bader@canonical.com>
 <20200123103541.GA28102@redhat.com> <20200123172816.GA31063@redhat.com>
 <81055166-37fb-ad65-6a53-11c22c626ab1@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="zTLhkZGxdCktEkSjLInMVv7empLOhgroL"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <81055166-37fb-ad65-6a53-11c22c626ab1@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Tyler Hicks <tyler.hicks@canonical.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zTLhkZGxdCktEkSjLInMVv7empLOhgroL
Content-Type: multipart/mixed; boundary="YFDhP2D9xiAic0tOcuyovTHE0VS66F84F"

--YFDhP2D9xiAic0tOcuyovTHE0VS66F84F
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 23.01.20 20:52, Jens Axboe wrote:
> On 1/23/20 10:28 AM, Mike Snitzer wrote:
>> On Thu, Jan 23 2020 at  5:35am -0500,
>> Mike Snitzer <snitzer@redhat.com> wrote:
>>
>>> On Thu, Jan 23 2020 at  4:17am -0500,
>>> Stefan Bader <stefan.bader@canonical.com> wrote:
>>>
>>>> When device-mapper adapted for multi-queue functionality, they
>>>> also re-organized the way the make-request function was set.
>>>> Before, this happened when the device-mapper logical device was
>>>> created. Now it is done once the mapping table gets loaded the
>>>> first time (this also decides whether the block device is request
>>>> or bio based).
>>>>
>>>> However in generic_make_request(), the request function gets used
>>>> without further checks and this happens if one tries to mount such
>>>> a partially set up device.
>>>>
>>>> This can easily be reproduced with the following steps:
>>>>  - dmsetup create -n test
>>>>  - mount /dev/dm-<#> /mnt
>>>>
>>>> This maybe is something which also should be fixed up in device-
>>>> mapper.
>>>
>>> I'll look closer at other options.
>>>
>>>> But given there is already a check for an unset queue
>>>> pointer and potentially there could be other drivers which do or
>>>> might do the same, it sounds like a good move to add another check
>>>> to generic_make_request_checks() and to bail out if the request
>>>> function has not been set, yet.
>>>>
>>>> BugLink: https://bugs.launchpad.net/bugs/1860231
>>>
>>> >From that bug;
>>> "The currently proposed fix introduces no chance of stability
>>> regressions. There is a chance of a very small performance regression=

>>> since an additional pointer comparison is performed on each block lay=
er
>>> request but this is unlikely to be noticeable."
>>>
>>> This captures my immediate concern: slowing down everyone for this DM=

>>> edge-case isn't desirable.
>>
>> SO I had a look and there isn't anything easier than adding the propos=
ed
>> NULL check in generic_make_request_checks().  Given the many
>> conditionals in that  function.. what's one more? ;)
>>
>> I looked at marking the queue frozen to prevent IO via
>> blk_queue_enter()'s existing cheeck -- but that quickly felt like an
>> abuse, especially in that there isn't a queue unfreeze for bio-based.
>>
>> Jens, I'll defer to you to judge this patch further.  If you're OK wit=
h
>> it: cool.  If not, I'm open to suggestions for how to proceed. =20
>>
>=20
> It does kinda suck... The generic_make_request_checks() is a mess, and
> this doesn't make it any better. Any reason why we can't solve this
> two step setup in a clean fashion instead of patching around it like
> this? Feels like a pretty bad hack, tbh.
>=20

Tyler spent some time thinking about delaying the allocation of the queue=

structure until later but that seemed rather dangerous. IIRC there are pl=
aces
during registration of the (generic) block device which expect this to be=
 done.

Not sure whether it would be feasible to start with one kind of dummy
make_request_fn and then switch that over to the proper one once that dec=
ision
can be made...


--YFDhP2D9xiAic0tOcuyovTHE0VS66F84F--

--zTLhkZGxdCktEkSjLInMVv7empLOhgroL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE2118yvOZTjOV2k0+6Gdd7svuzqMFAl4qiNcACgkQ6Gdd7svu
zqMScQ//Vf/z7PoK3uToouYs/S2bQ0nQ0P3kOSlp5L81Oo5rhIEn/6c6mkCbc/NI
dvgPAllLo7IeYSnR1Ha8NYvnJXSVl7e/AW0bH/CHJVhDO/fe5RRbGQUANc8ykK8K
ovTKsi88/0eoQGXajgKXxr+mnO21U+RHYzMl9x472l6gr+sSZ1aLWE8qvo4jvVPu
iNKXnVw37I7VLv6eMauBMBZGnlSwfmJfdyEq2v5SeljQSWRSk7h+Y3WOKEvFhRWa
ehmlz4Xb/mQhxURQyCsvn0rUn2EDF8OrdGdkY79ddD2h9A7YuUqd12YmbZF9xe36
f7ndEWW9TZsa6eIjuVMkzVHALMfPVwUynOKrBiChtMLzdXkF84rAy1jutWF2KP+M
ZrngByxOqheaHweUeExo9BNPne5hEID+aInEVDgm2zmoagHDzOsHAmc0H8PLwQx1
0vmHUGAzAZbs4BesoV2rdAhM9SSGpx8oVUys3hZj6KKBvRyXEQO64X9KZmpjpoWt
+qhcT5593Dodl/Vgawpc5AnXMq6sFJg+R5V6kcY+ac6H12p8mtS4nnREKjtq/li1
lNSju1n1cjqTBrJPyVZTYzdhHPY6NIAbkg8CVFUd9DYQ3HmPj4ftz8mTTjF72XjU
70vNsGCvEYMMjC1doXBuRj/DPjiA6i/Z6EYRcZw9iPWkyzuWO6E=
=h/Df
-----END PGP SIGNATURE-----

--zTLhkZGxdCktEkSjLInMVv7empLOhgroL--
