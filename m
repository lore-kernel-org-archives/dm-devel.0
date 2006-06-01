From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Add events for dm suspend / resume
Date: Thu, 1 Jun 2006 16:07:36 +0100
Message-ID: <20060601150736.GL10603@agk.surrey.redhat.com>
References: <447AAAF9.2070704@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <447AAAF9.2070704@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Greg KH <gregkh@suse.de>
List-Id: dm-devel.ids

On Mon, May 29, 2006 at 10:04:09AM +0200, Hannes Reinecke wrote:
> currently device-mapper doesn't play well with udev & hotplug events.

That's a matter of opinion - I'd say it's udev that doesn't play well with
device-mapper:-)

> The event is sent out on the initial device create; only at this stage
> the device is not usable. Only after one did a 'table load' and a
> 'resume' the device is actually accessible from userland.
> And thus it is purely coincidental if any 'dmsetup' call from udev
> (which is triggered by the device create events) will return any useful
> data.
> This patch adds two additional events 'online' and 'offline' which get
> send after 'resume' and 'suspend', respectively.

> With this patch udev can hook on the 'online' event and will always get
> valid data via the dmsetup call.

'Always' is rather too strong: the device could already have changed again
or even disappeared or mutated into a completely different device...
 

Very little seems to use kobject online/offline events yet, but this looks
to me to be a reasonable use for them to reduce some of the existing
problems.

So the new protocol would be:

  add: Says nothing about whether or not it's ready to be used.
       Ignore it.  [Or create a /dev node if you want.]

  online: The device is usable.
       Trigger the multipath kpartx now, for example.

  offline: I can't think of a need for this yet (and triggering udev events
           when a device is suspended could cause problems) so I'd rather
           leave it out for now.


*But* before applying this, testing is needed to check the extra event can't
lead to the machine locking up.  For example, I notice some worrying
allocations without mempools (or PF_MEMALLOC) in kobject_uevent(): 'suspend'
and 'resume' are sections of device-mapper where such allocations are not
permitted.


Assuming the memory allocation can be avoided or done safely, the change is
a step in the right direction, but it still doesn't address the design
problem with using an asynchronous udev for anything connected with
device-mapper, namely that by the time the udev event gets around to being
processed, the device's state could have changed - or it could even be a
completely different device.

Alasdair.


> --- linux-2.6.16/drivers/md/dm.c.orig	2006-05-23 12:18:09.000000000 +0200
> +++ linux-2.6.16/drivers/md/dm.c	2006-05-26 14:09:16.000000000 +0200
> @@ -1201,6 +1201,7 @@ int dm_suspend(struct mapped_device *md,
>  	dm_table_postsuspend_targets(map);
>  
>  	set_bit(DMF_SUSPENDED, &md->flags);
> +	kobject_uevent(&md->disk->kobj, KOBJ_OFFLINE);
>  
>  	r = 0;
>  
> @@ -1247,6 +1248,7 @@ int dm_resume(struct mapped_device *md)
>  
>  	dm_table_unplug_all(map);
>  
> +	kobject_uevent(&md->disk->kobj, KOBJ_ONLINE);
>  	r = 0;
>  
>  out:
