From: Chip Coldwell <coldwell@redhat.com>
Subject: Re: Linux utility to determine WWN from a LUN number
Date: Fri, 14 Mar 2008 10:24:43 -0400 (EDT)
Message-ID: <alpine.LRH.1.00.0803140958110.23740@bogart.boston.redhat.com>
References: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>
	<20080313214352.GA18433@us.ibm.com>
	<B6FF36386FC9AC4BB098A4528811409F02230CC4@CORPUSMX40A.corp.emc.com>
	<47DA257B.70904@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47DA257B.70904@suse.de>
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

On Fri, 14 Mar 2008, Hannes Reinecke wrote:

> The WWN is either in VPD page 0x83 or 0x80 (in that order of preference).
> You should be using the utility 'scsi_id' to generate the WWN for a given
> path (eg call it like 'scsi_id -g -u -s /block/sdX'), as this is the same
> program multipath is using.

scsi_id comes with udev, and uses an SG_IO to retrieve VPD page 0x83
or 0x80.  It does a little bit more than that, however, and will
return a slightly different WWN than sg3_utils.  According to SPC3, an
Identification Descriptor on VPD page 0x83 begins with a 4-bit code
set, then a 4-bit protocol identifier, then a 4-bit identifier type.
The identifier types are

0x00 vendor specific
0x01 T10 vendor ID based
0x02 EUI-64 based
0x03 NAA (Name Assigning Authority?)
0x04 relative target port id
0x05 target port group
0x06 logical unit group
0x07 MD5 logical unit id
0x08 SCSI name string

When the scsi_id program parses the VPD 0x83 data, it will prepend
this number to the identifier found in the VPD 0x83 descriptor.
sg3_utils does not do this.  For example:

# scsi_id -g -s /block/sda
3600601601040190000c7da47f286dc11

# sg_inq -p 0x83 /dev/sda
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 20
    id_type: NAA,  code_set: Binary
    associated with the addressed logical unit
      NAA 6, IEEE Company_id: 0x6016
      Vendor Specific Identifier: 0x10401900
      Vendor Specific Identifier Extension: 0xc7da47f286dc11
      [0x600601601040190000c7da47f286dc11]
  Designation descriptor number 2, descriptor length: 20
    id_type: vendor specific [0x0],  code_set: Binary
    associated with the addressed logical unit
 00     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00    ................
  Designation descriptor number 3, descriptor length: 8
    id_type: Relative target port,  code_set: Binary
    associated with the target port
      Relative target port: 0x1
  Designation descriptor number 4, descriptor length: 8
    id_type: Target port group,  code_set: Binary
    associated with the target port
      Target port group: 0x1

In my scsitool, I chose to emulate the scsi_id behavior

# scsitool --devname=sda --hbtl --wwid
sda 0:0:0:0 3600601601040190000c7da47f286dc11 

> So the scsi_id program will give a you a mapping sdX -> WWN. And to get
> the mapping 'LUN -> sdX' you can simply do a
> 
> ( cd -P /sys/block/sdX/device; echo ${PWD##*/} )
> 
> which will display the SCSI ID of the device; the last number of which is
> the LUN presented to the OS.
>
> The remainder is left as an exercise to the reader :-)

The --hbtl switch to scsitool gives host:bus:target:lun.  If the
device is multipathed, you will see the same lun with different h:b:t
combinations.  So what you could do is

scsitool --wwid --hbtl | awk '/:2 $/ { print $1 }' | sort -u

That gives you the WWID of LUN 2.  Unfortunately, there seems to be a
trailing space in the output ... I'll fix that and turn a rev.

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc
978-392-2426

GPG ID:  852E052F
GPG FPR: 77E5 2B51 4907 F08A 7E92  DE80 AFA9 9A8F 852E 052F
