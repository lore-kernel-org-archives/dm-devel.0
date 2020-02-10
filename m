From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v2 08/17] libmultipath: fix sgio_get_vpd
	looping
Date: Mon, 10 Feb 2020 14:35:12 +0000
Message-ID: <03bc5ce5223641d1d4002d3e673cdbf894c01e91.camel@suse.com>
References: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
	<1580929100-32572-9-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1580929100-32572-9-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <83F00B447B88C24CBB6743317ABDD8B2@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-02-05 at 12:58 -0600, Benjamin Marzinski wrote:
> If do_inq returns a page with a length that is less than maxlen, but
> larger than DEFAULT_SGIO_LEN, this function will loop forever. Also
> if do_inq returns with a length equal to or greater than maxlen,
> sgio_get_vpd will exit immediately, even if it hasn't read the entire
> page.  Fix these issues, modify the tests to verify the new behavior.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c | 12 +++----
>  tests/vpd.c              | 77 ++++++++++++++++++++++++------------
> ----
>  2 files changed, 52 insertions(+), 37 deletions(-)
>=20
>=20
> diff --git a/tests/vpd.c b/tests/vpd.c
> index d9f80eaa..1e653ed4 100644
> --- a/tests/vpd.c
> +++ b/tests/vpd.c
> \
> @@ -518,10 +519,16 @@ static void test_vpd_eui_ ## len ## _ ##
> wlen(void **state)             \
> =09\
>  =09n =3D create_vpd83(vt->vpdbuf, sizeof(vt->vpdbuf), test_id,=09\
>  =09=09=09 2, 0, len);=09=09=09=09=09\
> +=09if (sml) {=09=09=09=09=09=09=09\
> +=09=09/* overwrite the page side to DEFAULT_SGIO_LEN + 1 */=09\
> +=09=09put_unaligned_be16(255, vt->vpdbuf + 2);=09=09\
> +=09=09will_return(__wrap_ioctl, n);=09=09=09=09\
> +=09=09will_return(__wrap_ioctl, vt->vpdbuf);=09=09=09\
> +=09}=09=09=09=09=09=09=09=09\
>  =09will_return(__wrap_ioctl, n);=09=09=09=09=09\
>  =09will_return(__wrap_ioctl, vt->vpdbuf);=09=09=09=09

Nitpick:=20
1. "side" -> "size"
2. This looks like a missing "else" clause, even though it is not
(because get_vpd_sgio will make 2nd ioctl call). Perhaps add a comment
explaining that.

Anyway, that can be improved later, no need to resend the series again.
So:

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
