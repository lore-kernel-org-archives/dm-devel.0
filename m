From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2/2] multipathd: skip spurious event
 message for blacklisted paths
Date: Tue, 13 Dec 2016 21:53:03 -0200
Message-ID: <9de3a660-b6d6-77ee-87f6-50460a1488b7@linux.vnet.ibm.com>
References: <1481653629-22430-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	<1481653629-22430-2-git-send-email-mauricfo@linux.vnet.ibm.com>
	<20161213215024.GB19659@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161213215024.GB19659@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Ben,

On 12/13/2016 07:50 PM, Benjamin Marzinski wrote:
> [snip] I don't see why the udev_device_ref/unref
> is necessary. While servicing uevents, when we first get the udevice
> from udev_monitor_receive_device() in uevent_listen() it comes with a
> reference. After we finish servicing the uevent, we drop this reference
> in service_uevq().  [snip]

Oh, cool. Thanks for the detailed explanation. I hadn't realized about
that first reference. I'll remove the udev_device_ref/unref() in v3.

 > My second issue is more for Hannes. Is there a reason why we don't check
 > filter_property in pathinfo if we call it with (DI_BLACKLIST | DI_WWID).
 > If we have the information to get the WWID, then we have the information
 > to check filter_property. [snip]

If I may, I'm not sure that filter_property() has to do w/ DI_WWID.

iiuic, it just checks the /name/ of each udev property of udev_device
against the blacklist/blacklist-exceptions entries for property names
in the conf struct (i.e., it doesn't need the path wwid).

And that information about the udev_device is available upfront,
even before we call pathinfo() (BTW, I guess this is the reason
why it's not called from within it, but rather at a point in
path_discover() that only the udev_device is available, like
filter_devnode() too.)

 > [snip]  Looking at the code, I don't see how we could
 > be checking filter_property for paths added via uev_add_path. Am I
 > missing something subtle here, or should we just add a filter_property()
 > check to pathinfo()?

You're correct. If a path is added via uev_add_path() it ignores
the property blacklisting, and end up creating/joining a devmap.
It seems like an unhandled case.

So, I'll submit a v3 w/ your suggestion for this too.

Thanks!


Simple test case w/ change/add uevents:

# cat /etc/multipath.conf
blacklist {
         property "ID_SERIAL"
}

# multipathd -d -s -v3 &
...

# echo change > /sys/block/sdb/uevent
uevent 'change' from '/devices/vio/2000/host0/target0:0:0/0:0:0:1/block/sdb'
Forwarding 1 uevents
sdb: udev property ID_SERIAL blacklisted
sdb: spurious uevent, path is blacklisted

# echo add > /sys/block/sdb/uevent
uevent 'add' from '/devices/vio/2000/host0/target0:0:0/0:0:0:1/block/sdb'
Forwarding 1 uevents
sdb: add path (uevent)
...
0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1: load table [0 4194304 multipath 1 
retain_attached_hw_handler 0 1 1 service-time 0 1 1 8:16 1]
...
sdb [8:16]: path added to devmap 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1





-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
