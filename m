From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v7 0/6] block: Introduce REQ_ALLOCATE flag for REQ_OP_WRITE_ZEROES
Date: Thu, 19 Mar 2020 09:03:40 -0400
Message-ID: <yq1tv2k8pjn.fsf@oracle.com>
References: <158157930219.111879.12072477040351921368.stgit@localhost.localdomain>
        <e2b7cbab-d91f-fd7b-de6f-a671caa6f5eb@virtuozzo.com>
        <69c0b8a4-656f-98c4-eb55-2fd1184f5fc9@virtuozzo.com>
        <67d63190-c16f-cd26-6b67-641c8943dc3d@virtuozzo.com>
        <20200319102819.GA26418@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200319102819.GA26418@infradead.org> (Christoph Hellwig's
        message of "Thu, 19 Mar 2020 03:28:19 -0700")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>, axboe@kernel.dk, martin.petersen@oracle.com, bob.liu@oracle.com, darrick.wong@oracle.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


Christoph,

>> Some comments? Some requests for reworking? Some personal reasons to
>> ignore my patches?
>
> I'm still completely opposed to the magic overloading using a flag.
> That is just a bad design waiting for trouble to happen.

The observation was that Kirill's original patch set was a line-for-line
carbon copy of the write zeroes handling throughout the stack. The only
difference between the two was at the bottom. Instead of duplicating all
that code it seemed cleaner to use shared plumbing since these
operations need to be split and merged exactly the same way in the block
layer.

Also, we already have REQ_NOUNMAP, not sure why an additional handling
flag would lead to trouble? Note that I suggested renaming
REQ_OP_WRITE_ZEROES to something else to separate the semantics from the
plumbing.

We need to be able to express:

 - zero & allocate block range (REQ_OP_WRITE_ZEROES, REQ_NOUNMAP)
 - zero & deallocate block range (REQ_OP_WRITE_ZEROES, !REQ_NOUNMAP)
 - allocate block range (?, don't care about zeroing)
 - deallocate block range (REQ_OP_DISCARD, don't care about zeroing)

It just seems like a full-fledged REQ_OP_ALLOCATE is an overkill to fill
that gap.

That said, I do think that we have traditionally put emphasis on the
wrong part of these operations. All we ever talk about wrt. discard and
friends is the zeroing aspect. But I actually think that, semantically,
the act of allocating and deallocating blocks is more important. And
that zeroing is an optional second order effect of those operations. So
if we could go back in time and nuke multi-range DSM TRIM/UNMAP, I would
like to have REQ_OP_ALLOCATE/REQ_OP_DEALLOCATE with an optional REQ_ZERO
flag. I think that would be cleaner. I have a much easier time wrapping
my head around "allocate this block and zero it if you can" than "zero
this block and do not deallocate it". But maybe that's just me.

-- 
Martin K. Petersen	Oracle Linux Engineering
