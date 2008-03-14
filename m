From: Chip Coldwell <coldwell@redhat.com>
Subject: Re: Linux utility to determine WWN from a LUN number
Date: Fri, 14 Mar 2008 10:32:56 -0400 (EDT)
Message-ID: <alpine.LRH.1.00.0803141025260.23740@bogart.boston.redhat.com>
References: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>
	<20080313214352.GA18433@us.ibm.com>
	<B6FF36386FC9AC4BB098A4528811409F02230CC4@CORPUSMX40A.corp.emc.com>
	<alpine.LRH.1.00.0803140951210.23740@bogart.boston.redhat.com>
	<47DA85A1.2040503@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47DA85A1.2040503@suse.de>
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
Cc: Doug Gilbert <dougg@torque.net>
List-Id: dm-devel.ids

On Fri, 14 Mar 2008, Hannes Reinecke wrote:
> 
> BTW: what is the main reason for scsitool?

The main idea with scsitool is to be able to select, sort and output
properties of SCSI disks.  The properties it supports are

--devname (sda, sdb, etc.)
--hbtl (host:bus:target:lun nexus)
--wwid
--target-wwnn
--target-wwpn
--host-wwnn
--host-wwpn
--vendor
--model
--driver (e.g. lpfc, qla2xxx)

any of these options can be supplied bare (in which case it matches
all devices) or with a match value.  For example:

# scsitool --driver=qla2xxx --hbtl --devname
qla2xxx 1:0:0:1 sdo 
qla2xxx 1:0:1:1 sdp 
qla2xxx 1:0:2:0 sdq 
qla2xxx 1:0:2:1 sdr 
qla2xxx 1:0:2:2 sds 
qla2xxx 1:0:3:0 sdt 
qla2xxx 1:0:3:1 sdu 
qla2xxx 1:0:3:2 sdv 
qla2xxx 1:0:4:0 sdw 
qla2xxx 1:0:4:1 sdx 
qla2xxx 1:0:4:2 sdy 
qla2xxx 1:0:5:0 sdz 
qla2xxx 1:0:5:1 sdaa 
qla2xxx 1:0:5:2 sdab 

For any combination, the output only includes the properties
specified, and is sorted by those properties in the order that those
properties are specified.  So, for example, to find all the WWIDs on
the system

]# scsitool --wwid --devname
35000c5000020d907 sdac 
35000c5000020d933 sdad 
3600508b400105e210000900000550000 sdm 
3600508b400105e210000900000550000 sdn 
3600508b400105e210000900000550000 sdo 
3600508b400105e210000900000550000 sdp 
3600601601040190000c7da47f286dc11 sda 
3600601601040190000c7da47f286dc11 sdd 
3600601601040190000c7da47f286dc11 sdg 
3600601601040190000c7da47f286dc11 sdj 
3600601601040190000c7da47f286dc11 sdq 
3600601601040190000c7da47f286dc11 sdt 
3600601601040190000c7da47f286dc11 sdw 
3600601601040190000c7da47f286dc11 sdz 
360060160104019008e275c5af286dc11 sdc 
360060160104019008e275c5af286dc11 sdf 
360060160104019008e275c5af286dc11 sdi 
360060160104019008e275c5af286dc11 sdl 
360060160104019008e275c5af286dc11 sds 
360060160104019008e275c5af286dc11 sdv 
360060160104019008e275c5af286dc11 sdy 
360060160104019008e275c5af286dc11 sdab 
36006016010401900be062253f286dc11 sdb 
36006016010401900be062253f286dc11 sde 
36006016010401900be062253f286dc11 sdh 
36006016010401900be062253f286dc11 sdk 
36006016010401900be062253f286dc11 sdr 
36006016010401900be062253f286dc11 sdu 
36006016010401900be062253f286dc11 sdx 
36006016010401900be062253f286dc11 sdaa 

Now select the device names that correspond to just one WWID

# scsitool --wwid=3600601601040190000c7da47f286dc11 --devname
3600601601040190000c7da47f286dc11 sda 
3600601601040190000c7da47f286dc11 sdd 
3600601601040190000c7da47f286dc11 sdg 
3600601601040190000c7da47f286dc11 sdj 
3600601601040190000c7da47f286dc11 sdq 
3600601601040190000c7da47f286dc11 sdt 
3600601601040190000c7da47f286dc11 sdw 
3600601601040190000c7da47f286dc11 sdz 

The hope is that scsitool will be helpful for people writing scripts.
As a trivial example, if I wanted only the device names above:

# scsitool --wwid=3600601601040190000c7da47f286dc11 --devname | cut -d' ' -f2
sda
sdd
sdg
sdj
sdq
sdt
sdw
sdz

> Does it have features which scsi_id and sg3_utils are missing?

I think the answer, in a mathematical sense, is "no".  However, I
found it so cumbersome to combine the existing tools in scripts that
it was worthwhile for me to write a new one from scratch.  In
addition, in deployments with thousands of LUNs, I think combining the
existing tools in scripts can turn out to be rather slow.

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc
978-392-2426

GPG ID:  852E052F
GPG FPR: 77E5 2B51 4907 F08A 7E92  DE80 AFA9 9A8F 852E 052F
