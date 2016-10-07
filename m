From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH] multipath-tools: add IBM/FlashSystem to
 hwtable
Date: Fri, 7 Oct 2016 16:24:19 +0200
Message-ID: <7e9c1d8c-31df-5064-569a-01d3861925a9@linux.vnet.ibm.com>
References: <20161007131522.3442-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161007131522.3442-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/07/2016 03:15 PM, Xose Vazquez Perez wrote:
> System          Vendor Product          Multipathing Policy
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D =3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> FlashSystem 710 IBM    FlashSystem      Symmetric Active/Active
> FlashSystem 720 IBM    FlashSystem      Symmetric Active/Active
> FlashSystem 810 IBM    FlashSystem      Symmetric Active/Active
> FlashSystem 820 IBM    FlashSystem      Symmetric Active/Active
> FlashSystem 840 IBM    FlashSystem-9840 Symmetric Active/Active
> FlashSystem 900 IBM    FlashSystem-9840 Symmetric Active/Active
>
> Based on documentation from the manufacturer:
> http://www.redbooks.ibm.com/redbooks/pdfs/sg248271.pdf

IBM RedBooks are more like descriptions for one particular use case as =

described in the book rather than reference manuals.

Product documentation is elsewhere and also updated more often (like =

each product release) than a RedBook.
E.g. for IBM FlashSystem 900:
http://www.ibm.com/support/knowledgecenter/STKMQB/com.ibm.storage.flashsyst=
em900.1.2.doc/tms_multipathing.html

You'll notice that we from Linux on s390x have a bit different =

recommendations for some of the values (no_path_retry actually depends =

on whether you have a cluster software/filesystem that can cope with EIO =

on last-path-loss. Currently, I see the default without that, i.e. =

non-clustered from which we would like to hide any path issues).

Is there some way to have "dependent" settings?

> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index e1b055a..ff6989d 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -522,6 +522,13 @@ static struct hwentry default_hw[] =3D {
>  		.no_path_retry =3D NO_PATH_RETRY_QUEUE,
>  		.pgpolicy      =3D MULTIBUS,
>  	},
> +	{
> +		/* FlashSystem 710/720/810/820/840/900 */
> +		.vendor        =3D "IBM",
> +		.product       =3D "FlashSystem",
> +		.no_path_retry =3D NO_PATH_RETRY_FAIL,
> +		.pgpolicy      =3D MULTIBUS,
> +	},
>  		/*
>  		 * IBM Power Virtual SCSI Devices
>  		 *
>

-- =

Mit freundlichen Gr=FC=DFen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
