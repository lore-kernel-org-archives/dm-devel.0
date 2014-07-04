From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/12] enable gcc format-security check
Date: Fri, 04 Jul 2014 08:18:42 +0200
Message-ID: <53B64742.3030603@suse.de>
References: <1404105243-5071-1-git-send-email-bmarzins@redhat.com>
	<1404105243-5071-4-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1404105243-5071-4-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 06/30/2014 07:13 AM, Benjamin Marzinski wrote:
> -Wformat-security warns about format-strigs that represent possible
> security problems.  This is check is now enabled for fedora builds, and it
> seems like a reasonable thing to always be checking.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>   Makefile.inc | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile.inc b/Makefile.inc
> index 0669d32..1486721 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -46,7 +46,7 @@ GZIP        =3D gzip -9 -c
>   INSTALL_PROGRAM =3D install
>
>   ifndef RPM_OPT_FLAGS
> -	RPM_OPT_FLAGS =3D -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=3D2 -fexcept=
ions -fstack-protector --param=3Dssp-buffer-size=3D4
> +	RPM_OPT_FLAGS =3D -O2 -g -pipe -Wformat-security -Wall -Wp,-D_FORTIFY_S=
OURCE=3D2 -fexceptions -fstack-protector-strong --param=3Dssp-buffer-size=
=3D4
>   endif
>
>   OPTFLAGS     =3D $(RPM_OPT_FLAGS) -Wunused -Wstrict-prototypes
>

'-fstack-protector-strong' is not recognized on any of my gcc =

versions supplied by SUSE. Can we please revert it to the original =

'-fstack-protector'?
'-Wformat-security' is okay, though.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
