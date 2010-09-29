From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] dm-thinp: new device mapper target to thin
 provision storage
Date: Wed, 29 Sep 2010 13:25:12 +0200
Message-ID: <1285759512.23010.1.camel@o>
References: <1285706977.22966.20.camel@o>  <4CA261C5.7070005@cfl.rr.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4CA261C5.7070005@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Tue, 2010-09-28 at 17:44 -0400, Phillip Susi wrote:
> On 9/28/2010 4:49 PM, Heinz Mauelshagen wrote:
> > 
> > These are 2 new device mapper targets "thinp" and "thinp-dev"
> > implemented in one module, which allow for thin provisioning of storage
> > on a single host from a storage pool to an arbitrary amount of devices.
> 
> How is this different than snapshotting a zero target?

Like Hanness mentioned: you can free space.

> 
> > +Create an ext4 filesystem on the thin provisioned device:
> > +mkfs -t ext4 /dev/mapper/thinp1
> 
> FYI, that tends to spend a lot of time writing hundreds of mb of zeros
> to the inode tables, allocating chunks from the backing store.  You
> might want to add -E lazy_itable_init to stop that.

Thanks for the hint, I waned to have load on the thin provisioned
devices so far for testing but will have a look at the reduced
allocations with this option.

> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
