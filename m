From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-kcopyd: monitor io activity
Date: Tue, 31 May 2011 09:08:57 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105310856050.4685@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1105301238460.26092@hs20-bc2-1.build.redhat.com>
	<20110531090900.GA3164@ubuntu>
	<20110531091223.GI11145@agk-dp.fab.redhat.com>
	<20110531092340.GA3481@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110531092340.GA3481@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Tue, 31 May 2011, Joe Thornber wrote:

> On Tue, May 31, 2011 at 10:12:24AM +0100, Alasdair G Kergon wrote:
> > On Tue, May 31, 2011 at 10:09:01AM +0100, Joe Thornber wrote:
> > > Different kcopyd clients have different performance requirements, for
> > > instance the initial sync of a new mirror leg may have less priority
> > > than a copy-on-write exception for a snapshot.  This isn't something
> > > we've addressed so far, but if you're starting to slow kcopyd down
> > > (i.e. so the mirror sync doesn't saturate the system), then I think
> > > you'll get some complaints from the snapshot users.

I think it's a good comment. We could make different throttles for 
different clases of clients --- i.e. have one throttle for mirrors, one 
for snapshots, one for multisnap, etc.

The variables "dm_kcopyd_throttle", "activity_spinlock", "num_io_jobs", 
"io_period", "total_period", "last_jiffies" could be placed into a 
structure and the structure could be moved to every module that uses 
kcopyd. Thus, the modules could be throttled independently.

> > Is it plausible to differentiate between the classes of clients,
> > and prioritise snapshot i/o above mirror or have different throttling
> > parameters?
> 
> Well I think it's plausible to have a priority field as part of the
> request structure.  This could be either a direct priority, or a
> 'class' mapping onto a throttling parameter as you suggest.  As long
> as we're careful to avoid starvation it shouldn't be too hard to
> implement.
> 
> In general I'd rather avoid introducing paramaters for the sys admin.

If you don't make a parameter, the whole idea of throttling is useless. 
The throttling should happen only at admin's request, never do it 
automatically. If we slow down I/O deliberately, people will surely come 
up with scenarios where it hurts performance.

> It's more work for them, and in my experience they rarely get set
> properly.  So is there a way to infer priorities for different
> clients?  Perhaps a function of number and size of recently submitted
> kcopyd jobs?

This is duplicating work of i/o scheduler. Such decisions should be made 
in the i/o scheduler and not in kcopyd.

> If one client has submitted a request to copy 64k of
> data and the other 1G does it always make sense to do the small job in
> a more timely manner?
> 
> - Joe

Mikulas
