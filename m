From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-switch target
Date: Tue, 25 Sep 2012 19:35:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1209251934090.24606@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1209251746460.21075@file.rdu.redhat.com>
	<20120925231054.GE30431@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120925231054.GE30431@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Jason_Shamberger@dell.com, dm-devel@redhat.com, Jim Ramsay <jim_ramsay@dell.com>, Kevin_OKelley@dell.com
List-Id: dm-devel.ids



On Wed, 26 Sep 2012, Alasdair G Kergon wrote:

> On Tue, Sep 25, 2012 at 05:50:31PM -0400, Mikulas Patocka wrote:
> >  drivers/md/Kconfig     |   11 +
> >  drivers/md/Makefile    |    1 
> >  drivers/md/dm-switch.c |  520 +++++++++++++++++++++++++++++++++++++++++++++++++
> 
> Please would one of you also propose a Documentation/device-mapper/switch.txt file?
> 
> Alasdair

Here it is:

dm-switch target is suitable for Dell EqualLogic storage system.

The EqualLogic storage consists of several nodes. Each host is connected
to each node. The host may send I/O requests to any node, the node that
received the requests forwards it to the node where the data is stored.

However, there is a performance advantage of sending I/O requests to the
node where the data is stored to avoid forwarding. The dm-switch targets
is created to use this performance advantage.

The dm-switch target splits the device to fixed-size pages. It maintains
a page table that maps pages to storage nodes. Every request is
forwarded to the corresponding storage node specified in the page table.
The table may be changed with messages while the dm-switch target is
running.

DM table arguments:
- number of storage nodes
- page size
for every storage node:
- the underlying block device
- offset to the start of data in 512-byte sectors

DM message:
set-table index1:node1 index2:node2 index3:node3 ...
- modify page table, set values at index to point to the specific node.
  Index and node numbers are hexadecimal. You can omit the index number,
  in this case previous index plus 1 is used.
