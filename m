From: Mikulas Patocka <mpatocka@redhat.com>
Subject: crypto API and GFP_ATOMIC
Date: Tue, 9 Jun 2020 13:11:05 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi

I've found out that a lot of hardware crypto drivers use GFP_ATOMIC. Some 
of them switch between GFP_ATOMIC and GFP_KERNEL based on the flag 
CRYPTO_TFM_REQ_MAY_SLEEP.

dm-crypt and dm-integrity don't use CRYPTO_TFM_REQ_MAY_SLEEP (because 
GFP_KERNEL allocation requests can recurse back to the block device 
drivers and cause deadlocks).

So, basically, the crypto requests submitted by dm-crypt and dm-integrity 
can fail anytime. I'd like to ask, how to handle these random -ENOMEM 
return codes. If we pass -ENOMEM back to the block device stack, it could 
cause random I/O errors and data corruption.

The question is - if the crypto request returns -ENOMEM, could we sleep 
and retry it? I thought about it - the problem could be, if the crypto 
requests proceeds hafway through and then returns -ENOMEM, and if we 
retried it, it would cause data corruption, because part of the data would 
be decrypted twice.

Is it safe to assume that when we get -ENOMEM, the crypto driver didn't 
modify anything?

Do you have another idea how to solve this problem?

Mikulas
