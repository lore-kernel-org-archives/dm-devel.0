From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] multipath-tools: merge OPTFLAGS into
	CFLAGS
Date: Fri, 15 Jul 2016 12:19:58 +0200
Message-ID: <2af5e805-8bfe-72dc-d476-1c0184b76720@suse.de>
References: <1467995301-14226-1-git-send-email-xose.vazquez@gmail.com>
	<1467995301-14226-3-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467995301-14226-3-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>, Dragan Stancevic <dragan.stancevic@canonical.com>, device-mapper development <dm-devel@redhat.com>, Ritesh Raj Sarraf <rrs@debian.org>, Louis Bouchard <louis.bouchard@canonical.com>
List-Id: dm-devel.ids

On 07/08/2016 06:28 PM, Xose Vazquez Perez wrote:
> OPTFLAGS is not used anywhere, but maybe it's intrusive for distributions.
> =

> Cc: Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>
> Cc: Dragan Stancevic <dragan.stancevic@canonical.com>
> Cc: Louis Bouchard <louis.bouchard@canonical.com>
> Cc: Ritesh Raj Sarraf <rrs@debian.org>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  Makefile.inc | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> =

> diff --git a/Makefile.inc b/Makefile.inc
> index 01d743c..b7077fc 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -60,10 +60,9 @@ RM          =3D rm -f
>  LN          =3D ln -sf
>  INSTALL_PROGRAM =3D install
>  =

> -OPTFLAGS     =3D -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-secu=
rity -Wall \
> -		-Wp,-D_FORTIFY_SOURCE=3D2 -fexceptions -fstack-protector --param=3Dssp=
-buffer-size=3D4
> -
> -CFLAGS	     =3D $(OPTFLAGS) -fPIC -DLIB_STRING=3D\"${LIB}\" -DRUN_DIR=3D=
\"${RUN}\"
> +CFLAGS      =3D -Wunused -Wstrict-prototypes -O2 -g -pipe -Wformat-secur=
ity -Wall \
> +		-Wp,-D_FORTIFY_SOURCE=3D2 -fexceptions -fstack-protector --param=3Dssp=
-buffer-size=3D4 \
> +		-fPIC -DLIB_STRING=3D\"${LIB}\" -DRUN_DIR=3D\"${RUN}\"
>  SHARED_FLAGS =3D -shared
>  =

>  %.o:	%.c
> =

Nope, doesn't work for us.
Our buildsystem is using a distinct set of flags, which we need to use
for the build process.
At the same time we have no idea if there are other flags (like includes
etc) which are required by the build itself.

Please revert, this breaks our build.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
