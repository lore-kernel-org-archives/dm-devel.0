From: "Gary Funck" <gary@intrepid.com>
Subject: interpreting the output from dmsetup tables?
Date: Thu, 4 Aug 2005 19:09:08 -0700
Message-ID: <HLEPJEEBEKBMAHLBCNMMIEDOCEAA.gary@intrepid.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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
To: DM Developers <dm-devel@redhat.com>
List-Id: dm-devel.ids


dmsetup table says the following:

$ dmsetup table
VolGroup00-LogVol01: 0 3145728 linear 3:2 152830336
VolGroup00-LogVol00: 0 152829952 linear 3:2 384

where device [3:2] is /dev/hda2 (the root partition)

$ ls -l /dev/hda2
brw-rw----  1 root disk 3, 2 Jul 25 22:48 /dev/hda2


And fdisk says:

$ fdisk -u -l /dev/hda
 
Disk /dev/hda: 80.0 GB, 80026361856 bytes
255 heads, 63 sectors/track, 9729 cylinders, total 156301488 sectors
Units = sectors of 1 * 512 = 512 bytes
 
   Device Boot      Start         End      Blocks   Id  System
/dev/hda1   *          63      208844      104391   83  Linux
/dev/hda2          208845   156296384    78043770   8e  Linux LVM

We've mounted VolGroup00-LogVol00 on '/', and its dmsetup table
makes some sense, in that there are 156087540 sectors in /dev/hda2,
which is large enough to hold both VolGroup00-LogVol00
and VolGroup00-LogVol01, but I'm wondering where VolGroup00-LogVol01
might've crept in during the install? It has 3145728 sectors,
and starts after VolGroup00-LogVol00 ends, but it isn't mounted
and otherwise seems unecessary.  Is this typical of a default
FC4 install, specifing that '/' be a managed volume, did we somehow
hit the wrong buttons?
