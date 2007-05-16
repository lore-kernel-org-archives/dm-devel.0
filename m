From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG in kcryptd?
Date: Wed, 16 May 2007 11:29:47 -0700
Message-ID: <20070516112947.faf95c22.akpm@linux-foundation.org>
References: <464B1F2B.3030009@xs4all.nl>
	<Pine.LNX.4.61.0705161751020.9570@yvahk01.tjqt.qr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.61.0705161751020.9570@yvahk01.tjqt.qr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, 16 May 2007 17:52:09 +0200 (MEST)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On May 16 2007 17:11, Udo van den Heuvel wrote:
> >
> >While opening an encrypted partition and trying to fsck it:
> 
> Yeah, somewhere is a bug in it, I also get an oops with
> kcryptd in 2.6.20 on sparc64 after a few minutes (though,
> it's a NULL dereference there).

guys, please do try to copy the appropriate mailing list on bug reports,
thanks.

> >May 16 17:05:53 epia kernel: BUG: unable to handle kernel paging request
> >at virtual address 6b6b6b97
> >May 16 17:05:53 epia kernel:  printing eip:
> >May 16 17:05:53 epia kernel: c013cfe4
> >May 16 17:05:53 epia kernel: *pde = 00000000
> >May 16 17:05:53 epia kernel: Oops: 0000 [#1]
> >May 16 17:05:53 epia kernel: PREEMPT
> >May 16 17:05:53 epia kernel: Modules linked in: sha256 pwc sch_tbf
> >ipt_recent xt_string xt_MARK xt_length xt_tcpmss xt_mac xt_mark w83627hf
> >hwmon_vid eeprom i2c_isa sit nf_nat_h323 nf_conntrack_h323 nf_nat_ftp
> >nf_conntrack_ftp ipt_tos ipt_REDIRECT nf_nat_irc nf_conntrack_irc
> >ipt_owner ipt_ttl ipv6 ipt_MASQUERADE iptable_nat nf_nat xt_NOTRACK
> >iptable_raw ipt_TOS iptable_mangle ipt_LOG ipt_TCPMSS xt_limit xt_state
> >ipt_TARPIT ipt_REJECT iptable_filter binfmt_misc parport_pc lp parport
> >nvram snd_via82xx snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss
> >snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm snd_timer
> >snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device snd i2c_viapro
> >usblp compat_ioctl32 videodev v4l2_common v4l1_compat uhci_hcd
> >May 16 17:05:53 epia kernel: CPU:    0
> >May 16 17:05:53 epia kernel: EIP:    0060:[mempool_free+13/106]    Not
> >tainted VLI
> >May 16 17:05:53 epia kernel: EIP:    0060:[<c013cfe4>]    Not tainted VLI
> >May 16 17:05:53 epia kernel: EFLAGS: 00010286   (2.6.20.7t #15)
> >May 16 17:05:53 epia kernel: EIP is at mempool_free+0xd/0x6a
> >May 16 17:05:53 epia kernel: eax: c3955404   ebx: 6b6b6b6b   ecx:
> >c0307fac   edx: 6b6b6b6b
> >May 16 17:05:53 epia kernel: esi: c3955404   edi: c3955404   ebp:
> >ddeb3e60   esp: ddeb3e50
> >May 16 17:05:53 epia kernel: ds: 007b   es: 007b   ss: 0068
> >May 16 17:05:53 epia kernel: Process kcryptd/0 (pid: 297, ti=ddeb2000
> >task=ddf26b10 task.ti=ddeb2000)
> >May 16 17:05:53 epia kernel: Stack: 00000003 c62c392c c3955404 00000000
> >ddeb3e84 c02747d8 00000000 00000000
> >May 16 17:05:53 epia kernel:        00000000 000d4401 00000000 00000000
> >c357fd80 ddeb3eb0 c0274915 00000200
> >May 16 17:05:53 epia kernel:        ddeb3f2c dea18020 c49d8388 c62c392c
> >00000000 c357fd80 c0274878 00000000
> >May 16 17:05:53 epia kernel: Call Trace:
> >May 16 17:05:53 epia kernel:  [show_trace_log_lvl+26/47]
> >show_trace_log_lvl+0x1a/0x2f
> >May 16 17:05:53 epia kernel:  [<c0104013>] show_trace_log_lvl+0x1a/0x2f
> >May 16 17:05:53 epia kernel:  [show_stack_log_lvl+157/165]
> >show_stack_log_lvl+0x9d/0xa5
> >May 16 17:05:53 epia kernel:  [<c01040c5>] show_stack_log_lvl+0x9d/0xa5
> >May 16 17:05:53 epia kernel:  [show_registers+419/702]
> >show_registers+0x1a3/0x2be
> >May 16 17:05:53 epia kernel:  [<c0104270>] show_registers+0x1a3/0x2be
> >May 16 17:05:53 epia kernel:  [die+263/521] die+0x107/0x209
> >May 16 17:05:53 epia kernel:  [<c0104492>] die+0x107/0x209
> >May 16 17:05:53 epia kernel:  [do_page_fault+1096/1315]
> >do_page_fault+0x448/0x523
> >May 16 17:05:53 epia kernel:  [<c010f4f5>] do_page_fault+0x448/0x523
> >May 16 17:05:53 epia kernel:  [error_code+116/128] error_code+0x74/0x80
> >May 16 17:05:53 epia kernel:  [<c0308214>] error_code+0x74/0x80
> >May 16 17:05:53 epia kernel:  [dec_pending+349/357] dec_pending+0x15d/0x165
> >May 16 17:05:53 epia kernel:  [<c02747d8>] dec_pending+0x15d/0x165
> >May 16 17:05:53 epia kernel:  [clone_endio+157/203] clone_endio+0x9d/0xcb
> >May 16 17:05:53 epia kernel:  [<c0274915>] clone_endio+0x9d/0xcb
> >May 16 17:05:53 epia kernel:  [bio_endio+83/91] bio_endio+0x53/0x5b
> >May 16 17:05:54 epia kernel:  [<c0173947>] bio_endio+0x53/0x5b
> >May 16 17:05:54 epia kernel:  [dec_pending+55/69] dec_pending+0x37/0x45
> >May 16 17:05:54 epia kernel:  [<c027a07e>] dec_pending+0x37/0x45
> >May 16 17:05:54 epia kernel:  [kcryptd_do_work+158/830]
> >kcryptd_do_work+0x9e/0x33e
> >May 16 17:05:54 epia kernel:  [<c027a241>] kcryptd_do_work+0x9e/0x33e
> >May 16 17:05:54 epia kernel:  [run_workqueue+142/341]
> >run_workqueue+0x8e/0x155
> >May 16 17:05:54 epia kernel:  [<c01218e1>] run_workqueue+0x8e/0x155
> >May 16 17:05:54 epia kernel:  [worker_thread+260/302]
> >worker_thread+0x104/0x12e
> >May 16 17:05:54 epia kernel:  [<c0121f59>] worker_thread+0x104/0x12e
> >May 16 17:05:54 epia kernel:  [kthread+163/206] kthread+0xa3/0xce
> >May 16 17:05:54 epia kernel:  [<c012452d>] kthread+0xa3/0xce
> >May 16 17:05:54 epia kernel:  [kernel_thread_helper+7/16]
> >kernel_thread_helper+0x7/0x10
> >May 16 17:05:54 epia kernel:  [<c0103cb7>] kernel_thread_helper+0x7/0x10
> >May 16 17:05:54 epia kernel:  =======================
> >May 16 17:05:54 epia kernel: Code: 89 c2 55 89 c8 89 e5 e8 da 49 01 00
> >5d c3 89 d1 89 c2 55 89 c8 89 e5 e8 df 3e 01 00 5d c3 55 89 e5 57 89 c7
> >56 53 89 d3 83 ec 04 <8b> 42 2c 3b 42 28 7d 47 89 d0 e8 77 a8 1c 00 89
> >c6 8b 43 2c 3b
> >May 16 17:05:54 epia kernel: EIP: [mempool_free+13/106]
> >mempool_free+0xd/0x6a SS:ESP 0068:ddeb3e50
> >May 16 17:05:54 epia kernel: EIP: [<c013cfe4>] mempool_free+0xd/0x6a
> >SS:ESP 0068:ddeb3e50
> 
> 
> 	Jan
> -- 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
