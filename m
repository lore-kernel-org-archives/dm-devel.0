From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH RFC 0/2] dm-mp netlink events
Date: Tue, 8 Nov 2005 23:54:23 -0800
Message-ID: <20051109075423.GA11492@us.ibm.com>
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

This patch series creates a dm-mp hardware handler that sends netlink
messages when a hardware handlers error function is called. The skb
mempool in this patch is derived / copied from
drivers/scsi/scsi_transport_iscsi.c.

Currently I have created this support in a hardware handler to reduce the
impact on other code, but this code could easily be moved to
dm-mpath.c::do_end_io or higher if desired. The events will also contain
better information once the scsi error mapping patches are done.

This patch series contains:
	1 A hardware handler that sends events over netlink (dm-evt)
	2 A sample user space program to receive / display events.
	  (dm_evtd)

-andmike
--
Michael Anderson
andmike@us.ibm.com
