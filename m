From: Christian May <cmay@linux.vnet.ibm.com>
Subject: Oops in dm-multipath
Date: Wed, 10 Jun 2009 15:18:01 +0200
Message-ID: <4A2FB289.3050008@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I've setup an IBM z10 LPAR (mainframe server) with selfmade kernel. 
Attached to the System z10 was an IBM DS8000 storage server. 10x SCSI 
LUNs were assigned to LPAR via two pathes:
Example:
36005076303ffc48e000000000000c03e dm-2 IBM,2107900
size=5.0G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=2 status=enabled
  |- 2:0:1:1077821632 sde   8:64   active ready  running
  `- 3:0:2:1077821632 sdf   8:80   active ready  running

Special parameter setting: dev_loss_tmo=90sec; fast_io_fail_tmo=5sec
Kernel version: 2.6.29-37.x.20090604
multipath tools: multipath-tools v0.4.9 (04/04, 2009)
device-mapper: device-mapper-1.02.27-7.fc10.s390x, 
device-mapper-libs-1.02.27-7.fc10.s390x

All 10 SCSI LUNs were mounted and filesystem I/O was started (using IBM 
internal BLAST tool).

In order to verify correct error recovery of zFCP driver and 
multipath-tools I've disabled and re-enabled ports on the BROADE FC 
switch between z10 server and storage server.
Port off/on times were random between 10..120sec. After a couple hours 
an Oops occured. Analysis by zFCP development  was pointing to dm-multipath:

<3>end_request: I/O error, dev sdg, sector 20654968
    <6>sd 3:0:1:1077952704: [sdg] Unhandled error code
    <6>sd 3:0:1:1077952704: [sdg] Result: 
hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK,SUGGEST_OK
    <3>end_request: I/O error, dev sdg, sector 20655680
    <6>sd 3:0:1:1077952704: [sdg] Unhandled error code
    <6>sd 3:0:1:1077952704: [sdg] Result: 
hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK,SUGGEST_OK
    <3>end_request: I/O error, dev sdg, sector 20656392
    <6>sd 3:0:1:1077952704: [sdg] Unhandled error code
    <6>sd 3:0:1:1077952704: [sdg] Result: 
hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK,SUGGEST_OK
    <3>end_request: I/O error, dev sdg, sector 20657104
    <1>Unable to handle kernel pointer dereference at virtual kernel 
address 0000004418c55000
    <4>Oops: 003b [#1] PREEMPT SMP DEBUG_PAGEALLOC
    <4>Modules linked in: dm_round_robin sunrpc qeth_l2 dm_multipath 
dm_mod chsc_sch qeth ccwgroup
    <4>CPU: 1 Not tainted 2.6.29-Swen_debug #1
    <4>Process events/1 (pid: 8, task: 0000000079b00c38, ksp: 
0000000079b07b80)
    <4>Krnl PSW : 0704100180000000 000003e0001c6186 
(trigger_event+0x6/0x14 [dm_multipath])
    <4>           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
    <4>Krnl GPRS: 1ec8200000000000 0000004418c55000 0000000074a44968 
0000000000000001
    <4>           000000000015e96a 0000000079b01420 0000000000000002 
fffffffffffffffe
    <4>           0000000079b07e38 0000000079cc9e40 000003e0001c6180 
0000000079cc9e00
    <4>           0000000074a44968 0000000000523e70 000000000015e970 
0000000079b07d88
    <4>Krnl Code: 000003e0001c6174: ebaff0a00004         lmg        
 %r10,%r15,160(%r15)
    <4>           000003e0001c617a: c0f4ffffff8b         brcl        
 15,3e0001c6090
    <4>           000003e0001c6180: e3102ea8ff04         lg        
 %r1,-344(%r2)
    <4>          >000003e0001c6186: e32010000004         lg        
 %r2,0(%r1)
    <4>           000003e0001c618c: c0f4fffec1f4         brcl        
 15,3e00019e574
    <4>           000003e0001c6192: 0707                  bcr         0,%r7
    <4>           000003e0001c6194: eb8ff0580024         stmg        
 %r8,%r15,88(%r15)
    <4>           000003e0001c619a: a7f13f80                  tmll    
     %r15,16256
    <4>Call Trace:
    <4>([<000000000015e96a>] run_workqueue+0x196/0x258)
    <4> [<000000000015eaa6>] worker_thread+0x7a/0xdc
    <4> [<0000000000164662>] kthread+0x6e/0xb0
    <4> [<000000000010a4b2>] kernel_thread_starter+0x6/0xc
    <4> [<000000000010a4ac>] kernel_thread_starter+0x0/0xc
    <4>INFO: lockdep is turned off.
    <4>Last Breaking-Event-Address:
    <4> [<000000000015e96e>] run_workqueue+0x19a/0x258
    <4> <0>Kernel panic - not syncing: Fatal exception: panic_on_oops
    <4> I/O error, dev sdf, sector 2947736
    <6>sd 2:0:3:1077559488: [sdn] Unhandled error code
    <6>sd 2:0:3:1077559488: [sdn] Result: 
hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK,SUGGEST_OK



If more information is needed please let me know.

Christian
