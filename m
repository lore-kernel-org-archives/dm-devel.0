From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Date: Thu, 28 Feb 2008 23:20:48 -0800
Message-ID: <20080228232048.51e28c1d.akpm@linux-foundation.org>
References: <200802281924.03996.rrs@researchut.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200802281924.03996.rrs@researchut.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ritesh Raj Sarraf <rrs@researchut.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com, Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, 28 Feb 2008 19:24:03 +0530 Ritesh Raj Sarraf <rrs@researchut.com> wrote:

> Hi Christophe,

(cc's added)

> I noted kernel soft lockup messages on my laptop when doing a lot of I/O 
> (200GB) to a dm-crypt device. It was setup using LUKS.
> The I/O never got disrupted nor anything failed. Just the messages.
> 
> Kernel: 2.6.24
> Distribution: Debian Testing/Unstable
> Tainted: Yes (nvidia proprietary drivers)
> 
> I've not filed a bugzilla because my kernel is a tainted kernel because of 
> nvidia drivers.

That would be pretty dogmatic - if nuking the nvodia module prevents this
I'll eat several hats.

> I'm attaching the messages. Please let me know if it stands as a candidate for 
> a bug report.
> 

> a200 EDI: 0000000a EBP: 00000000 ESP: f32bfd7c
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: b3c3e000 CR3: 003b5000 CR4: 000026d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
>  [<c012902d>] do_softirq+0x45/0x53
>  [<c0129291>] irq_exit+0x38/0x6b
>  [<c01066f2>] do_IRQ+0x5a/0x70
>  [<c01048c3>] common_interrupt+0x23/0x28
>  [<f899202f>] xor_128+0x0/0x17 [cbc]
>  [<f899237e>] crypto_cbc_encrypt+0xe4/0x146 [cbc]
>  [<f899202f>] xor_128+0x0/0x17 [cbc]
>  [<c01dd80a>] cfq_allow_merge+0x0/0x5a
>  [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
>  [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
>  [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
>  [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
>  [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
>  [<c0132225>] run_workqueue+0x7d/0x109
>  [<c0135554>] prepare_to_wait+0x12/0x49
>  [<c0132a9b>] worker_thread+0x0/0xc5
>  [<c0132b55>] worker_thread+0xba/0xc5
>  [<c0135441>] autoremove_wake_function+0x0/0x35
>  [<c013537a>] kthread+0x38/0x5e
>  [<c0135342>] kthread+0x0/0x5e
>  [<c0104b0f>] kernel_thread_helper+0x7/0x10
>  =======================
> BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]
> 
> Pid: 22652, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
> EIP: 0060:[<c0128f6c>] EFLAGS: 00000202 CPU: 0
> EIP is at __do_softirq+0x57/0xd3
> EAX: c03b4860 EBX: 00000020 ECX: 00000009 EDX: 01c5c000
> ESI: c036a200 EDI: 0000000a EBP: 00000000 ESP: f32bfd30
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: b3c3e000 CR3: 003b5000 CR4: 000026d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
>  [<c012902d>] do_softirq+0x45/0x53
>  [<c0129291>] irq_exit+0x38/0x6b
>  [<c01066f2>] do_IRQ+0x5a/0x70
>  [<c01048c3>] common_interrupt+0x23/0x28
>  [<c01100d8>] cyrix_get_arr+0xb4/0x126
>  [<c011ad36>] native_flush_tlb_single+0x3/0x4
>  [<c011d0e9>] kunmap_atomic+0x60/0x94
>  [<f89742d5>] blkcipher_walk_done+0x87/0x1fe [blkcipher]
>  [<f89923cc>] crypto_cbc_encrypt+0x132/0x146 [cbc]
>  [<f899202f>] xor_128+0x0/0x17 [cbc]
>  [<c01dd80a>] cfq_allow_merge+0x0/0x5a
>  [<f89ad6ef>] aes_encrypt+0x0/0x17 [aes_i586]
>  [<f88fe648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
>  [<f88fe7e0>] crypt_convert+0x148/0x185 [dm_crypt]
>  [<f88fe9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
>  [<f88fe81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
>  [<c0132225>] run_workqueue+0x7d/0x109
>  [<c0135554>] prepare_to_wait+0x12/0x49
>  [<c0132a9b>] worker_thread+0x0/0xc5
>  [<c0132b55>] worker_thread+0xba/0xc5
>  [<c0135441>] autoremove_wake_function+0x0/0x35
>  [<c013537a>] kthread+0x38/0x5e
>  [<c0135342>] kthread+0x0/0x5e
>  [<c0104b0f>] kernel_thread_helper+0x7/0x10
>  =======================
> BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:22652]
> 

Could be a dm-crypt problem, could be a crypto problem, could even be a
core block problems.

If nothing happens in the next few days, yes, please do raise a bugzilla
report.  That helps us to avoid forgetting about it, but it doesn't do much
to get things fixed, I'm afraid.

If you can provide us with a simple step-by-step recipe to reprodue this,
and if others can indeed reproduce it, the chances of getting it fixed will
increase.


Now, I'm assuming that it's just unreasonable for a machine to spend a full
11 seconds crunching away on crypto in that code path.  Maybe it _is_
reasonable, and all we need to do is to poke a cond_resched() in there
somewhere.  Herbert, any thoughts?  What's the speed of that code?

Thanks.
