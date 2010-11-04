From: Andi Kleen <andi@firstfloor.org>
Subject: Re: cmwq and dm-crypt devices?
Date: Thu, 4 Nov 2010 10:55:25 +0100
Message-ID: <20101104095525.GB32383@basil.fritz.box>
References: <x2h236ccac1004271358o90a80b6bi1b4099865abc81e8@mail.gmail.com>
	<20101102220207.GD23680@redhat.com> <4CD12F6E.8040501@kernel.org>
	<20101103115144.GA18935@basil.fritz.box>
	<4CD14DF1.90601@redhat.com>
	<20101103123347.GB18935@basil.fritz.box>
	<20101103131835.GB5833@agk-dp.fab.redhat.com>
	<20101103161327.GC18935@basil.fritz.box>
	<4CD18B24.2010602@kernel.org> <4CD18C2F.2070408@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4CD18C2F.2070408@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: Christophe Saout <christophe@saout.de>, Mike Snitzer <snitzer@redhat.com>, Brian Swetland <swetland@google.com>, San Mehat <san@google.com>, device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> Yes, that is exactly what I was looking for but was not sure if possible.
> 
> So switch to normal per device device threads (not singlethreaded as now)
> combined with the Andi's fixes and it should work for everyone?

Sounds like it could handle this.

You'll need to revert some of the hunks in my patch, I ripped out some
of the per device work queue code. It should not be very hard.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
