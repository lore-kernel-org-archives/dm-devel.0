From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 67/72] multipath-tools: Makefile.inc: use -Wp,
 ... for compiling only
Date: Wed, 30 Oct 2019 09:55:30 -0500
Message-ID: <20191030145530.GO25414@octiron.msp.redhat.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
	<20191012212703.12989-68-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-68-martin.wilck@suse.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Oct 12, 2019 at 09:29:01PM +0000, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> clang-3.9 errors out if -Wp,... preprocessor flags are used in the
> linking stage.
>=20
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  Makefile.inc | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/Makefile.inc b/Makefile.inc
> index d4d08fe9..f309a274 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -96,9 +96,8 @@ OPTFLAGS=09=3D -O2 -g -pipe -Wall -Wextra -Wformat=3D2 =
-Werror=3Dimplicit-int \
>  =09=09  -Werror=3Dimplicit-function-declaration -Werror=3Dformat-securit=
y \
>  =09=09  -Wno-clobbered \
>  =09=09  -Werror=3Dcast-qual $(ERROR_DISCARDED_QUALIFIERS) \
> -=09=09  -Wp,-D_FORTIFY_SOURCE=3D2 $(STACKPROT) \
> -=09=09  --param=3Dssp-buffer-size=3D4
> -
> +=09=09  $(STACKPROT) --param=3Dssp-buffer-size=3D4
> +CPPFLAGS=09:=3D -Wp,-D_FORTIFY_SOURCE=3D2=20

Just a nit. The above line adds trailing whitespace.

-Ben

>  CFLAGS=09=09:=3D $(OPTFLAGS) -DBIN_DIR=3D\"$(bindir)\" -DLIB_STRING=3D\"=
${LIB}\" -DRUN_DIR=3D\"${RUN}\" \
>  =09=09   -MMD -MP $(CFLAGS)
>  BIN_CFLAGS=09=3D -fPIE -DPIE
> @@ -135,4 +134,4 @@ check_file =3D $(shell \
> =20
>  %.o:=09%.c
>  =09@echo building $@ because of $?
> -=09$(CC) $(CFLAGS) -c -o $@ $<
> +=09$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
> --=20
> 2.23.0
