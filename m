From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC] [PATCH 0/1] Introduce emergency raid0 stop for
	mounted arrays
Date: Fri, 03 Aug 2018 07:37:57 +1000
Message-ID: <87h8kcphze.fsf@notabene.neil.brown.name>
References: <20180801145608.19880-1-gpiccoli@canonical.com>
	<87tvodpmc8.fsf@notabene.neil.brown.name>
	<7cfa220e-c04d-b69e-fe39-5b9277f0538d@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8080174146340539826=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7cfa220e-c04d-b69e-fe39-5b9277f0538d@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>, linux-raid@vger.kernel.org, shli@kernel.org
Cc: linux-block@vger.kernel.org, jay.vosburgh@canonical.com, dm-devel@redhat.com, kernel@gpiccoli.net, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

--===============8080174146340539826==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 02 2018, Guilherme G. Piccoli wrote:

> On 01/08/2018 22:51, NeilBrown wrote:
>>> [...]=20
>> If you have hard drive and some sectors or track stop working, I think
>> you would still expect IO to the other sectors or tracks to keep
>> working.
>>=20
>> For this reason, the behaviour of md/raid0 is to continue to serve IO to
>> working devices, and only fail IO to failed/missing devices.
>>=20
>
> Hi Neil, thanks for your quick response. I agree with you about the
> potential sector failure, it shouldn't automatically fail the entire
> array for a single failed write.
>
> The check I'm using in the patch is against device request queue - if a
> raid0 member queue is dying/dead, then we consider the device as dead,
> and as a consequence, the array is marked dead.
>
> In my understanding of raid0/stripping, data is split among N devices,
> called raid members. If one member is failed, for sure the data written
> to the array will be corrupted, since that "portion" of data going to
> the failed device won't be stored.
>
> Regarding the current behavior, one test I made was to remove 1 device
> of a 2-disk raid0 array and after that, write a file. Write completed
> normally (no errors from the userspace perspective), and I hashed the
> file using md5. I then rebooted the machine, raid0 was back with the 2
> devices, and guess what?
> The written file was there, but corrupted (with a different hash). I
> don't think this is something fine, user could have written important
> data and don't realize it was getting corrupted while writing.


In your test, did you "fsync" the file after writing to it?  That is
essential for data security.
If fsync succeeded even though the data wasn't written, that is
certainly a bug.  If it doesn't succeed, then you know there is a
problem with your data.

>
>
>> It seems reasonable that you might want a different behaviour, but I
>> think that should be optional.  i.e. you would need to explicitly set a
>> "one-out-all-out" flag on the array.  I'm not sure if this should cause
>> reads to fail, but it seems quite reasonable that it would cause all
>> writes to fail.
>>=20
>> I would only change the kernel to recognise the flag and refuse any
>> writes after any error has been seen.
>> I would use udev/mdadm to detect a device removal and to mark the
>> relevant component device as missing.
>>
>
> Using the udev/mdadm to notice a member has failed and the array must be
> stopped might work, it was my first approach. The main issue here is
> timing: it takes "some time" until userspace is aware of the failure, so
> we have a window in which writes were sent between
>
> (A) the array member failed/got removed and
> (B) mdadm notices and instruct driver to refuse new writes;

I don't think the delay is relevant.
If writes are happening, then the kernel will get write error from the
failed devices and can flag the array as faulty.
If writes aren't happening, then it no important cost in the "device is
removed" message going up to user-space and back.

NeilBrown

>
> between (A) and (B), those writes are seen as completed, since they are
> indeed complete (at least, they are fine from the page cache point of
> view). Then, writeback will try to write those, which will cause
> problems or they will complete in a corrupted form (the file will
> be present in the array's filesystem after array is restored, but
> corrupted).
>
> So, the in-kernel mechanism avoided most part of window (A)-(B),
> although it seems we still have some problems when nesting arrays,
> due to this same window, even with the in-kernel mechanism (given the
> fact it takes some time to remove the top array when a pretty "far"
> bottom-member is failed).
>
> More suggestions on how to deal with this in a definitive manner are
> highly appreciated.
> Thanks,
>
>
> Guilherme

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAltjebYACgkQOeye3VZi
gbkz5w/9HVou2dww+Ny0lqYWJn8Ses4OqX1+Wn+U2pu3ln1K/kMhrkTJqVn243fi
0virsEggL7xeGSY5K2vJlOv5GN+9qNCh2fYzZXngxBPSQko8/CBgnWmQ6QbSfwCy
N1YLFM68qvjfE2+ttcOKjurf68hB7XawgFTK9TV3cQTBRaC2U3cHYMG/msGdsTDE
So1kQsQc3F3e5B0wNtGlZ9Xab9QIW/blhJ/qipLmresC9D3yPIWitbLNa582lmqx
0Om/dk+Oe+xetEhTRxdR9pU409CfzhXq9Wu7YxIcdoh58Mz5lb0wQGLCgNeV7kC+
IpXvv90sfGmF1oB6TfmPNxpCqbhVusRtrCLvUEDdULV0Q1UGhY+NARjRnAvEz3Ov
gcP6UZ2b3YcxFCkKqDXjiwjUhMgPfygOKTyQeMtIsaW5KDCB6Emt6wBBHRImfOw7
TNNlc5Mo9m9VYzj3SxdWqqCtlDlxidBizhc06PnJwn7aW2M9IJYZmu3y/MnUKsgh
ZaE/HlACquRa4J5daMB2c/tEuDMys9qGq7uJnm0gejolIq3jrR6bxp2Fn6nYL05o
TYJ3zxbBnSfChruFP2kSNC0h46xVWMsgK/s4ob7MEyKruFIvHbFpKfZt4ILnxqwg
p2nuetYVBt99Zn6Pzd6LFIarcKeWMS130mqrScbBnL19TOJ5Wow=
=+zB/
-----END PGP SIGNATURE-----
--=-=-=--


--===============8080174146340539826==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8080174146340539826==--
