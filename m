From: <Levy_Jerome@emc.com>
Subject: Re: multipath: Determine which device to use for
	grubdevice.map file
Date: Sat, 20 Feb 2010 15:16:25 -0500
Message-ID: <6416EE16C1AF1E4C86882867E4DD0FF608E4FD3E@CORPUSMX40B.corp.emc.com>
References: <mailman.31.1266685205.1349.dm-devel@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <mailman.31.1266685205.1349.dm-devel@redhat.com>
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

I'm not so sure this is going to work out for you anyway. Suppose you
pick sdd and sdf as your boot path devices. If a trespass occurs, then
those may well become sdc and sde, and you won't be able to boot if
you're nailed down to sdd and sdf. Assuming that SLES doesn't work with
the by-id devices and that you're at relatively recent FLARE and
dm-multipath code, you might want to consider ALUA mode if you
absolutely have to boot from the array.

However, I don't understand why by-id wouldn't work. My SLES 11 box's
device.map contains (among others):

(hd0)   /dev/disk/by-id/scsi-SFUJITSU_MAJ3182MC_50085460

Which can be obtained from:

# /lib/udev/scsi_id -g -u /dev/sda
SFUJITSU_MAJ3182MC_50085460

Did you try using that identifier in your device.map file?

Cheers, Jerry

 
---------------------------------------------
eService at your fingertips: http://powerlink.emc.com
-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of dm-devel-request@redhat.com
Sent: Saturday, February 20, 2010 12:00 PM
To: dm-devel@redhat.com
Subject: dm-devel Digest, Vol 72, Issue 20

Send dm-devel mailing list submissions to
	dm-devel@redhat.com

To subscribe or unsubscribe via the World Wide Web, visit
	https://www.redhat.com/mailman/listinfo/dm-devel
or, via email, send a message with subject or body 'help' to
	dm-devel-request@redhat.com

You can reach the person managing the list at
	dm-devel-owner@redhat.com

When replying, please edit your Subject line so it is more specific
than "Re: Contents of dm-devel digest..."


Today's Topics:

   1. Re: multipath: Determine which device to use for
      grubdevice.map file (berthiaume_wayne@emc.com)
   2. Re: multipath: Determine which device to use for
      grubdevice.map file (David Huffman)
   3. Re: multipath: Determine which device to use for
      grubdevice.map file (malahal@us.ibm.com)


----------------------------------------------------------------------

Message: 1
Date: Fri, 19 Feb 2010 14:53:52 -0500
From: <berthiaume_wayne@emc.com>
To: <dm-devel@redhat.com>
Subject: Re: [dm-devel] multipath: Determine which device to use for
	grubdevice.map file
Message-ID:
	
<8F08A56613D77044BD153E2AC5DA0F8403B0E9F0@CORPUSMX40A.corp.emc.com>
Content-Type: text/plain;	charset="US-ASCII"

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




------------------------------

Message: 2
Date: Fri, 19 Feb 2010 14:32:52 -0800
From: David Huffman <dm-devel@storix.com>
To: device-mapper development <dm-devel@redhat.com>
Subject: Re: [dm-devel] multipath: Determine which device to use for
	grubdevice.map file
Message-ID: <4B7F1194.2040201@storix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Thanks for the response Wayne, but this does me no good. You cannot use 
the /dev/disk/by-id/* entries for device.map. You have to use the block 
device and not a link or dm-* device name.

Essentially, I need to know which underlying paths can be written to 
directly.

-David

berthiaume_wayne@emc.com wrote:
> Hi David.
>
> 	For SLES you should be using
> /dev/disk/by-id/36006016094511600449d92ae1937d611-part2 for a typical
> root partition.
>
> Regards,
> Wayne. 
>
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of David Huffman
> Sent: Thursday, February 18, 2010 8:15 PM
> To: dm-devel@redhat.com
> Subject: [dm-devel] multipath: Determine which device to use for
> grubdevice.map file
>
> I need to configure a dm-multipath device (mpatha) as a boot disk in a

> script. For RHEL it appears I can put the mpath device in my
device.map 
> file. However, for  SLES 11 if I use the mpath device, grub fails with

> "Floating point exception". For SLES I have to use the underlying path

> device (sd[a-z]).
>
> I know which devices make up my multipath disk. Here is an example
that 
> shows my problem.
>
> mpatha (36006016094511600449d92ae1937d611) dm-0 DGC,DISK
> [size=50G][features=1 queue_if_no_path][hwhandler=1 emc][rw]
> \_ round-robin 0 [prio=2][active]
> \_ 2:0:1:0 sdd 8:48  [active][ready]
> \_ 3:0:1:0 sdf 8:80  [active][ready]
> \_ round-robin 0 [prio=0][enabled]
> \_ 2:0:0:0 sdc 8:32  [active][ready]
> \_ 3:0:0:0 sde 8:64  [active][ready]
>
> Out of the 4 paths, only two (sdd and sdf) are active. This output is 
> not very good to parse through in a script to determine which disks I 
> can specify in my device.map file. Is there a command or better way to

> determine which underlying paths I can use in my device.map file.
>
> For clarification, here is a breakdown of my device.map entries and
the 
> results:
>
> (hd0) /dev/mapper/mpatha  - FAIL with "Floating point exception"
>
> (hd0) /dev/sdc  - FAIL with "Error 21: Selected disk does not exist"
>
> (hd0) /dev/sdd - Success!!!
>
> I would rather put the mpath device in device.map, but that does not 
> appear to be an option for SLES. Is there a way to determine the 
> underlying path device that is "active" and not just enabled?
>
> Right now I can run "dd if=/dev/sdc of=/dev/null bs=512 count=1 
> 2>/dev/null; echo $?"
>
> This will tell me in the device can be written to. Any suggestions
would
>
> be helpful.
>
> - David
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>   



------------------------------

Message: 3
Date: Fri, 19 Feb 2010 16:04:34 -0800
From: malahal@us.ibm.com
To: dm-devel@redhat.com
Subject: Re: [dm-devel] multipath: Determine which device to use for
	grubdevice.map file
Message-ID: <20100220000434.GA7527@us.ibm.com>
Content-Type: text/plain; charset=us-ascii

> mpatha (36006016094511600449d92ae1937d611) dm-0 DGC,DISK
> [size=50G][features=1 queue_if_no_path][hwhandler=1 emc][rw]
> \_ round-robin 0 [prio=2][active]
> \_ 2:0:1:0 sdd 8:48  [active][ready]
> \_ 3:0:1:0 sdf 8:80  [active][ready]
> \_ round-robin 0 [prio=0][enabled]
> \_ 2:0:0:0 sdc 8:32  [active][ready]
> \_ 3:0:0:0 sde 8:64  [active][ready]
>
> Out of the 4 paths, only two (sdd and sdf) are active. This output is 
> not very good to parse through in a script to determine which disks I 
> can specify in my device.map file. Is there a command or better way to

> determine which underlying paths I can use in my device.map file.

You can probably get it from "dmsetup status <device>", but it may be
even harder to parse!

Thanks, Malahal.



------------------------------

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

End of dm-devel Digest, Vol 72, Issue 20
****************************************
