From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Tue, 12 Apr 2011 08:20:43 +0200
Message-ID: <4DA3EF3B.9080804@fusionio.com>
References: <20110308202100.GA31744@redhat.com> <4D76912C.9040705@fusionio.com> <20110308220526.GA393@redhat.com> <20110310005810.GA17911@redhat.com> <20110405130541.6c2b5f86@notabene.brown> <20110411145022.710c30e9@notabene.brown> <4DA2C7BE.6060804@fusionio.com> <20110411205928.13915719@notabene.brown> <20110411215521.78c87573@notabene.brown> <4DA2F02D.2000903@fusionio.com> <20110411225812.GA32310@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110411225812.GA32310@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On 2011-04-12 00:58, hch@infradead.org wrote:
> Looking at the patch
> (http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=761e433f3de6fb8e369af9e5c08beb86286d023f)
> 
> I'm not sure it's an optimal design.  The flush callback really
> is a per-queue thing.  Why isn't it a function pointer in the request
> queue when doing the blk_run_queue call once we're done with a given
> queue before moving on to the next one?

I was thinking about this yesterday as well, the design didn't quite
feel just right. Additionally the user now must track this state too,
and whether he's plugged on that task or not.

I'll rewrite this.

-- 
Jens Axboe

