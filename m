From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: might_sleep warning in multipath_dtr
Date: Wed, 21 May 2008 14:15:26 +0200
Message-ID: <20080521121526.GA1038@schmichrtp.de.ibm.com>
References: <20080507083716.GA30401@schmichrtp.de.ibm.com>
	<20080507132820.GN8827@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080507132820.GN8827@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, May 07, 2008 at 02:28:20PM +0100, Alasdair G Kergon wrote:
> On Wed, May 07, 2008 at 10:37:16AM +0200, Christof Schmitt wrote:
> >     <4> [<000003e00008f79c>] multipath_dtr+0x38/0x50 [dm_multipath]
> >     <4> [<000003e000077e4a>] dm_table_put+0xae/0x134 [dm_mod]
> >     <4> [<000003e000076020>] dm_any_congested+0x50/0x88 [dm_mod]
> 
> > I don't know, if this exact situation is reproducible, but we have a
> > memory dump that should have some more data.
> 
> Well I'm guessing dm_any_congested() ran alongside a table reload, such
> that dm_any_congested() was still referencing the old table after
> dm_swap_table() removed it.
> 
> IOW There needs to be better synchronisation between those two
> functions.

I had a look at the code, but i don't have enough knowledge about the
device-mapper and the block layer to understand what is happening
here. dm_swap_table is probably triggered by multipathd, but i don't
know about the congestion mechanism.

Do you have an idea how to continue with this problem?

Christof
