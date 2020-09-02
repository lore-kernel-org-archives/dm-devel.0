From: linmiaohe <linmiaohe@huawei.com>
Subject: Re: [PATCH] block: make bio_crypt_clone() return an error code
Date: Wed, 2 Sep 2020 06:34:16 +0000
Message-ID: <b90bb41c7755452eb6f3fb3116ff9d6d@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-block-owner@vger.kernel.org
To: Satya Tangirala <satyat@google.com>, Eric Biggers <ebiggers@kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Satya Tangirala <satyat@google.com> wrote:
>On Tue, Sep 01, 2020 at 10:15:11PM -0700, Eric Biggers wrote:
>> From: Eric Biggers <ebiggers@google.com>
>> 
>> Callers of bio_clone_fast() may use a gfp_mask that excludes 
>> GFP_DIRECT_RECLAIM.  For example, map_request() uses GFP_ATOMIC.
>> 
>> If this were to happen, the mempool_alloc() in __bio_crypt_clone() can 
>> fail, causing a NULL dereference.
>The call to blk_crypto_rq_bio_prep() from blk_rq_prep_clone() could also fail for the same reason. So we may need to make blk_crypto_rq_bio_prep() also return a bool and handle the errors in the callers (the only other caller is I think blk_mq_bio_to_request(), which explicitly calls the function with GFP_NOIO, so maybe we could explicitly document the fact that blk_mq_bio_to_request will return true when called with a gfp_mask th
at includes GFP_DIRECT_RECLAIM, and ignore the return value in blk_mq_bio_to_request()). (And maybe we should document the same for bio_crypt_set_ctx and bio_crypt_clone?)

Agreed.
Except for above suggestions, the patch looks good for me, many thanks.

>> 
>> In reality map_request() currently never has to clone an encryption  
