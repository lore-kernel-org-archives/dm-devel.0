From: Milan Broz <mbroz@redhat.com>
Subject: Re: cmwq and dm-crypt devices?
Date: Wed, 03 Nov 2010 17:22:07 +0100
Message-ID: <4CD18C2F.2070408@redhat.com>
References: <q2q236ccac1004221108y276b7e27x2a30e8a1eef77b03@mail.gmail.com>
	<4BD099DB.2020108@redhat.com>
	<s2p236ccac1004221242z4b0a8f68pbf7887e741a56af1@mail.gmail.com>
	<x2h236ccac1004271358o90a80b6bi1b4099865abc81e8@mail.gmail.com>
	<20101102220207.GD23680@redhat.com> <4CD12F6E.8040501@kernel.org>
	<20101103115144.GA18935@basil.fritz.box>
	<4CD14DF1.90601@redhat.com>
	<20101103123347.GB18935@basil.fritz.box>
	<20101103131835.GB5833@agk-dp.fab.redhat.com>
	<20101103161327.GC18935@basil.fritz.box>
	<4CD18B24.2010602@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4CD18B24.2010602@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: Christophe Saout <christophe@saout.de>, Mike Snitzer <snitzer@redhat.com>, Brian Swetland <swetland@google.com>, San Mehat <san@google.com>, device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 11/03/2010 05:17 PM, Tejun Heo wrote:
>> The old stacking relies on per device threads. Per device threads
>> cannot be combined with per CPU threads, because that would lead
>> to a thread explosion for large device counts.
> 
> Dunno the context here but creating WQ_NON_REENTRANT | WQ_MEM_RECLAIM
> workqueue per device should achieve what you want.  It will be per-cpu
> while reserving only one worker per workqueue, so there won't be
> explosion of threads.

Thanks for answer,

Yes, that is exactly what I was looking for but was not sure if possible.

So switch to normal per device device threads (not singlethreaded as now)
combined with the Andi's fixes and it should work for everyone?

Milan
