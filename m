From: Neil Brown <nfbrown@novell.com>
Subject: Re: Possible bug in DM-RAID.
Date: Wed, 21 Oct 2015 12:39:32 +1100
Message-ID: <87y4ex0zl7.fsf@notabene.neil.brown.name>
References: <562659DD.1000505@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562659DD.1000505@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, Linux-Kernel mailing list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain


Added dm-devel, which is probably the more appropriate list for dm
things.

NeilBrown

Austin S Hemmelgarn <ahferroin7@gmail.com> writes:

> I think I've stumbled upon a bug in DM-RAID.  The primary symptom is that when
> creating a new DM-RAID based device (using either LVM or dmsetup) in a RAID1
> configuration, it very quickly claims one by one that all of the disks failed
> except the first, and goes degraded.  When this happens on a given system, the
> disks always 'fail' in the reverse of the order of the mirror numbers.  All of
> the other RAID profiles work just fine.  Curiously, it also only seems to
> happen for 'big' devices (I haven't been able to determine exactly what the
> minimum size is, but I see it 100% of the time with 32G devices, never with 16G
> ones, and only intermittently with 24G).
>
> Here's what I got from dmesg when creating a 32G LVM volume that exhibited
> this issue:
> [66318.401295] device-mapper: raid: Superblocks created for new array
> [66318.450452] md/raid1:mdX: active with 2 out of 2 mirrors
> [66318.450467] Choosing daemon_sleep default (5 sec)
> [66318.450482] created bitmap (32 pages) for device mdX
> [66318.450495] attempt to access beyond end of device
> [66318.450501] dm-91: rw=13329, want=0, limit=8192
> [66318.450506] md: super_written gets error=-5, uptodate=0
> [66318.450513] md/raid1:mdX: Disk failure on dm-92, disabling device.
>                md/raid1:mdX: Operation continuing on 1 devices.
> [66318.459815] attempt to access beyond end of device
> [66318.459819] dm-89: rw=13329, want=0, limit=8192
> [66318.459822] md: super_written gets error=-5, uptodate=0
> [66318.492852] attempt to access beyond end of device
> [66318.492862] dm-89: rw=13329, want=0, limit=8192
> [66318.492868] md: super_written gets error=-5, uptodate=0
> [66318.627183] mdX: bitmap file is out of date, doing full recovery
> [66318.714107] mdX: bitmap initialized from disk: read 3 pages, set 65536 of 65536 bits
> [66318.782045] RAID1 conf printout:
> [66318.782054]  --- wd:1 rd:2
> [66318.782061]  disk 0, wo:0, o:1, dev:dm-90
> [66318.782068]  disk 1, wo:1, o:0, dev:dm-92
> [66318.836598] RAID1 conf printout:
> [66318.836607]  --- wd:1 rd:2
> [66318.836614]  disk 0, wo:0, o:1, dev:dm-90
>
> And here's output for a 24G LVM volume that didn't display the issue.
> [66343.407954] device-mapper: raid: Superblocks created for new array
> [66343.479065] md/raid1:mdX: active with 2 out of 2 mirrors
> [66343.479078] Choosing daemon_sleep default (5 sec)
> [66343.479101] created bitmap (24 pages) for device mdX
> [66343.629329] mdX: bitmap file is out of date, doing full recovery
> [66343.677374] mdX: bitmap initialized from disk: read 2 pages, set 49152 of 49152 bits
>
> I'm using a lightly patched version of 4.2.3
> (the source can be found at https://github.com/ferroin/linux)
> but none of the patches I'm using come anywhere near anything in the block layer,
> let alone the DM/MD code.
>
> I've attempted to bisect this, although it got kind of complicated.  So far I've
> determined that the first commit that I see this issue on is d3b178a: md: Skip cluster setup for dm-raid
> Prior to that commit, I can't initialize any dm-raid devices due to the bug it fixes.
> I have not tested anything prior to d51e4fe (the merge commit that pulled in the md-cluster code),
> but I do distinctly remember that I did not see this issue in 3.19.
>
> I'll be happy to provide more info if needed.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWJuzUAAoJEDnsnt1WYoG5uhYQAIYqGQjxEhvpieEfN++B2mpn
lDc5dnrH8RKkp7HcBCEJK29XIekNEHtLeosN38FtAH+AZYU51ou1OTg4gZ5Ne1aK
XQBSsiOrhSocQNvWm3XVO5n72BiFuvv+K76gQG/xQm5wnY5IDKdRdIbIN/deu6GB
gZSp9KdYDvd9g6SnwGKeEvo0/ZFVXT9TwSJEs5axTwQQp8P19CzKucwpJO8XkyFr
RsSoOhmDrqF5v6M3TUQJRmI3TI4hBFyMpRLKurnOx6OBE8uH5E5QDvnmigwTGbUR
XYQqjpStIX5iGRDH0qnBeV7/m5Y2z7n3fPgMVDn78RwEnxjzhoa7cRl6iNtzviIh
WnePylk8joB5Qf7O6rSGarRnYocV3mWqEh959raTRn1FfFkTa4xmp6MkqYDJIkjU
4jPJHboZQ5QRJF7aIVaUdDAoIC7bREx81AXvp/7ExR/sO2SJmUvAIMBC1HHLV8wz
jb3rcOHXO+zb+NVO6kRNf8GozK7okQkrlCZe8Mn2Y1LAq6TYD7ycDVLWzVbab1KD
kPuimaUNzpFLj4d5qWHKWq27/U28qyVeJE4FFr5D8YuXFzcWTDZzy0Td35qFT0IP
TzKievJ3k5mak4aP6tcOXUtXs/z9dbBF986B7+y9mllzfOeuI42IyeN7aTTjiozf
nr94gAtL7LlwJouC3Ty+
=A6M1
-----END PGP SIGNATURE-----
--=-=-=--
