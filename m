From: Martin Schwenke <martin@meltin.net>
Subject: Re: [PATCH] multipathd: Don't mark a virtio_blk path
 offline if it has no sysfs "state" attribute
Date: Thu, 5 May 2011 17:37:22 +1000
Message-ID: <20110505173722.52a24858@martins.ozlabs.org>
References: <20110505163225.0a8a5257@martins.ozlabs.org>
	<4DC24B6F.5020407@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4DC24B6F.5020407@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 05 May 2011 09:02:07 +0200, Hannes Reinecke <hare@suse.de>
wrote:

> path_offline() _absolutely_ requires a check if the device is 
> actually a SCSI device. We do have several others to contend with 
> (cciss, dasd), and none of those do have the 'state' attribute.
> 
> So we need this patch
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 6cd2ec9..4af0cd3 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -645,6 +645,10 @@ path_offline (struct path * pp)
>          struct sysfs_device * parent;
>          char buff[SCSI_STATE_SIZE];
> 
> +       if (pp->bus != SYSFS_BUS_SCSI)
> +               /* No information for non-SCSI devices, return UP */
> +               return PATH_UP;
> +
>          pp->sysdev = sysfs_device_from_path(pp);
>          if (!pp->sysdev) {
>                  condlog(1, "%s: failed to get sysfs information", 
> pp->dev);


That sure works for me...  ;-)

> And you need to implement virtio_blk as it's own bus type.
> (Say SYSFS_BUS_VIRTIO). And teach discovery.c to detect this one 
> properly.
> Look at 'cciss' and 'dasd' on how that's done.

Have to?  Currently it all works!  :-)

Devices with bus SYSFS_BUS_UNDEF seem to work just fine - someone
seems to have made a conscious decision to make it so in the past. I
don't get a vendor/model or anything else very useful listed against
my paths, but multipath works fine...

Do you think that's an acceptable way of operating or should we
definitely put some code in to give virtio_blk a bus type?  My personal
opinion is that it is OK as it is.

Thanks...

peace & happiness,
martin
