From: Maksym Planeta <mplaneta@os.inf.tu-dresden.de>
Subject: Re: Remove WQ_CPU_INTENSIVE flag from unbound wq's
Date: Thu, 13 Feb 2020 17:19:01 +0100
Message-ID: <82715589-8b59-5cfd-a32f-1e57871327fe@os.inf.tu-dresden.de>
References: <20200213141823.2174236-1-mplaneta@os.inf.tu-dresden.de>
 <20200213153645.GA11313@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200213153645.GA11313@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Zhou Wang <wangzhou1@hisilicon.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Song Liu <song@kernel.org>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org
List-Id: dm-devel.ids



On 13/02/2020 16:36, Mike Snitzer wrote:
> On Thu, Feb 13 2020 at  9:18am -0500,
> Maksym Planeta <mplaneta@os.inf.tu-dresden.de> wrote:
> 
>> The documentation [1] says that WQ_CPU_INTENSIVE is "meaningless" for
>> unbound wq. I remove this flag from places where unbound queue is
>> allocated. This is supposed to improve code readability.
>>
>> 1. https://www.kernel.org/doc/html/latest/core-api/workqueue.html#flags
>>
>> Signed-off-by: Maksym Planeta <mplaneta@os.inf.tu-dresden.de>
> 
> What the Documentation says aside, have you cross referenced with the
> code?  And/or have you done benchmarks to verify no changes?
> 

It seems so from the code. Although, I'm not 100% confident. I did not 
run benchmarks, instead I relied that on the assumption that 
documentation is correct.

> Thanks,
> Mike
> 

-- 
Regards,
Maksym Planeta
