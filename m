From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: cmwq and dm-crypt devices?
Date: Wed, 3 Nov 2010 13:18:35 +0000
Message-ID: <20101103131835.GB5833@agk-dp.fab.redhat.com>
References: <4BD08F78.4000701@redhat.com>
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
Content-Disposition: inline
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
Cc: Christophe Saout <christophe@saout.de>, Mike Snitzer <snitzer@redhat.com>, Brian Swetland <swetland@google.com>, San Mehat <san@google.com>, device-mapper development <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 03, 2010 at 01:33:47PM +0100, Andi Kleen wrote:
> Traditionally stacking didn't work very 
> well in the kernel due to the limited kernel stack overflows. 
> I don't think that's significantly different here.
 
Stacking in dm works reasonably well today and many people rely upon
that.

> Anyways stacking could be probably fixed, but it's also that 99.999999%

Please fix this regression the patch causes then or give some
fundamental arguments why we can't satisfy the two requirements
simultaneously: I just don't understand why it is necessary to cause a
regression in stacking/low memory support in order to provide the
performance boost in the way you desire.  The two things ought to be
independent of each other.

(And I remain sceptical about the suitability of the patch even with a
stack of just two or three layers as I don't see anything in the failed
tests that shows why similar failures couldn't in principle affect
people with thinner stacks.  The compromise I suggested was to amend the
patch to introduce the change only for non-stacked devices.)

Alasdair
