From: <berthiaume_wayne@emc.com>
Subject: Re: multipath: Determine which device to use for
	grubdevice.map file
Date: Fri, 19 Feb 2010 14:53:52 -0500
Message-ID: <8F08A56613D77044BD153E2AC5DA0F8403B0E9F0@CORPUSMX40A.corp.emc.com>
References: <4B7DE60A.9020805@storix.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4B7DE60A.9020805@storix.com>
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
List-Id: dm-devel.ids

Hi David.

	For SLES you should be using
/dev/disk/by-id/36006016094511600449d92ae1937d611-part2 for a typical
root partition.

Regards,
Wayne. 

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of David Huffman
Sent: Thursday, February 18, 2010 8:15 PM
To: dm-devel@redhat.com
Subject: [dm-devel] multipath: Determine which device to use for
grubdevice.map file

I need to configure a dm-multipath device (mpatha) as a boot disk in a 
script. For RHEL it appears I can put the mpath device in my device.map 
file. However, for  SLES 11 if I use the mpath device, grub fails with 
"Floating point exception". For SLES I have to use the underlying path 
device (sd[a-z]).

I know which devices make up my multipath disk. Here is an example that 
shows my problem.

mpatha (36006016094511600449d92ae1937d611) dm-0 DGC,DISK
[size=50G][features=1 queue_if_no_path][hwhandler=1 emc][rw]
\_ round-robin 0 [prio=2][active]
\_ 2:0:1:0 sdd 8:48  [active][ready]
\_ 3:0:1:0 sdf 8:80  [active][ready]
\_ round-robin 0 [prio=0][enabled]
\_ 2:0:0:0 sdc 8:32  [active][ready]
\_ 3:0:0:0 sde 8:64  [active][ready]

Out of the 4 paths, only two (sdd and sdf) are active. This output is 
not very good to parse through in a script to determine which disks I 
can specify in my device.map file. Is there a command or better way to 
determine which underlying paths I can use in my device.map file.

For clarification, here is a breakdown of my device.map entries and the 
results:

(hd0) /dev/mapper/mpatha  - FAIL with "Floating point exception"

(hd0) /dev/sdc  - FAIL with "Error 21: Selected disk does not exist"

(hd0) /dev/sdd - Success!!!

I would rather put the mpath device in device.map, but that does not 
appear to be an option for SLES. Is there a way to determine the 
underlying path device that is "active" and not just enabled?

Right now I can run "dd if=/dev/sdc of=/dev/null bs=512 count=1 
2>/dev/null; echo $?"

This will tell me in the device can be written to. Any suggestions would

be helpful.

- David

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
