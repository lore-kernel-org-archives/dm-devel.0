From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH v2 0/5] dm-replicator: introduce new remote
	replication target
Date: Thu, 26 Nov 2009 10:21:15 -0600
Message-ID: <1259252475.7584.46.camel@mulgrave.site>
References: <1259238592-12439-1-git-send-email-heinzm@redhat.com>
	<1259248689.7584.8.camel@mulgrave.site> <1259251972.11469.13.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1259251972.11469.13.camel@o>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2009-11-26 at 17:12 +0100, Heinz Mauelshagen wrote:
> On Thu, 2009-11-26 at 09:18 -0600, James Bottomley wrote:
> > On Thu, 2009-11-26 at 13:29 +0100, heinzm@redhat.com wrote:
> > > From: Heinz Mauelshagen <heinzm@redhat.com>
> > > 
> > > 
> > > * 2nd version of patch series (dated Oct 23 2009) *
> > > 
> > > This is a series of 5 patches introducing the device-mapper remote
> > > data replication target "dm-replicator" to kernel 2.6.
> > > 
> > > Userspace support for remote data replication will be in
> > > a future LVM2 version.
> > > 
> > > The target supports disaster recovery by replicating groups of active
> > > mapped devices (ie. receiving io from applications) to one or more
> > > remote sites to paired groups of equally sized passive block devices
> > > (ie. no application access). Synchronous, asynchronous replication
> > > (with fallbehind settings) and temporary downtime of transports
> > > are supported.
> > > 
> > > It utilizes a replication log to ensure write ordering fidelity for
> > > the whole group of replicated devices, hence allowing for consistent
> > > recovery after failover of arbitrary applications
> > > (eg. DBMS utilizing N > 1 devices).
> > > 
> > > In case the replication log runs full, it is capable to fall back
> > > to dirty logging utilizing the existing dm-log module, hence keeping
> > > track of regions of devices wich need resynchronization after access
> > > to the transport returned.
> > > 
> > > Access logic of the replication log and the site links are implemented
> > > as loadable modules, hence allowing for future implementations with
> > > different capabilities in terms of additional plugins.
> > > 
> > > A "ringbuffer" replication log module implements a circular ring buffer
> > > store for all writes being processed. Other replication log handlers
> > > may follow this one as plugins too.
> > > 
> > > A "blockdev" site link module implements block devices access to all remote
> > > devices, ie. all devices exposed via the Linux block device layer
> > > (eg. iSCSI, FC).
> > > Again, other eg. network type transport site link handlers may
> > > follow as plugins.
> > > 
> > > Please review for upstream inclusion.
> > 
> > So having read the above, I don't get what the benefit is over either
> > the in-kernel md/nbd ... which does intent logging, or over the pending
> > drbd which is fairly similar to md/nbd but also does symmetric active
> > replication for clustering.
> 
> This solution combines multiple devices into one entity and ensures
> write ordering on it as a whole like mentioned above, which is mandatory
> to allow for applications utilizing multiple devices being replicated to
> recover after a failover (eg. multi device DB).
> No other open source solution supports this so far TTBOMK.

Technically they all do that.  The straight line solution to the problem
is to use dm to combine the two devices prior to the replication pipe
and split them again on the remote.

> It is not limited to 2-3 sites but supports up to 2048, which ain't
> practical I know but there's no artifical limit in practical terms.

md/nbd supports large numbers of remote sites too ... not sure about
drbd.

> The design of the device-mapper remote replicator is open to support
> active-active with a future replication log type. Code from DRBD may as
> well fit into that.

OK, so if the goal is to provide infrastructure to unify our current
replicators, that makes a lot more sense ... but shouldn't it begin with
modifying the existing rather than adding yet another replicator?

> > Since md/nbd implements the writer in userspace, by the way, it already
> > has a userspace ringbuffer module that some companies are using in
> > commercial products for backup rewind and the like.  It strikes me that
> > the userspace approach, since it seems to work well, is a better one
> > than an in-kernel approach.
> 
> The given ringbuffer log implementation is just an initial example,
> which can be replaced by enhanced ones (eg. to support active-active).
> 
> Would be subject to analysis if callouts to userspace might help.
> Is the userspace implementation capable of journaling multiple devices
> or just one, which I assume ?

It journals one per replication stream.  I believe the current
implementation, for performance, is a remotely located old data
transaction log (since that makes rewind easier).  Your implementation,
by the way: local new data transaction log has nasty performance
implications under load because of the double write volume.

James
