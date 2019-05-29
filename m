From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] [PATCH] dm-init: fix 2 incorrect use of kstrndup()
Date: Wed, 29 May 2019 05:23:53 -0700
Message-ID: <fcf2c3c0-e479-9e74-59d5-79cd2a0bade6@acm.org>
References: <20190529013320.GA3307@zhanggen-UX430UQ>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190529013320.GA3307@zhanggen-UX430UQ>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Gen Zhang <blackgod016574@gmail.com>, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 5/28/19 6:33 PM, Gen Zhang wrote:
> In drivers/md/dm-init.c, kstrndup() is incorrectly used twice.
> 
> It should be: char *kstrndup(const char *s, size_t max, gfp_t gfp);

Should the following be added to this patch?

Fixes: 6bbc923dfcf5 ("dm: add support to directly boot to a mapped
device") # v5.1.
Cc: stable

Thanks,

Bart.
