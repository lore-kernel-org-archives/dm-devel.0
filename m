From: Mike Anderson <andmike@us.ibm.com>
Subject: [RFC 0/3] dm: add path uevents
Date: Tue, 14 Aug 2007 13:05:44 -0700
Message-ID: <38449.9011947357$1187122037@news.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

This patch series enables device mapper (dm) to send kobject uevents for
dm events. Currently only two new events are sent related to path state
changes.

A previous patch was posted to send these events out over netlink. It was
suggested that the events could be sent using kboject_uevent which lead to
the creation of this patch.

The previous posts can be found in this list archive
http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/3588

This patch leaves the existing dm ioctl event interface in place and
allows user to pickup the new events when available. This would allow
tools that are already processing uevents to pick up the context of the
path events with a small addition to existing processing code.

This patch series against linux-2.6.23-rc2-mm2 contains the following:
- Add dm uevent skeleton.
- Add support for the event functions.
- Add event calls for failed and reinstated paths.

An example of the uevents generated as captured by udevmonitor is shown
below.

1.) Path failure.
UEVENT[1187096865.290808] change@/block/dm-0
ACTION=change
DEVPATH=/block/dm-0
SUBSYSTEM=block
DM_ACTION=PATH_FAILED
DM_SEQNUM=1
DM_PATH=8:48
DM_PATHS=1
SEQNUM=1774
MINOR=0
MAJOR=0

2.) Path reinstate.
UEVENT[1187097039.466958] change@/block/dm-0
ACTION=change
DEVPATH=/block/dm-0
SUBSYSTEM=block
DM_ACTION=PATH_REINSTATED
DM_SEQNUM=2
DM_PATH=8:48
DM_PATHS=2
SEQNUM=1775
MINOR=0
MAJOR=0

-andmike
--
Michael Anderson
andmike@us.ibm.com
