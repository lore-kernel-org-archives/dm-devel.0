From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v7 0/6] block: Introduce REQ_ALLOCATE flag for REQ_OP_WRITE_ZEROES
Date: Thu, 26 Mar 2020 10:34:42 -0400
Message-ID: <yq1lfnngp6l.fsf@oracle.com>
References: <158157930219.111879.12072477040351921368.stgit@localhost.localdomain>
        <e2b7cbab-d91f-fd7b-de6f-a671caa6f5eb@virtuozzo.com>
        <69c0b8a4-656f-98c4-eb55-2fd1184f5fc9@virtuozzo.com>
        <67d63190-c16f-cd26-6b67-641c8943dc3d@virtuozzo.com>
        <20200319102819.GA26418@infradead.org> <yq1tv2k8pjn.fsf@oracle.com>
        <20200325162656.GJ29351@magnolia>
        <20200325163223.GA27156@infradead.org> <yq1d090jqlm.fsf@oracle.com>
        <20200326092935.GA6478@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200326092935.GA6478@infradead.org> (Christoph Hellwig's
        message of "Thu, 26 Mar 2020 02:29:35 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, axboe@kernel.dk, bob.liu@oracle.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


Christoph,

> That's why I don't like the whole flags game very much.  I'd rather
> have REQ_OP_WRITE_ZEROES as the integrity operation that gurantees
> zeroing, and a REQ_ALLOCATE that doesn't guarantee zeroing, just some
> deterministic state of the blocks.

I just worry about the proliferation of identical merging and splitting
code throughout the block stack as we add additional single-range, no
payload operations (Verify, etc.). I prefer to enforce the semantics in
the LLD and not in the plumbing. But I won't object to a separate
REQ_OP_ALLOCATE if you find the resulting code duplication acceptable.

-- 
Martin K. Petersen	Oracle Linux Engineering
