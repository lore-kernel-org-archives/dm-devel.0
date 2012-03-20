From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-table: delayed cleanup for dm_table_destroy()
Date: Tue, 20 Mar 2012 15:43:08 -0400
Message-ID: <20120320194307.GD30980@redhat.com>
References: <1332172428-35948-1-git-send-email-hare@suse.de>
	<1332172428-35948-2-git-send-email-hare@suse.de>
	<1332172428-35948-3-git-send-email-hare@suse.de>
	<1332172428-35948-4-git-send-email-hare@suse.de>
	<Pine.LNX.4.64.1203191714090.10651@file.rdu.redhat.com>
	<4F68A3D8.40005@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4F68A3D8.40005@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 20 2012 at 11:35am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> Hi Mikulas,
> 
> On 03/19/2012 10:45 PM, Mikulas Patocka wrote:
> > Hi Hannes
> > 
> > I wouldn't do this. This behavior actually existed in kernels <= 2.6.28.
> > And it caused trouble.
> > 
> > The problems are these:
> > 
> > Some code may hold a spinlock and call dm_table_put. Currently, 
> > dm_table_put just decrements the counter and the cleanup is done 
> > synchronously in dm_table_destroy. With your patch, cleanup would be done 
> > in dm_table_put --- you call a target destructor (which may sleep) in a 
> > non-sleeping context.
> > 
> > Some code may hold a mutex and call dm_table_put. If you call a target 
> > destructor from dm_table_put and it takes the same mutex, it deadlocks.
> > 
> > Currently, when dm_table_destroy exits, it is guaranteed that the table is 
> > destroyed and all target destructors have been called. With your patch, 
> > dm_table_destroy may exit and the table could be still alive because of 
> > some other reference. This may cause leaked references to some other files 
> > or devices. For example, suppose that the user has a device mapper device 
> > "dm" that redirects requests to "/dev/sda". The user assumes that if he 
> > runs "dmsetup remove dm" and this command returns, "/dev/sda" will not be 
> > open. Your patch breaks this assumption.
> > 
> Hmm. Yes, true.
> 
> > Look at the commit "d58168763f74d1edbc296d7038c60efe6493fdd4" in 2.6.29 
> > --- I was actually removing the old-style reference counting (that is 
> > functionally equivalent to what your patch does) because of these three 
> > problems. The old code really caused a crash although it happened very 
> > rarely.
> > 
> Ah. That'll explain it.
> The actual problem I'm trying to track down is that I'm seeing an
> excessive duration for the 'resume' dm ioctl after a table update.
> I've got reports where the ioctl can take up to several seconds.
> Which (as this is multipath) causes an extremely erratic behaviour.
> 
> And the 'msleep' here is one of the obvious culprits.
> 
> But I'll continue debugging, maybe I'll find something else.

I once wanted to replace all msleep(1); with cpu_relax();:
http://www.redhat.com/archives/dm-devel/2010-September/msg00100.html

But Alasdair wasn't sure if cpu_relax() would provide the required
delay effect:
https://www.redhat.com/archives/dm-devel/2011-June/msg00080.html
