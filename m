From: "Ray Lauff" <spudly.mcgruff@gmail.com>
Subject: Device too small for target
Date: Mon, 19 Nov 2007 17:48:53 -0500
Message-ID: <c01151d00711191448u5ee6b92buec5b336133736060@mail.gmail.com>
Reply-To: spudly.mcgruff@gmail.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello all-

I have a 7.4Tb lvm2 volume that was working fine until this morning,
when I rebooted the server.  It was a 600Gb disk that I did a

     lvextend -L+6.7T /dev/homegroup/home
     resize2fs /dev/homegroup/home

on last week, and that disk worked fine all week.  During reboot, I
get the messages

    kernel: device-mapper: table: device 8:193 too small for target
    kernel: device-mapper: table: 253:0: linear: dm-linear: Device lookup failed
    kernel: device-mapper: ioctl: error adding target to table

and, needless to say, the disk won't come up

    # mount /dev/mapper/homegroup-home /home -t ext3
    mount: wrong fs type, bad option, bad superblock on
/dev/mapper/homegroup-home,
           missing codepage or other error
           (could this be the IDE device where you in fact use
           ide-scsi so that sr0 or sda or so is needed?)
           In some cases useful info is found in syslog - try
           dmesg | tail  or so

I've also tried a fsck, but that comes back with

    fsck -t ext3 /dev/mapper/homegroup-home
    fsck 1.39 (29-May-2006)
    e2fsck 1.39 (29-May-2006)
    fsck.ext3: Invalid argument while trying to open /dev/mapper/homegroup-home

     The superblock could not be read or does not describe a correct ext2
    filesystem.  If the device is valid and it really contains an ext2
    filesystem (and not swap or ufs or something else), then the superblock
    is corrupt, and you might try running e2fsck with an alternate superblock:
        e2fsck -b 8193 <device>

Kernel is 2.6.18-8.1.10.el5PAE.

Is there something else I need to do with the device mapper to change
the size of something for this larger lvm?

    # lvs
    LV   VG        Attr   LSize Origin Snap%  Move Log Copy%
    home homegroup -wi-d- 7.35T

The hardware all appears to be fine (it's an EMC SAN).

I apologize if this isn't the best place to ask this, but if anyone
has any experience with this error I'd appreciate any help on
correcting it.  If there's a better list for this question please
point me there and I'll go away.

Thanks.
