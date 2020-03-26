From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7 0/6] block: Introduce REQ_ALLOCATE flag
 for REQ_OP_WRITE_ZEROES
Date: Thu, 26 Mar 2020 07:45:56 -0700
Message-ID: <20200326144556.GA4317@infradead.org>
References: <e2b7cbab-d91f-fd7b-de6f-a671caa6f5eb@virtuozzo.com>
	<69c0b8a4-656f-98c4-eb55-2fd1184f5fc9@virtuozzo.com>
	<67d63190-c16f-cd26-6b67-641c8943dc3d@virtuozzo.com>
	<20200319102819.GA26418@infradead.org> <yq1tv2k8pjn.fsf@oracle.com>
	<20200325162656.GJ29351@magnolia>
	<20200325163223.GA27156@infradead.org> <yq1d090jqlm.fsf@oracle.com>
	<20200326092935.GA6478@infradead.org> <yq1lfnngp6l.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <yq1lfnngp6l.fsf@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: andrea.parri@amarulasolutions.com, snitzer@redhat.com, dhowells@redhat.com, song@kernel.org, dm-devel@redhat.com, adilger.kernel@dilger.ca, osandov@fb.com, agk@redhat.com, hare@suse.com, sagi@grimberg.me, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, bob.liu@oracle.com, minwoo.im.dev@gmail.com, jthumshirn@suse.de, ajay.joshi@wdc.com, Chaitanya.Kulkarni@wdc.com, ming.lei@redhat.com, linux-block@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>, dsterba@suse.com, bvanassche@acm.org, axboe@kernel.dk, damien.lemoal@wdc.com, tytso@mit.edu, linux-kernel@vger.kernel.org, tj@kernel.org, asml.silence@gmail.com
List-Id: dm-devel.ids

On Thu, Mar 26, 2020 at 10:34:42AM -0400, Martin K. Petersen wrote:
> I just worry about the proliferation of identical merging and splitting
> code throughout the block stack as we add additional single-range, no
> payload operations (Verify, etc.). I prefer to enforce the semantics in
> the LLD and not in the plumbing. But I won't object to a separate
> REQ_OP_ALLOCATE if you find the resulting code duplication acceptable.

I find it acceptable for now.  And I think we should find some way
(e.g. by being table driven) to share code between differnet opcodes.
