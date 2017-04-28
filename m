From: NeilBrown <neilb@suse.com>
Subject: Re: [mdadm PATCH 4/4] Create: tell udev device is not ready when first created.
Date: Fri, 28 Apr 2017 13:55:21 +1000
Message-ID: <87k265rxsm.fsf@notabene.neil.brown.name>
References: <149265560315.31004.3851231165281498425.stgit@noble> <149265600601.31004.323865505557190368.stgit@noble> <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com> <87mvbasqx6.fsf@notabene.neil.brown.name> <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rajnoha <prajnoha@redhat.com>, Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 26 2017, Peter Rajnoha wrote:

> On 04/20/2017 11:35 PM, NeilBrown wrote:
>> On Thu, Apr 20 2017, Jes Sorensen wrote:
> ...
>>> Second, isn't this going to be racey if you have multiple arrays=20
>>> running? I am wondering if we cannot find a solution that relies on a=20
>>> permanently installed udev rule that we enable/disable with systemctl=20
>>> and use the device name as an argument?
>>=20
>> There would only be a problematic race of an array as being created at
>> the same time that another array is being assembled.  Is that at all
>> likely?  They tend to happen at different parts of the usage cycle...  I
>> guess we shouldn't assume though.
>>=20
>> I admit that blocking *all* arrays was a short cut.  We need to create
>> the udev rule before the new device is first activated, and keep it in
>> existence until after the array has been started and the fd on /dev/mdXX
>> has been closed - and then a bit more because udev doesn't respond
>> instantly.
>> In some cases we don't know the name of the md device until
>> create_mddev() chooses on with find_free_devnum().
>> So if we want to block udev from handling a device, we need to put the
>> block into effect (e.g. create the rules.d file) in mddev_create() just
>> before the call to open_dev_excl().
>>=20
>> If we wanted an more permanent udev rule, we would need to record the
>> devices that should be ignored in the filesystem somewhere else.
>> Maybe in /run/mdadm.
>> e.g.
>>=20
>>  KERNEL=3D=3D"md*", TEST=3D"/run/mdadm/creating-$kernel", ENV{SYSTEMD_RE=
ADY}=3D"0"
>>=20
>> Then we could have something like the following (untested) in mdadm.
>> Does that seem more suitable?
>>=20
>
> Yes, please, if possible, go for a permanent udev rule surely - this
> will make it much easier for other foreign tools to hook in properly if
> needed and it would also be much easier to debug.

I'm leaning towards the files-in-/run/mdadm approach too.  I'll make a
proper patch.

>
> But, wouldn't it be better if we could just pass this information ("not
> initialized yet") as RUN_ARRAY md ioctl parameter? In that case the md
> driver in kernel could add the variable to the uevent it generates which
> userspace udev rules could check for easily. This way, we don't need to
> hassle with creating files in filesystem and the information would be
> directly a part of the uevent the md kernel driver generates (so
> directly accessible in udev rules too). Also, possibly adding more
> variables for other future scenarios if needed.

When would we clear the "not initialised yet" flag in the kernel, and
how?  And would that be enough.

When mdadm creates an md array, at least 3 uevents get generated.
The first is generated when the md device object is created, either by
opening the /dev/mdXX file, or by writing magic to somewhere in sysfs.
The second is generated when the array is started and the content is
visible.
The third is generated when mdadm closes the file descriptor.  It opens
/dev/mdXX for O_RDWR and performs ioctls on this, and then closes it.
Because udev uses inotify to watch for a 'close for a writable file
descriptor', this generates another event.

We need to ensure that none of these cause udev to run anything that
inspects the contents of the array.
Of the three, only the second one is directly under the control of the
md module, so only that one can add an environment variable.

It might be possible to avoid the last one (by not opening for write),
but I cannot see a way to avoid the first one.

I don't think that making a file appear in /run is really very different
from making a variable appear in a uevent.   If the variable were
describing the event itself there would be a different, but it would be
describing the state of the device.  So the only important difference is
"which is easier to work with".  I think creating an deleting a file is
easier to setting and clearing a variable.

Thanks,
NeilBrown


>
> We use something similar in device-mapper already where we pass flags
> (besides other things) as a device-mapper ioctl parameter which then
> gets into the uevent as DM_COOKIE uevent variable (which in turn the
> udev rules can decode into individual flags). This method proved to be
> working well for us to solve the problem of uninitialized data area so
> we don't get into trouble with scans from udev (see also dm_ioctl
> structure in usr/include/linux/dm-ioctl.h and the dm_kobject_uevent
> function in drivers/md/dm.c for the kernel part; in udev rules the flags
> are then various DM_UDEV_* variables we check for)
>
> --=20
> Peter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkCvSkACgkQOeye3VZi
gblDUBAAuKotkqP7UClCiyREzb65rtG8XJ4ItmQhYJS2vq3N/Gpfisxqfw9EhyG1
WtW6S1NVShMBpsDLOk0X6pbzvPi5XB9SXQCQnZSdMx0Vi9gncAkhOubOvTtXxzvs
zebjGZfNU2YMPi0dYUSaYn/yZ7yt28kqulx596EWQDDlHF03dKTSzVzmYmFHU90H
Obl2zuokMvF/VWIGkNQLJW7E3Jkxzx4JKVD7mixGgEMJBxPhvTNLJDHSF/AnSxtc
OSaKfk8JUihvlruJktdg3lmk4uu8YuAp1rMJCgX9Uc2j1MGCLGU+g0XJtIvP3IMj
jFK1UjTx8lPm+co7W5DLmR19zf3lepDWnh+Q2VOvvtZpoqLZrhqJ1T7r/0TV7D2p
MDLJTIRBOEYu730HnhxPi5TZIuCNRhJeUDSr0sHaet3wPSdTy2F1ro2bL7BoHoCx
7ZBzWLUTen/0v5lzPooCEYvGfmUo1rFhMXam7RwLg2p2JZm6PlJc4urE/8x/UoPa
xMyq9Zs/PO42WYoWKsN9WyX7A7tzsbQ9INDu7apQGgyuNg1AVc7ui9I3ptvYRoqd
ONC8sqmzJdv71W5KSYsWtA3vbyqrD+IlpSKCru6bGYMF7JIrV5umeAJnoaKFUog3
g+O5klceCv7RXVQ/Qrf2Vy4R0adb0FLG0rachRaMgsSeSPA3dVA=
=k1yS
-----END PGP SIGNATURE-----
--=-=-=--
