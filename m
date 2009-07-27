From: Mikulas Patocka <mpatocka@redhat.com>
Subject: New kernel shared snapshots
Date: Mon, 27 Jul 2009 07:24:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907270657080.527@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi

The new release of shared snapshots can be found here:
http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/

It has the interface we talked about on Linux Tag.
So look at it as a last chance to review the interface. And also test it.


To create a snapshot, you have to:
- send a message
- ask for status, get the snapshot id
- suspend (this creates the snapshot, when the filesystem is quiescent)
- resume

Then, you can attach the snapshots by loading "multisnap-snap" target.

If the table line contains argument "sync-snapshots", it synchronizes the 
snapshot list against what is given on the table --- i.e. creates 
snapshots that are on the table but are not in the store and deletes those 
that are not in the store but are on the table.

Other changes:
- make more structures private (move them to dm-multisnap-private.h), so 
  that ABI doesn't change if these are chaged.
- snapshot IDs are treated as strings, not numbers.
- metadata cache size can be specified as an argument to the "mikulas" 
  exception store.
- an argument "preserve-on-error" that says that on error or overflow, 
  writes to the origin should be disabled.
	- if you don't specify this, the origin continues operation, but 
	snapshots are irreversibly damaged by this (use for non-important
	snapshots such as backups)
	- if you specify this, the data are always preserved, the whole
	thing just halts on error (user when snapshots contain some
	important data.
- fixed two bad bugs in dm-bufio.


Known bugs:
- that read-vs-realloc race (that I already fixed in the old snapshots a 
year ago) is present there. I'll fix it, but it isn't so trivial as in 
unshared snapshots.


Mikulas
