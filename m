From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs v3 on 2.6.37-rc* ?
Date: Sun, 07 Nov 2010 15:30:18 +0100
Message-ID: <4CD6B7FA.3050005@redhat.com>
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt <jackdachef@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Linux Kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids


On 11/06/2010 11:16 PM, Matt wrote:
> before diving into testing out 2.6.37-rc* kernels I wanted to make
> sure that the patch:
> 
> [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
> 
> is safe to use with e.g. >2.6.37-rc1 kernels
> 
> I know that it's not a "fix all" patch but it significantly seems to
> speed up my backup jobs (by factor 2-3)
> and 2.6.37* has evolved that much that interactivity isn't hurt too much

yes, it should work for the simple mappings without problems.

I hope we will fix the patch soon to be ready for upstream.

Milan
