From: "Stewart, Sean" <Sean.Stewart@netapp.com>
Subject: Re: Trouble with ALUA on controller failover
Date: Wed, 6 May 2015 14:56:07 +0000
Message-ID: <1430924167.1436.10.camel@localhost>
References: <2C57E63023777C48B6C9F37639B365170E3EE72A@MBX02.nimblestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2C57E63023777C48B6C9F37639B365170E3EE72A@MBX02.nimblestorage.com>
Content-Language: en-US
Content-ID: <807381593C3AC64E84AA7AA0CCE26598@hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Hi Adam,

On Thu, 2015-04-30 at 14:34 +0000, Adam Drew wrote:
> Hi all,
> 
> We're facing a bit of a strange problem and would like some input on debugging and next steps.
> 
> We have RHEL 7 connected to a Nimble CS-series array via FC. We're running device-mapper-multipath-0.4.9-77.el7.x86_64 and 3.10.0-123.el7.x86_64. Our multipath config is very simple:
...
> The path status is strange. The path that should be active ready running now, 9:0:1:0, is failed ready  running:
> mpathek (29b72fe86f66a2a366c9ce9009d9a9742) dm-0 Nimble  ,Server          
> size=244G features='1 queue_if_no_path' hwhandler='0' wp=rw
> |-+- policy='round-robin 0' prio=0 status=enabled
> | `- 9:0:0:0 sdb 8:16 failed faulty offline
> `-+- policy='round-robin 0' prio=50 status=enabled
>   `- 9:0:1:0 sdc 8:32 failed ready  running

The "failed ready" path status is from the fact that the last I/O dm
sent down sdc came back failed, which can be seen below.

> 
> Multipath tries to send IO down that path but:
> [  405.078481] Add. Sense: Logical unit not accessible, target port in standby state                
> [  405.086856] sd 9:0:1:0: [sdc] CDB:                                                               
> [  405.090748] Write(10): 2a 00 1c fe 95 30 00 00 08 00                                             
> [  405.096456] sd 9:0:1:0: [sdc] Device not ready                                                   
> [  405.101419] sd 9:0:1:0: [sdc]                                                                    
> [  405.104934] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE                                      
> [  405.111162] sd 9:0:1:0: [sdc]                                                                    
> [  405.114678] Sense Key : Not Ready [current]                                                      
> [  405.119481] Info fld=0x0                                                                         
> [  405.122321] sd 9:0:1:0: [sdc]                                                                    
> [  405.125838] Add. Sense: Logical unit not accessible, target port in standby state                
> [  405.134202] sd 9:0:1:0: [sdc] CDB:                                                               
> [  405.138096] Write(10): 2a 00 1b 64 94 b0 00 00 02 00                                             
> [  405.143785] sd 9:0:1:0: [sdc] Device not ready                                                   
> [  405.148736] sd 9:0:1:0: [sdc]                                                                    
> [  405.152254] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE                                      
> [  405.158488] sd 9:0:1:0: [sdc]                                                                    
> [  405.162003] Sense Key : Not Ready [current]  
> 
It's getting an 02/04/0b check condition from your storage, because it's
still in the standby AAS.

> When we point RHEL 6 at this same array, and same volume, failover goes over without a hitch. We've been able to reproduce this on the RHEL 7 kernel / device-mapper-multipath combo on several systems.

I'm not sure how this is possible, because the code should be very
similar between RHEL6 and RHEL7 in these areas.

> We've been tearing through the device-mapper-multipath-libs and kernel code to see if we can find the cause of the problem, and we've been testing quite a bit, but have as yet been unable to resolve this. We'd like some input on next steps for debugging and testing.
> 
> The only thing we've found so far that looks promising is with the parameter data format on RTPG during failover. RHEL 7 is sending a parameter data format of 1, but we answer 0 (which is within spec). Here's the message on our array side:
> 
> dsd.log.2:19485 2015-04-20,11:45:46.746395-07 INFO: scsi.core:_scsi_report_target_group: parameter data format = 1, treating it as length only format(0)
> dsd.log.2:19485 2015-04-20,11:45:46.747362-07 INFO: scsi.core:_scsi_report_target_group: parameter data format = 1, treating it as length only format(0)
> 
> But on the RHEL side we see:
> Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: host1: Assigned Port ID 720080
> Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: scsi 1:0:0:0: Direct-Access Nimble Server 1.0 PQ: 0 ANSI: 5
> Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: scsi 1:0:0:0: alua: supports implicit TPGS
> Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: scsi 1:0:0:0: alua: port group 01 rel port 01
> Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: scsi 1:0:0:0: alua: rtpg failed with 8000002
> Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: scsi 1:0:0:0: alua: port group 01 state S non-preferred supports tolusna
> Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: scsi 1:0:0:0: alua: Attached
> 
> We're wondering if the RTPG failure is causing us to be unable to instate the new active path, and we wonder if this is due to RHEL 7 kernel or dmm not liking the 0 pdf response on 1. However, we're unsure if this would be in the kernel ALUA scsi_dh code, or in the device-mapper-multipath-libs alua code.
> 
The RTPG failure should not be causing this problem, as you see with the
subsequent "port group 01 state S non-preferred supports tolusna"
message that the RTPG does complete successfully. The first attempt uses
extended RTPG headers, and if it gets an illegal request back, it
disables it and tries again.

Your RTPG data indicates that only implicit TPGS is supported. Also, the
multipath configuration and multipath -ll output shows that no hardware
handler is being used for failover and failback (but I see the alua
handler is attached, which must be happening on device discovery and not
because of dm).  Basically, in this configuration, it would be up to the
array to change the AAS to allow I/O on the other path.

I have to wonder if there's some configuration difference, or reporting
difference between the two cases. Sorry I don't have all the answers,
but hopefully this helps to some extent.

Thanks,
Sean Stewart
