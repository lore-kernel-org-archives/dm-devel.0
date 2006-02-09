From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 0/2] dm-netlink events (update)
Date: Thu, 9 Feb 2006 07:40:09 -0800
Message-ID: <20060209154009.GA29591@us.ibm.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


This is another update of my previous patch to add netlink event support to dm.

The skb mempool in this patch is derived from:
drivers/scsi/scsi_transport_iscsi.c.

This patch series contains:
1 dm-netlink skeleton support.
2 The netlink support to dm-netlink. Add init calls and send on path
failure and reinstate events.

I have ran path failure testing on a small config.

Output:
1.) Path failure.
Msg Type: 17 Recevied
Event Type: 1 Version: 8
[Event]: MDNAME: 253:5, SEQNUM: 3, Time: Thu Feb  9 15:33:41 2006, DMNAME:
65:112, VLDPTHS: 0x3


2.) Path reinstate.
Msg Type: 17 Recevied
Event Type: 2 Version: 8
[Event]: MDNAME: 253:5, SEQNUM: 4, Time: Thu Feb  9 15:38:33 2006, DMNAME:
65:112, VLDPTHS: 0x4

-andmike
--
Michael Anderson
andmike@us.ibm.com
