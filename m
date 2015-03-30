From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 2/2] lib/lcm.c: lcm(n,0)=lcm(0,n) is 0, not n
Date: Mon, 30 Mar 2015 21:38:27 +0200
Message-ID: <87y4me8edo.fsf@rasmusvillemoes.dk>
References: <1418158984-25546-1-git-send-email-linux@rasmusvillemoes.dk>
	<1418158984-25546-2-git-send-email-linux@rasmusvillemoes.dk>
	<CAMM=eLdw+7zfoufBEBSKhVR5d=g-a-GdzTA4WBgXUcMx=Av91A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMM=eLdw+7zfoufBEBSKhVR5d=g-a-GdzTA4WBgXUcMx=Av91A@mail.gmail.com>
	(Mike Snitzer's message of "Sat, 28 Mar 2015 22:44:28 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>
List-Id: dm-devel.ids

On Sun, Mar 29 2015, Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Dec 9, 2014 at 4:03 PM, Rasmus Villemoes
> <linux@rasmusvillemoes.dk> wrote:
>> Return the mathematically correct answer when an argument is 0.
>>
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>
> This change is the source of 3.19 regression for stacking device
> limits, via commit 69c953c ("lib/lcm.c: lcm(n,0)=lcm(0,n) is 0, not
> n").
>
>
> Rasmus, mathematical purity of lcm() aside, it'd have been nice if you
> looked at the lcm() callers to determine whether you'd be breaking
> them.

I'm sorry about this. I thought I did check the callers, but evidently
not well enough.

Rasmus
