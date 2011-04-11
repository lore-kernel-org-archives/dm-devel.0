From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Mon, 11 Apr 2011 14:48:45 +0200
Message-ID: <4DA2F8AD.1060605@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>	<20110303221353.GA10366@redhat.com>	<4D761E0D.8050200@fusionio.com>	<20110308202100.GA31744@redhat.com>	<4D76912C.9040705@fusionio.com>	<20110308220526.GA393@redhat.com>	<20110310005810.GA17911@redhat.com>	<20110405130541.6c2b5f86@notabene.brown>	<20110411145022.710c30e9@notabene.brown>	<4DA2C7BE.6060804@fusionio.com>	<20110411205928.13915719@notabene.brown>	<4DA2E03A.2080607@fusionio.com>	<20110411212635.7959de70@notabene.brown>	<4DA2E7F0.9010904@fusionio.com>	<20110411220505.1028816e@notabene.brown>	<4DA2F00E.6010907@fusionio.com> <20110411223623.4278fad1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110411223623.4278fad1@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On 2011-04-11 14:36, NeilBrown wrote:
> On Mon, 11 Apr 2011 14:11:58 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:
> 
>>> Yes.  But I need to know when to release the requests that I have stored.
>>> I need to know when ->write_pages or ->read_pages or whatever has finished
>>> submitting a pile of pages so that I can start processing the request that I
>>> have put aside.  So I need a callback from blk_finish_plug.
>>
>> OK fair enough, I'll add your callback patch.
>>
> 
> Thanks.  I'll queue up my md fixes to follow it once it gets  to -linus.

Great, once you do that and XFS kills the blk_flush_plug() calls too,
then we can remove that export and make it internal only.

-- 
Jens Axboe
