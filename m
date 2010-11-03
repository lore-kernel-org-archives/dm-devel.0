From: Milan Broz <mbroz@redhat.com>
Subject: Re: cmwq and dm-crypt devices?
Date: Wed, 03 Nov 2010 12:56:33 +0100
Message-ID: <4CD14DF1.90601@redhat.com>
References: <1271958538-11193-1-git-send-email-san@google.com>
	<4BD08F78.4000701@redhat.com>
	<q2q236ccac1004221108y276b7e27x2a30e8a1eef77b03@mail.gmail.com>
	<4BD099DB.2020108@redhat.com>
	<s2p236ccac1004221242z4b0a8f68pbf7887e741a56af1@mail.gmail.com>
	<x2h236ccac1004271358o90a80b6bi1b4099865abc81e8@mail.gmail.com>
	<20101102220207.GD23680@redhat.com> <4CD12F6E.8040501@kernel.org>
	<20101103115144.GA18935@basil.fritz.box>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101103115144.GA18935@basil.fritz.box>
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

On 11/03/2010 12:51 PM, Andi Kleen wrote:
>>
>>> 2) scale up the number of workqueue threads used for a single dm-crypt
>>>    device so that a device can realize per-cpu concurrency (to address
>>>    Andi's scalability concerns: https://patchwork.kernel.org/patch/244031/)
> 
> They are already addressed in my patchkit and the patches seem to be used
> by more and more users. It's just you guys who are behind.

No, sorry, they are not addressed.

Did you read my mail with tests? http://lkml.org/lkml/2010/10/20/215

Async crypto is not solved at all by your patch.

Milan
