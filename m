From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: How can I get my sector size (via queue_limits?)
 from a dm_target?
Date: Wed, 20 Jan 2016 12:52:23 -0500
Message-ID: <20160120175222.GA15897@redhat.com>
References: <alpine.LRH.2.11.1601191922570.22808@mail.ewheeler.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1601191922570.22808@mail.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jan 19 2016 at 10:32pm -0500,
Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:

> Hello all,
> 
> dm_target->len gives me sector count, but I need to know the default 
> sector size discovered by the blk stacking code without assuming 512b.
> 
> Now that I have the dm .iterate_devices callback defined and my 
> queue_limits are sane by default, how can I get a pointer to the 
> queue_limits structure for my device given a dm_target structure?
> 
> It looks like I should call dm_get_md_queue() after getting the md from 
> dm_table_get_md(target->table), but dm_get_md_queue is not an exported 
> symbol.
> 
> Also, is that value correct within the .ctr, or only after the .ctr 
> returns?  If after, how can I hook in after limits are assigned but before 
> .map gets called?  Otherwise stated, I would like to know the stacked 
> queue_limits corrected for lower layers within the .ctr function.

You cannot know it from .ctr because the device is actively being
constructed.  The .io_hints hook allows you access to stacked
queue_limits -- see dm_calculate_queue_limits() which calls ->io_hints
_after_ combining all underlying queue_limits.

See dm-thin.c's pool_io_hints() and thin_io_hints() for examples of how
the .io_hints hook is used for DM-thinp.

Mike
