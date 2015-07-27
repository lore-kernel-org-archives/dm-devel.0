From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm cache: fix alloc_bitset check that always evaluates as false
Date: Mon, 27 Jul 2015 08:15:29 -0400
Message-ID: <20150727121529.GC2312@redhat.com>
References: <1437666479-24633-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437666479-24633-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jul 23 2015 at 11:47P -0400,
Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> static analysis by cppcheck has found a check on alloc_bitset that
> always evaluates as false and hence never finds an allocation failure:
> 
> [drivers/md/dm-cache-policy-smq.c:1689]: (warning) Logical conjunction
>   always evaluates to false: !EXPR && EXPR.
> 
> Fix this by removing the incorrect mq->cache_hit_bits check
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied for 4.2-rc5 inclussion, thanks:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=134bf30c06f057d6b8d90132e8f8b3cd2be79572
