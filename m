From: NeilBrown <neilb@suse.com>
Subject: Re: pvmove/mirror target mirroring data between two
	devices with different sector size
Date: Thu, 31 Mar 2016 13:09:34 +1100
Message-ID: <8737r7tn35.fsf@notabene.neil.brown.name>
References: <56F94727020000A000058AA7@prv3-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4174366731112937890=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56F94727020000A000058AA7@prv3-mh.provo.novell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Liuhua Wang <lwang@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--===============4174366731112937890==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

On Mon, Mar 28 2016, Liuhua Wang wrote:

> Hi List,
>
> I have a question that I think maybe you can give me some idea.
>
> I have two devices with different sector size: 512B and 4096B.
>
> - SOURCE DEVICE (mdos lvm partiton)
> #parted /dev/sdb
> Model: ATA SATADOM-SL 3ME (scsi)
> Disk /dev/sdb: 32.0GB
> Sector size (logical/physical): 512B/512B
> Partition Table: msdos
> (In `parted` Sector size are both got from IOCTL(BLKSSZGET))
>
> - TARGET DEVICE (WHOLE DISK)
> #parted /dev/sdc
> Error: /dev/sdd: unrecognised disk label
> Model: ATA HUH728080ALN600 (scsi)
> Disk /dev/sdd: 8002GB
> Sector size (logical/physical): 4096B/4096B
> Partition Table: unknown
>
> I want to move data from one device to the other using lvm command
> `pvmove`, but after pvmove, file system cannot mount.

This seems to raise questions that you could easily answer:
1/ what filesystem.  What error when mounting?
2/ Is the data exactly the same after the move. e.g does
  sh1sum of the old and new device report the same content?
  If not, what about sha1sum of the first 10Gig? The first Gig?
  100K? 16K? 1K? ...
  i.e. if there is a difference, where is the first difference?

NeilBrown


>
> So my question is whether pvmove support moving date between devices with different sector size
> or same question: mirror target support mirroring data between two devices with different sector size?
>
> Thank you in advance.
>
> Best regards,
> Liuhua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW/IbeAAoJEDnsnt1WYoG5m/gP/1wUJWaTe1C2KVwl/y7v+Kny
5Ieynk15IaEsi/GWFeV54IM2XvIcPQ8LiFWVX6iFVpY6occEMFGUWrEx6hpDiquf
uNG3IDC04u8eoPXYrphmzHlg60wS5dHE9zVY4Etg2TAdCaLPp0zeuJaUmNy/HpTP
wVIYHBrvQYCq7HYAxEoNlKVeLtgDk9EGiLDYAcBI/f2HVb98pYLCkWvBUGyzkiBO
SThjwedfAyAlsoPtyFx39mSBTOl/EhaBV3/nh5IjnqBW8Rray1zrG7HB/1rD6Gqv
N/rPQtse8EOtHA2S+XTk9xV66+Oi0hU1d6RAYXRuFtkt20cCZvxSUSpuYxmf/qYW
f3gHQdz8PqDtpvNXQS/Qqbmx1vW0/fy+My9zLFrnn39r1ioWbMe4HI9Ge/i8QNP1
ieY8EyNxWri9DOr66x27UNktfb36LZ4RSm6aJFdNBgimluNq4/1qlo5CPuEsMx+h
CtOYeMk1QoTo3fX9AA6h7V0T8wtyNy2UEkpSoISmzybfHnltnGYIC1/m0KalqIm7
J0MTYtvuT4XM2S1zu2ickK59CUmUeep15lnqLnJifUg9lgrREkmSmBTr69jZo1EO
t9SkGi0XQF/NBT9I3J1x49rzHEVPQyrEZJwjQ2U3p+rcNEOsH/kP2GJ6lC2IW2mz
PVV3kqfUvHZU5QclTouu
=2kmB
-----END PGP SIGNATURE-----
--=-=-=--


--===============4174366731112937890==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4174366731112937890==--
