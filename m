From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Fix slab name "biovec-(1<<(21-12))"
Date: Wed, 21 Mar 2018 19:25:53 -0600
Message-ID: <8aa57856-ad92-0358-27ed-45ddc55c5b35@kernel.dk>
References: <alpine.LRH.2.02.1803211248020.26409@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1803211248020.26409@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 3/21/18 10:49 AM, Mikulas Patocka wrote:
> I'm getting a slab named "biovec-(1<<(21-12))". It is caused by unintended
> expansion of the macro BIO_MAX_PAGES. This patch renames it to biovec-max.

Applied, thanks.

-- 
Jens Axboe
