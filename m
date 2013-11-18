From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/13] libmultipath: return error numbers
	from sysfs_get_XXX
Date: Mon, 18 Nov 2013 07:51:40 +0100
Message-ID: <5289B8FC.1010801@suse.de>
References: <1384511384-27642-1-git-send-email-hare@suse.de>	<1384511384-27642-5-git-send-email-hare@suse.de>
	<CABr-Gndi_0r_2f4KNArkc9pOUvr=N51L55xQJzh5zLLo+umpeQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gndi_0r_2f4KNArkc9pOUvr=N51L55xQJzh5zLLo+umpeQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/17/2013 06:34 PM, Christophe Varoqui wrote:
>  declare_sysfs_get_str(devtype);
> -declare_sysfs_get_str(cutype);
>  declare_sysfs_get_str(vendor);
>  declare_sysfs_get_str(model);
>  declare_sysfs_get_str(rev);
> =

> This part seems correct, as this function is not used anywhere, but
> orthogonal to the patch.
> Can you confirm this slip is safe ?
> =

Yes. I've added the 'cutype' attribute back then when I've added
multipath support for DASD, but then it turned out this attribute
is not required (DASD selection relies on 'devtype').

So it's safe to remove it.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
