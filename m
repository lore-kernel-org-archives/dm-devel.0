From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [RFC] Change to the mirror table map
Date: Thu, 19 Oct 2006 15:56:18 -0500
Message-ID: <1161291378.26135.3.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

The impetus for this was the desire to add read balancing to mirroring
and have it share code with multipath.

 brassow

ORIGINAL:
<start> <length> mirror \
<log_type> <#log_params> <log_params> \
<#mirrors> <device1> <offset1> ... <deviceN> <offsetN>

Example:
0 1024000 mirror \
disk 3 253:2 1024 block_on_error \
2 253:3 0 253:4 0


MODIFIED:
                          [-------- logging section ---------] [- mirror devices section -] [--------------- read balancing section -------------]
0 71014400 mirror format2 log 4 disk 253:2 1024 block_on_error devices 2 1 253:3 S 253:4 A  read-balance 8 round-robin 0 2 1 253:3 1000 253:4 1000
^    ^       ^       ^     ^  ^  ^   <^^^^^^^^^^^^^^^^^^^^^^^>    ^    ^ ^   ^   ^              ^       ^ <^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^>
|    |       |       |     |  |  |   |                            |    | |   |   |              |       | |
|    |       |       |     |  |  |   |                            |    | |   |   |              |       | same as multipath
|    |       |       |     |  |  |   |                            |    | |   |   |              |       # read-balance args
|    |       |       |     |  |  |   |                            |    | |   |   |              read-balance section indicator
|    |       |       |     |  |  |   |                            |    | |   |   Device status (slave/active/dead)
|    |       |       |     |  |  |   |                            |    | |   Device
|    |       |       |     |  |  |   |                            |    | # of device args
|    |       |       |     |  |  |   |                            |    # of devices
|    |       |       |     |  |  |   |                            device section indicator
|    |       |       |     |  |  |   log type specific args
|    |       |       |     |  |  log type
|    |       |       |     |  # of log args
|    |       |       |     log section indicator
|    |       |       target table format
|    |       target name
|    target length in 512-byte blocks
starting offset of target

New features:
================================================================================
I've added a format argument ("format2" in example).  It is always the first
argument to the mirror target.  If it isn't present, we can assume the original
format.  If it is present, we can use the format specified.

The mapping table is broken up into sections.  The sections are allowed to be
in any order, and we should be able to add sections in the future if
necessary.

The logging section starts with the keyword 'log' and is followed by the number
of log arguments.  No changes to the dm_create_dirty_log function should be
necessary.

The devices section starts with the keyword 'devices' and is followed by the
number of devices then the number of per device arguments.  This is not
consistent with the other sections.  It may be better to have the keyword
followed by the argument count, followed by the per device argument count.
Something like:
    devices 5 1 253:3 S 253:4 A
or
    devices 5 2 253:3 S 253:4 A
depending on if you want to include the device in the per device argument
count.  Notice that I have done away with the 'offset' parameter found in
the original.  Multipath doesn't have that, and neither does mirroring
when specifying the log device.  For the above example, I did add an
additional per device parameter to specify the status of a device.  I was
imagining a scenario where IBM's slave context might be specified, or
a new mirror device is added to the set.  With the indicator, you could
tell which devices were in-sync, and which ones needed recovery.
(Perhaps that is better left to an additional section, since it is not
yet known how this functionality would be added.)

The read balancing section starts with the keyword 'read-balance' and is
followed by the number of read balancing arguments.  After that, it is
just like multipathing.  If we were certain that the devices section did
not need any device specific arguments, we could combine the devices section
and the read-balance section.  (This could be the case if we decided to
add a section for initial device status and didn't need the offset argument.)
Mirror does need to keep it's own list of devices, however; and it might be
nice to be able to parse that section separate - rather than parse the
read-balancing section twice.

Multipath takes the approach of having positional arguments (e.g. the 'number
of features' argument is in a known place).  If we took this approach, we
could eliminate the keywords.  However, I think I prefer the ability to
identify sections.
