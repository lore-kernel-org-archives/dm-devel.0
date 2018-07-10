From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Q about dm-verity per bio data
Date: Tue, 10 Jul 2018 14:00:36 -0400
Message-ID: <20180710180036.GA10461@redhat.com>
References: <000701d4184d$bd1cb2b0$37561810$@foss.arm.com>
	<20180710162946.GA55629@redhat.com>
	<000701d41874$233ed3e0$69bc7ba0$@foss.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <000701d41874$233ed3e0$69bc7ba0$@foss.arm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: yael.chemla@foss.arm.com
Cc: dm-devel@redhat.com, 'Yael Chemla' <Yael.Chemla@arm.com>, 'Milan Broz' <gmazyland@gmail.com>
List-Id: dm-devel.ids

On Tue, Jul 10 2018 at  1:33pm -0400,
yael.chemla@foss.arm.com <yael.chemla@foss.arm.com> wrote:

> 
> 
> > -----Original Message-----
> > From: Mike Snitzer <snitzer@redhat.com>
> > Sent: Tuesday, 10 July 2018 19:30
> > To: yael.chemla@foss.arm.com
> > Cc: 'Milan Broz' <gmazyland@gmail.com>; Yael Chemla
> > <Yael.Chemla@arm.com>; dm-devel@redhat.com
> > Subject: Re: Q about dm-verity per bio data
> > 
> > On Tue, Jul 10 2018 at  8:58am -0400,
> > yael.chemla@foss.arm.com <yael.chemla@foss.arm.com> wrote:
> > 
> > > Hi Mike and Milan,
> > > I'd like to consult with you,
> > > I'm trying to rewrite a patch I submitted few month ago according to
> > > comments I got, Eric Bigger asked my to adopt the method used in dm-
> > crypt for dynamic allocations.
> > > ([dm-devel] [PATCH 2/2] md: dm-verity: allow parallel processing of
> > > bio blocks)
> > >
> > > I saw you rewrite lately in verity_ctr (dm-verity-target.c) the
> > > alignment and the calculation of ti->per_io_data_size, and also did similar
> > modification at crypt_ctr,  in dm-crypt.c And I suspect it's the source of my
> > problem.
> > >
> > > In my new patch edition as a preparation for parallelization of requests I've
> > added new structure (dm_verity_request ) to the end of dm-verity "per bio
> > data" area.
> > > And enlarged accordingly the size of per_io_data_size
> > >
> > > I keep getting kernel panic such as " bad PC value" or cpu salls.
> > > I guess there's something related to alignment that is missing
> > >
> > > Here my code (it's not the complete patch I intend to submit) but it
> > demonstrate my modification and triggers the mentioned panics:
> > >
> > > Please let me know if you see any issues with alignment or
> > per_io_data_size  size calculation that is missing.

...

> > > @@ -447,6 +448,10 @@ static int verity_verify_io(struct dm_verity_io *io)
> > >                 unsigned int total_len = 0;
> > >                 sector_t cur_block = io->block + b;
> > >                 struct ahash_request *req = verity_io_hash_req(v, io);
> > > +               struct dm_verity_request *vreq = verity_io_req(io);
> > > +
> > > +               vreq->sg = sg;
> > > +               vreq->cur_block = cur_block;
> > >
> > >                 if (v->validated_blocks &&
> > >                     likely(test_bit(cur_block, v->validated_blocks)))
> > > { @@ -641,6 +646,7 @@ static int verity_map(struct dm_target *ti, struct
> > bio *bio)
> > >         bio->bi_end_io = verity_end_io;
> > >         bio->bi_private = io;
> > >         io->iter = bio->bi_iter;
> > > +       io->vreq = (struct dm_verity_request *)((struct
> > > + dm_verity_fec_io *)verity_io_digest_end(v, io) + 1);
> > >
> > >         verity_fec_init_io(io);
> > >
> > 
> > The above looks very wrong, 2 issues I'm seeing:
> > 
> > 1)
> > your new 'struct dm_verity_request' follows the 'want_digest' in 'struct
> > dm_verity_io' right?
> 
> You're right currently documentation is misleading, it's actually after everything that resides in per bio data.
> thus dmverity per bio data looks as follows:
> 
> u8 hash_req[v->ahash_reqsize];
> u8 real_digest[v->digest_size];
> u8 want_digest[v->digest_size];
> struct dm_verity_fec_io ;
> struct dm_verity_request;
> 
> therefore io->vreq is set to location after fec_io structure at per bio memory area (see verity_map).

Ah, OK, yes I see this now in verity_fec_ctr():

        /* Reserve space for our per-bio data */
        ti->per_io_data_size += sizeof(struct dm_verity_fec_io);

Given that, I'm not sure why your code is crashing.

> > 2)
> > There is no need to add 'struct dm_verity_request *vreq;' to 'struct
> > dm_verity_io':
> > 
> 
> vreq pointer is preparation for same solution as in dm-crypt, where
> there's a pointer to the request structure either located at per bio
> memory area,  or dynimicly allocated request, see ctx->r.req
> (dm-crypt.c at crypt_alloc_req_skcipher)
> so when certain cipher is done asynchronously (see in crypt_convert
> handling of -EINPROGRESS) this pointer will point to a dynamically
> allocated request, while async cipher will be satisfied with the
> single request structure resides at per bio area. 

OK.
