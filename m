From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [PATCH RFC] dm snapshot: shared exception store
Date: Wed, 13 Aug 2008 17:14:08 -0700
Message-ID: <200808131714.09311.phillips@phunq.net>
References: <Pine.LNX.4.64.0808061453470.19728@devserv.devel.redhat.com>
	<Pine.LNX.4.64.0808111740520.14722@hs20-bc2-1.build.redhat.com>
	<20080812083440U.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080812083440U.fujita.tomonori@lab.ntt.co.jp>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Monday 11 August 2008 16:34, FUJITA Tomonori wrote:
> On Mon, 11 Aug 2008 18:12:08 -0400 (EDT) Mikulas Patocka <mpatocka@redhat.com> wrote:
> > So use different format --- we in RedHat plan redesigning it too. One of 
> > the needed features is "rolling snapshots" --- i.e. you take snapshot 

Matt Dillon's Hammer for BSD has rolling snapshots, effectively
infinite snapshots on a per-fsync basis.  I strongly suggest that you
think about rustling up some engineers to join a porting team, both
Red Hat and NTT.

> > every 5 minutes or so and you keep them around. The result is that you 
> > have complete history of the system activity.
> 
> I think that implementing a better format is far more difficult than
> you think. for example, see the tux3 vs. HAMMER discussion between
> Daniel Phillips and Matthew Dillon.
> 
> Unless Alasdair tells me that unlimited snapshots is a must, probably
> I will not work on it. I'm focusing integrating a snapshot feature
> into dm cleanly.
> 
> Of course, I'm happy to use the better snapshot code if it's
> available.

Very sensible.  Over time it will be available, but there is a whole
lot of benefit to starting with code that is known to work.

One thing you need to keep in mind: any time you have a memory-using
daemon doing work on behalf of block IO code you need to implement
anti-deadlock measures of the kind ddsnap implements via bio-throttle.
Other ways have been proposed to solve these deadlocks, but the
bio-throttle approach is the only one that has been observed to work
reliably.

You are also welcome to port the real thing to kernel: ddsnapd.  The
scope of that work would be roughly what you have already accomplished.
You would only port the part that responds to kernel read/write
requests.  I could take care of designing and implementing a kernel
interface between your port and the rest of ddsnapd that does such
things as respond to control messages and generate block delta
lists.  You can optionally leave the delete code in userspace, except
for the journalling, which has to work together with the journalling
that will be triggered for origin write and snapshot read/write.
Since delete can now run in background (with my new patch) that should
not be a performance issue at all.

It is also possible to interface ddsnapd seamlessly to LVM2.  That
mechanism has been built into LVM2 since forever, via dynamically
loadable modules in the LVM2 userspace support.  I am not sure what
would be done about LVM2 re replication.  Perhaps LVM2 can be taught
to understand that.  Otherwise, I do not think it would be hard to
create a suitable out-of-band interface for replication control.

Regards,

Daniel
