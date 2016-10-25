From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] brd: remove support for BLKFLSBUF
Date: Tue, 25 Oct 2016 08:46:52 -0600
Message-ID: <710b07a3-9091-6935-37c4-ea1dcedcab4f@kernel.dk>
References: <alpine.LRH.2.02.1610211406290.9197@file01.intranet.prod.int.rdu2.redhat.com>
 <20161021200022.GA12580@redhat.com>
 <alpine.LRH.2.02.1610211616450.31606@file01.intranet.prod.int.rdu2.redhat.com>
 <20161024155756.GA48306@redhat.com> <20161025130712.GA12717@infradead.org>
 <20161025143719.GA51266@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161025143719.GA51266@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 10/25/2016 08:37 AM, Mike Snitzer wrote:
> On Tue, Oct 25 2016 at  9:07P -0400,
> Christoph Hellwig <hch@infradead.org> wrote:
>
>> I think the right fix is to kill off the BLKFLSBUF special case in
>> brd.  Yes, it break compatibility - but in this case the compatibility
>> breaks more than it helps.
>
> Jens, please pick up this patch:
>
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Tue, 25 Oct 2016 10:25:07 -0400
> Subject: [PATCH] brd: remove support for BLKFLSBUF

Added, thanks.

-- 
Jens Axboe

