From: Milan Broz <mbroz@redhat.com>
Subject: Re: cmwq and dm-crypt devices?
Date: Wed, 03 Nov 2010 14:02:14 +0100
Message-ID: <4CD15D56.1060808@redhat.com>
References: <1271958538-11193-1-git-send-email-san@google.com>
	<4BD08F78.4000701@redhat.com>
	<q2q236ccac1004221108y276b7e27x2a30e8a1eef77b03@mail.gmail.com>
	<4BD099DB.2020108@redhat.com>
	<s2p236ccac1004221242z4b0a8f68pbf7887e741a56af1@mail.gmail.com>
	<x2h236ccac1004271358o90a80b6bi1b4099865abc81e8@mail.gmail.com>
	<20101102220207.GD23680@redhat.com> <4CD12F6E.8040501@kernel.org>
	<20101103115144.GA18935@basil.fritz.box>
	<4CD14DF1.90601@redhat.com>
	<20101103123347.GB18935@basil.fritz.box>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101103123347.GB18935@basil.fritz.box>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andi Kleen <andi@firstfloor.org>
Cc: Christophe Saout <christophe@saout.de>, Mike Snitzer <snitzer@redhat.com>, Brian Swetland <swetland@google.com>, San Mehat <san@google.com>, device-mapper development <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 11/03/2010 01:33 PM, Andi Kleen wrote:
>> Async crypto is not solved at all by your patch.
> 
> You mean async crypto with 10 stacked devices? Find me a single
> user who does that.

It is just quick reproducer. It can happen with several
non-stacked devices too and just points to the
problem that there was reason for dedicated threads per device.

I would really prefer If we can fix the scalable problem without
dismantling existing stacking support.

There are users who plans to massively use many dm-crypt devices
in system and this will ensure that it will work properly
even in bizarre configurations.

> Traditionally stacking didn't work very 
> well in the kernel due to the limited kernel stack overflows. 
> I don't think that's significantly different here.

Sorry? device-mapper is designed to be stackable. And it works.

> Anyways stacking could be probably fixed, but it's also that 99.999999%
> of all dm-crypt users don't stack or use async but simply need a 
> scalable dm-crypt.  Extreme stacking is extremly low on the 
> priority list.
> 
> Right now dm-crypt seems to have other problems anyways that need
> to be addressed first.

I fixed many bugs in dm-crypt which were caused by reducing problem
to "common situation" (and which appeared later).

Please can you fix you patch instead of this argumentation?

I know that some fix is needed, I am using the patch myself and I am also
receiving mails requesting it.

The whole thread was reopened because we tried to find solution
to this - IOW fix your patch.

Milan
