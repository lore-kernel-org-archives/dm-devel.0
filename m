From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH -next] dm cache: fix error return code in cache_create()
Date: Thu, 25 Apr 2013 21:30:36 +0100
Message-ID: <20130425203036.GD23535@agk-dp.fab.redhat.com>
References: <CAPgLHd8twedhKj8MNkCyHKTEtV421_251Ot-zm-=boCJZ5nc9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPgLHd8twedhKj8MNkCyHKTEtV421_251Ot-zm-=boCJZ5nc9w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: agk@redhat.com, neilb@suse.de, yongjun_wei@trendmicro.com.cn, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Apr 19, 2013 at 01:11:30PM +0800, Wei Yongjun wrote:
> Fix to return -ENOMEM in the memory alloc error handing
> cases instead of 0, as done elsewhere in this function.
 
Otherwise it dereferences a NULL pointer...

Queued.

Alasdair

