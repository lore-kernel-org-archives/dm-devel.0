From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v7 0/6] block: Introduce REQ_ALLOCATE flag for REQ_OP_WRITE_ZEROES
Date: Wed, 25 Mar 2020 13:23:33 -0400
Message-ID: <yq1d090jqlm.fsf@oracle.com>
References: <158157930219.111879.12072477040351921368.stgit@localhost.localdomain>
        <e2b7cbab-d91f-fd7b-de6f-a671caa6f5eb@virtuozzo.com>
        <69c0b8a4-656f-98c4-eb55-2fd1184f5fc9@virtuozzo.com>
        <67d63190-c16f-cd26-6b67-641c8943dc3d@virtuozzo.com>
        <20200319102819.GA26418@infradead.org> <yq1tv2k8pjn.fsf@oracle.com>
        <20200325162656.GJ29351@magnolia>
        <20200325163223.GA27156@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200325163223.GA27156@infradead.org> (Christoph Hellwig's
        message of "Wed, 25 Mar 2020 09:32:23 -0700")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, axboe@kernel.dk, bob.liu@oracle.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


Christoph,

> I am very much against that for the following reason:
>
>  - the current REQ_OP_DISCARD is purely a hint, and implementations can
>    (and do) choose to ignore it
>
>  - REQ_OP_WRITE_ZEROES is an actual data integrity operation with
>    everything that entails

If you want to keep emphasis on the "integrity operation" instead of the
provisioning aspect, would you expect REQ_ALLOCATE (which may or may not
zero blocks) to be considered a deterministic operation or a
non-deterministic one? Should this depend on whether the device
guarantees zeroing when provisioning blocks or not?

-- 
Martin K. Petersen	Oracle Linux Engineering
