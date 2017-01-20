From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: Question about dmsetup / udev interactions
Date: Fri, 20 Jan 2017 09:40:38 +0100
Message-ID: <bd19464c-0e45-2442-2eae-a2bb0f1ab457@redhat.com>
References: <55BECEAF-A213-425D-87F8-9C83ABA4DDA9@ccs.neu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <55BECEAF-A213-425D-87F8-9C83ABA4DDA9@ccs.neu.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Desnoyers <pjd@ccs.neu.edu>, dm-devel@redhat.com
Cc: Mohammad Hossein Hajkazemi <hajkazemi@gmail.com>, MAniA Abdi <mania.abdi287@gmail.com>
List-Id: dm-devel.ids

On 01/19/2017 11:43 PM, Peter Desnoyers wrote:
> I'm not quite sure where to start with this. We've got a device mapper target (implementing a translation layer over shingled disk) where a lot of the functionality is up at user level. In our current design, when the target is first created it doesn't have any mapping information, and so must block all I/Os until the user space daemon has fed that information to it, after which it unblocks any pending I/Os.
> 
> The problem we have is a deadlock with udev - when the target device appears, udev seems to try to read its partition table, hanging until the userspace daemon sends the map down and enables I/Os. However some versions of dmsetup / libdevmapper interact with udev, so the device doesn't get created (and thus we can't feed it the map) because we're blocked on udevd.
> 
> At the moment we're not really sure where to start looking to figure a way out of this - would it be a udev rules change or something simple like that? Or for now should we just rebuild the LVM tools with one or two of the thirty-odd options set to a different value?
> 
> Any suggestions on which direction we should start looking would be welcome.
> 

From what you wrote, it seems you're using libdevmapper directly to set
up the mapping, right?

If so, you need to make sure the libdevmeppr is compiled with udev
synchronization support (--enable-udev_sync). If you're using the
library directly from distribution, this should be already set as all
the distributions I know about use DM's udev synchronization.

The way libdevmapper interacts with udev is controlled by so called "DM
udev cookies". You can set this cookie for each DM ioctl using
dm_task_set_cookie libdm function before you call dm_task_run function
that executes the ioctl and then dm_udev_wait to wait for udev to finish
its related processing in userspace. The cookie is passed through DM
kernel driver and then passed back to userspace with udev event that is
generated. Then, you can see that as DM_COOKIE environment variable in
uevents for DM devices.

The cookie is 32-bit number that has 16 bits reserved for cookie
identifier and 16 bits for flags. The cookie identifier is used to
unlock waiting userspace process to confirm all the related userspace
udev processing is finished for the ioctl (that is, it unlocks the
dm_udev_wait call in the userpace I mentioned earlier).

The flags are used to control udev rules where first 8 bits are reserved
for general DM functionality while the other 8 bits are reserved for
DM-subsystem-specific functionality (see DM_UDEV_* and
DM_SUBSYSTEM_UDEV_* flags defined in libdevmapper.h and the comments there).

If you have your own target, you can try to use existing generic flags
if they fit your needs or you can use your "subsystem" flags if your
needs are more specific and then you can create appropriate udev rules
to react on these flags.

The important flags to avoid scanning within udev rules (blkid and
similar calls there) is the DM_UDEV_DISABLE_DISK_RULES_FLAG (this is to
disable the blkid call in 13-dm-disk.rules and associated symlink
creation) and also DM_UDEV_DISABLE_OTHER_RULES_FLAG to disable all the
other foreign non-dm udev rules - this is a flag that other rules
(should) check to skip processing if they see it.

With these flags, we've implemented something very similar in LVM2 where
we need to make sure that newly created LV is not accessed by processes
from udev rules before the LV data area is properly wiped and any old
signatures are cleared.

This is only general information on how device-mapper with libdm
interacts with udev. To help you more, I'd probably need more detailed
look at your usecase, design and goals you need to achieve so feel free
to contact me...

-- 
Peter
