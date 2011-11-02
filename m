From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] scsi_dh_rdac: Adding the match function
 for	rdac device handler
Date: Wed, 02 Nov 2011 08:20:31 +0100
Message-ID: <4EB0EF3F.1010300@suse.de>
References: <47D23AD8469A2B448F33C24BD7A39BD9105DB4D8@RTPMVEXC1-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD9105DB4D8@RTPMVEXC1-PRD.hq.netapp.com>
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

On 11/01/2011 06:19 PM, Moger, Babu wrote:
> This patch introduces the match function for rdac device handler. Without=
 this,
> sometimes handler attach fails during the device_add.  The match function=
 was
> introduced by this patch
> http://www.spinics.net/lists/linux-scsi/msg54284.html
>
> Signed-off-by: Babu Moger<babu.moger@netapp.com>
> ---
>
> --- linux/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2011-10-31 11:2=
5:44.000000000 -0500
> +++ linux/drivers/scsi/device_handler/scsi_dh_rdac.c	2011-10-31 11:31:34.=
000000000 -0500
> @@ -819,6 +819,21 @@ static const struct scsi_dh_devlist rdac
>   	{NULL, NULL},
>   };
>
> +static bool rdac_match(struct scsi_device *sdev)
> +{
> +	int i;
> +
> +	for (i =3D 0; rdac_dev_list[i].vendor; i++) {
> +		if (!strncmp(sdev->vendor, rdac_dev_list[i].vendor,
> +			strlen(rdac_dev_list[i].vendor))&&
> +		    !strncmp(sdev->model, rdac_dev_list[i].model,
> +			strlen(rdac_dev_list[i].model))) {
> +			return true;
> +		}
> +	}
> +	return false;
> +}
> +
>   static int rdac_bus_attach(struct scsi_device *sdev);
>   static void rdac_bus_detach(struct scsi_device *sdev);
>
> @@ -831,6 +846,7 @@ static struct scsi_device_handler rdac_d
>   	.attach =3D rdac_bus_attach,
>   	.detach =3D rdac_bus_detach,
>   	.activate =3D rdac_activate,
> +	.match =3D rdac_match,
>   };
>
>   static int rdac_bus_attach(struct scsi_device *sdev)
>
As stated in the other mail, I guess we would need to have a check =

if the LUN is in ALUA mode.
And, btw, the _original_ intention was to allow vendor-specific =

device_handler to do some better probing, eg querying some =

vendor-specific VPD pages.
Especially for RDAC it would make far more sense to query the =

existence and format of one of the RDAC-specific VPD pages (eg 0xC2, =

0xC4, or 0xC8) and use that for matching.
Then you could do away with the vendor/model array altogether here =

and we wouldn't need to update the rdac handler every time a new =

array comes out or has been rebranded by some OEM.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
