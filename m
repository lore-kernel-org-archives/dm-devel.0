From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device
	mapper warnings
Date: Wed, 9 Dec 2009 19:56:46 -0500
Message-ID: <170fa0d20912091656s31575d0cneaf899e1781bdc16@mail.gmail.com>
References: <200912091049.12604.borntraeger@de.ibm.com>
	 <20091209212516.GA6206@fancy-poultry.org>
	 <20091209214501.GC8742@kernel.dk> <20091209220749.GD8742@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753435AbZLJA4s@vger.kernel.org>
In-Reply-To: <20091209220749.GD8742@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, Christian Borntraeger <borntraeger@de.ibm.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 9, 2009 at 5:07 PM, Jens Axboe <jens.axboe@oracle.com> wrot=
e:
> On Wed, Dec 09 2009, Jens Axboe wrote:
>> On Wed, Dec 09 2009, Heinz Diehl wrote:
>> > On 09.12.2009, Christian Borntraeger wrote:
>> >
>> > > with todays git I got a huge amount of warnings for device mappe=
r:
>> > > device-mapper: uevent: version 1.0.3
>> > > device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-=
devel@redhat.com
>> > > device-mapper: table: 252:0: target device dasdf1 is misaligned:=
 physical_block_size=3D4096, logical_block_size=3D4096, alignment_offse=
t=3D0, start=3D196608
>> > [...]
>> >
>> > > The same devices produce no warning with a 2.6.32 vanilla kernel=
=2E
>> >
>> > I have exactly the same here...
>>
>> Can either one of you try and bisect it? I've cc'ed Martin, it's lik=
ely
>> one of the io stacking patches that causes this.
>
> Does this work?
>
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index dd1f1e0..0116d29 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -554,11 +554,13 @@ int blk_stack_limits(struct queue_limits *t, st=
ruct queue_limits *b,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -1;
> =A0 =A0 =A0 =A0}
>
> +#if 0
> =A0 =A0 =A0 =A0if (offset &&
> =A0 =A0 =A0 =A0 =A0 =A0(offset & (b->discard_granularity - 1)) !=3D b=
->discard_alignment) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0t->discard_misaligned =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -1;
> =A0 =A0 =A0 =A0}
> +#endif
>
> =A0 =A0 =A0 =A0/* If top has no alignment offset, inherit from bottom=
 */
> =A0 =A0 =A0 =A0if (!t->alignment_offset)

Jens,

It should be noted that Christian (original poster but cc's got
dropped) is using striped LVs.

Striped LVs use blk_limits_io_opt() via drivers/md/dm-stripe.c:stripe_i=
o_hints()

Martin's change for discard alignment (commit: 86b37281) also splits
out the least common multiple code, that was exclusively used for
io_opt, to a new lcm() function in block/blk-settings.c

On the surface I thought this might be the reason for the warnings,
but Martin's lcm() looks perfectly fine; can't see why it would cause
these warnings to appear all of a sudden... but I figured I'd share.

It'll be interesting to see if the discard_granularity block you
#ifdef'd out helps either Christian or Heinz.

Mike
