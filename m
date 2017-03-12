From: NeilBrown <neilb@suse.com>
Subject: Re: [dm-devel] [PATCH 0/5] Updates following recent generic_make_request improvement
Date: Mon, 13 Mar 2017 08:52:50 +1100
Message-ID: <87lgsaf9hp.fsf@notabene.neil.brown.name>
References: <148912539296.4002.219258660543808741.stgit@noble> <3c5e786a-ba42-ada8-c943-17e8b72c63d1@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <3c5e786a-ba42-ada8-c943-17e8b72c63d1@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Pavel Machek <pavel@ucw.cz>, Jack Wang <jinpu.wang@profitbricks.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 11 2017, Jens Axboe wrote:

> On 03/09/2017 11:00 PM, NeilBrown wrote:
>> This is a rebase of the series I sent earlier, based on the
>> very latest from Linus, which included my first patch.
>>=20
>> The first fixes a problem that patch introduced, and so should go to
>> Linux promptly.
>> The others are more general improvements and can go in the normal
>> course of events.
>>=20
>> It is possible that the changes to btrfs and xfs can just be dropped
>> as a subsequent patch will be needed to revert them anyway.  They are
>> there only to be able to say that "blk: make the bioset
>> rescue_workqueue optional." doesn't change any functionality at all.
>
> I have applied the first patch for this series, and added the Fixes
> tag. We'll let the rest simmer a bit, then aim for 4.12 for those.
>

Sounds good, thanks.
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljFwzIACgkQOeye3VZi
gblP4g/+OK2+Il19jFe3uEH7tSZmXRJCYWJQhOEE6SoHelttD53TBgSBlxGW/SyB
L7gP8yN8FmO5xCrY3sWvVIgx9iVS2uJIu6ndgo6eJ+8sDmtDCkSIP9iuCVO+Dyq1
sgri4XNmVR494EyFR3P5fdPwelY4yd0C5nwSkqOqLuB7TKZ3Mo3RixMJmNEmdzY5
cyhbsfxXERfcxaUmTV32fNO7Kp+LILrFG6ACv0OQjhejCIJXh9EB5DFJI8Jz9OcR
OWNR+y5RDb+p5Obpmd8vsWLMuvppm5pUSMvu8VJwV/fKqocBVsiRNA3d8Jr6faAh
AcQC0OneOVGmUFSdwwYBuI7HRw6QTYG+ykjh6TsmeP5L/R9v91uDupJzSf6oMBLj
HCFYty2XXubydpt2vceWFVezfqlf/zqqncop3POxDfthzVdAuOVrjTkOhSUoxEYY
5ySXDN/YTGXqLO35m7stHdHHkHBGLlJI0o3Mv9e76QIv8phbXtlkovqBi9kVhPjn
xv4RLYnO8ZsNRUzwdfq8jekvM4iXeBLXsQDYTNZhLXMFxwg4TLFxRRuT9VVROGnS
1NymqgUZZlfc2RS3bbVhAU6pFPDvzsyZh4C9xOZfXRZYMRAn3sJcu6En5mBPxDm0
QnXW3CKjr0tMYTW7SYhJ0IXobxaTI0I5UQiG56C/fv/c2rke23Y=
=nvb5
-----END PGP SIGNATURE-----
--=-=-=--
