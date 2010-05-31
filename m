From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Mon, 31 May 2010 20:55:50 +0200
Message-ID: <4C040636.8060702@redhat.com>
References: <20100531160425.GA20344@basil.fritz.box> <4C03F04D.4040200@redhat.com> <20100531174225.GE10766@basil.fritz.box> <4C03FB8E.1060109@redhat.com> <20100531182724.GG10766@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100531182724.GG10766@basil.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: device-mapper development <dm-devel@redhat.com>, herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
List-Id: dm-devel.ids

On 05/31/2010 08:27 PM, Andi Kleen wrote:

>>> AES-NI is not asynchronous and doesn't have limited resources.
>>
>> AES-NI used asynchronous crypto interface, was using asynchronous
>> crypto API cryptd daemon IIRC. So this changed?
> 
> AFAIK all ciphers use the asynchronous interface,  but that 
> doesn't mean they are actually asynchronous. AES-NI certainly
> does not require running in a special thread. The only
> thing it doesn't support is running from interrupt context.

I mean how it is implemented now in crypto API, and I was almost
sure that aes-ni acceleration code uses cryptd (iow real asynchronous processing)
and also that not all CPU cores can run these instruction in parallel.

So I am mistaken here?

Milan
