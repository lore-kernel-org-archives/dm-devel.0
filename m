From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipathd: Don't mark a virtio_blk path
 offline if it has no sysfs "state" attribute
Date: Thu, 05 May 2011 09:02:07 +0200
Message-ID: <4DC24B6F.5020407@suse.de>
References: <20110505163225.0a8a5257@martins.ozlabs.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110505163225.0a8a5257@martins.ozlabs.org>
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
Cc: Martin Schwenke <martin@meltin.net>
List-Id: dm-devel.ids

On 05/05/2011 08:32 AM, Martin Schwenke wrote:
> multipathd currently marks paths as down if they don't have a sysfs
> "state" attribute.
>
> Unfortunately, this makes multipathd unusable with Linux virtio_blk
> devices, since they don't have this attribute.  I need to use multipath
> with virtio for consistency with a real configuration when testing a
> clustered NAS system - yeah, I'm that guy again...  :-)
>
> One way of working around this might be to have path_offline() return
> PATH_UP for all devices that don't have a sysfs "state" attribute,
> instead of PATH_WILD.  However, I'm guessing the current behaviour might
> exist for a reason.
>
> The following patch makes path_offline() always return PATH_UP instead
> of PATH_WILD for virtio_blk devices.  I've implemented the nested if
> statements as below to change the code flow as little as possible
> when sysfs_get_state() actually succeeds, which I assume is usually the
> case.   If nobody is feeling paranoid then the check for virtio_blk
> could obviously be done before the call to sysfs_get_state().
>
> If people think this patch is too specific then at least it can be
> used to start a discussion...  ;-)
>
Argl. They messed it up _again_.
(Speaking as someone who is in the process of cleaning up his patch =

queue for multipath. Should have done that _far_ earlier :-( )

path_offline() _absolutely_ requires a check if the device is =

actually a SCSI device. We do have several others to contend with =

(cciss, dasd), and none of those do have the 'state' attribute.

So we need this patch

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 6cd2ec9..4af0cd3 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -645,6 +645,10 @@ path_offline (struct path * pp)
         struct sysfs_device * parent;
         char buff[SCSI_STATE_SIZE];

+       if (pp->bus !=3D SYSFS_BUS_SCSI)
+               /* No information for non-SCSI devices, return UP */
+               return PATH_UP;
+
         pp->sysdev =3D sysfs_device_from_path(pp);
         if (!pp->sysdev) {
                 condlog(1, "%s: failed to get sysfs information", =

pp->dev);

And you need to implement virtio_blk as it's own bus type.
(Say SYSFS_BUS_VIRTIO). And teach discovery.c to detect this one =

properly.
Look at 'cciss' and 'dasd' on how that's done.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
