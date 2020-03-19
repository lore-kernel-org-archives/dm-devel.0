From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7 0/6] block: Introduce REQ_ALLOCATE flag for
 REQ_OP_WRITE_ZEROES
Date: Thu, 19 Mar 2020 03:28:19 -0700
Message-ID: <20200319102819.GA26418@infradead.org>
References: <158157930219.111879.12072477040351921368.stgit@localhost.localdomain>
 <e2b7cbab-d91f-fd7b-de6f-a671caa6f5eb@virtuozzo.com>
 <69c0b8a4-656f-98c4-eb55-2fd1184f5fc9@virtuozzo.com>
 <67d63190-c16f-cd26-6b67-641c8943dc3d@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <67d63190-c16f-cd26-6b67-641c8943dc3d@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, bob.liu@oracle.com, darrick.wong@oracle.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Mar 13, 2020 at 04:08:58PM +0300, Kirill Tkhai wrote:
> I just don't understand the reason nothing happens :(
> I see newly-sent patches comes fast into block tree.
> But there is only silence... I grepped over Documentation,
> and there is no special rules about block tree. So,
> it looks like standard rules should be applyable.
> 
> Some comments? Some requests for reworking? Some personal reasons to ignore my patches?

I'm still completely opposed to the magic overloading using a flag.
That is just a bad design waiting for trouble to happen.
