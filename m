From: Gris Ge <fge@redhat.com>
Subject: Re: [PATCH 1/1] add display of map information in JSON
 format
Date: Thu, 5 May 2016 21:16:28 +0800
Message-ID: <20160505131628.GA3938@redhat.com>
References: <1462393428-13929-1-git-send-email-tgill@redhat.com>
	<1462393428-13929-2-git-send-email-tgill@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5468446794910914869=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1462393428-13929-2-git-send-email-tgill@redhat.com>
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


--===============5468446794910914869==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 04, 2016 at 04:23:48PM -0400, Todd Gill wrote:
> The patch adds these commands:
>
> multipathd show maps json
> multipathd show map $map json
>
> Each command will output the requested map(s) in JSON.
>
> For the "show maps json" command, the patch pre-allocates
> INITIAL_REPLY_LEN * 5.  The JSON text is about 5x the size of
> the "show maps topology" text.
Hi Todd,

How about define a constant with this line as comment, instead of
using magic number directly?
>
> Signed-off-by: Todd Gill <tgill@redhat.com>
> ---
> +int
> +snprint_multipath_json (char * buff, int len, struct multipath * mpp, in=
t last)
> +{
> +	int i, fwd =3D 0;
> +	struct path *pp;
> +
> +	fwd +=3D  snprint_json(buff + fwd,
> +			len - fwd, 1, PRINT_JSON_START_ELEM);
> +	if (fwd > len)
> +		return len;
> +
> +	fwd +=3D snprint_multipath(buff + fwd, len - fwd,
> +			PRINT_JSON_MAP, mpp, 0);
If we are using snprint_multipath() there, basally this is just a
daemon version of 'show maps raw format <fancy_json_format>'.

So if I may sum up, we have three options to provide a user-friendly
library.

 A) Expand 'show maps raw format' to include all formation where
    user/client could selectively print needed properties out in their
    favored format. And create a wrapper library(check my previous
    post on libdmmp).

        Pros:
            * Minimum changes to daemon.
            * Client only have to parse properties they are
              interested which saves the CPU time and IPC
              communication.

        Cons:
            * We have to document every formatters,
              example: the meanings and possible values of "%N".

 B) Provide 'show maps json' and do the string
    formatting(JSON/XML/etc) at the daemon side.

        Pros:
            * Easy for client to parse IPC output.

        Cons:
            * More IPC communication, like Todd said, about 5 times.
              And client will waste their CPU and memory on parsing
              un-needed properties if only interested on few.
              For example, you have 1000 maps, and just want to know
              which maps has failed path, then you have to parse
              about 108,000 lines of json string.

            * People (we already have) might suggest XML or whatever
              format is better than JSON, why not use that.

 C) Provide both expanded 'show maps raw format' and 'show maps json'
        Pros:
            * All pros above.

        Cons:
            * Do we have to maintain these two ways?

My negligible vote to option B), ideally the wrapper library should be
user's first choice instead messing with 'raw format'.

Thanks for the patch.
Best regards.

--=20
Gris Ge

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXK0esAAoJEGzN5Y/kHij/J24P/iG9at/CosWiOiGV67HQRHsD
boIczb77/znGmGMPeIpI4qPuQt29fzNXPkfQFyzk0NLiYhs1+KMUgj+h8hrr8ojU
rZUCCXapr+2ckoSmjhgGhRC2wXYFqA8Bb2OmqITPlYoA97LZ7VaMFwvF8tPhRoBT
HLNPs9cTi3DNqw87cGGgdlyD+Sz38UgRGzZUKsdG72GCEdUVbi9tNq2nCT0LCxhD
4sG1lHpVe2PGx8UAL4Ae/GLu686gqGIzvTKIwaLvdfriHs64l63kaA082l3Z/K9/
MG98C0FDpmlGO1tl8Q2ip6y/wYvM/PXJwUjQIokJ7TOwvzpw21e8B1Dcn3UDnV8N
68tainb54QMGX9xvv6GP//oubm+9nsCroc83y842nqo7yoHIxuc2if0o5VBCzYh8
G/QX68LYCx8WIQKnGr3q7iEgExmU2Gr/yZkZ+b6CjhD2ftPO5LOfwSPiXctHChj6
tgQKAdgMVmJwbPRiWqoEDM3180BdEjl2MsEKZpFYZxoPsZcMfLnhiz0PNx9XQ27k
lgs6KB1XMMI+ZIy/eZuhj6KYHQj4TVoTHcGPGcWVmsUeN2CnKiHVZmIWarbtEDPf
FmDZgtp7d1ob+snk9Lnq5KBUtESBDC5oJr9M/anVaJVRh4krV3/kZsWjVXDJvRBc
fdnViZKzaDphhtsNrZQu
=24h4
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--


--===============5468446794910914869==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5468446794910914869==--
