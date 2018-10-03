From: Joe Thornber <thornber@redhat.com>
Subject: Re: extracting thin mappings in real time
Date: Wed, 3 Oct 2018 14:03:33 +0100
Message-ID: <20181003130333.GA20800@reti>
References: <CA+fs2JN0evmnJP2yZT144bUOdxaxUydchXrZmLmFVy4F20yfAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CA+fs2JN0evmnJP2yZT144bUOdxaxUydchXrZmLmFVy4F20yfAA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thanos Makatos <thanos.makatos@sunlight.io>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 03, 2018 at 01:40:22PM +0100, Thanos Makatos wrote:
> I have a kernel module that sits on top of a thin device mapper target that
> receives block I/O requests and re-submits then to the thin target. I would
> like to implement the following functionality: whenever I receive a write
> completion from the thin target (assuming that it's the first time a block
> written to) I would like to extract the newly-established mapping of that
> virtual block.
> 
> I know that I can do this using thin_dump, however this involves:
> (1) spawning a process
> (2) reserving/releasing a metadata snapshot, and
> (3) dumping _all_ the mappings.
> 
> In other words, it's far to heavyweight for my performance requirements.
> 
> Ideally I would like to be able to obtain the mapping in kernel space. I
> had a look at thin_dump and from what I understand it directly reads the
> B-tree from the disk? Is there some kernel function that already does this?
> E.g. given a thin LBA return the physical block address.
> 
> Also, regarding having to have reserved a metadata snapshot, is this
> necessary for obtaining mappings? Aren't mappings immutable once established
> ?

Could you say more about why you want to do this?

Mappings don't change if you're not using snapshots.  If you are, then any write
to a shared block will trigger a copy on write operation, and subsequently a new
mapping.

So for backups etc. I made the metadata snapshot available, which gives you a
view of all the metadata frozen at a point in time.  If you're using the metadata
snap you still need to guarantee the mappings for the devices that you're interested
in are not changing.  eg, instead of backing up a live thin, take a snapshot of the thin
and back this up instead.

- Joe
