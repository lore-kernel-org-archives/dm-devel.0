From: Will Drewry <wad@chromium.org>
Subject: Re: [PATCH] dm: remake of the verity target
Date: Fri, 16 Mar 2012 22:06:10 -0500
Message-ID: <CABqD9hav7MCrCfJ-5k0duvitXh2AOSk2of1MFZZmyv=kmoXb8w@mail.gmail.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
	<Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
	<20120306215947.GB27051@google.com>
	<Pine.LNX.4.64.1203131742230.24876@file.rdu.redhat.com>
	<CABqD9hYUVpC-NQ_WQ5bH8ZxLein+zxHQHDGJzwyRWHokMiPSbg@mail.gmail.com>
	<Pine.LNX.4.64.1203152149190.20644@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1203152149190.20644@file.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>, Steffen Klassert <steffen.klassert@secunet.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

On Fri, Mar 16, 2012 at 8:16 PM, Mikulas Patocka <mpatocka@redhat.com> =
wrote:
> Hi Will
>
>
> On Wed, 14 Mar 2012, Will Drewry wrote:
>
>> Hi Mikulas,
>>
>> This is a nice rewrite and takes advantage of your dm-bufio layer. I
>> wish it'd existed (and or we wrote it :) in 2009 when we started thi=
s
>> work! =A0Some comments below:
>>
>> > ---
>> > +static void verity_prefetch_io(struct dm_verity *v, struct dm_ver=
ity_io *io)
>> > +{
>> > + =A0 =A0 =A0 int i;
>> > + =A0 =A0 =A0 for (i =3D v->levels - 2; i >=3D 0; i--) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t hash_block_start;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sector_t hash_block_end;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 verity_hash_at_level(v, io->block, i=
, &hash_block_start, NULL);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 verity_hash_at_level(v, io->block + =
io->n_blocks - 1, i, &hash_block_end, NULL);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!i) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned cluster =3D=
 prefetch_cluster;
>> > + =A0 =A0 =A0 =A0/* barrier to stop GCC from re-reading prefetch_c=
luster again */
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 barrier();
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cluster >>=3D v->dat=
a_dev_block_bits;
>>
>> Would:
>> =A0 unsigned cluster =3D prefetch_cluster >> v->data_dev_block_bits;
>> not have similar behavior without a barrier? =A0(Yeah yeah I could
>> compile and see, but I was curious if you already had.)
>>
>> Since the max iterations here is 61 in a worst-case, I don't think
>> it's a big deal to barrier() each time, just thought I'd ask.
>>
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(!cluste=
r))
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto=
 no_prefetch_cluster;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(cluster=
 & (cluster - 1)))
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clus=
ter =3D 1 << (fls(cluster) - 1);
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hash_block_start &=3D=
 ~(sector_t)(cluster - 1);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hash_block_end |=3D =
cluster - 1;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(hash_bl=
ock_end >=3D v->hash_blocks))
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hash=
_block_end =3D v->hash_blocks - 1;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > +no_prefetch_cluster:
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dm_bufio_prefetch(v->bufio, hash_blo=
ck_start,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 hash_block_end - hash_block_start + 1);
>
> The problem here is this. If you look at the code, you think that aft=
er
> the clause "if (unlikely(!cluster)) goto no_prefetch_cluster;", clust=
er
> can't be zero. But this assumption is wrong. The C compiler is allowe=
d to
> transform the above code into:
>
> unsigned cluster;
> if (!(prefetch_cluster >> v->data_dev_block_bits))
> =A0 =A0 =A0 =A0goto no_prefetch_cluster;
> cluster =3D prefetch_cluster >> v->data_dev_block_bits;
> if (unlikely(cluster & (cluster - 1)))
> =A0 =A0 =A0 =A0cluster =3D 1 << (fls(cluster) - 1);
>
> I know it's suboptimal, but the C compiler is just allowed to perform=
 this
> transformation. Now, if you know that "prefetch_cluster" can change
> asynchronously by another thread running simultaneously, the conditio=
n "if
> (!(prefetch_cluster >> v->data_dev_block_bits))" is useless ---
> prefetch_cluster may change just after this condition and we won't ca=
tch
> the zero value. (if the cluster value is zero in the above code, it e=
nds
> up in hash_block_end being ORed with -1 and the prefetch goes wild ov=
er
> the whole hash device).
>
> That's why I put that "barrier()" there. It would be better to declar=
e
> "prefetch_cluster" as volatile, but the module param macros issue war=
nings
> if the variable is volatile.
>
> Or maybe I can change it this way:
> "unsigned cluster =3D *(volatile unsigned *)&prefetch_cluster", it co=
uld be
> better than the "barrier()".

I think that'd read a little bit more clearly, and I think the C
standard supports that approach. If it doesn't work in practice, the
barrier isn't the worst.

>> > + =A0 =A0 =A0 case STATUSTYPE_TABLE:
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMEMIT("%u %s %s %llu %u %s ",
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->data_dev->name,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 v->hash_dev->name,
>>
>> I understand the new approach is to use major:minor instead of the
>> device name. =A0I don't care which, but I believe agk@ requested tha=
t.
>
> All the device mappers report dm_dev->name in their status routine, s=
o I
> do it this way too.
>
>> > +static int verity_ioctl(struct dm_target *ti, unsigned cmd,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long arg)
>> > +{
>> > + =A0 =A0 =A0 struct dm_verity *v =3D ti->private;
>> > + =A0 =A0 =A0 int r =3D 0;
>> > +
>> > + =A0 =A0 =A0 if (v->data_start ||
>> > + =A0 =A0 =A0 =A0 =A0 ti->len !=3D i_size_read(v->data_dev->bdev->=
bd_inode) >> SECTOR_SHIFT)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 r =3D scsi_verify_blk_ioctl(NULL, cm=
d);
>> > +
>>
>> Is it worth supporting ioctl at all given these hoops? =A0Nothing st=
ops
>> a privileged user from directly running the ioctl on the underlying
>> device/devices, it's just very inconvenient :)
>
> I don't know. The other dm targets attempt to pass-thru ioctls too.
>
> You need ioctl pass-thru if you want to run it over a cd-rom because
> the iso9660 filesystem needs to send an ioctl to find its superblock.
> Other than that I don't know if other filesystems need ioctls.

Makes sense. I just think the passthrough condition is ugly, but at
least it provides some support.

>> > + =A0 =A0 =A0 if (ti->len > i_size_read(v->data_dev->bdev->bd_inod=
e) >> SECTOR_SHIFT) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Data device si too sm=
all";
>>
>> s/si/is
>>
>> Should this also check ti->start + ti->len to ensure it isn't readin=
g
>> off the end or do you just rely on the requests failing?
>
> ti->start is the offset in the target table --- so it shouldn't be ch=
ecked
> here (for example, you can map a verity device having 1024 blocks to =
a
> sector offset 1000000 in the table --- so ti->start =3D=3D 1000000 an=
d ti->len
> =3D=3D 1024 --- in this case, you have test that the underlying devic=
e has at
> least 1024 blocks, but you shouldn't test it for 1000000 sectors ---
> 1000000 is offset in the table, not required device size.
>
> But this reminds me that I had the size test wrong in verity_map ...
> fixed.

Well at least some good came of it!  I typed ti->start, but I had mean
v->data_start.  However, I was misinterpreting the i_size_read as
giving the last sector not the actual size, so my comment was still
pointless.

>> > +MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
>>
>> As per linux/module.h, I'd welcome additional authors as per the
>> lkml/patch lineage:
>> MODULE_AUTHOR("Mandeep Baines <msb@chromium.org>");
>> MODULE_AUTHOR("Will Drewry <wad@chromium.org>");
>
> OK, I added you there.

Very much appreciated.

>> Regardless, I'll just be happy to see this functionality merge.
>>
>> > +MODULE_DESCRIPTION(DM_NAME " target for transparent disk integrit=
y checking");
>> > +MODULE_LICENSE("GPL");
>> > +
>> > Index: linux-3.3-rc6-fast/drivers/md/dm-bufio.c
>>
>> This should be in a separate patch I think.
>
> Yes, it is a separate patch.
>
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0b->hold_count++;
>>
>> Are these hold_counts safe on architectures with weak memory models?
>> Should they be atomic_ts? =A0 I haven't looked at them in context, b=
ut
>> based on what I see here they make me a bit nervous.
>>
>> Thanks for jumping in to the fray! =A0None of my comments are blocki=
ng,
>> so I believe the following is appropriate (if not
>> s/Signed-off/Reviewed-by/).
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>>
>> cheers!
>> will
>
> hold_count is read or changed only when we hold dm_bufio_client->lock=
, so
> it doesn't have to be atomic.

Ah nice!  The little snippet had me worried, but I should've looked at
the full context first.

Thanks!
will
