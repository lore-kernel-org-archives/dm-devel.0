From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipathd: Don't mark a virtio_blk path
 offline if it has no sysfs "state" attribute
Date: Thu, 05 May 2011 09:13:21 +0200
Message-ID: <1304579601.27286.54.camel@zezette>
References: <20110505163225.0a8a5257@martins.ozlabs.org>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
List-Id: dm-devel.ids

On jeu., 2011-05-05 at 16:32 +1000, Martin Schwenke wrote:
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
I'd personnaly prefer the un-nested version, and keep apply this
passthrough only for drivers who don't present the state file. Is there
other such drivers by the way ?

Best regards,
-- 
Christophe Varoqui
OpenSVC - Tools to scale
http://www.opensvc.com/
