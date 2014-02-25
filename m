From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] dm-raid: check events in super_validate
Date: Tue, 25 Feb 2014 16:30:20 +1100
Message-ID: <20140225163020.6f299f15@notabene.brown>
References: <52ED0628.4030203@stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BabbffUVNIgFbz+kDHTScLm"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52ED0628.4030203@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>
Cc: linux-raid@vger.kernel.org, Jonathan Brassow <jbrassow@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--Sig_/BabbffUVNIgFbz+kDHTScLm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 1 Feb 2014 09:35:20 -0500 Nate Dailey <nate.dailey@stratus.com> wro=
te:

> If an LVM raid1 recovery is interrupted by deactivating the LV, when the=
=20
> LV is reactivated it comes up with both members in sync--the recovery=20
> never completes.
>=20
> I've been trying to figure out how to fix this. Does this approach look=20
> okay? I'm not sure what else to use to determine that a member disk is=20
> out of sync. It looks like if disk_recovery_offset in the superblock=20
> were updated during the recovery, that would also cause it to resume=20
> after interruption--but MD skips the recovery target disk when writing=20
> superblocks, so this doesn't work.
>=20
> Comments?

I know it is confusing, but this should really have gone to dm-devel rather
than linux-raid, to make sure Jon Brassow see it (hi Jon!).

Setting recovery_offset to 0 certainly looks wrong, it should be set to
  sb->disk_recovery_offset
like the code just above your change.
Why does the code there not meet your need.

Jon: can you help?

NeilBrown

>=20
> Thanks,
>=20
> Nate Dailey
> Stratus Technologies
>=20
>=20
>=20
> diff -Nupr linux-3.12.9.orig/drivers/md/dm-raid.c=20
> linux-3.12.9/drivers/md/dm-raid.c
> --- linux-3.12.9.orig/drivers/md/dm-raid.c    2014-02-01=20
> 08:46:51.088086299 -0500
> +++ linux-3.12.9/drivers/md/dm-raid.c    2014-02-01 09:02:06.657149550 -0=
500
> @@ -1042,6 +1042,21 @@ static int super_validate(struct mddev *
>           rdev->recovery_offset =3D le64_to_cpu(sb->disk_recovery_offset);
>           if (rdev->recovery_offset !=3D MaxSector)
>               clear_bit(In_sync, &rdev->flags);
> +        else if (!test_bit(Faulty, &rdev->flags)) {
> +            uint64_t events_sb;
> +
> +            /*
> +             * Trigger recovery if events is out-of-date.
> +             */
> +            events_sb =3D le64_to_cpu(sb->events);
> +            if (events_sb < mddev->events) {
> +                DMINFO("Force recovery on out-of-date device #%d.",
> +                       rdev->raid_disk);
> +                clear_bit(In_sync, &rdev->flags);
> +                rdev->saved_raid_disk =3D rdev->raid_disk;
> +                rdev->recovery_offset =3D 0;
> +            }
> +        }
>       }
>=20
>       /*
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/BabbffUVNIgFbz+kDHTScLm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUwwqbDnsnt1WYoG5AQKVLg/+Nqm+D+G+ysgO41/wvNvD4ZBRmnuZRzgI
UIgp85cEVUO8qusp0WK0CifVbFwg1CW6siEE8szQ5gfxoEP6sn0u67gDleUUPqxW
4JQo14pBdxJrYLQeAmFFbGVDr0BmenMeNkjl4AoZJ9Of3Ex2kDcstE2E9fyR1Snb
f/ofpUNATNMheH1ZuRKmwR/3C7jnZqSbjQDnJBV+/zPbwGLIu1Xxl9wkgO7vqMwc
llxBF9gvVxFbAZoh5DuWupzRixmF65xW6f2GbVDIgEXryMNDuwypjXAcF3DhhqD4
i4TC/Gih4Er92WnSkyPE1gODb5kqng5yXWANZryBKBtzmAMSu4PGTtHhrL/lsBeU
GUBeA84+VvcZoq3disT6KTqvkbMDs7BkE5ry/m3ZjN28pIHtTQbxAIHiq3R/OVJZ
9j+dZ6IagByGWgmENn38SlwwGLmiFedqjzmPu837FBlT5nyW/+C3atUGMTZvzz1K
RsuqdT9WQ9Nc1YWGk3mGm1eebU/uf1Aq91PTHY4PRMFvETAP3wEV1noB0eH0V57n
BTGq10Uk6BHS1g1I06CK9wpO+gE8un5w8ZMZv52hNXcCE0FbVPoCkmF0fi6mvMp1
yr8ouvahcYkhd6j/IXRDN9K3+VJRWFRGjxSmL1mN4Ejmztv1XqQjutP58W8P7q0A
OWwwvaVezec=
=dlNU
-----END PGP SIGNATURE-----

--Sig_/BabbffUVNIgFbz+kDHTScLm--
