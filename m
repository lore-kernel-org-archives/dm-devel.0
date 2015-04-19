From: =?ISO-8859-1?Q?Murilo_Opsfelder_Ara=FAjo?= <mopsfelder@gmail.com>
Subject: Re: Device mapper failed to open temporary keystore device
Date: Sun, 19 Apr 2015 14:08:38 -0300
Message-ID: <CA+LKeY5onPt_sJHQOgiuQjxqaT3cJv11DEeoDCqpHqn74on0bA@mail.gmail.com>
References: <CA+LKeY6Vm=hWj+gaKxm5JqLqehu8557OX2101a8roKas6WcsFg@mail.gmail.com>
 <20150417223848.GD4028@redhat.com> <20150418020021.GA2432@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150418020021.GA2432@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Mike Snitzer <snitzer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Apr 17, 2015 at 11:00 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Fri, Apr 17, 2015 at 06:38:49PM -0400, Mike Snitzer wrote:
>>
>> There are also some crypto changes that could very easily be the cause
>> of your problem (cc'ing Herbert), e.g.:
>>
>> $ git diff next-20150410^..next-20150413 -- crypto | diffstat
>
> My guess is that you guys need this patch:
>
> commit 34c9a0ffc75ad25b6a60f61e27c4a4b1189b8085
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Thu Apr 16 11:07:13 2015 +0800
>
>     crypto: fix broken crypto_register_instance() module handling
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Hello, Herbert.

Sorry for my ignorance but which tree and branch does this commit come from?

-- 
Murilo
