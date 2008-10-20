From: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
Subject: Calltrace in dm-snapshot in 2.6.27 kernel
Date: Mon, 20 Oct 2008 08:23:26 +0200
Message-ID: <48FC23DE.5040000@poczta.onet.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
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

I have some problems with device mapper in 2.6.27 kernel. Below there is
 calltrace from logs:


---------------
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<0000000000000000>] 0x0
PGD 5a84c067 PUD 5cfdb067 PMD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in: iscsi_trgt drbd bonding iscsi_tcp libiscsi
scsi_transport_iscsi megaraid_mbox megaraid_mm sky2 skge button ftdi_sio
usbserial
Pid: 31704, comm: kcopyd Not tainted 2.6.27 #7
RIP: 0010:[<0000000000000000>]  [<0000000000000000>] 0x0
RSP: 0000:ffff880055af5d18  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff88007dfe3128 RCX: 010000000000059d
RDX: 0000000000000018 RSI: 8000000000000000 RDI: ffff88007dfe3128
RBP: ffff88007dfe33c8 R08: ffffc20005f751d0 R09: 00ffffffffffffff
R10: 0100000000000000 R11: 0000000000000000 R12: ffff880014d8dc00
R13: 0000000000000000 R14: ffff880059c89840 R15: ffff880014d8dd18
FS:  0000000000000000(0000) GS:ffffffff808dea80(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000007d0d0000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process kcopyd (pid: 31704, threadinfo ffff880055af4000, task
ffff880026e3ce70)
Stack:  ffffffff805c2ea4 00000000ffffff7e 00000000000000ee ffff88004c268440
 0000000000000000 ffff880026d58eb8 0000000000000400 0000000000000000
 ffffffff805c4140 0000000000001d5a 00000000000005b8 ffff880001025af0
Call Trace:
 [<ffffffff805c2ea4>] ? pending_complete+0x1e4/0x220
 [<ffffffff805c4140>] ? persistent_commit+0x100/0x130
 [<ffffffff805bd8a3>] ? segment_complete+0x183/0x1c0
 [<ffffffff805bd720>] ? segment_complete+0x0/0x1c0
 [<ffffffff805bd385>] ? run_complete_job+0x65/0xb0
 [<ffffffff805bd320>] ? run_complete_job+0x0/0xb0
 [<ffffffff805bd5d6>] ? process_jobs+0x26/0xe0
 [<ffffffff805bd690>] ? do_work+0x0/0x60
 [<ffffffff805bd6b8>] ? do_work+0x28/0x60
 [<ffffffff8024686a>] ? run_workqueue+0x5a/0x110
 [<ffffffff802469bc>] ? worker_thread+0x9c/0xf0
 [<ffffffff8024a620>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff8024a620>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff80246920>] ? worker_thread+0x0/0xf0
 [<ffffffff80249f0c>] ? kthread+0x6c/0xa0
 [<ffffffff8020d1c9>] ? child_rip+0xa/0x11
 [<ffffffff8021b5f0>] ? lapic_next_event+0x0/0x10
 [<ffffffff80249ea0>] ? kthread+0x0/0xa0
 [<ffffffff8020d1bf>] ? child_rip+0x0/0x11


Code:  Bad RIP value.
RIP  [<0000000000000000>] 0x0
 RSP <ffff880055af5d18>
CR2: 0000000000000000
---------------

I've got this calltrace from our QA team. They say that they mad few
snapshots, run several programs like bacula or rsync and that calltrace
is appearing about 1 hour after starting those programs.

We didn't recognize the reason of this calltrace so far. I mean we don't
know which of these programs can cause this calltrace.

I investigate a little this calltrace on my own. That what I know is
NULL value of "free" pointer (in mempool_t structure) while calling
mempool_free().

Here there is trace of procedures call:

(...) -> put_pending_exception():841 -> free_pending_exception() ->
mempool_free()

The mempool_free() calls:

pool->free(element, pool->pool_data)

and here pool->free is NULL, so it causes calltrace.

This is the description of the problem.

Is this known problem? Is there any solution for fixing it?
Any suggestions?
