From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Shared snapshots
Date: Tue, 30 Mar 2010 23:43:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1003302342430.25360@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0912160255370.10656@hs20-bc2-1.build.redhat.com>
	<20091216203901.GA17098@redhat.com> <20100330162620.GA20000@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100330162620.GA20000@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

OK.

I removed the notion of cache-threshold and cache-limit, because it is 
being set in sysfs. (I also removed remains of it from the code).

Mikulas


On Tue, 30 Mar 2010, Mike Snitzer wrote:

> On Wed, Dec 16 2009 at  3:39pm -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > As an aside, I have some ideas for improving
> > Documentation/device-mapper/dm-multisnapshot.txt
> > I'll just send a patch and we can go from there.
> 
> OK, here is the updated dm-multisnapshot.txt (finally):
> 
> Device-mapper multiple snapshot support
> =======================================
> 
> Device-mapper allows a single copy-on-write (COW) block device to be
> shared among multiple snapshots of an origin device.  This variant of dm
> snapshot is ideal for supporting high numbers of snapshots.
> 
> There is a single dm target for the origin device:
> multisnapshot
> 
> and associated shared COW storage modules:
> mikulas - supports 2^32 snapshots and 2^32 snapshots of snapshots with
> 	  full consistency across crashes via journaling
> daniel  - only supports 64 snapshots and does not provide consistency
>           through journaling
> 
> The snapshots within the shared COW use a single dm target:
> multisnap-snap
> 
> *) multisnapshot <origin> <COW device> <chunksize>
>    <# generic args> <generic args> <shared COW store type>
>    <# shared COW store args> <shared COW store args>
>    [<# snapshot ids> <snapshot ids>]
> 
> Table line arguments:
> - <origin> : origin device
> - <COW device> : shared COW store device
> - <chunksize> : chunk size in 512b sectors
> - <# generic args> : number of generic arguments
> - <generic args> : generic arguments
> 	sync-snapshots --- synchronize snapshots according to the list
> 	preserve-on-error --- halt the origin on error in the snapshot store
> - <shared COW store type> : shared COW store type
> 	mikulas --- provided by the 'dm-store-mikulas' module
> 	daniel --- provided by the 'dm-store-daniel' module
> - <# shared COW store args> : number of arguments for shared COW store type
> - <shared COW store args> : shared COW store arguments
> 	cache-threshold size --- a background write is started
> 	cache-limit size --- a limit for metadata cache size
> If 'sync-snapshots' was specified:
> - <# snapshot ids> : number of snapshot ids
> - <snapshot ids> : snapshot ids in desired sync order
> 
> 
> *) multisnap-snap <origin> <snapshot id>
> 
> Table line arguments:
> - <origin> : origin device
> - <snapshot id> : id of the snapshot within the shared store
> 
> 
> Status output:
> *) multisnapshot <# output args> <errno> <new snapid>
>    <total_sectors> <sectors_allocated> <metadata_sectors>
>    <# snapshot ids> <snapshot ids>
> 
> Status line output arguments:
> - <# shared COW store output args> : number of output arguments before
>                                      snapshot id list
> - <errno> : error number associated with the first error that occurred in
>             the store (e.g. -EIO), 0 means the store is active with no errors
> - <new snapid> : snapshot id that will be used for next snapshot, '-' if
>                  no snapshot is in the process of being created
> - <total_sectors> : total size of the shared store in 512b sectors
> - <sectors_allocated> : number of sectors allocated for data and metadata
> - <metadata_sectors> : number of sectors allocated for metadata
> - <# snapshot ids> : number of snapshot ids
> - <snapshot ids> : snapshot ids for snapshots in the store
> 
> 
> Other tunables:
> *) multisnapshot (when using 'mikulas' store)
> The size of the metadata cache associated with the 'mikulas' shared COW
> store defaults to 2% of system memory or 25% of vmalloc memory (which
> ever is lower).  The size of the metadata cache may be overriden using
> the 'dm_bufio_cache_size' module parameter when loading the
> 'dm-store-mikulas' module.  Alternatively, the size may be changed or
> queried after the module is loaded via sysfs:
> /sys/module/dm_store_mikulas/parameters/dm_bufio_cache_size
> 
> 
> DM messages:
> *) multisnapshot
>    - create : creates next new snapshot id, reports created id through 'status'
>      (the snapshot is created once the multisnapshot is suspended)
>    - create_subsnap <snapshot id> : create subsnapshot of specified snapshot
>    - delete <snapshot id> : delete the specified snapshot
> 
> 
> Usage
> =====
> *) Create two logical volumes, one for origin and one for snapshots.
> (The following examples assume /dev/sda for origin and /dev/sdb for snapshot)
> 
> *) Clear the first 4 sectors of the snapshot volume:
> dd if=/dev/zero of=/dev/sdb bs=4096 count=1
> (Otherwise the multisnapshot target's constructor will fail)
> 
> *) Load the shared snapshot driver:
> ORIGIN_BDEV_SIZE=`blockdev --getsize /dev/sda`
> echo 0 $ORIGIN_BDEV_SIZE multisnapshot /dev/sda /dev/sdb 16 0 mikulas 0 | dmsetup create ms
> ('16' is the chunk size in 512-byte sectors. The chunk size may range
> from 1 to 1024 512-byte sectors via lvm. DM's maximum chunk size is only
> limited by 32-bit integer size and available memory)
> 
> This creates the multisnapshot device on /dev/mapper/ms. If the COW
> store was zeroed, it creates a new structure, otherwise it loads
> existing structure.
> 
> Once this is done, you should no longer access /dev/sda and
> /dev/sdb and only use /dev/mapper/ms.
> 
> *) Create new snapshot:
> ('0' in the following dmsetup message commands means sector arg isn't needed)
> dmsetup message /dev/mapper/ms 0 create
> 	If you want to create snapshot-of-snapshot, use:
> 	dmsetup message /dev/mapper/ms 0 create_subsnap <snapID>
> dmsetup status /dev/mapper/ms
> 	(this will display the newly created snapshot ID)
> dmsetup suspend /dev/mapper/ms
> dmsetup resume /dev/mapper/ms
> 
> *) Attach the snapshot:
> echo 0 $ORIGIN_BDEV_SIZE multisnap-snap /dev/sda <snapID> | dmsetup create ms0
> This attaches the snapshot with <snapID> to /dev/mapper/ms0
> 
> *) Delete the snapshot:
> dmsetup message /dev/mapper/ms 0 delete <snapID>
> 
> *) See shared store's status:
> dmsetup status /dev/mapper/ms
> (multisnapshot target's status output is documented above)
> 
> *) Unload it:
> dmsetup remove ms
> dmsetup remove ms0
> ... etc. (note, once you unload the origin, the snapshots become inaccessible
> - the devices exist but they return -EIO when accessed)
> 
> 
