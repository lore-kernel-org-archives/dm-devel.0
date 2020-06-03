From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/4] qat: fix misunderstood -EBUSY return code
Date: Wed, 3 Jun 2020 15:54:09 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006031553170.9890@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200601160418.171851200@debian-a64.vm> <20200602220516.GA20880@silpixa00400314> <alpine.LRH.2.02.2006030409520.15292@file01.intranet.prod.int.rdu2.redhat.com> <20200603165526.GA94360@silpixa00400314>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20200603165526.GA94360@silpixa00400314>
Sender: linux-crypto-owner@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Milan Broz <mbroz@redhat.com>, djeffery@redhat.com, dm-devel@redhat.com, qat-linux@intel.com, linux-crypto@vger.kernel.org, guazhang@redhat.com, jpittman@redhat.com, ahsan.atta@intel.com
List-Id: dm-devel.ids



On Wed, 3 Jun 2020, Giovanni Cabiddu wrote:

> > > > +bool adf_should_back_off(struct adf_etr_ring_data *ring)
> > > > +{
> > > > +	return atomic_read(ring->inflights) > ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size) * 15 / 16;
> > > How did you came up with 15/16?
> > 
> > I want the sender to back off before the queue is full, to avoid 
> > busy-waiting. There may be more concurrent senders, so we want to back off 
> > at some point before the queue is full.
> Yes, I understood this. My question was about the actual number.
> 93% of the depth of the queue.

I just guessed the value. If you have some benchmark, you can try 
different values, to test if they perform better.

Mikulas
