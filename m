From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
Date: Sun, 10 Oct 2010 18:06:08 +0200
Message-ID: <20101010160608.GE26728@basil.fritz.box>
References: <20101010115941.GA8539@basil.fritz.box>
 <4CB1B3B9.4030205@redhat.com>
 <20101010130842.GE8256@basil.fritz.box>
 <4CB1DD1A.5080906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CB1DD1A.5080906@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>, device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On Sun, Oct 10, 2010 at 05:34:50PM +0200, Milan Broz wrote:
> On 10/10/2010 03:08 PM, Andi Kleen wrote:
> > I did it intentionally not split up because a split up is unlikely
> > to be bisectable. I think there is no need for any splitups.
> 
> Shrug. The main encryption thread and ESSIV per-cpu are two separate
> things from my point of view.

Is not obvious to me.

> 
> Anyway, the ball is on DM maintainer's playground now.

Well I was told already for 2.6.35 it was ready to merge
(and also I already have an active user base, people are using
it because it's solving a wide spread problem) 

I am frankly somewhat surprised things should be suddenly 
completely open now again and such contortions as you
did to the patch should be needed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
