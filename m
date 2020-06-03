From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/4] qat: fix misunderstood -EBUSY return code
Date: Wed, 3 Jun 2020 04:31:54 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006030409520.15292@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200601160418.171851200@debian-a64.vm> <20200602220516.GA20880@silpixa00400314>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20200602220516.GA20880@silpixa00400314>
Sender: linux-crypto-owner@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>, djeffery@redhat.com, dm-devel@redhat.com, qat-linux@intel.com, linux-crypto@vger.kernel.org, guazhang@redhat.com, jpittman@redhat.com
List-Id: dm-devel.ids



On Tue, 2 Jun 2020, Giovanni Cabiddu wrote:

> Hi Mikulas,
> 
> thanks for your patch. See below.
> 
> > +	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
> > +again:
> > +	ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
> >  	if (ret == -EAGAIN) {
> > -		qat_alg_free_bufl(ctx->inst, qat_req);
> > -		return -EBUSY;
> > +		qat_req->backed_off = backed_off = 1;
> > +		cpu_relax();
> > +		goto again;
> >  	}
> I am a bit concerned about this potential infinite loop.
> If an error occurred on the device and the queue is full, we will be
> stuck here forever.
> Should we just retry a number of times and then fail?

It's better to get stuck in an infinite loop than to cause random I/O 
errors. The infinite loop requires reboot, but it doesn't damage data on 
disks.

The proper solution would be to add the request to a queue and process the 
queue when some other request ended - but it would need substantial 
rewrite of the driver. Do you want to rewrite it using a queue?

> Or, should we just move to the crypto-engine?

What do you mean by the crypto-engine?

> > -	do {
> > -		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
> > -	} while (ret == -EAGAIN && ctr++ < 10);
> > -
> > +	qat_req->backed_off = backed_off = adf_should_back_off(ctx->inst->sym_tx);
> checkpatch: line over 80 characters - same in every place
> adf_should_back_off is used.

Recently, Linus announced that we can have larger lines than 80 bytes.
See bdc48fa11e46f867ea4d75fa59ee87a7f48be144

> >  static int qat_alg_skcipher_blk_decrypt(struct skcipher_request *req)
> > Index: linux-2.6/drivers/crypto/qat/qat_common/adf_transport.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/crypto/qat/qat_common/adf_transport.c
> > +++ linux-2.6/drivers/crypto/qat/qat_common/adf_transport.c
> > @@ -114,10 +114,19 @@ static void adf_disable_ring_irq(struct
> >  	WRITE_CSR_INT_COL_EN(bank->csr_addr, bank->bank_number, bank->irq_mask);
> >  }
> >  
> > +bool adf_should_back_off(struct adf_etr_ring_data *ring)
> > +{
> > +	return atomic_read(ring->inflights) > ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size) * 15 / 16;
> How did you came up with 15/16?

I want the sender to back off before the queue is full, to avoid 
busy-waiting. There may be more concurrent senders, so we want to back off 
at some point before the queue is full.

> checkpatch: WARNING: line over 80 characters
> 
> > +}
> > +
> >  int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg)
> >  {
> > -	if (atomic_add_return(1, ring->inflights) >
> > -	    ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size)) {
> > +	int limit = ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size);
> > +
> > +	if (atomic_read(ring->inflights) >= limit)
> > +		return -EAGAIN;

> Can this be removed and leave only the condition below?
> Am I missing something here?

atomic_read is light, atomic_add_return is heavy. We may be busy-waiting 
here, so I want to use the light instruction. Spinlocks do the same - when 
they are spinning, they use just a light "read" instruction and when the 
"read" instruction indicates that the spinlock is free, they execute the 
read-modify-write instruction to actually acquire the lock.

> > +
> > +	if (atomic_add_return(1, ring->inflights) > limit) {
> >  		atomic_dec(ring->inflights);
> >  		return -EAGAIN;
> >  	}

Mikulas
