From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.27.14: BUG: lock held when returning to user space!
Date: Wed, 25 Feb 2009 17:29:49 +0100
Message-ID: <1235579389.4645.3621.camel@laptop>
References: <20090225142136.GA29505@janus>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759636AbZBYQaH@vger.kernel.org>
In-Reply-To: <20090225142136.GA29505@janus>
Sender: linux-kernel-owner@vger.kernel.org
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, 2009-02-25 at 15:21 +0100, Frank van Maarseveen wrote:
> An lvextend -L+16G command for a logical volume while being mounted rw
> as ext3 triggered the following on 2.6.27.14:
> 
> ================================================
> [ BUG: lock held when returning to user space! ]
> ------------------------------------------------
> lvextend/29191 is leaving the kernel with locks still held!
> 2 locks held by lvextend/29191:
>  #0: (&type->s_umount_key #15){....}, at: [<c019edfb>] get_super+0x6b/0xb0
>  #1: (&journal->j_barrier){....}, at: [<c01f9af3>] journal_lock_updates+0xc3/0xd0

Do recent kernels still say this?

CC'ed lvm folks.
