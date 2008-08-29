From: Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: Tree for August 27
Date: Fri, 29 Aug 2008 11:37:37 +0200
Message-ID: <48B7C361.9070008@kernel.org>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com> <200808272145.20627.bzolnier@gmail.com> <200808290210.37211.bzolnier@gmail.com> <20080829070515.GL20055@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756244AbYH2Jjp@vger.kernel.org>
In-Reply-To: <20080829070515.GL20055@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, dm-devel@redhat.com
List-Id: dm-devel.ids

Jens Axboe wrote:
>> On the somehow related topic - CONFIG_DEBUG_BLOCK_EXT_DEVT which is
>> introduced by commit 3e5ba59bbab878f60b8b87004ac55a464bddc819 ("block:
>> implement CONFIG_DEBUG_BLOCK_EXT_DEVT") is way too intrusive to be
>> enabled by default if CONFIG_DEBUG_KERNEL is set as it easily results
>> in no longer bootable systems (+ help entry for the new option says
>> "Say N if you are unsure.").
>>
>> Tejun/Jens: please consider changing this.
> 
> I have change the default to 'n' for now.

Hmmm... it broke booting?  Bart, can you please elaborate a bit what got
broken?  Did it fail to locate the root partition or were you using
static device nodes?

Thanks.

-- 
tejun
