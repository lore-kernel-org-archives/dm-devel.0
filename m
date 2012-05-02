From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCHES]: dm lock optimization
Date: Tue, 1 May 2012 20:03:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1205011958240.6126@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1204182249060.12984@file.rdu.redhat.com>
	<20120423131438.GA32127@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120423131438.GA32127@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 23 Apr 2012, Joe Thornber wrote:

> On Wed, Apr 18, 2012 at 11:03:33PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > I placed dm lock optimization patches here
> > 
> > http://people.redhat.com/mpatocka/patches/kernel/dm-lock-optimization/
> 
> Just a heads up that sparse gives some warnings with these patches:
> 
> drivers/md/dm.c:689:24: warning: context imbalance in 'dm_get_live_table_fast' - wrong count at exit
> drivers/md/dm.c:695:13: warning: context imbalance in 'dm_put_live_table_fast' - unexpected unlock
> drivers/md/dm.c:1789:17: warning: context imbalance in 'dm_request_fn' - unexpected unlock
> 
> - Joe

I couldn't figure out how to shut up sparse warnings. For RCU you can mark 
functions that take/release RCU with __acquires(RCU)/__releases(RCU), but 
I didn't find out how to do it for SRCU.

If I use "__acquires(&md->io_barrier)"
struct dm_table *dm_get_live_table(struct mapped_device *md, int 
*srcu_idx) __acquires(&md->io_barrier)
{
        *srcu_idx = srcu_read_lock(&md->io_barrier);
        return rcu_dereference(md->map);
}
it doens't work and I get an error:
drivers/md/dm.c:557:9: warning: context imbalance in 'dm_get_live_table': 
unexpected unlock
drivers/md/dm.c:557:9:    default context: wanted 1, got 0

Maybe it is a bug in sparse, maybe I am using a wrong tag? Is there a 
reference of all sparse tags somewhere?

Mikulas
