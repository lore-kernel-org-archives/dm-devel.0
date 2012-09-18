From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm table: do not allow queue limits that
 will exceed hardware limits
Date: Tue, 18 Sep 2012 09:02:26 -0400
Message-ID: <20120918130226.GA8065@redhat.com>
References: <20120914204133.GA376@redhat.com>
	<213748621.1049831.1347911069189.JavaMail.root@redhat.com>
	<20120918114022.GA17356@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120918114022.GA17356@agk-dp.fab.redhat.com>
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
Cc: dm-devel@redhat.com, David Jeffery <djeffery@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 18 2012 at  7:40am -0400,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Mon, Sep 17, 2012 at 03:44:29PM -0400, David Jeffery wrote:
> > @@ -2425,6 +2425,15 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
> 
> > +	if (limits.max_sectors == UINT_MAX)
>   
> Specifically, I don't want dm.c to be peering directly into limits.

That's fine.  I agree, it is wrong to have DM code be so fragile
relative to potential block layer changes.

> It just called calculate_queue_limits() above that.
> Why is calculate_queue_limits getting the limits wrong?

Because, in the mpath case David reported, there are no longer any
devices in the table.  So .iterate_devices doesn't have anything to work
with; which means the blk_set_stacking_limits()' limits are left
unchanged (e.g. limits.max_sectors is UINT_MAX).

I'll try to think of a way to get dm_calculate_queue_limits() to detect:
1) that there are no devices in the table
2) that there is a live table that already has established limits
3) if 1 && 2, then use existing limits (should address David's request)
