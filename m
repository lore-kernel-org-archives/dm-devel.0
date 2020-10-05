From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/3] block: fix up bio_crypt_ctx allocation
Date: Mon, 5 Oct 2020 10:48:16 -0600
Message-ID: <b84faa9c-f5e7-8c90-d54b-6a1dbf68a35b@kernel.dk>
References: <20200916035315.34046-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200916035315.34046-1-ebiggers@kernel.org>
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>, linux-block@vger.kernel.org
Cc: dm-devel@redhat.com, Satya Tangirala <satyat@google.com>, Miaohe Lin <linmiaohe@huawei.com>
List-Id: dm-devel.ids

On 9/15/20 9:53 PM, Eric Biggers wrote:
> This series makes allocation of encryption contexts either able to fail,
> or explicitly require __GFP_DIRECT_RECLAIM (via WARN_ON_ONCE).
> 
> This applies to linux-block/for-next.
> 
> Changed since v1 (https://lkml.kernel.org/r/20200902051511.79821-1-ebiggers@kernel.org):
>     - Added patches 2 and 3.
>     - Added kerneldoc for bio_crypt_clone().
>     - Adjusted commit message.

Applied for 5.10, thanks.

-- 
Jens Axboe
