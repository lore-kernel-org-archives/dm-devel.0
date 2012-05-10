From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [dm-devel] [Bcache v13 02/16] Bio pool freeing
Date: Thu, 10 May 2012 14:39:26 -0700
Message-ID: <CAH+dOxL7QwcyUm46cK-pF1qK+kHYC=67iAaQDDwUF2ssJwergA@mail.gmail.com>
References: <cover.1336619038.git.koverstreet@google.com>
	<ba8ce9fcca87f192ff5f5d3a436eb8f4d0bcb006.1336619038.git.koverstreet@google.com>
	<20120510213217.GN23768@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120510213217.GN23768@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, tejun@google.com, agk@redhat.com
List-Id: dm-devel.ids

On Thu, May 10, 2012 at 2:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, May 09, 2012 at 11:08:34PM -0400, Kent Overstreet wrote:
>> When you allocate a bio from a bio pool, to free it you have to know
>> where it came from; this adds a flag which, if set, means bi_destruc=
tor
>> is the pointer to the pool and bio_put() can do the right thing.
>>
>> This is used in bcache, so we can cleanly use per device bio pools.
>
> Ok, that will explain BIO_HAS_POOL flag. =A0Why to replace
> bio_has_allocated_vec() with BIO_HAS_VEC flag?

Using bio_has_allocated_vec() would mean the bvec would always be
freed if it wasn't a pointer to the inline vecs - my bio splitting
code will use the bvec from the original bio for the split if it's
splitting on a bvec boundary, in which case that's not what we want.

It means "bio owns its bvec".

>
> Thanks
> Vivek
>
>>
>> Signed-off-by: Kent Overstreet <koverstreet@google.com>
>> ---
>> =A0fs/bio.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A09 +++++++--
>> =A0include/linux/blk_types.h | =A0 =A02 ++
>> =A02 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/bio.c b/fs/bio.c
>> index a965b89..6a967fc 100644
>> --- a/fs/bio.c
>> +++ b/fs/bio.c
>> @@ -235,7 +235,7 @@ void bio_free(struct bio *bio, struct bio_set *b=
s)
>> =A0{
>> =A0 =A0 =A0 void *p;
>>
>> - =A0 =A0 if (bio_has_allocated_vec(bio))
>> + =A0 =A0 if (bio_flagged(bio, BIO_HAS_VEC))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bvec_free_bs(bs, bio->bi_io_vec, BIO_POO=
L_IDX(bio));
>>
>> =A0 =A0 =A0 if (bio_integrity(bio))
>> @@ -301,6 +301,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int=
 nr_iovecs, struct bio_set *bs)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_free;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr_iovecs =3D bvec_nr_vecs(idx);
>> + =A0 =A0 =A0 =A0 =A0 =A0 bio->bi_flags |=3D 1 << BIO_HAS_VEC;
>> =A0 =A0 =A0 }
>> =A0out_set:
>> =A0 =A0 =A0 bio->bi_flags |=3D idx << BIO_POOL_OFFSET;
>> @@ -417,7 +418,11 @@ void bio_put(struct bio *bio)
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 if (atomic_dec_and_test(&bio->bi_cnt)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio->bi_next =3D NULL;
>> - =A0 =A0 =A0 =A0 =A0 =A0 bio->bi_destructor(bio);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (bio_flagged(bio, BIO_HAS_POOL))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio_free(bio, (void *) bio=
->bi_destructor);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio->bi_destructor(bio);
>> =A0 =A0 =A0 }
>> =A0}
>> =A0EXPORT_SYMBOL(bio_put);
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index 4053cbd..a0be8b3 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -95,6 +95,8 @@ struct bio {
>> =A0#define BIO_FS_INTEGRITY 9 =A0 /* fs owns integrity data, not blo=
ck layer */
>> =A0#define BIO_QUIET =A0 =A010 =A0 =A0 =A0/* Make BIO Quiet */
>> =A0#define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been rem=
apped */
>> +#define BIO_HAS_POOL 12 =A0 =A0 =A0/* bi_destructor points to bio_p=
ool */
>> +#define BIO_HAS_VEC =A013 =A0 =A0 =A0/* bio_free() should free bvec=
 */
>> =A0#define bio_flagged(bio, flag) =A0 =A0 =A0 ((bio)->bi_flags & (1 =
<< (flag)))
>>
>> =A0/*
>> --
>> 1.7.9.rc2
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
