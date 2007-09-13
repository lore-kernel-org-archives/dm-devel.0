From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 0/4] dm: add path uevents
Date: Thu, 13 Sep 2007 08:07:10 -0700
Message-ID: <1561.29846950552$1189696783@news.gmane.org>
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
To: dm-devel@redhat.com
Cc: Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

This patch series enables device mapper (dm) to send kobject uevents for
dm events. Currently only two new events are sent related to path state
changes.

The previous RFC posts can be found in this list archive
http://article.gmane.org/gmane.linux.kernel.device-mapper.devel/3949

This patch leaves the existing dm ioctl event interface in place and
allows user to pickup the new events when available. This would allow
tools that are already processing uevents to pick up the context of the
path events with a small addition to existing processing code.

This patch series is against linux-2.6.23-rc4-mm1 and contains the
following:
1 Add dm uevent skeleton.
2 Add support for the event functions.
3 Add dm name and uuid to event output.
4 Add event calls for failed and reinstated paths in mpath target.

An example of the uevents generated as captured by udevmonitor is shown
below.

1.) Path failure.
# UEVENT[1189606553.769166] change@/block/dm-0
ACTION=change
DEVPATH=/block/dm-0
SUBSYSTEM=block
DM_ACTION=PATH_FAILED
DM_SEQNUM=1
DM_PATH=8:16
DM_PATHS=1
DM_NAME=3600a0b8000173c960000001845bf88b4
DM_UUID=mpath-3600a0b8000173c960000001845bf88b4
MINOR=0
MAJOR=0
SEQNUM=1699

2.) Path reinstate.
UEVENT[1189635862.724786] change@/block/dm-0
ACTION=change
DEVPATH=/block/dm-0
SUBSYSTEM=block
DM_ACTION=PATH_REINSTATED
DM_SEQNUM=10
DM_PATH=8:16
DM_PATHS=2
DM_NAME=3600a0b8000173c960000001845bf88b4
DM_UUID=mpath-3600a0b8000173c960000001845bf88b4
MINOR=0
MAJOR=0
SEQNUM=1713

The uevent output uses the same env name for the dm name and uuid as the
ones created with the dmsetup export option. Some env values where not
appropriate in the uevent or dmsetup export so there is not a full mapping
between the two outputs. The major minor env values where not repeated in
DM_ env values for uevents, but this could be added if more capability was
needed between uevents and the export output.

Output from dmsetup export on the same device enabled through the use of
Kay's patch

./dmsetup export 3600a0b8000173c960000001845bf88b4
DM_NAME=3600a0b8000173c960000001845bf88b4
DM_UUID=mpath-3600a0b8000173c960000001845bf88b4
DM_STATE=ACTIVE
DM_TABLE_STATE=LIVE
DM_OPENCOUNT=0
DM_LAST_EVENT_NR=2
DM_MAJOR=0
DM_MINOR=0
DM_TARGET_COUNT=1
DM_TARGET_TYPES=multipath

-andmike
--
Michael Anderson
andmike@us.ibm.com
-- 
