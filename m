From: "Liuhua Wang" <lwang@suse.com>
Subject: pvmove/mirror target mirroring data between two devices
 with different sector size
Date: Sun, 27 Mar 2016 22:00:55 -0600
Message-ID: <56F94727020000A000058AA7@prv-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Neil F Brown <neilb@suse.com>
List-Id: dm-devel.ids

Hi List,

I have a question that I think maybe you can give me some idea.

I have two devices with different sector size: 512B and 4096B.

- SOURCE DEVICE (mdos lvm partiton)
#parted /dev/sdb
Model: ATA SATADOM-SL 3ME (scsi)
Disk /dev/sdb: 32.0GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
(In `parted` Sector size are both got from IOCTL(BLKSSZGET))

- TARGET DEVICE (WHOLE DISK)
#parted /dev/sdc
Error: /dev/sdd: unrecognised disk label
Model: ATA HUH728080ALN600 (scsi)
Disk /dev/sdd: 8002GB
Sector size (logical/physical): 4096B/4096B
Partition Table: unknown

I want to move data from one device to the other using lvm command
`pvmove`, but after pvmove, file system cannot mount.

So my question is whether pvmove support moving date between devices with different sector size
or same question: mirror target support mirroring data between two devices with different sector size?

Thank you in advance.

Best regards,
Liuhua
