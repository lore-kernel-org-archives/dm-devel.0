From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Shared snapshots
Date: Thu, 17 Dec 2009 11:32:31 -0500
Message-ID: <20091217163230.GB24072@redhat.com>
References: <Pine.LNX.4.64.0912160255370.10656@hs20-bc2-1.build.redhat.com>
	<20091216203901.GA17098@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091216203901.GA17098@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Dec 16 2009 at  3:39pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Dec 16 2009 at  3:05am -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
...
> > - Exposed interface for snapshots-of-snapshots, tested that they work
> 
> Where is that interface documented?

I see the 'dmsetup message ...' to do so is quietly mentioned in the
"Create new snapshot" section of the documentation.

> As an aside, I have some ideas for improving
> Documentation/device-mapper/dm-multisnapshot.txt
> I'll just send a patch and we can go from there.

The inlined [TODO: ...] comments in the following patch are things I'm
looking to understand by reviewing the code; but I think they should be
answered in the Documentation.  I wanted to get you my edits sooner
rather than later.

diff --git a/Documentation/device-mapper/dm-multisnapshot.txt b/Documentation/device-mapper/dm-multisnapshot.txt
index 0dff16e..d730d3a 100644
--- a/Documentation/device-mapper/dm-multisnapshot.txt
+++ b/Documentation/device-mapper/dm-multisnapshot.txt
@@ -1,64 +1,90 @@
-This snapshot implementation has shared storage and high number of snapshots.
+Device-mapper multiple snapshot support
+=======================================
 
-The work is split to two modules:
-dm-multisnapshot.ko - the general module
-dm-store-mikulas.ko - the snapshot store
+Device-mapper allows a single copy-on-write (COW) block device to be
+shared among multiple snapshots of an origin device.  This variant of dm
+snapshot is ideal for supporting high numbers of snapshots.  It also
+supports snapshots of snapshots.
 
-The modularity allows to load other snapshot stores.
+There is a single dm target:
+multisnapshot
 
-Usage:
-Create two logical volumes, one for origin and one for snapshots.
-(assume /dev/mapper/vg1-lv1 for origin and /dev/mapper/vg1-lv2 for snapshot in
-these examples)
+and associated shared COW storage modules:
+mikulas
+daniel
 
-Clear the first sector of the snapshot volume:
-dd if=/dev/zero of=/dev/mapper/vg1-lv2 bs=4096 count=1
+[TODO: expand on the benefits/design of each store; so as to help a user
+       decide between them?]
+
+*) multisnapshot <origin> <COW device> <chunksize>
+   <# generic args> <generic args> <shared COW store type>
+   <# shared COW store args> <shared COW store args>
+   [<# snapshot ids> <snapshot ids>]
 
 Table line arguments:
-- origin device
-- shared store device
-- chunk size
-- number of generic arguments
-- generic arguments
+- <origin> : origin device
+- <COW device> : shared COW store device
+- <chunksize> : chunk size
+- <# generic args> : number of generic arguments
+- <generic args> : generic arguments
 	sync-snapshots --- synchronize snapshots according to the list
 	preserve-on-error --- halt the origin on error in the snapshot store
-- shared store type
-- number of arguments for shared store type
-- shared store arguments
+- <shared COW store type> : shared COW store type
+	mikulas --- TODO
+	daniel --- TODO
+- <# shared COW store args> : number of arguments for shared COW store type
+- <shared COW store args> : shared COW store arguments
 	cache-threshold size --- a background write is started
 	cache-limit size --- a limit for metadata cache size
-if sync-snapshots was specified
-	- number of snapshot ids
-	- snapshot ids
+If 'sync-snapshots' was specified:
+- <# snapshot ids> : number of snapshot ids
+- <snapshot ids> : snapshot ids in desired sync order
+
+
+Usage
+=====
+*) Create two logical volumes, one for origin and one for snapshots.
+(The following examples assume /dev/mapper/vg1-lv1 for origin and
+/dev/mapper/vg1-lv2 for snapshot)
+
+*) Clear the first 4 sectors of the snapshot volume:
+[TODO: I see below that the store will create a new metadata structure if
+the snapshot device were zero'd.  What if it wasn't zero'd and the
+device still has data?  Appears the ctr will error out.  So will lvm
+blindly zero any device that it is told to use for a multisnap store?]
+dd if=/dev/zero of=/dev/mapper/vg1-lv2 bs=4096 count=1
 
-Load the shared snapshot driver:
+*) Load the shared snapshot driver:
 echo 0 `blockdev --getsize /dev/mapper/vg1-lv1` multisnapshot /dev/mapper/vg1-lv1 /dev/mapper/vg1-lv2 16 0 mikulas 0|dmsetup create ms
-(16 is the chunk size in 512-byte sectors. You can place different number there)
-This creates the origin store on /dev/mapper/ms. If the store was zeroed, it
-creates new structure, otherwise it loads existing structure.
+(16 is the chunk size in 512-byte sectors. You can place a different
+number there. [TODO: what is the limit?])
+This creates the origin store on /dev/mapper/ms. If the COW store was
+zeroed, it creates new structure, otherwise it loads existing structure.
 
 Once this is done, you should no longer access /dev/mapper/vg1-lv1 and
 /dev/mapper/vg1-lv2 and only use /dev/mapper/ms.
 
-Create new snapshot:
+*) Create new snapshot:
+[TODO: what is the '0' in the following messages?]
 dmsetup message /dev/mapper/ms 0 create
-	If you want to create snapshot-of-snapshot, use
+	If you want to create snapshot-of-snapshot, use:
 	dmsetup message /dev/mapper/ms 0 create_subsnap <snapID>
 dmsetup status /dev/mapper/ms
-	(this will find out the newly created snapshot ID)
+	(this will display the newly created snapshot ID)
+	[TODO: how will that scale? Does the status output sort based on
+	creation time?  maybe show example output?]
 dmsetup suspend /dev/mapper/ms
 dmsetup resume /dev/mapper/ms
 
-Attach the snapshot:
-echo 0 `blockdev --getsize /dev/mapper/vg1-lv1` multisnap-snap /dev/mapper/vg1-lv1 0|dmsetup create ms0
-(that '0' is the snapshot id ... you can use different number)
-This attaches the snapshot '0' on /dev/mapper/ms0
+*) Attach the snapshot:
+echo 0 `blockdev --getsize /dev/mapper/vg1-lv1` multisnap-snap /dev/mapper/vg1-lv1 <snapID>|dmsetup create ms0
+This attaches the snapshot with <snapID> to /dev/mapper/ms0
 
-Delete the snapshot:
-dmsetup message /dev/mapper/ms 0 delete 0
-(the parameter after "delete" is the snapshot id)
+*) Delete the snapshot:
+dmsetup message /dev/mapper/ms 0 delete <snapID>
 
-See status:
+*) See status:
+[TODO: could use some further cleanup.. maybe show example output?]
 dmsetup status prints these information about the multisnapshot device:
 - number of arguments befor the snapshot id list (5)
 - 0 on active storage, -error number on error (-ENOSPC, -EIO, etc.)
@@ -69,9 +95,9 @@ dmsetup status prints these information about the multisnapshot device:
 - a number of snapshots
 - existing snapshot IDs
 
-Unload it:
+*) Unload it:
 dmsetup remove ms
 dmsetup remove ms0
 ... etc. (note, once you unload the origin, the snapshots become inaccessible
-- the devices exist but they return -EIO on everything)
+- the devices exist but they return -EIO when accessed)
 
