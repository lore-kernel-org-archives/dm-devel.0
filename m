From: "Sampathkumar, Kishore" <Kishore.SampathKumar@lsi.com>
Subject: question on hot plug removal and addition of a USB disk
Date: Thu, 15 Sep 2011 02:22:59 +0530
Message-ID: <E4D7778E36CF944ABD2F7E18D2DB96660CA26D8EF0@inbmail02.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

I sent the below query (appended in this email) to linux-scsi and linux-hotplug mailing lists.
I wanted to know how Device Mapper handles backend disks managed by Device mapper targets.
Consider the below command:

# dmsetup create linear-map linear-map-table
where, linear-map-table contains:
       0 1028160 linear /dev/sda 0
       1028160 3903762 linear /dev/sdb 0

Now, when the above is executed, does device mapper open /dev/sda and /dev/sdb, and continue to maintain reference counts to the underlying SCSI block devices in the kernel corresponding to them?

Assume that on successful completion of the above command, a file system is created on /dev/mapper/linear-map and then mounted on /mnt. Let us say /dev/sdb corresponds to a USB disk. Suppose this USB disk is pulled out (hot plug removal), and then added back after some time (hot plug addition). Let us assume that the USB disk is untouched between removal and insertion. The USB disk on re-insertion gets a different name (say /dev/sde). Given the below context, what are the specific steps the user has to follow to ensure that the file system access can resume on the USB disk that was hot-plug added? So, do we have to redo the dmsetup command with /dev/sde in place of /dev/sdb? How do we do that when the file system is still mounted?

Thanks,
- Kishore

-----Original Message-----
From: Sampathkumar, Kishore 
Sent: Thursday, September 15, 2011 1:54 AM
To: 'linux-hotplug@vger.kernel.org'
Subject: question on hot plug removal and addition of a USB disk

I sent the below query to linux-scsi. Thought it would be better to check on the linux-hotplug mailing list.
Can you please provide the details of the expected behavior, and where in the code should I look for details?

Thanks and Regards,
- Kishore

-----Original Message-----
From: Sampathkumar, Kishore 
Sent: Wednesday, September 14, 2011 7:47 PM
To: 'linux-scsi@vger.kernel.org'
Subject: question on hot plug removal and addition of a USB disk

Scenario: I have a file system on a USB SCSI disk /dev/sdb mounted on /mnt.
I perform Action 1 below, and after some time, perform Action 2 below.

Action 1: removal (unplug) of a USB disk

At the time of removal of the USB disk, since the file system was mounted, is the reference to kobject corresponding (now orphaned) sdb still maintained in the kernel, although /dev/sdb is gone due to disk removal?

Is it that the old scsi_disk (sdb) still persists, but, the underlying scsi_dev is removed? Where should I start to trace the hotplug removal of the USB disk? What are the specific processing steps involved in the kernel to handle this (in terms of main routines handling this)?

Action 2: (hot) plug addition of the same USB SCSI disk

On plugging in the same USB SCSI disk, does the sd layer in scsi subsystem grab the first available 'free' sdX device (say sdp), given that sdb is still being referenced by the mounted file system?

Again, in terms of code, does this correspond to:
-	a new scsi_dev being allocated
-	a corresponding scsi_disk for sdp being allocated by the sd layer in scsi subsystem as part of 'probe' for the added SCSI device

Does the hot plugging work the same way for SAS disks attached behind a FC switch?

Thanks,
-	Kishore
