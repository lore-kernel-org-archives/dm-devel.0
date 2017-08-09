From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [dm-devel] [BUG] BLKZEROOUT on dm-crypt container cause OOM /
 kernel panic
Date: Wed, 9 Aug 2017 20:21:21 +0200
Message-ID: <b6ae3be0-a0f6-7f3f-65ed-ee6b80c133f7@redhat.com>
References: <CAGnHSEngW1Ugf66V5henR9fMEev0xcJnKVY9MjJb19gy3CkgNA@mail.gmail.com>
 <20170809133833.GA25681@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170809133833.GA25681@lst.de>
Content-Language: en-MW
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, Tom Yan <tom.ty89@gmail.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, "axboe@fb.com" <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, gmazyland@gmail.com
List-Id: dm-devel.ids

On 08/09/2017 03:38 PM, hch@lst.de wrote:
> Does commit 615d22a51c04856efe62af6e1d5b450aaf5cc2c0
> "block: Fix __blkdev_issue_zeroout loop" fix the issue for you?

I crashed the 4.13-rc4 with the test above (blkdiscard -z on dm-crypt 
dev). Unfortunately I hadn't have my VM configured properly so the only 
info I got before it crashed was basically OOM. I'm going to play with 
it tomorrow and will let you know.

O.
