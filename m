From: Stefan Weinhuber <WEIN@de.ibm.com>
Subject: [RFC] improve device mapper response characteristics by
 implementing timeouts
Date: Tue, 21 Feb 2006 19:02:25 +0100
Message-ID: <OF6C9A5B0A.EE19FB3C-ONC125711C.0061011B-C125711C.00631634@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: heinzm@redhat.com, agk@redhat.com, Holger Smolinski <smolinski@de.ibm.com>
List-Id: dm-devel.ids

Hello everyone,

Stefan Bader and I are currently looking into the device mapper and
its mirror target, with the intention to improve its response
characteristic. (We already got some early feedback from Alasdair and
others, so just assume that the bad ideas are from us and the good
ones are from those helpful people :-)

The current implementation of device mapper relies entirely on the
underlying devices to report success or failure within a short time
frame. With SAN devices however, there may be longer delays due to
network congestion or error recovery within the storage device or the
network.  For the mirror target this means that a single delayed
physical device will cause a delay on the virtual device.

Applications on the other hand expect certain response times before
taking recovery actions as well. We want to improve the response time
of a virtual device by allowing the mirror volume to become out of
sync to a certain degree if one of the underlying devices doesn't
respond within a user defined time frame but other devices in the
mirror group do. Devices that do not respond will become 'degraded'
and will not be used for further reading or writing until all of the
outstanding requests have been completed.

Of course there are several issues that have to be solved:

First issue: Risk of data corruption.

Bios that are still running on some of the devices but are returned as
finished to the upper layer may cause data inconsistency. The memory
referred to by the bios may be changed before the device is actually
performing any read or write action. So the device will update memory
or disk in an inconsistent way.

We see two ways how to deal with this problem:

1. Implement a way to control a request still running on a device, so
   that it can be stopped before it is finished. A possible
   implementation would be to introduce some new functionality in the
   block layer that allows to cancel a submitted request. If one of
   the low level devices doesn't return in the requested time frame,
   then the device mapper could actively cancel the request on that
   device. The low level driver of that device must make sure that a
   canceled request will not be executed and thus will not change disk
   or memory in any unexpected way.

2. Make sure that the memory used for any request running on the
   device is not changed. This can be achieved by making a deep copy
   of every bio and sub those clones to the devices instead of the
   original bios.
   This could be implemented within device mapper or the mirror target
   itself. Instead of just creating a set of bios that all refer to
   the original memory pages, the memory pages would be copied as
   well. When one of the low level devices does not return within the
   requested time frame, that device can be simply ignored. Device
   mapper can return the original bio without risk of data
   inconsistency. Once this happens to a device we should stop cloning
   bios for that device until we know it is fully operational again
   and the devices were resynchronized again.

Some further considerations:=20
- Cloning is expensive and we probably want a cancellation method in
  the long term. The cancellation approach though will need a lot of
  discussion and it may take some time before the needed
  infrastructure is there. We should design the interfaces in a way
  that allows us to do either cloning or canceling.=20
- Cloning or rather caching of data is something that is needed in
  other places as well. The raid4 and raid5 targets already implement
  a data cache. This code might be moved out of those targets for
  generic use.


Second issue: Where should the timeout be handled?=20

We want to improve the mirror target, but other targets might profit
from a timeout interface as well. For example, on a multipath target a
bio is send via one path to a target, if that path fails, the bio must
be resent via a different path. But if a path does not react at all,
the bio can't be resent. In this case a timeout could help to break up
such a situation. So the timeout interface should be implemented in a
generic way, that makes its use possible for all device mapper targets.


Third issue: Logging and error recovery.

With our approach disks will go out of sync not just because of error
situations but also because of bad performance, which is much more
likely to happen. So the mechanisms for resynchronization must be able
to deal with this. We also need to think about error recovery. What
will happen if we reboot a system and the master disk of a mirror
fails and only an out of sync copy comes up? What will happen if our
log device fails? As long as we only have one log we have a single
point of failure, but if we had two logs how would we recognize an up
to date log in case of an error recovery?



Well, these are our ideas and intentions so far.=20
Do you think this makes sense at all? Any issues that we overlooked?
We appreciate any kind of feedback. :-)
As the next step we will think about the new interfaces that would be
needed and how they could look like.


Best Regards /  Mit freundlichen Gr=FC=DFen

Stefan Weinhuber

-------------------------------------------------------------------
IBM Deutschland Entwicklung GmbH
Linux for zSeries Development & Services
