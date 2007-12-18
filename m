From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Snapshots
Date: Tue, 18 Dec 2007 17:38:27 -0500
Message-ID: <47684BE3.5060408@ce.jp.nec.com>
References: <47682630.5060803@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47682630.5060803@cfl.rr.com>
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

Phillip Susi wrote:
> I have been playing around with the snapshot target with dmsetup, and I
> can set up a snapshot that diverts writes to a backing file, so that
> modifications to the snapshot device are discarded when I remove the
> snapshot device and go back to using the origin device.  What I can't
> figure out is how to keep the origin device mounted and have the
> snapshot device appear to contain the origin's data at the time it was
> created, even though the origin continues to be modified.
> 
> I thought one of the main ideas of the snapshot was to be able to backup
> a consistent filesystem image even though the filesystem continues to be
> written to, but it seems that having the origin device mounted gets an
> exclusive lock on it so that the snapshot device can not be targeted at
> it, so how do you do this?

LVM2 does it by putting a linear mapping on top of the origin device.

I'm not sure if this meets your requirement, but something like this:

1. Put a linear mapping on the origin
   (/dev/sdb2 is origin in this example)

# echo "0 $(blockdev --getsz /dev/sdb2) linear /dev/sdb2 0" | dmsetup create sdb2

2. Use the device as you like..

# mkfs.ext3 /dev/mapper/sdb2
# mount /dev/mapper/sdb2 /mnt/1
..

3. Insert a snapshot-origin map *below* the dm-linear

# dmsetup suspend sdb2
# echo $(dmsetup table sdb2) | dmsetup create sdb2-origin
# echo "0 $(blockdev --getsz /dev/mapper/sdb2-origin) snapshot-origin /dev/mapper/sdb2-origin" | dmsetup load sdb2
# dmsetup resume sdb2

4. Create any number of snapshots for the origin map

# echo "0 $(blockdev --getsz /dev/mapper/sdb2) snapshot /dev/mapper/sdb2-origin /dev/sdc2 P 8 " | dmsetup create
sdb2-snapshot
# dmsetup ls --tree
sdb2 (253:19)
 `-sdb2-origin (253:21)
    `- (8:18)
sdb2-snapshot1 (253:20)
 |- (8:34)
 `-sdb2-origin (253:21)
    `- (8:18)
# dmsetup table | grep sdb
sdb2: 0 15615180 linear 253:21 0
sdb2-snapshot1: 0 15615180 snapshot 253:21 8:34 P 8
sdb2-origin: 0 15615180 linear 8:18 0

If dm can insert a mapping *below* the device, you can do
without the dm-linear layer. But there's no such feature yet.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America
