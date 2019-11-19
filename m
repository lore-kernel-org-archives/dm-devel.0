From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 2/5] libmultipath: dict.c: rename duplicate
 set_no_path_retry()
Date: Tue, 19 Nov 2019 16:30:53 -0600
Message-ID: <20191119223053.GO30153@octiron.msp.redhat.com>
References: <20191115143403.31692-1-martin.wilck@suse.com>
	<20191115143403.31692-3-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191115143403.31692-3-martin.wilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Chongyun Wu <wu.chongyun@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>
List-Id: dm-devel.ids

On Fri, Nov 15, 2019 at 02:41:48PM +0000, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> We have two functions called set_no_path_retry(). Fix that by
> renaming the function in dict.c to no_path_retry_helper().
>=20
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/dict.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index a90690fa..e8a5ecb2 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -1099,7 +1099,7 @@ declare_mp_handler(pgfailback, set_pgfailback)
>  declare_mp_snprint(pgfailback, print_pgfailback)
> =20
>  static int
> -set_no_path_retry(vector strvec, void *ptr)
> +no_path_retry_helper(vector strvec, void *ptr)
>  {
>  =09int *int_ptr =3D (int *)ptr;
>  =09char * buff;
> @@ -1134,13 +1134,13 @@ print_no_path_retry(char * buff, int len, long v)
>  =09}
>  }
> =20
> -declare_def_handler(no_path_retry, set_no_path_retry)
> +declare_def_handler(no_path_retry, no_path_retry_helper)
>  declare_def_snprint(no_path_retry, print_no_path_retry)
> -declare_ovr_handler(no_path_retry, set_no_path_retry)
> +declare_ovr_handler(no_path_retry, no_path_retry_helper)
>  declare_ovr_snprint(no_path_retry, print_no_path_retry)
> -declare_hw_handler(no_path_retry, set_no_path_retry)
> +declare_hw_handler(no_path_retry, no_path_retry_helper)
>  declare_hw_snprint(no_path_retry, print_no_path_retry)
> -declare_mp_handler(no_path_retry, set_no_path_retry)
> +declare_mp_handler(no_path_retry, no_path_retry_helper)
>  declare_mp_snprint(no_path_retry, print_no_path_retry)
> =20
>  static int
> --=20
> 2.24.0
