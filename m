From: Adam Drew <Adam.Drew@nimblestorage.com>
Subject: Trouble with ALUA on controller failover
Date: Thu, 30 Apr 2015 14:34:00 +0000
Message-ID: <2C57E63023777C48B6C9F37639B365170E3EE72A@MBX02.nimblestorage.com>
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

Hi all,

We're facing a bit of a strange problem and would like some input on debugging and next steps.

We have RHEL 7 connected to a Nimble CS-series array via FC. We're running device-mapper-multipath-0.4.9-77.el7.x86_64 and 3.10.0-123.el7.x86_64. Our multipath config is very simple:

devices {
     device {
          vendor "Nimble"
          product "Server"
          prio          alua
          path_grouping_policy group_by_prio
          path_checker tur
          features      "1 queue_if_no_path"
          rr_weight priorities
          rr_min_io 20
          failback manual
          path_selector "round-robin 0"
          dev_loss_tmo infinity
          fast_io_fail_tmo 5
     }
}

And our devices look as expected:
mpathek (29b72fe86f66a2a366c9ce9009d9a9742) dm-0 Nimble  ,Server          
size=244G features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=50 status=active
| `- 9:0:0:0 sdb 8:16 active ready running
`-+- policy='round-robin 0' prio=1 status=enabled
  `- 9:0:1:0 sdc 8:32 active ghost running

When we initiate controller failover we never switch over to the correct path:

[  822.192772] sd 9:0:0:0: rejecting I/O to offline device                                          
[  822.198633] device-mapper: multipath: Failing path 8:16.                                         
[  822.204595] device-mapper: multipath: Failing path 8:32.                                         
[  824.099448] sd 9:0:1:0: Parameters changed                                                       
[  825.043943] device-mapper: multipath: Failing path 8:32.                                         
[  830.052981] device-mapper: multipath: Failing path 8:32.                                         
[  835.062030] device-mapper: multipath: Failing path 8:32.                                         
[  840.071071] device-mapper: multipath: Failing path 8:32.                                         
[  845.080060] device-mapper: multipath: Failing path 8:32.                                         
[  850.089089] device-mapper: multipath: Failing path 8:32.                                         
[  855.098110] device-mapper: multipath: Failing path 8:32.

The path status is strange. The path that should be active ready running now, 9:0:1:0, is failed ready  running:
mpathek (29b72fe86f66a2a366c9ce9009d9a9742) dm-0 Nimble  ,Server          
size=244G features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=0 status=enabled
| `- 9:0:0:0 sdb 8:16 failed faulty offline
`-+- policy='round-robin 0' prio=50 status=enabled
  `- 9:0:1:0 sdc 8:32 failed ready  running

Multipath tries to send IO down that path but:
[  405.078481] Add. Sense: Logical unit not accessible, target port in standby state                
[  405.086856] sd 9:0:1:0: [sdc] CDB:                                                               
[  405.090748] Write(10): 2a 00 1c fe 95 30 00 00 08 00                                             
[  405.096456] sd 9:0:1:0: [sdc] Device not ready                                                   
[  405.101419] sd 9:0:1:0: [sdc]                                                                    
[  405.104934] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE                                      
[  405.111162] sd 9:0:1:0: [sdc]                                                                    
[  405.114678] Sense Key : Not Ready [current]                                                      
[  405.119481] Info fld=0x0                                                                         
[  405.122321] sd 9:0:1:0: [sdc]                                                                    
[  405.125838] Add. Sense: Logical unit not accessible, target port in standby state                
[  405.134202] sd 9:0:1:0: [sdc] CDB:                                                               
[  405.138096] Write(10): 2a 00 1b 64 94 b0 00 00 02 00                                             
[  405.143785] sd 9:0:1:0: [sdc] Device not ready                                                   
[  405.148736] sd 9:0:1:0: [sdc]                                                                    
[  405.152254] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE                                      
[  405.158488] sd 9:0:1:0: [sdc]                                                                    
[  405.162003] Sense Key : Not Ready [current]  

When we point RHEL 6 at this same array, and same volume, failover goes over without a hitch. We've been able to reproduce this on the RHEL 7 kernel / device-mapper-multipath combo on several systems.

We've been tearing through the device-mapper-multipath-libs and kernel code to see if we can find the cause of the problem, and we've been testing quite a bit, but have as yet been unable to resolve this. We'd like some input on next steps for debugging and testing.

The only thing we've found so far that looks promising is with the parameter data format on RTPG during failover. RHEL 7 is sending a parameter data format of 1, but we answer 0 (which is within spec). Here's the message on our array side:

dsd.log.2:19485 2015-04-20,11:45:46.746395-07 INFO: scsi.core:_scsi_report_target_group: parameter data format = 1, treating it as length only format(0)
dsd.log.2:19485 2015-04-20,11:45:46.747362-07 INFO: scsi.core:_scsi_report_target_group: parameter data format = 1, treating it as length only format(0)

But on the RHEL side we see:
Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: host1: Assigned Port ID 720080
Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: scsi 1:0:0:0: Direct-Access Nimble Server 1.0 PQ: 0 ANSI: 5
Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: scsi 1:0:0:0: alua: supports implicit TPGS
Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: scsi 1:0:0:0: alua: port group 01 rel port 01
Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: scsi 1:0:0:0: alua: rtpg failed with 8000002
Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: scsi 1:0:0:0: alua: port group 01 state S non-preferred supports tolusna
Apr 14 18:05:54 UCS-PGUO-RHEL7 kernel: scsi 1:0:0:0: alua: Attached

We're wondering if the RTPG failure is causing us to be unable to instate the new active path, and we wonder if this is due to RHEL 7 kernel or dmm not liking the 0 pdf response on 1. However, we're unsure if this would be in the kernel ALUA scsi_dh code, or in the device-mapper-multipath-libs alua code.

Any helped is appreciated. We'll supply any data request.

Adam Drew
Nimble Storage
