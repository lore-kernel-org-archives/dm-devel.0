From: malahal@us.ibm.com
Subject: BUG in dm/dm-mirror module?
Date: Fri, 10 Aug 2007 18:08:53 -0700
Message-ID: <20070811010853.GA9952@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi, I am trying to create a mirrored disk log. I have four block
devices, two for the log (which is a mirror!) and two for the actual
mirror device.  But I can't use the mirror device at all. It just hangs
for any read/write. Here are the details of dmsetup calls. I am using
RHEL5 (2.6.18-8.el5). Looks like a mirror module bug and I appreciate
any help.

dev1="/dev/sda1"
dev2="/dev/sdb1"
dev3="/dev/sdc1"
dev4="/dev/sdd1"
echo "0 8192 mirror core 1 512 2 $dev1 0 $dev2 0" | dmsetup create log
echo "0 24576 mirror disk 2 /dev/mapper/log 512 2 $dev3 0 $dev4 0" | dmsetup create mirror

The following are the stack traces for kmirrord and the "dd
if=/dev/mapper/mirror of=/dev/null" command on the mirror: 

crash> bt 312
PID: 312    TASK: c00000001dd311d0  CPU: 1   COMMAND: "kmirrord"
 #0 [c00000001dd577d0] .schedule at c0000000003483c8
 #1 [c00000001dd578e0] .io_schedule at c000000000349094
 #2 [c00000001dd57970] .sync_io at d0000000002777f4
 #3 [c00000001dd57a20] .dm_io_sync_vm at d0000000002778a0
 #4 [c00000001dd57af0] .disk_flush at d0000000000808cc
 #5 [c00000001dd57b90] .do_work at d00000000008342c
 #6 [c00000001dd57d50] .run_workqueue at c00000000007b76c
 #7 [c00000001dd57df0] .worker_thread at c00000000007c4d8
 #8 [c00000001dd57ee0] .kthread at c000000000080fb8
 #9 [c00000001dd57f90] .kernel_thread at c0000000000264bc

crash> bt 2489
PID: 2489   TASK: c00000000747cbc0  CPU: 1   COMMAND: "dd"
 #0 [c00000000717b5c0] .schedule at c0000000003483c8
 #1 [c00000000717b6d0] .io_schedule at c000000000349094
 #2 [c00000000717b760] .sync_page at c0000000000aa180
 #3 [c00000000717b7e0] .__wait_on_bit_lock at c0000000003492c0
 #4 [c00000000717b880] .__lock_page at c0000000000a9fa4
 #5 [c00000000717b950] .do_generic_mapping_read at c0000000000aad00
 #6 [c00000000717baa0] .__generic_file_aio_read at c0000000000aba74
 #7 [c00000000717bb70] .generic_file_read at c0000000000ad0c8
 #8 [c00000000717bcf0] .vfs_read at c0000000000e0f10
 #9 [c00000000717bd90] .sys_read at c0000000000e13f4
#10 [c00000000717be30] syscall_exit at c00000000000869c
 syscall  [c00] exception frame:
 R0:  0000000000000003    R1:  00000000ffedf650    R2:  000000000fff9450   
 R3:  0000000000000000    R4:  0000000010030000    R5:  0000000000000200   
 R6:  000000001001d1a8    R7:  0000000000000000    R8:  00000000000001ff   
 R9:  0000000000000000    R10: 0000000000000000    R11: 0000000000000000   
 R12: 0000000000000000    R13: 0000000010025144    R14: 0000000000000000   
 R15: 0000000010040a60    R16: 000000001001d190    R17: 000000001001d198   
 R18: 0000000000000000    R19: 000000001001d1f4    R20: 000000001001d128   
 R21: 000000001001d178    R22: 000000001001d160    R23: 000000001001d1bc   
 R24: 0000000010030000    R25: 000000001001d170    R26: 000000001001d170   
 R27: 0000000000000000    R28: 0000000010030000    R29: 0000000000000200   
 R30: 000000001001d008    R31: 0000000010030200   
 NIP: 000000000ff1a6d4    MSR: 000000000000d032    OR3: 0000000000000000
 CTR: 000000000ff1a6c0    LR:  0000000010001df4    XER: 0000000000000000
 CCR: 0000000044000428    MQ:  c000000000421ae8    DAR: 0000000010050c64
 DSISR: 0000000042000000     Syscall Result: 0000000000000200
