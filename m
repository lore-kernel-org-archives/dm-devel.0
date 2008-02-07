From: Vu Pham <vuhuong@mellanox.com>
Subject: Crash in dm-mod RHEL5,
Date: Wed, 06 Feb 2008 17:08:12 -0800
Message-ID: <47AA59FC.5080604@mellanox.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

I performed cable pull test and hit this crash in RHEL 5

PID: 2752   TASK: ffff81023d018080  CPU: 3   COMMAND: 
"multipathd"
#0 [ffff81022f8efa60] crash_kexec at ffffffff800a959f
#1 [ffff81022f8efae8] dm_swap_table at ffffffff88363380
#2 [ffff81022f8efb20] __die at ffffffff80062e9d
#3 [ffff81022f8efb60] do_page_fault at ffffffff80064827
#4 [ffff81022f8efb90] physflat_send_IPI_allbutself at 
ffffffff800765f4
#5 [ffff81022f8efbf0] __smp_call_function at ffffffff800729b8
#6 [ffff81022f8efc50] error_exit at ffffffff8005be1d
    [exception RIP: dm_swap_table+119]
    RIP: ffffffff88363380  RSP: ffff81022f8efd08  RFLAGS: 
00010246
    RAX: 0000000000000000  RBX: ffff81022dced600  RCX: 
0000000000000000
    RDX: 0000000000000000  RSI: 000000000740c620  RDI: 
ffff81021ee28200
    RBP: 0000000001387b00   R8: 0000000000000003   R9: 
000000000000003d
    R10: ffff81022f8efb58  R11: ffff810211681b80  R12: 
ffff81021ee28200
    R13: ffff81022dced618  R14: ffff81020171c088  R15: 
ffffffff8836607e
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
#7 [ffff81022f8efd00] dm_swap_table at ffffffff88363356
#8 [ffff81022f8efd30] dev_suspend at ffffffff88366181
#9 [ffff81022f8efd60] ctl_ioctl at ffffffff883669d8
#10 [ffff81022f8efee0] do_ioctl at ffffffff8003fc73
#11 [ffff81022f8eff00] vfs_ioctl at ffffffff8002fa45
#12 [ffff81022f8eff40] sys_ioctl at ffffffff8004a24b
#13 [ffff81022f8eff80] tracesys at ffffffff8005b2c1
    RIP: 00000030578c5fd7  RSP: 0000000040052bc8  RFLAGS: 
00000246
    RAX: ffffffffffffffda  RBX: ffffffff8005b2c1  RCX: 
ffffffffffffffff
    RDX: 000000001868d7e0  RSI: 00000000c138fd06  RDI: 
0000000000000008
    RBP: 0000000000000000   R8: 0000003057c0c8da   R9: 
000000001868d810
    R10: 0000003057c0c78c  R11: 0000000000000246  R12: 
0000003057c0c89e
    R13: 0000000000000000  R14: 0000003057c0c78c  R15: 
0000000000000000
    ORIG_RAX: 0000000000000010  CS: 0033  SS: 002b

Have anyone seen this crash before?

thanks,
    -vu
