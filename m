From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH v3 0/4] dm-replicator: introduce new remote
	replication target
Date: Tue, 01 Dec 2009 18:18:39 +0100
Message-ID: <1259687919.9639.15.camel@o>
References: <1259683507-12455-1-git-send-email-heinzm@redhat.com>
	<20091201164142.GL19238@suse.de>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091201164142.GL19238@suse.de>
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

On Tue, 2009-12-01 at 17:41 +0100, Lars Marowsky-Bree wrote:
> On 2009-12-01T17:05:03, heinzm@redhat.com wrote:
> 
> > * 3rd version of patch series (dated Oct 23 2009) *
> > 
> > Reworked to allow for Build after each single patch has been applied.
> 
> Hi Heinz, have you considered a git tree? Might make it easier to review
> changes.

Hi Lars,

got an internal one but no public git so far.

> 
> > This is a series of 4 patches introducing the device-mapper remote
> > data replication target "dm-replicator" to kernel 2.6.
> > 
> > Userspace support for remote data replication will be in
> > a future LVM2 version.
> 
> Is there any code available for testing this yet?

Zdenek's patches for lvm2 on lvm-devel.
If you want to at the dm level, I can send you test scripts to create
test LVs and utiluze them as devices for the replicator.

> 
> > The target supports disaster recovery by replicating groups of active
> > mapped devices (ie. receiving io from applications) to one or more
> > remote sites to paired groups of equally sized passive block devices
> > (ie. no application access). Synchronous, asynchronous replication
> > (with fallbehind settings) and temporary downtime of transports
> > are supported.
> 
> How is resync handled - peer-to-peer or relayed via the master?

All io activity is driven by the master in this initial version.
Ie. resync happens with the primary site as the source for all the
remote ones.

>  
> 
> What about device failures / IO errors at the sites?

The replication log retries until the administrator decides to drop the
broken devices. Requirement is to have at least RAID1 in a storage
appliance remotely. It would work w/o such resilience though.

> 
> > It utilizes a replication log to ensure write ordering fidelity for
> > the whole group of replicated devices, hence allowing for consistent
> > recovery after failover of arbitrary applications
> > (eg. DBMS utilizing N > 1 devices).
> 
> Write ordering is not guaranteed across different file systems / block
> devices today; so no DBMS actually requires this. What is the benefit?

W/o replication at the block level, no application needs it because a
local flush will do at application consistency points. With replication,
we only have data sets corresponding to such consistency points in the
log as sequentially ordered entries. In order to allow for application
recovery in remote sites, we need to ensure write-ordering so that any
data commits will follow the data. Otherwise we'd end up with finding a
commit record remotely but not the full data set commited by it, hence
causing data corruption.

> 
> What kind of reordering on a per-device basis is allowed via this
> infrastructure at each site? (drbd has logic to detect implicit write
> dependencies to allow peers to optimize local IO.)

No reordering allowed so far. Any such write dependency optimization is
subject to another replication log handler implentation which could
potentially take advantage of given DRBD logic. Surely we've got
optimization potential...

> 
> > A "blockdev" site link module implements block devices access to all remote
> > devices, ie. all devices exposed via the Linux block device layer
> > (eg. iSCSI, FC).
> 
> > Again, other eg. network type transport site link handlers may
> > follow as plugins.
> 
> How is all of this actually configured and used?

Via the above mentioned LVM2 patches.
Ie. lvm command extensions.

> 
> > Please review for upstream inclusion.
> 
> Should this not be Cc'ed to LKML if you aim for upstream inclusion? I
> actually would expect that most of the criticism of drbd's inclusion
> would also apply here, no? (With the added point that dm-replicator does
> not actually have any users yet.)

We have a series of patches to sort out basic issues on dm-devel.
The usual process is, that agk as the subsystem maintainer integrates
and upstreams it.

Regards,
Heinz

> 
> 
> Regards,
>     Lars
> 
