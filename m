From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Recommendations for cascaded snapshots
Date: Sun, 1 Oct 2006 15:12:01 -0400
Message-ID: <D47F6AD4-A487-41B7-8576-D480D50E9F23@mac.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
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
To: Device-Mapper Devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi, I've begun looking at using device-mapper on one of my linux  
servers to store a series of "points in time" of a data volume  
without chewing up excessive quantities of disk space.  I'm currently  
using LVM for volume management, but the LVM snapshot functionality  
seemed too simple to handle what I want.

Basically I'm looking for a tiered set of snapshots, so that I have a  
snapshot for every day of the last week, one for sunday every week of  
the last month, one for the first day of every month for the last  
year, and one for the first of January every year.

Firstly, this is around 16-20 snapshots or so; how scalable is the dm- 
snapshot system in 2.6.18?  Would a dual-core home-office fileserver  
with 1GB of RAM be able to handle that number of snapshots?

Another quickie question:  How can I measure the current %use of a  
given snapshot device?  I'm going to have some automated cronjobs  
which automatically resize my LVM devices based on disk consumption  
and whether or not that snapshow-backend device is expected to get  
more changes, but I can't figure out how to get at the amount-free  
information.

My first "solution" was to use stacked snapshots such that the  
"origin" was the raw block device populated with our current data,  
and each snapshot is the changes until the next recorded point-in- 
time, but I ran into a few problems.  First of all, it doesn't seem  
possible to merge two snapshots together; for example if I have Nov  
30th and Dec 1st snapshots, at some point I don't care about the  
specific Nov 30th changes anymore and I want to merge the Dec 1st  
snapshot ontop of the Nov 30th one and then drop the now-empty Dec  
1st snapshot (renaming the Nov 30th one as Dec 1st).

I was able to find this patchset:
http://www.gnome.org/~markmc/code/lvm-snapshot-merging/

referenced here:
http://fedoraproject.org/wiki/StatelessLinuxCachedClient

which talked about a dm snapshot-merge target which ran a kernel  
thread to merge changes back into a lower-level device, solving the  
problem above; but I couldn't determine how stable it was or whether  
or not it applied to recent kernels.

Potentially I could even implement the merging in userspace without  
too much difficulty if the on-disk exception format was documented  
somewhere useful, but I have yet to find anything detailed and  
consise enough to make this practical for me; perhaps someone on the  
list has better information?

Another concern is the computational and disk overhead of having 30  
chained snapshots, as the exceptions would be scattered across ~16  
logical volumes and every read from the _current_ volume would need  
to scan through all 16 exception tables.

Alternatively I was considering having the "current" go to the  
snapshot-origin target and a series of snapshot-device-stacked-on- 
snapshot-device.  For example, when I do my midnight snapshot, I  
would have the devices like this:

data:
0 $SIZE snapshot-origin /dev/mapper/data-origin

data-back1:
0 $SIZE snapshot /dev/mapper/data-origin /dev/mapper/data-excp1 p 32

data-prev1:
0 $SIZE snapshot-origin /dev/mapper/back1

data-snap0:
0 $SIZE snapshot /dev/mapper/back1 /dev/mappper/data-excp0 p 32

data-prev0:
0 $SIZE snapshot-origin /dev/mapper/back0

I would mount as follows:
/dev/mapper/data  => /data (rw)
/dev/mapper/prev1 => /data/backup/2006-10-02 (ro)
/dev/mapper/prev0 => /data/backup/2006-10-01 (ro)

Then at midnight when chaining a new snapshot, I would:
  1) create a new empty snapshot blockdev
  2) suspend data and data-back1
  3) insert data-excp000002 under data-back000001 like this:

data-back000002:
0 $SIZE snapshot /dev/mapper/data-origin /dev/mapper/data-excp000002  
p 32

data-prev000002:
0 $SIZE snapshot-origin /dev/mapper/data-back000002

data-back000001:
0 $SIZE snapshot /dev/mapper/data-back000002 /dev/mapper/data- 
excp000001 p 32

  4) Resume data-back1 and data-origin
  5) Mount data-back2 on /data/backup/2006-10-03 (ro)

This means that the only performance penalty would be accessing data  
far in the past, although I still need to figure out some way to  
merge an unneeded snapshot into another one so I can free up the  
space used by the unneeded snapshot.

As you might expect I'm writing perl scripts to store the state of my  
snapshot-tree on-disk and automate the snapshotting process.

I appreciate any advice you can offer; especially pertaining to  
merging a snapshot into its base device.

Cheers,
Kyle Moffett
