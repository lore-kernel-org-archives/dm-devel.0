From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] crypto: memzero_explicit - make sure to clear out sensitive
 data
Date: Sun, 07 Sep 2014 19:15:01 +0200
Message-ID: <540C9295.8070409@gmail.com>
References: <1410108360-15363-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <1410108360-15363-1-git-send-email-dborkman@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Daniel Borkmann <dborkman@redhat.com>
Cc: herbert@gondor.apana.org.au, tytso@mit.edu, hannes@stressinduktion.org, linux-crypto@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 09/07/2014 06:46 PM, Daniel Borkmann wrote:
> Recently, in commit 13aa93c70e71 ("random: add and use memzero_explicit()
> for clearing data"), we have found that GCC may optimize some memset()
> cases away when it detects a stack variable is not being used anymore
> and going out of scope. This can happen, for example, in cases when we
> are clearing out sensitive information such as keying material or any
> e.g. intermediate results from crypto computations, etc.

Hi,

do you plan to send patches also for other crypto code in kernel?
(I am almost sure we have the same pattern in dmcrypt.)

If not, I can do this for the dmcrypt part.

Milan
