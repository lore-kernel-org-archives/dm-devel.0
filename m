From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: Re: [PATCH v7 0/6] block: Introduce REQ_ALLOCATE flag for
 REQ_OP_WRITE_ZEROES
Date: Thu, 19 Mar 2020 13:42:11 +0300
Message-ID: <dda7926e-7f2c-61b7-9173-845377cf1229@virtuozzo.com>
References: <158157930219.111879.12072477040351921368.stgit@localhost.localdomain>
 <e2b7cbab-d91f-fd7b-de6f-a671caa6f5eb@virtuozzo.com>
 <69c0b8a4-656f-98c4-eb55-2fd1184f5fc9@virtuozzo.com>
 <67d63190-c16f-cd26-6b67-641c8943dc3d@virtuozzo.com>
 <20200319102819.GA26418@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200319102819.GA26418@infradead.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, martin.petersen@oracle.com
Cc: axboe@kernel.dk, bob.liu@oracle.com, darrick.wong@oracle.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 19.03.2020 13:28, Christoph Hellwig wrote:
> On Fri, Mar 13, 2020 at 04:08:58PM +0300, Kirill Tkhai wrote:
>> I just don't understand the reason nothing happens :(
>> I see newly-sent patches comes fast into block tree.
>> But there is only silence... I grepped over Documentation,
>> and there is no special rules about block tree. So,
>> it looks like standard rules should be applyable.
>>
>> Some comments? Some requests for reworking? Some personal reasons to ignore my patches?
> 
> I'm still completely opposed to the magic overloading using a flag.
> That is just a bad design waiting for trouble to happen.

This flag is suggested by Martin Petersen, while the first version of the patchset was based
on a separate operation.

Since I see only Jens in MAINTAINERS:

BLOCK LAYER
M:      Jens Axboe <axboe@kernel.dk>
L:      linux-block@vger.kernel.org
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
S:      Maintained
F:      block/
F:      drivers/block/
F:      kernel/trace/blktrace.c
F:      lib/sbitmap.c

I expect his comments about final design of this, because both you and Martin are maintainers
of another subsystems. I don't want rework this many times until Jens says he wants some third
design.

I think I'm pretty polite and patient in my waiting, while Jens completely ignores me by some
reasons, which are completely unclear for me. I don't think this is completely polite in relation
to me.

Kirill
