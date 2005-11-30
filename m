From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH RFC 0/4] dm-netlink events
Date: Wed, 30 Nov 2005 00:23:11 -0800
Message-ID: <20051130082311.GA18453@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

This is an update of my previous patch to add netlink event support to dm
multipath. I have moved the dm netlink support out of a hardware handler
and into a dm-netlink support file. I have changed the event messages to
use netlink attributes which should allow for more flexibility in event
message content over time.

This patch series adds a file called dm-netlink to the drivers/md
directory to provide netlink support for dm events.

The skb mempool in this patch is derived / copied from
drivers/scsi/scsi_transport_iscsi.c.

This patch series contains:
1 Core dm netlink support (dm-netlink).
2 Calls to dm-netlink for path failure / reinstate events.
3 A sample user space program to receive / display events (dm_nld).

I have ran path failure testing on a small config.
I ran the sample program as a 32 bit and 64 bit app against a 64 bit
kernel.

Currently on path failures the blkerr is hard coded until that error
support is complete.

Example out:
1.) Path failure.
Msg Type: 17 Recevied
Event Type: 1 Version: 6
[Event]: SEQNUM: 7, Time: Tue Nov 29 21:50:47 2005, DMNAME: 8:160, BLKERR:
0x5a5a5a5a

2.) Path reinstate
Msg Type: 17 Recevied
Event Type: 2 Version: 6
[Event]: SEQNUM: 12, Time: Tue Nov 29 21:51:57 2005, DMNAME: 8:48


-andmike
--
Michael Anderson
andmike@us.ibm.com
