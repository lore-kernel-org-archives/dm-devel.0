From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 0/3] dm-netlink events
Date: Mon, 16 Jan 2006 00:33:56 -0800
Message-ID: <20060116083356.GA15587@us.ibm.com>
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


This is an update of my previous patch to add netlink event support to dm
multipath. I have generalized the interface and made it so all callers
of dm_table_event can also generate a netlink event.

The skb mempool in this patch is derived / copied from
drivers/scsi/scsi_transport_iscsi.c.

This patch series contains:
1 dm-netlink skeleton support.
2 The netlink support for dm-netlink.
3 Add init calls and send on path failure and reinstate events.

I have ran path failure testing on a small config.

Example out:
1.) Path failure.
Msg Type: 17 Recevied
Event Type: 1 Version: 6
[Event]: SEQNUM: 7, Time: Tue Nov 29 21:50:47 2005, DMNAME: 8:160

2.) Path reinstate
Msg Type: 17 Recevied
Event Type: 2 Version: 6
[Event]: SEQNUM: 12, Time: Tue Nov 29 21:51:57 2005, DMNAME: 8:48

-andmike
--
Michael Anderson
andmike@us.ibm.com
