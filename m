From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0 of 2] dm-raid: Bug fixes
Date: Tue, 17 Apr 2012 14:26:58 +1000
Message-ID: <20120417142658.265a0a40@notabene.brown>
References: <1334619917.16017.25.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3WgWzV4.c_NORja2jaOAjj."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334619917.16017.25.camel@f14.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

--Sig_/3WgWzV4.c_NORja2jaOAjj.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Apr 2012 18:45:17 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> Neil,
>=20
> I have 3 bugs that I've been working on.  Two I have fixed and one I
> have not, but have a question.
>=20
> The first patch (dm-raid-set-recovery-flags-on-resume) addresses the
> fact that some recovery flags are altered during suspend, but not
> corrected upon resume.  I'm wondering if you think these flags would be
> better pushed into 'mddev_resume' rather that being altered in
> dm-raid.c?

I think setting MD_RECOVERY_NEEDED in mddev_resume makes perfect sense.
It is quite safe to set it at any time, and the one place where md.c calls
mddev_resume() it sets the flag immediately afterwards.  So moving that
setting into mddev_resume() makes sense.

MD_RECOVERY_FROZEN I'm less sure about.  If we clear it in mddev_resume(),
then as soon as you convert a RAID5 to a RAID6 it would start recovery of t=
he
extra device, even if you had set sync_action to 'frozen' first.  That would
be wrong.

I guess we are over-loading 'MD_RECOVERY_FROZEN' it bit.  It means both
"user-space requested a freeze" and  "resync temporarily disabled".

I wonder if md_stop_writes() only needs to set it temporarily, and to make
sure MD_RECOVERY_NEEDED isn't set when it completes.  That might be enough??

However maybe it is easiest to just clear it in raid_resume() like you did.


>=20
> The second patch (dm-raid-record-and-handle-missing-devices) adds code
> to address the case where the user specifies particular array positions
> as missing.  I don't have any significant questions about this patch.

I do :-)

md already does all the proper accounting for ->degraded, dm-raid shouldn't
need to.

Incrementing md.degraded in dev_parms shouldn't be needed as md_run is
subsequently called, and it sets md.degraded correctly.

incrementing it in read_disk_sb() and setting the Faulty flag is wrong.  I
think it should just call md_error().

The other changes in that patch look OK.


>=20
> The 3rd issue I am seeing concerns how 'suspend' happens.  Suspend
> should flush all outstanding I/O and quiesce.  When I look at the code,
> I feel it should be doing this.  ('md_stop_writes' is called and
> followed-up by a call to 'mddev_suspend', which quiesces the
> personality.)  However, if I create a RAID1 device, suspend it, and then
> detach one of the legs, it does not show the changes written immediately
> before the suspend.  If I issue a 'sync', then the changes do show-up.
> I confused as to why the suspend process doesn't seem to be pushing out
> the writes that have been issued.  Any ideas?

That sounds like it is behaving exactly as I would expect.
You have written to the filesystem (and so to the pagecache) but the
filesystem hasn't written to the device yet.  That happens after a time, or
on a 'sync' or 'fsync'.

You might be able to get the block device to ask the filesystem to flush
things out using freeze_bdev(), but I'm not sure of the details there.
It might not flush things, it might just ensure metadata is consistent - or
something.


NeilBrown

--Sig_/3WgWzV4.c_NORja2jaOAjj.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4zxEjnsnt1WYoG5AQIVuQ/+LbZ0heJY2KRit5qom6pN48CxzbUiDjDs
Bn8AvmKuQrQbNxW+/a94FZh/EjdI6zXU6cHd9HKli0R+s4uBkvkel4uh/EDUWdIc
cw/pVwW4gUDL+SX/oQ8oo1Uqw5A4XPk3yHTPv53C6fBnSjHjPelO7KMWrVguFLvR
W217L7ui4qzVONfolTe9TExR+6JdzaMGqnIVB6IZONLKKojXF90N0FHe9uKce2jC
x/+8A7zTD8q7h2smwxNBRYQNMQk9NvaovvQB8ARWrEpKJiSmqa5Jj67L4nDowedr
uhjTOy7w71w9VLfWPOlM12ke/OlLwVG2mlSsM/BYvRW+2BbeOvjYrPKMK7d5UW07
eQIjBvW1lzrHr9tfpNJSXz3wtLYj3U7HJjYBG+ppf4Qh10jNIoaKmnESTlkNg3fR
igiZOFtKM1KgIDu/9bMZA9IcdIA4BmCWRaF8UP/yC0h7Qv29cmDx+2opsuH/ox0+
JxeiIKvLrMAJxK70gadTa2Ryjte0Tapm0rvy4nYIYWjFu8+W+vPzPjEUXoWmC4/k
SIPFTD+DTYTqn59N68J9TAgOh0iBWzePOkGijyxrGlR/ubAejBz0CXYPbXFXAr62
Alfvw9epyOacFDyDgt9GuWCMcKV5koANB3BSAL7uxljyc/iIZbnUvjIQuQkMNtvI
TFZ6E8wlufI=
=L30+
-----END PGP SIGNATURE-----

--Sig_/3WgWzV4.c_NORja2jaOAjj.--
