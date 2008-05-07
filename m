From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: might_sleep warning in multipath_dtr
Date: Wed, 7 May 2008 14:28:20 +0100
Message-ID: <20080507132820.GN8827@agk.fab.redhat.com>
References: <20080507083716.GA30401@schmichrtp.de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080507083716.GA30401@schmichrtp.de.ibm.com>
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

On Wed, May 07, 2008 at 10:37:16AM +0200, Christof Schmitt wrote:
>     <4> [<000003e00008f79c>] multipath_dtr+0x38/0x50 [dm_multipath]
>     <4> [<000003e000077e4a>] dm_table_put+0xae/0x134 [dm_mod]
>     <4> [<000003e000076020>] dm_any_congested+0x50/0x88 [dm_mod]

> I don't know, if this exact situation is reproducible, but we have a
> memory dump that should have some more data.

Well I'm guessing dm_any_congested() ran alongside a table reload, such
that dm_any_congested() was still referencing the old table after
dm_swap_table() removed it.

IOW There needs to be better synchronisation between those two
functions.

Alasdair
-- 
agk@redhat.com
