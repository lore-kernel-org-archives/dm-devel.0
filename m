From: NeilBrown <neilb@suse.com>
Subject: Re: DM Regression in 4.16-rc1 - read() returns data when it shouldn't
Date: Mon, 26 Feb 2018 22:01:12 +1100
Message-ID: <87606khv5z.fsf@notabene.neil.brown.name>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com> <5fca4e3f-536c-9c52-31bb-927e8ab5b6c8@leemhuis.info> <20180219171531.GA27498@redhat.com> <3fa615bf-8239-f189-8557-cb2d072181c0@leemhuis.info>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3fa615bf-8239-f189-8557-cb2d072181c0@leemhuis.info>
Sender: linux-kernel-owner@vger.kernel.org
To: Thorsten Leemhuis <regressions@leemhuis.info>, Mike Snitzer <snitzer@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>, device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26 2018, Thorsten Leemhuis wrote:

> Hi Mike! On 19.02.2018 18:15, Mike Snitzer wrote:
>> On Mon, Feb 19 2018 at  8:44am -0500,
>> Thorsten Leemhuis <regressions@leemhuis.info> wrote:
>>=20
>>> JFYI: This issues is tracked in the regression reports for Linux 4.16
>>> (http://bit.ly/lnxregrep416 ) with this id:
>>> Linux-Regression-ID: lr#9e195f
>>> Please include this line in the comment section of patches that are
>> [=E2=80=A6]
>> The fix was already merged by Linus on Friday, see:
>> git.kernel.org/linus/8dd601fa8317243be887458c49f6c29c2f3d719f
>
> Ohh, thx for the pointer. Could you please next time add a tag like
>
> Fixes: 18a25da84354 ("dm: ensure bio submission follows a depth-first
> tree walk")

The thing is... it didn't fix that commit.  That commit was fine.
If fixed something else much further back, which that commit just made
more problematic.
That is why I added the Cc: stable with the earliest version that needed
fixing.

Unfortunately, reality isn't always neat and tidy :-(  when it is, I do
use Fixes:

Thanks,
NeilBrown

>
> to the commit? For details see
> Documnetation/process/submitting-patches.rst section 2 and 13:
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
>
> That would have saved both of us this conversation. In addition I head
> that at least one big Linux distributor is using those tags when
> backporting changes to make sure all relevant fixes for a particular
> backported commit get backported as well.
>
>> But moving forward I have no interest in sprinkling external metadata
>> references in Linux commit headers.=20
>>=20
>> Seems more like you're engineering something that gives you, and
>> possibly a select few others, meaning but that is make work for all
>> Linux maintainers.
>
> I just asked you to help me make regression tracking work a little bit
> easier. I'm neither planing to enforce this nor in a position to do so,
> thus feel free to not do what I asked for; that's totally fine for me.
> Especially as those tags are only a interim solution afaics (one that I
> don't like to much myself; but they sometimes help connecting the
> various dots in the phase where the commit that introduced a regression
> is not yet known).
>
> Ciao, Thorsten

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlqT6PkACgkQOeye3VZi
gbmCJg//TlJGQa6jewde73WQfEEvtng2Cu5rFZ+HStbL5FICabCAMZ+YUo0Yg6/y
JkyVPqPiKtsFQsGCXdi69G49cf/1en+maOSRQzas7H75jcdDTZwFCs4bL1OCA1j2
qfvMh7vzMYfCcQyzZa4VwFzMheCBc4ERXy3jlwjbuouI8aQt+7JE1UVZtgJyJpHD
GpqpAz562jVpElW4X776YHl45ojlDhlmY4GP0hzmqZkrLSOBVp7i2ao8/FJpjIfz
4VZuaP6mFy8dpFLAWlTf5p5GJ/EBrnqGg9LzRMKkjkhf2ZYDArcYw8aA6w4o2N07
2XoGbgje5OUY1gNkwgxv9+Sh77aUn/Al0fTRksNqPiIHAfusHacPcJEvjlw693WW
zkltqF6F2227rwLk0YZqRzJgveEzoPJN6F1ohJifVPVia2hTVZT4bpI52uZlMmk3
AOpxqlEDC38vwMGgZtRvzviiBDx5GXDr4gTKyCu/6aQmK4eUpYITmsbf/Zs6FIiH
QSNOrri7RwslKFk31r6w4AVOvJmux9/JG88B2zgpqVgXDnUDtE/nFRYQnd3QL0SH
2B5Df3gl3gg121zkSgtch6497Gcg41d3/PRmVLTnlrUHq4GK0srTSezNsaEH8OER
su3N087XSCehe9m/nQwAWZQeI45vUrKkP3SKuIJ0sqVIrDmgbq4=
=05PH
-----END PGP SIGNATURE-----
--=-=-=--
