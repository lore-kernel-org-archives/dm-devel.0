From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more
	than 120 seconds
Date: Tue, 18 Mar 2008 05:07:43 +0100
Message-ID: <47DF400F.5080606@redhat.com>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de>
	<200803150108.04008.chunkeey@web.de>
	<200803151432.11125.chunkeey@web.de>
	<200803152234.53199.chunkeey@web.de>
	<alpine.DEB.1.00.0803161406040.6213@sheep.housecafe.de>
	<20080317173609.GD29322@agk.fab.redhat.com>
	<20080318005653.GA14575@gondor.apana.org.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080318005653.GA14575@gondor.apana.org.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ritesh Raj Sarraf <rrs@researchut.com>, Christian Kujau <lists@nerdbynature.de>, David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Chr <chunkeey@web.de>, dm-devel@redhat.com, dm-crypt@saout.de
List-Id: dm-devel.ids

Herbert Xu wrote:
> On Mon, Mar 17, 2008 at 05:36:09PM +0000, Alasdair G Kergon wrote:
>> Latest version for everyone to try:
>>
>> From: Milan Broz <mbroz@redhat.com>
>>
>> Fix regression in dm-crypt introduced in commit
>> 3a7f6c990ad04e6f576a159876c602d14d6f7fef
>> (dm crypt: use async crypto).
>>
>> If write requests need to be split into pieces, the code must not
>> process them in parallel because the crypto context cannot be shared.
>> So there can be parallel crypto operations on one part of the write,
>> but only one write bio can be processed at a time.
> 
> Could you explain this part please? Crypto tfm objects are meant
> to be reentrant, synchronous or not.

Ah, sorry - I mean dm-crypt convert context (with crypto context included).

Context is reentrant in the sense of crypto operations. But we need also
sometimes split bio in writes (not only because of low memory,
but also new memory layout of cloned bio can be different and we
must not violate hardware restrictions - spec. XFS generates such
highly optimized bio requests - it's why it discovers so many dm-crypt problems ;-)

see problematic dm-crypt bio write path

	while (remaining) {
		clone = crypt_alloc_buffer(io, remaining);
		...
		io->ctx.bio_out = clone;
		io->ctx.idx_out = 0;
		remaining -= clone->bi_size;
		...
		r = crypt_convert(cc, &io->ctx);
			-> fire sync or (multiple) async crypto operation

		if (atomic_dec_and_test(&io->ctx.pending))
			-> sync mode, submit clone direclty
		...
		if (unlikely(remaining))
			congestion_wait(WRITE, HZ/100);
	}

and in async crypto completion callback (because async callback cannot
call in its context generic_make_request directly) is called:

	struct convert_context *ctx = async_req->data;
	...
	if (!atomic_dec_and_test(&ctx->pending))
		return;
	...
	INIT_WORK(&io->work, kcryptd_io);
	queue_work(cc->io_queue, &io->work);
	...
	(and from io thread later)
	struct bio *clone = io->ctx.bio_out;
	generic_make_request(clone);

problems:
1) we cannot use io->work struct in parallel
2) io->ctx.pending is shared here between multiple sub-bio clones
... 

(there was no problems in sync crypto mode. and dm-crypt io struct is
already allocated from mempool in crypt_map allocation, so changing this
to per cloned sub-bio allocation can cause new problems in low-memory situations,
not good idea change it in this development phase...)

Milan
--
mbroz@redhat.com
