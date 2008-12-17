From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [BUG] linux-next: 20081209 - kernel bug at __rcu_process_callbacks, while booting up
Date: Wed, 17 Dec 2008 12:18:21 +0100
Message-ID: <20081217111821.GH32491@kernel.dk>
References: <20081210145414.GA6945@linux.vnet.ibm.com> <20081210163007.GA6391@linux.vnet.ibm.com> <20081210175338.GB6745@linux.vnet.ibm.com> <20081210180936.GD6391@linux.vnet.ibm.com> <20081210183302.GD6745@linux.vnet.ibm.com> <20081212194026.GA5455@linux.vnet.ibm.com> <20081212221611.GG6950@linux.vnet.ibm.com> <20081216143001.GA4365@linux.vnet.ibm.com> <20081216143721.GT32491@kernel.dk> <20081217111203.GA4426@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081217111203.GA4426@linux.vnet.ibm.com>
Sender: linux-next-owner@vger.kernel.org
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, tglx@linutronix.de, mel@csn.ul.ie
List-Id: dm-devel.ids

On Wed, Dec 17 2008, Kamalesh Babulal wrote:
> * Jens Axboe <jens.axboe@oracle.com> [2008-12-16 15:37:21]:
> 
> > On Tue, Dec 16 2008, Kamalesh Babulal wrote:
> > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2008-12-12 14:16:11]:
> > > 
> > > > On Sat, Dec 13, 2008 at 01:10:26AM +0530, Kamalesh Babulal wrote:
> > > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2008-12-10 10:33:02]:
> > > > > 
> > > > > > On Wed, Dec 10, 2008 at 11:39:36PM +0530, Kamalesh Babulal wrote:
> > > > > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2008-12-10 09:53:38]:
> > > > > > > 
> > > > > > > > On Wed, Dec 10, 2008 at 10:00:07PM +0530, Kamalesh Babulal wrote:
> > > > > > > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2008-12-10 06:54:14]:
> > > > > > > > > 
> > > > > > > > > > On Wed, Dec 10, 2008 at 05:27:21PM +0530, Kamalesh Babulal wrote:
> > > > > > > > > > > Hi,
> > > > > > > > > > > 
> > > > > > > > > > > 	Kernel bug is hit while booting up the next-20081208/09 kernels over
> > > > > > > > > > > the x86_64 box. The IP is pointing to 0x0 and its stuck at
> > > > > > > > > > > __rcu_process_callbacks.
> > > > > > > > > > 
> > > > > > > > > > Kernel config?
> > > > > > > > > > 
> > > > > > > > > > 							Thanx, Paul
> > > > > > > > > > 
> > > > > > > > > Hi Paul,
> > > > > > > > > 
> > > > > > > > > 	I have attached the kernel config file.
> > > > > > > > 
> > > > > > > > Hello, Kamalesh,
> > > > > > > > 
> > > > > > > > No significant recent changes in this area.  Is this consistent?
> > > > > > > > Any chance of "git bisect"?
> > > > > > > > 
> > > > > > > > 							Thanx, Paul
> > > > > > > > 
> > > > > > > Hi Paul,
> > > > > > > 
> > > > > > > 	I tried reproducing it for three times and I was successfull in reproducing it thrice.
> > > > > > > I have already started the git bisect, will update the results soon.
> > > > > > 
> > > > > > Very good, looking forward to seeing the result!
> > > > > > 
> > > > > > 							Thanx, Paul
> > > > > > 
> > > > > Hi Paul,
> > > > > 
> > > > > 	After a Complete round of git bisect, I was not able to reproduce the oops,
> > > > > but when I tried again with complete next-20081209 patch, I am getting
> > > > > different warning message altogether this time
> > > > 
> > > > Might be that the two oopses are different manifestations of the same
> > > > underlying problem, right?
> > > > 
> > > > 							Thanx, Paul
> > > > 
> > > Hi Paul,
> > > 
> > > 	Your were right, those were the manifestation of the same
> > > 	problem. Adding to it another calltrace was commonly visible
> > > 	during the git-bisect.
> > 
> > Did you try with a newer version? Should be fixed since last week.
> > 
> > -- 
> > Jens Axboe
> > 
> Hi Jens,
> 
> 	I tried with the next-20081216 kernel, but the kernel was stuck
> after loading the initrd image, passing unknown_nmi_panic=1, triggered
> following call trace,
> 
> Initializing CPU#0
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
> IP: [<ffffffff8072c547>] init_ISA_irqs+0x20/0x5d
> PGD 0 
> Thread overran stack, or stack corrupted
> Oops: 0002 [#1] SMP 
> last sysfs file: 
> CPU 0 
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.28-rc8-next-20081216-autokern1 #1
> RIP: 0010:[<ffffffff8072c547>]  [<ffffffff8072c547>] init_ISA_irqs+0x20/0x5d
> RSP: 0018:ffffffff8071df38  EFLAGS: 00010093
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff80796e40
> RDX: 0000000000000100 RSI: 0000000000000092 RDI: 0000000000000000
> RBP: ffffffff8071df48 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff8071df18 R11: 0000000000000070 R12: ffff88000103a040
> R13: cccccccccccccccd R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffffffff8070e3c0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000048 CR3: 0000000000201000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffffffff8071c000, task ffffffff806a43a0)
> Stack:
>  cccccccccccccccd ffffffff80754aa0 ffffffff8071df68 ffffffff8072c591
>  ffffffff8071df68 ffffffff8073ca50 ffffffff8071df98 ffffffff80725af2
>  0000000000000000 0000000000837a70 0000000000000000 0000000000000000
> Call Trace:
>  [<ffffffff8072c591>] native_init_IRQ+0xd/0x8a2
>  [<ffffffff8073ca50>] ? rcu_init+0x9/0xb
>  [<ffffffff80725af2>] start_kernel+0x1a1/0x315
>  [<ffffffff807252a0>] x86_64_start_reservations+0xaf/0xb3
>  [<ffffffff807253a1>] x86_64_start_kernel+0xda/0xe1
> Code: 20 5f 6a 80 e8 63 08 cb ff c9 c3 55 48 89 e5 53 31 db 48 83 ec 08 e8 05 88 00 00 31 ff e8 cd 2f ae ff 89 df e8 4d d5 b3 ff 89 df <c7> 40 48 00 02 00 00 48 c7 40 40 00 00 00 00 c7 40 4c 01 00 00 
> RIP  [<ffffffff8072c547>] init_ISA_irqs+0x20/0x5d
>  RSP <ffffffff8071df38>
> CR2: 0000000000000048
> ---[ end trace 4eaa2a86a8e2da22 ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc8-next-20081216-autokern1 #1
> Call Trace:
>  [<ffffffff80237e80>] panic+0xa0/0x160
>  [<ffffffff803b6b40>] ? account+0xe2/0xf1
>  [<ffffffff8024e065>] ? blocking_notifier_call_chain+0xf/0x11
>  [<ffffffff8023ad07>] do_exit+0x7c/0x7a9
>  [<ffffffff803b6cf1>] ? get_random_bytes+0x1b/0x1d
>  [<ffffffff80546456>] oops_end+0xb2/0xba
>  [<ffffffff80547cfb>] do_page_fault+0x738/0x7e7
>  [<ffffffff80545a3f>] page_fault+0x1f/0x30
>  [<ffffffff8072c547>] ? init_ISA_irqs+0x20/0x5d
>  [<ffffffff8072c545>] ? init_ISA_irqs+0x1e/0x5d
>  [<ffffffff8072c591>] native_init_IRQ+0xd/0x8a2
>  [<ffffffff8073ca50>] ? rcu_init+0x9/0xb
>  [<ffffffff80725af2>] start_kernel+0x1a1/0x315
>  [<ffffffff807252a0>] x86_64_start_reservations+0xaf/0xb3
>  [<ffffffff807253a1>] x86_64_start_kernel+0xda/0xe1
> ------------[ cut here ]------------
> WARNING: at kernel/smp.c:299 smp_call_function_many+0x3a/0x215()
> Hardware name: IBM eServer BladeCenter LS20 -[885055U]-
> Modules linked in:
> Pid: 0, comm: swapper Tainted: G      D    2.6.28-rc8-next-20081216-autokern1 #1
> Call Trace:
>  [<ffffffff80237db2>] warn_slowpath+0xd3/0xf2
>  [<ffffffff80238ada>] ? printk+0x67/0x69
>  [<ffffffff807253a1>] ? x86_64_start_kernel+0xda/0xe1
>  [<ffffffff8021eb4b>] ? touch_nmi_watchdog+0x65/0x69
>  [<ffffffff8020f26e>] ? printk_address+0x2c/0x2e
>  [<ffffffff807253a1>] ? x86_64_start_kernel+0xda/0xe1
>  [<ffffffff8020f453>] ? print_context_stack+0x97/0xaf
>  [<ffffffff8020e6b9>] ? dump_trace+0x26f/0x27e
>  [<ffffffff8025631c>] smp_call_function_many+0x3a/0x215
>  [<ffffffff80212130>] ? stop_this_cpu+0x0/0x20
>  [<ffffffff80256517>] smp_call_function+0x20/0x24
>  [<ffffffff8021d4fb>] native_smp_send_stop+0x22/0x30
>  [<ffffffff80237e94>] panic+0xb4/0x160
>  [<ffffffff803b6b40>] ? account+0xe2/0xf1
>  [<ffffffff8024e065>] ? blocking_notifier_call_chain+0xf/0x11
>  [<ffffffff8023ad07>] do_exit+0x7c/0x7a9
>  [<ffffffff803b6cf1>] ? get_random_bytes+0x1b/0x1d
>  [<ffffffff80546456>] oops_end+0xb2/0xba
>  [<ffffffff80547cfb>] do_page_fault+0x738/0x7e7
>  [<ffffffff80545a3f>] page_fault+0x1f/0x30
>  [<ffffffff8072c547>] ? init_ISA_irqs+0x20/0x5d
>  [<ffffffff8072c545>] ? init_ISA_irqs+0x1e/0x5d
>  [<ffffffff8072c591>] native_init_IRQ+0xd/0x8a2
>  [<ffffffff8073ca50>] ? rcu_init+0x9/0xb
>  [<ffffffff80725af2>] start_kernel+0x1a1/0x315
>  [<ffffffff807252a0>] x86_64_start_reservations+0xaf/0xb3
>  [<ffffffff807253a1>] x86_64_start_kernel+0xda/0xe1
> ---[ end trace 4eaa2a86a8e2da22 ]---

Looks like bad luck for you, now you are hitting another bug :-(
You should probably debug/post this seperately.

-- 
Jens Axboe
