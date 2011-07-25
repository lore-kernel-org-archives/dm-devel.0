From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Reduce number of KOBJ_REMOVE events
Date: Mon, 25 Jul 2011 02:18:47 +0200
Message-ID: <1311553130.1671.21.camel@mop>
References: <4E2987AE.2070707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E2987AE.2070707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
List-Id: dm-devel.ids

On Fri, 2011-07-22 at 16:22 +0200, Zdenek Kabelac wrote:

> For now udev recieves 3 event for removal of DM logical volumes. (1 for
> bdi and 2 for same block kobject). Reason is dm device generates its
> own kobject event with approriate env parameter and block layer sends
> another KOBJ_REMOVE event on its own unconditionaly for the same
> kobject. As for now only the kobject cleanup checks that the REMOVE
> event has been already sent and avoids duplicate REMOVE event.

> The patch for kobject_uevent_env() which has been testing for duplicate
> REMOVE event did not passed into the mainline (yet?):

No, it's wasn't merged. Subsystems should really not send their own
'add' or 'remove' events. These are properties of the driver core.

> I'm proposing alternative way around to always use kobject cleanup
> routine for sending REMOVE event if it was not send by the module - so
> it makes the code few lines shorter.

The events the core creates are only sent out at release() not at del(),
so we would delay 'remove' events when we keep the device pinned but
it's not valid anymore. We can not do that today, we would need to move
the core-created 'remove' events to del().


For device-mapper, I would prefer to add a '.dev_uevent' callback to the
'block' class let this callback check 'struct block_device_operations'
for a possibly specified '.uevent' callback and call it.

Then have 'dm_blk_dops' add '.uevent' and let the core call into the dm
code to the needed properties to the 'remove' event, instead of sending
its own, and see the duplication.

Let me know if you need more details.

Thanks,
Kay
