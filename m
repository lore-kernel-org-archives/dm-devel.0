From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: docs: device-mapper: Add dm-clone to documentation index
Date: Tue, 26 Nov 2019 15:16:13 -0500
Message-ID: <20191126201613.GA3750@redhat.com>
References: <20191126185627.970-1-geert+renesas@glider.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191126185627.970-1-geert+renesas@glider.be>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Nikos Tsironis <ntsironis@arrikto.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>, Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Nov 26 2019 at  1:56pm -0500,
Geert Uytterhoeven <geert+renesas@glider.be> wrote:

> When the dm-clone documentation was added, it was not added to the
> documentation index, leading to a warning when building the
> documentation:
>=20
>     Documentation/admin-guide/device-mapper/dm-clone.rst: WARNING: docume=
nt isn't included in any toctree
>=20
> Fixes: 7431b7835f554f86 ("dm: add clone target")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/admin-guide/device-mapper/index.rst | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Document=
ation/admin-guide/device-mapper/index.rst
> index 4872fb6d29524593..ec62fcc8eeceed83 100644
> --- a/Documentation/admin-guide/device-mapper/index.rst
> +++ b/Documentation/admin-guide/device-mapper/index.rst
> @@ -8,6 +8,7 @@ Device Mapper
>      cache-policies
>      cache
>      delay
> +    dm-clone
>      dm-crypt
>      dm-dust
>      dm-flakey
>=20

I already staged this for 5.5 here:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/=
commit/?h=3Ddm-5.5&id=3D484e0d2b11e1fdd0d17702b282eb2ed56148385f

But I don't plan to send to Linus for a week or 2...

If Jon and/or someone else would like to send it along before then
that'd be fine with me.
