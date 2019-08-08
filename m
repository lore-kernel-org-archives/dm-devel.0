From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH 0/2] dm log writes: Add support for filter bios based on
 its type
Date: Thu, 8 Aug 2019 20:54:40 +0800
Message-ID: <256f2ccc-af5b-e30a-76c1-a911f242d252@gmx.com>
References: <20190619080312.11549-1-wqu@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UJjeYQViLV1ROwxoJtPmPkc7BCH810Ccd"
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20190619080312.11549-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Qu Wenruo <wqu@suse.com>, dm-devel@redhat.com
Cc: linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UJjeYQViLV1ROwxoJtPmPkc7BCH810Ccd
Content-Type: multipart/mixed; boundary="kUwSWdupgWDROeoUG3SFSfjvAqpoqorlf";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, dm-devel@redhat.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <256f2ccc-af5b-e30a-76c1-a911f242d252@gmx.com>
Subject: Re: [PATCH 0/2] dm log writes: Add support for filter bios based on
 its type
References: <20190619080312.11549-1-wqu@suse.com>
In-Reply-To: <20190619080312.11549-1-wqu@suse.com>

--kUwSWdupgWDROeoUG3SFSfjvAqpoqorlf
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Gentle ping?

This feature would be pretty useful if we want to really log heavy
operations on a relatively small log devices.

Thanks,
Qu

On 2019/6/19 =E4=B8=8B=E5=8D=884:03, Qu Wenruo wrote:
> Current dm-log-writes will record all bios, no matter if the bios is
> METADATA (normally what we care) or is DATA (normally we cares less for=

> the log-replay context).
>=20
> This causes a lot of extra space required for log device. E.g write 10M=
,
> sync, overwrite that 10M file, this would cause over 20M for log device=

> just for the data.
>=20
> This patchset introduces two way to specify the dump type:
> - dump_type=3D%s optional option for constructor
>   The default dump_type is ALL, thus no behavior change.
>=20
> - dump_type=3D%s message type to change type on the fly
>=20
> Also to cooperate the new dump_type=3D option, always output the dump_t=
ype
> for STATUSTYPE_TABLE.
>=20
> A common use case would be:
>  # dmsetup create log --table 0 $(blockdev --getsz $dev) log-writes $de=
v $log_dev
>  # mkfs.btrfs -f /dev/mapper/log
>  # dmsetup suspend log
>  # dmsetup message log 0 dump_type=3DMETADATA|FUA|FLUSH|DISCARD|MARK
>  # dmsetup resume log
>  # mount /dev/mapper/log <mnt>
>  # <do some work load>
>  # umount <mnt>
>  # dmsetup remove log
>  # <replay>
>=20
> Now the log device will not record data writes, thus hugely reduce the
> space requirement for log device, allowing more operations to be down
> before hitting the space limit.
>=20
> Currently btrfs check doesn't check data checksum by default, thus even=

> we have wrong data on-disk, we should be fine checking the metadata.
>=20
> I'm not 100% sure if this applies to other filesystems, but as long as
> metadata writes is marked correctly, other filesystems can also benifit=

> from this feature.
>=20
> Qu Wenruo (2):
>   dm log writes: Allow dm-log-writes to filter bios based on types to
>     reduce log device space usage
>   dm log writes: Introduce dump_type=3D message type to change dump_typ=
e
>     on the fly
>=20
>  drivers/md/dm-log-writes.c | 177 ++++++++++++++++++++++++++++++++++---=

>  1 file changed, 167 insertions(+), 10 deletions(-)
>=20


--kUwSWdupgWDROeoUG3SFSfjvAqpoqorlf--

--UJjeYQViLV1ROwxoJtPmPkc7BCH810Ccd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAl1MG5AACgkQwj2R86El
/qghagf/Q2vvP4Ah6dNhKhOZpgm67p9TSpaMF05UXsYrZ07uebR2QWP7pMoC3eEr
xLEO9d4ikzfqMRf4c6VOLorjPAVzwML6Wi0PwT5EbhPacBNRLBRxlwOzR99dt2RD
CvLE2I5pngFyUpikMsYrIpWaGGJ2P4o/DK0iCyUb5ZBE4gTupIQOm6wdRyzXbjx/
OCm+BHVUNdv2dNDGTOu/08nqyC0ZcKpCkgQWCHfJ0uE16w8SSg8xwl8+vRS9CnK3
IRqlmsX2JaciMzvphgI1ra6lryRI1s8tarYHy0b7ejLM9BI2zqaZSDsr+Xdsd64A
YEzpRrrMpX5Nfu7mRJd/QQalC6g0tA==
=0OJn
-----END PGP SIGNATURE-----

--UJjeYQViLV1ROwxoJtPmPkc7BCH810Ccd--
