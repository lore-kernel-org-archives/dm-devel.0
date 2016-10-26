From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] [PATCH 1/4] brd: handle misaligned discard
Date: Wed, 26 Oct 2016 14:57:49 -0700
Message-ID: <9ee4e796-2a85-3b81-ebaa-90ed50f8bf66@sandisk.com>
References: <alpine.LRH.2.02.1610211406290.9197@file01.intranet.prod.int.rdu2.redhat.com>
 <20161021200022.GA12580@redhat.com>
 <alpine.LRH.2.02.1610211616450.31606@file01.intranet.prod.int.rdu2.redhat.com>
 <20161024155756.GA48306@redhat.com> <20161025130712.GA12717@infradead.org>
 <20161025143719.GA51266@redhat.com>
 <710b07a3-9091-6935-37c4-ea1dcedcab4f@kernel.dk>
 <alpine.LRH.2.02.1610261624100.12287@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1610261625580.12287@file01.intranet.prod.int.rdu2.redhat.com>
 <338b76f0-40d1-904f-66e0-f6455c5287e7@sandisk.com>
 <alpine.LRH.2.02.1610261733190.25893@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1610261733190.25893@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 10/26/2016 02:46 PM, Mikulas Patocka wrote:
> I don't like the idea of complicating the code by turning discards into
> writes.

That's not what my patch series does. The only writes added by my patch 
series are those for the non-aligned head and tail of the range passed 
to blkdev_issue_zeroout().

> The flag "discard_zeroes_data" is actually misdesigned, because the
> storage stack can change dynamically while bios are in progress. You can
> send a discard bio to a device mapper device that has
> "discard_zeroes_data" - and while the bio is in progress, the device
> mapper stack can be reconfigured to redirect the bio to another device
> that doesn't have "discard_zeroes_data" - and the bio won't zero data and
> the caller that issued it has no way to find it out.
>
> I think the proper thing would be to move "discard_zeroes_data" flag into
> the bio itself - there would be REQ_OP_DISCARD and REQ_OP_DISCARD_ZERO -
> and if the device doesn't support REQ_OP_DISCARD_ZERO, it rejects the bio
> and the caller is supposed to do zeroing manually.

Sorry but I don't like this proposal. I think that a much better 
solution would be to pause I/O before making any changes to the 
discard_zeroes_data flag.

Bart.
