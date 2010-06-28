From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard
  requests
Date: Mon, 28 Jun 2010 14:41:30 +0200
Message-ID: <4C28987A.7000701@kernel.dk>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-2-git-send-email-snitzer@redhat.com> <4C2896C6.9030607@kernel.dk> <20100628123742.GB19497@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100628123742.GB19497@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

On 2010-06-28 14:37, Mike Snitzer wrote:
> On Mon, Jun 28 2010 at  8:34am -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 2010-06-26 21:56, Mike Snitzer wrote:
>>> Don't alloc discard bio with a biovec in blkdev_issue_discard.  Doing so
>>> means bio_has_data() will not be true until the SCSI layer adds the
>>> payload to the discard request via blk_add_request_payload.
>>
>> Sorry, this looks horrible.
> 
> Your judgment isn't giving me much to work with... not sure where I go
> with "horrible".

The horrible part is working around that issue by fiddling with the
assignment of the internal vec. THAT looks like a horrible solution
to that problem.

How about just adding a check to bio_has_data() for non-zero
bio->bi_vcnt?

-- 
Jens Axboe
