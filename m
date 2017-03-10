From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] blk: improve order of bio handling in
 generic_make_request()
Date: Fri, 10 Mar 2017 09:38:22 -0500
Message-ID: <20170310143822.GA23879@redhat.com>
References: <87h93blz6g.fsf@notabene.neil.brown.name>
 <71562c2c-97f4-9a0a-32ec-30e0702ca575@profitbricks.com>
 <87lgsjj9w8.fsf@notabene.neil.brown.name>
 <a674456d-fb93-437e-c50e-195e7a035ba4@kernel.dk>
 <87r328j00i.fsf@notabene.neil.brown.name>
 <87d1dphhuy.fsf@notabene.neil.brown.name>
 <58be6551-4aa7-72ee-1616-a1545606d029@kernel.dk>
 <87varhg14d.fsf@notabene.neil.brown.name>
 <CANr6vz8EbRWXq7igGCzRy9JC1Nt=MMma0h8M6nxHQtwiMDa5aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANr6vz8EbRWXq7igGCzRy9JC1Nt=MMma0h8M6nxHQtwiMDa5aQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: NeilBrown <neilb@suse.com>, Jens Axboe <axboe@kernel.dk>, Jack Wang <jinpu.wang@profitbricks.com>, LKML <linux-kernel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Pavel Machek <pavel@ucw.cz>, Mikulas Patocka <mpatocka@redhat.com>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Mar 10 2017 at  7:34am -0500,
Lars Ellenberg <lars.ellenberg@linbit.com> wrote:

> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -1975,7 +1975,14 @@ generic_make_request_checks(struct bio *bio)
> >   */
> >  blk_qc_t generic_make_request(struct bio *bio)
> >  {
> > -       struct bio_list bio_list_on_stack;
> > +       /*
> > +        * bio_list_on_stack[0] contains bios submitted by the current
> > +        * make_request_fn.
> > +        * bio_list_on_stack[1] contains bios that were submitted before
> > +        * the current make_request_fn, but that haven't been processed
> > +        * yet.
> > +        */
> > +       struct bio_list bio_list_on_stack[2];
> >         blk_qc_t ret = BLK_QC_T_NONE;
> 
> May I suggest that, if you intend to assign something that is not a
> plain &(struct bio_list), but a &(struct bio_list[2]),
> you change the task member so it is renamed (current->bio_list vs
> current->bio_lists, plural, is what I did last year).
> Or you will break external modules, silently, and horribly (or,
> rather, they won't notice, but break the kernel).
> Examples of such modules would be DRBD, ZFS, quite possibly others.

drbd is upstream -- so what is the problem?  (if you are having to
distribute drbd independent of the upstream drbd then why is drbd
upstream?)

As for ZFS, worrying about ZFS kABI breakage is the last thing we should
be doing.

So Nack from me on this defensive make-work for external modules.
