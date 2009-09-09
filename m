From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Snapshot merging
Date: Wed, 9 Sep 2009 13:23:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0909091318340.21052@hs20-bc2-1.build.redhat.com>
References: <4A97A035.9010604@redhat.com>
	<Pine.LNX.4.64.0908311740160.16318@hs20-bc2-1.build.redhat.com>
	<20090831221149.GB15126@redhat.com>
	<Pine.LNX.4.64.0909091142190.2960@hs20-bc2-1.build.redhat.com>
	<20090909155642.GB15981@redhat.com> <20090909161247.GA16156@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090909161247.GA16156@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Wed, 9 Sep 2009, Mike Snitzer wrote:

> On Wed, Sep 09 2009 at 11:56am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Wed, Sep 09 2009 at 11:47am -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > Hi
> > > 
> > > I found one bug in the userspace code --- start merging, then from the 
> > > other console deactivate the origin volume with lvchange -an, then wait 
> > > next 15 seconds for the next poll interval:
> > > 
> > > the poll process will think that the merging finished, removing the 
> > > snapshot, leaving partially merged origin and causing data corruption:
> > > 
> > > [slunicko:~]# lvconvert -M vg1/lv2_snap1
> > >   Merging of volume lv2_snap1 started.
> > >   lv2: Merged: 13.1%
> > > ( .... deactivate the volume from the other console ....)
> > >   lv2: Merged: -1.0%
> > >   Merge into logical volume lv2 finished.
> > >   Logical volume "snapshot4" successfully removed
> > > 
> > > Maybe this bug was in my code too, I don't remember.
> > 
> > Likely, considering I merely ported your LVM2 patches to the latest
> > version.  That said, I could've introduced this issue by missing
> > something in the port.  Regardless, I'll have a look at preventing the
> > origin LV from being deactivated during a merge.
> 
> Or more correctly: gracefully halt the merge and deactivate merging
> snapshot along with the origin.  Then on activation the merge should
> just resume (in the background).
> 
> Mike

I'd patch _poll_merge_progress to return zero (instead of 
PROGRESS_FINISHED) if querying the lv failed (lv_snapshot_percent returned 
zero) --- that should terminate the polling process without updating 
anything.

You can try it and test it.

Mikulas
