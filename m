From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: Make device-mapper udev rules more friendly to udev
Date: Wed, 23 Jun 2010 18:21:11 +0200
Message-ID: <4C223477.8010207@redhat.com>
References: <AANLkTilaLZ9vortsfcAZzYG0vDTmEpTR55bpkeREu5ZE@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTilaLZ9vortsfcAZzYG0vDTmEpTR55bpkeREu5ZE@mail.gmail.com>
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

On 06/23/2010 02:45 PM, Xinwei Hu wrote:
> Hi all,
> 
>   I found there're changes to udev/10-dm.rules.in, which tries to add
> support for uevent triggered outside of libdevmapper.
> Think this is a great step.
> 
>   In current situation, if an admin calls "echo add >
> /sys/block/dm-N/uevent", the symlinks in /dev/mapper and
> /dev/$VGNAME/ will still be removed anyway. I'm not sure who many
> realistic application will trigger the 'add' event in users
> space out side the libdevmapper. But I think it'll be more friendly to udev ;)
> 
>   The attached 10-dm.rules.in is an attempt on this direction. It
> basically import{db} if the events are not trigged by libdevmapper.
> 

Yes, the ADD event. There was one major problem with supporting the ADD event this
way and that was the initial udevadm trigger that's called from the udev init script
(it tries to "coldplug" all previously activated devices and repopulate the /dev
content). That's actually the same situation as with triggering individual ADD events
using the "echo add > /sys/.../uevent" that you have mentioned above.

First of all, we needed to remove the STARTUP environment variable from the rules - a
workaround that was awaiting a better solution (it seems we can't expect each distro to use
this trick, there were complaints raised). Another thing that needs to go away is the NAME=""
rule, that's not supported by udevd anymore...

We can do that by using the IMPORT{db} udev rule, but still we had problems with the
initial udevadm trigger since the database was always cleared explicitly before. The line
you can find in udev start scripts goes something like:

  rm -fr $udev_root/.udev

We discussed this with upstream udev whether this is really needed and actually it's
not - the udev database from initrd can be preserved. So it needs a little modification
in udev init script (each distro has its own way to do that).

This way we can access all the information needed anytime we need (after a device is
correctly activated, of course).

This is the most recent change that should be upstream soon. There's a patch
prepared already: https://www.redhat.com/archives/lvm-devel/2010-June/msg00040.html

Anyway, thanks a lot for the heads-up! I appreciate that.

Peter
