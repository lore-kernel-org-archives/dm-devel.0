From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH v3 1/1] add display of map information in
 JSON format
Date: Wed, 18 May 2016 16:18:29 +0800
Message-ID: <20160518081828.GB2629@redhat.com>
References: <1463150340-27174-1-git-send-email-tgill@redhat.com>
	<1463150340-27174-2-git-send-email-tgill@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5741952528726132769=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1463150340-27174-2-git-send-email-tgill@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Todd Gill <tgill@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============5741952528726132769==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Content-Disposition: inline


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 13, 2016 at 10:39:00AM -0400, Todd Gill wrote:
>
Just found trivial issue:
> +#define PRINT_JSON_MAJOR_VERSION  0
> +#define PRINT_JSON_MINOR_VERSION  1
> +#define PRINT_JSON_START_VERSION  "   \"major_version \": %d,\n" \
> +                                  "   \"minor_version \": %d,\n"
Got extra space in json key name: 'major_version ' and
'minor_version ', should be 'major_version' and 'minor_version'

--=20
Gris Ge

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXPCVUAAoJEGzN5Y/kHij/E2MQAJm21oKxhs+gHIpi/3RR6NqM
UifiP2/3FHQi1sYgYbyeEs1o4ZJYYd9OQ2pXorKin+F+aa9x9qWv7gLkRl42qrO4
oyOryNhUloNjCBxeeZll4qbLg9u2eTp9MLRUX0qQZlid8f4rxbiFpmAcORIphflX
NvMk0V+ZBBmrbTrYzX5ptQUhyVygiG+WCuyhJ43WhcDy8+VGZxGIsD8UeUW6jRDx
v4/O4OvAmE3m97Ss+oAGtj1bcNQ1wBcFScgBlIdp9B1rejycRnSAhhL7xuUtiaOG
qgQ9dVryD9G8T+4ew1WSihH4GznzAOEGzQyOSEJ0fnpSzTW/Cv3DWnGeMv1CNUBT
RCJRtOn+7sxOWgrjasw2tOp3ayovcJzNiKJVIDz1ydSF+5sksWhWm396GcSb6Dpx
UTnOiJz/RVCgDRdORQUV1BUwJKFuCiV0elQ9vIHRNXJY7lH5gMzZAlIWhZc2R9w8
0bUcEpHUUFQCN9PUMYaBybASf1rV3ccjMxFOdCsdUJjJgYhjtnVFiySASvkt6U9c
t+/xSrsKB2wAJcL+D70E7snV1HxFVQnHbQQSFfyPP7iENh57w+ZpUvTna99Rkh2A
YjTcwY1f6AgL0NPiA57rWnEw6HTq0c7m/tLBWbKjrfl3ered8tHFyPA5OKXlKTJu
dH7clO2sKCuRzVDAaUci
=hZr7
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--


--===============5741952528726132769==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5741952528726132769==--
