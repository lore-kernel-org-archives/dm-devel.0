From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Mon, 11 Apr 2011 18:58:12 -0400
Message-ID: <20110411225812.GA32310@infradead.org>
References: <20110308202100.GA31744@redhat.com>
 <4D76912C.9040705@fusionio.com>
 <20110308220526.GA393@redhat.com>
 <20110310005810.GA17911@redhat.com>
 <20110405130541.6c2b5f86@notabene.brown>
 <20110411145022.710c30e9@notabene.brown>
 <4DA2C7BE.6060804@fusionio.com>
 <20110411205928.13915719@notabene.brown>
 <20110411215521.78c87573@notabene.brown>
 <4DA2F02D.2000903@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4DA2F02D.2000903@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

Looking at the patch
(http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=761e433f3de6fb8e369af9e5c08beb86286d023f)

I'm not sure it's an optimal design.  The flush callback really
is a per-queue thing.  Why isn't it a function pointer in the request
queue when doing the blk_run_queue call once we're done with a given
queue before moving on to the next one?
