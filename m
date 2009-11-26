From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH v2 0/5] dm-replicator: introduce new remote
	replication target
Date: Thu, 26 Nov 2009 11:04:48 -0600
Message-ID: <1259255088.7584.62.camel@mulgrave.site>
References: <1259238592-12439-1-git-send-email-heinzm@redhat.com>
	<1259248689.7584.8.camel@mulgrave.site> <1259251972.11469.13.camel@o>
	<1259252475.7584.46.camel@mulgrave.site> <1259253835.11469.40.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1259253835.11469.40.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, 2009-11-26 at 17:43 +0100, Heinz Mauelshagen wrote:
> On Thu, 2009-11-26 at 10:21 -0600, James Bottomley wrote:
> > On Thu, 2009-11-26 at 17:12 +0100, Heinz Mauelshagen wrote:
> > > On Thu, 2009-11-26 at 09:18 -0600, James Bottomley wrote:
> > > > On Thu, 2009-11-26 at 13:29 +0100, heinzm@redhat.com wrote:
> > > > > From: Heinz Mauelshagen <heinzm@redhat.com>
> > > > > 
> > > > > 
> > > > > * 2nd version of patch series (dated Oct 23 2009) *
> > > > > 
> > > > > This is a series of 5 patches introducing the device-mapper remote
> > > > > data replication target "dm-replicator" to kernel 2.6.
> > > > > 
> > > > > Userspace support for remote data replication will be in
> > > > > a future LVM2 version.
> > > > > 
> > > > > The target supports disaster recovery by replicating groups of active
> > > > > mapped devices (ie. receiving io from applications) to one or more
> > > > > remote sites to paired groups of equally sized passive block devices
> > > > > (ie. no application access). Synchronous, asynchronous replication
> > > > > (with fallbehind settings) and temporary downtime of transports
> > > > > are supported.
> > > > > 
> > > > > It utilizes a replication log to ensure write ordering fidelity for
> > > > > the whole group of replicated devices, hence allowing for consistent
> > > > > recovery after failover of arbitrary applications
> > > > > (eg. DBMS utilizing N > 1 devices).
> > > > > 
> > > > > In case the replication log runs full, it is capable to fall back
> > > > > to dirty logging utilizing the existing dm-log module, hence keeping
> > > > > track of regions of devices wich need resynchronization after access
> > > > > to the transport returned.
> > > > > 
> > > > > Access logic of the replication log and the site links are implemented
> > > > > as loadable modules, hence allowing for future implementations with
> > > > > different capabilities in terms of additional plugins.
> > > > > 
> > > > > A "ringbuffer" replication log module implements a circular ring buffer
> > > > > store for all writes being processed. Other replication log handlers
> > > > > may follow this one as plugins too.
> > > > > 
> > > > > A "blockdev" site link module implements block devices access to all remote
> > > > > devices, ie. all devices exposed via the Linux block device layer
> > > > > (eg. iSCSI, FC).
> > > > > Again, other eg. network type transport site link handlers may
> > > > > follow as plugins.
> > > > > 
> > > > > Please review for upstream inclusion.
> > > > 
> > > > So having read the above, I don't get what the benefit is over either
> > > > the in-kernel md/nbd ... which does intent logging, or over the pending
> > > > drbd which is fairly similar to md/nbd but also does symmetric active
> > > > replication for clustering.
> > > 
> > > This solution combines multiple devices into one entity and ensures
> > > write ordering on it as a whole like mentioned above, which is mandatory
> > > to allow for applications utilizing multiple devices being replicated to
> > > recover after a failover (eg. multi device DB).
> > > No other open source solution supports this so far TTBOMK.
> > 
> > Technically they all do that.  The straight line solution to the problem
> > is to use dm to combine the two devices prior to the replication pipe
> > and split them again on the remote.
> 
> How would that (presumably existing) way to combine via dm ensure write
> ordering? No target allows for that so far.

Yes they do.

The theory of database multiple device use is that the OS guarantees no
ordering at all, so the DB has to impose ordering on top of the OS
semantics, which it does by delaying writes for dependent write commit
acknowledgements.  The way most replication systems work is that the
network order follows the ack order, so as long as you combine the
stream above the acks (which is what dm does) the semantic guarantee is
sufficient to satisfy the DB ordering problem (because of the extra work
the DB does to impose ordering).  This is textbook 101 DB multi volume
replication ... virtually every replication system uses this.  Actually
the only exception I know is windows replicators ... they have a sync
barrier scheme usually because device stacking doesn't work very well in
windows systems.

> That's what the multi-device replication log in dm-replicator is about.
> 
> > 
> > > It is not limited to 2-3 sites but supports up to 2048, which ain't
> > > practical I know but there's no artifical limit in practical terms.
> > 
> > md/nbd supports large numbers of remote sites too ... not sure about
> > drbd.
> 
> 3 sites.
> 
> > 
> > > The design of the device-mapper remote replicator is open to support
> > > active-active with a future replication log type. Code from DRBD may as
> > > well fit into that.
> > 
> > OK, so if the goal is to provide infrastructure to unify our current
> > replicators, that makes a lot more sense ... but shouldn't it begin with
> > modifying the existing rather than adding yet another replicator?
> 
> I spend time to analyse if that was feasible (ie. DRBD -> dm
> integration) but DRBD is a standalone driver which makes it hard to
> cherry-pick logic because of the way it is modularized. The DRBD folks
> actually have been nice by offering capacity for a dm port but didn't
> get to it so far.

and md/nbd, which is currently in-kernel?

> > 
> > > > Since md/nbd implements the writer in userspace, by the way, it already
> > > > has a userspace ringbuffer module that some companies are using in
> > > > commercial products for backup rewind and the like.  It strikes me that
> > > > the userspace approach, since it seems to work well, is a better one
> > > > than an in-kernel approach.
> > > 
> > > The given ringbuffer log implementation is just an initial example,
> > > which can be replaced by enhanced ones (eg. to support active-active).
> > > 
> > > Would be subject to analysis if callouts to userspace might help.
> > > Is the userspace implementation capable of journaling multiple devices
> > > or just one, which I assume ?
> > 
> > It journals one per replication stream.  I believe the current
> > implementation, for performance, is a remotely located old data
> > transaction log (since that makes rewind easier).  Your implementation,
> > by the way: local new data transaction log has nasty performance
> > implications under load because of the double write volume.
> 
> That only applies to synchronous replication, where the application by
> definition has to wait for the data to hit the (remote) device.
> 
> In the asynchronous case, endio is being reported when the data has hit
> the replication logs backing store together with metadata describing it
> (sector/device/size).

Actually, no, that's the wrong analysis.  It only applies if your log is
infinite and you don't have any time constraints on the remote.

The correct analysis for a functioning system is a steady state one.
That assumes that, although we can cope with bursting, primarily a write
goes in one end and one at the other end gets committed and transmitted.
That gives you a steady state data load of two writes and a net packet
for every one write going in.

This isn't necessarily bad:  it's exactly what the veritas replicator
does, for instance ... and many sites are happy to provision 2x the disk
bandwidth in exchange for data integrity of replication.

> But ok, in theory you've found one example for another replication log
> type (call it redirector log), which allows writes to go through to the
> fast local devices unless entries get written over, where we need to
> journal them. Again that only gives an advantage for asynchronous
> replication, because any synchronous site link will throttle the io
> stream.

That's pretty much an intent log.  However, it doesn't work well for
database workloads because the DB log gets overwritten on each
transaction.

James
