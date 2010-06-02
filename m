From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Date: Wed, 02 Jun 2010 09:51:59 +0200
Message-ID: <4C060D9F.3050600@linux.intel.com>
References: <20100531160425.GA20344@basil.fritz.box> <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com> <20100601043901.GA25693@gondor.apana.org.au> <Pine.LNX.4.64.1006020051540.22695@hs20-bc2-1.build.redhat.com> <20100602051403.GA5784@gondor.apana.org.au> <Pine.LNX.4.64.1006020119540.22695@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1006020119540.22695@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids


>>
>>> It is pointless to track the submitting CPU.
>>
>> No you are wrong.
>
> For what? For avoiding cache bounces? But the encrypting is
> order-of-magnitude slower than memory speed.

On a system with reasonably fast CPUs it's fastest to just stay
on your current CPU, don't try to talk to other CPUs, avoid
communication, just get the work done ASAP. But make
sure you can do this on multiple CPUs at the same time.

With AES-NI this becomes even more pronounced because it effectively
makes the CPU faster for encryption.

-andi
