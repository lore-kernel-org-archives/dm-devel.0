From: Vasily Tarasov <tarasov@vasily.name>
Subject: Re: [PATCH RFCv2 01/10] dm-dedup: main data structures
Date: Mon, 29 Sep 2014 09:34:52 -0400
Message-ID: <CAFTzLMP07qBzEBaaOuFQvi0W219YqLpz8epWdMLO36Sj8gBJoQ@mail.gmail.com>
References: <53ffb64d.c58d320a.14c8.1413@mx.google.com>
	<20140926152416.GA4464@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140926152416.GA4464@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

Hi Mike,

Thanks for staging the patches and fixing some issues!

It totally makes sense to clone your repo and develop on top of it.
That should make things easier both for you and us.

Let us work through the error paths and fix BUG() and BUG_ON() things
first. We'll try to get some patches ready by the end of the week.

Thanks,
Vasily

On Fri, Sep 26, 2014 at 11:24 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> Hi Vasily et al,
>
> I've rebased my dm-dedup branch to your v2 patchset.  I then fixed
> various issues with the code -- please see the ~7 commits that follow
> your v2 patchset baseline:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=dm-dedup
>
> I will soon transition to actually trying to use dm-dedup and will then
> focus primarily on the design (less on code style nits, etc).
>
> I'll still likely fixup the ERRORs listed below.  Of note is the "ERROR:
> application of sizeof to pointer".  I noticed that one during my
> code-review too but it still needs fixing.
>
> And BUG() and BUG_ON() are useful for early code development but they
> need to be removed before the code can advance to the next stage
> (e.g. upstream inclusion).
>
> So I would _really_ appreciate it if you could remove most (if not all)
> of the BUG() and BUG_ON() in the code.  Please rework the error paths so
> that an error is returned and the error is propagated back to the
> various callers in a graceful (non-destructive way).
>
> Also, rather than posting v3 of the patchset, it'd probably be easiest
> if you just cloned my repo and forked my 'dm-dedup' branch and then
> submitted incremental patches to dm-devel.
>
> Here is a forward of the kernel.org autobuild email we were sent related
> to dm-dedup's excessive use of BUG() AND BUG_ON(), etc:
>
> ----- Forwarded message from Julia Lawall <julia.lawall@lip6.fr> -----
>
>> Date: Tue, 23 Sep 2014 13:54:42 +0200 (CEST)
>> From: Julia Lawall <julia.lawall@lip6.fr>
>> To: kbuild test robot <fengguang.wu@intel.com>, tarasov@vasily.name
>> cc: kbuild@01.org, snitzer@redhat.com
>> Subject: [snitzer:dm-dedup 12/20] drivers/md/dm-dedup-hash.c:81:3-6: WARNING: Use BUG_ON (fwd)
>>
>> All of the patches look good except for the one about unneeded variable
>> (the last one?).
>>
>> julia
>>
>> ---------- Forwarded message ----------
>> Date: Tue, 23 Sep 2014 05:27:24 +0800
>> From: kbuild test robot <fengguang.wu@intel.com>
>> To: kbuild@01.org
>> Cc: Julia Lawall <julia.lawall@lip6.fr>
>> Subject: [snitzer:dm-dedup 12/20] drivers/md/dm-dedup-hash.c:81:3-6: WARNING:
>>     Use BUG_ON
>>
>> TO: Vasily Tarasov <tarasov@vasily.name>
>> CC: Mike Snitzer <snitzer@redhat.com>
>>
>> Hi Vasily,
>>
>> First bad commit (maybe != root cause):
>>
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git dm-dedup
>> head:   6d716389dd3b8320da41db4341ee390e226083b2
>> commit: 266d082b5a0b2f7f2008379f7a31b0a7f2b498b6 [12/20] dm-dedup: Kconfig changes
>> :::::: branch date: 3 hours ago
>> :::::: commit date: 6 hours ago
>>
>> >> drivers/md/dm-dedup-hash.c:81:3-6: WARNING: Use BUG_ON
>> --
>> >> drivers/md/dm-dedup-rw.c:219:2-5: WARNING: Use BUG_ON
>> --
>> >> drivers/md/dm-dedup-target.c:784:3-6: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:788:3-6: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:652:2-5: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:658:3-6: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:724:3-6: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:729:2-5: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:292:2-5: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:161:3-6: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:165:3-6: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:169:2-5: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:180:2-5: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:190:2-5: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:194:2-5: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:220:3-6: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:228:3-6: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:234:2-5: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:242:3-6: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:250:3-6: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:254:3-6: WARNING: Use BUG_ON
>> >> drivers/md/dm-dedup-target.c:130:2-5: WARNING: Use BUG_ON
>> --
>> >> drivers/md/dm-dedup-cbt.c:343:8-10: ERROR: reference preceded by free on line 342
>> >> drivers/md/dm-dedup-cbt.c:545:27-30: ERROR: reference preceded by free on line 544
>> >> drivers/md/dm-dedup-cbt.c:738:27-30: ERROR: reference preceded by free on line 737
>> --
>> >> drivers/md/dm-dedup-rw.c:168:14-20: ERROR: application of sizeof to pointer
>> --
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/xmmintrin.h:109:9-12: Unneeded variable: "__Y". Return "__Y" on line 110
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h:1180:9-12: Unneeded variable: "__Y". Return "__Y" on line 1181
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h:1173:10-13: Unneeded variable: "__Y". Return "__Y" on line 1174
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h:1187:10-13: Unneeded variable: "__Y". Return "__Y" on line 1188
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/emmintrin.h:93:10-13: Unneeded variable: "__Y". Return "__Y" on line 94
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/emmintrin.h:743:10-13: Unneeded variable: "__Y". Return "__Y" on line 744
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h:115:9-12: Unneeded variable: "__Y". Return "__Y" on line 116
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h:123:10-13: Unneeded variable: "__Y". Return "__Y" on line 124
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h:131:10-13: Unneeded variable: "__Y". Return "__Y" on line 132
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/xmmintrin.h:109:9-12: Unneeded variable: "__Y". Return "__Y" on line 110
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h:1180:9-12: Unneeded variable: "__Y". Return "__Y" on line 1181
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h:1173:10-13: Unneeded variable: "__Y". Return "__Y" on line 1174
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h:1187:10-13: Unneeded variable: "__Y". Return "__Y" on line 1188
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/emmintrin.h:93:10-13: Unneeded variable: "__Y". Return "__Y" on line 94
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/emmintrin.h:743:10-13: Unneeded variable: "__Y". Return "__Y" on line 744
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h:115:9-12: Unneeded variable: "__Y". Return "__Y" on line 116
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h:123:10-13: Unneeded variable: "__Y". Return "__Y" on line 124
>>    /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h:131:10-13: Unneeded variable: "__Y". Return "__Y" on line 132
>> >> drivers/md/dm-dedup-target.c:750:5-8: Unneeded variable: "ret". Return "0" on line 761
>>
>> Please consider folding the attached diff :-)
>>
>> ---
>> 0-DAY kernel build testing backend              Open Source Technology Center
>> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
>
>> From: Fengguang Wu <fengguang.wu@intel.com>
>>
>> Subject: [PATCH] dm-dedup: fix coccinelle warnings
>>
>> TO: Mike Snitzer <snitzer@redhat.com>
>>
>> CC: Vasily Tarasov <tarasov@vasily.name>
>>
>> CC: linux-raid@vger.kernel.org (open list:SOFTWARE RAID
>>
>> CC: linux-kernel@vger.kernel.org
>>
>>
>>
>> drivers/md/dm-dedup-hash.c:81:3-6: WARNING: Use BUG_ON
>>
>>
>>
>>  Use BUG_ON instead of a if condition followed by BUG.
>>
>>
>>
>> Semantic patch information:
>>
>>  This makes an effort to find cases where BUG() follows an if
>>
>>  condition on an expression and replaces the if condition and BUG()
>>
>>  with a BUG_ON having the conditional expression of the if statement
>>
>>  as argument.
>>
>>
>>
>> Generated by: scripts/coccinelle/misc/bugon.cocci
>>
>>
>>
>> CC: Vasily Tarasov <tarasov@vasily.name>
>>
>> CC: Mike Snitzer <snitzer@redhat.com>
>>
>> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
>>
>> ---
>>
>>
>>
>> Please take the patch only if it's a positive warning. Thanks!
>>
>>
>>
>>  dm-dedup-hash.c |    3 +--
>>
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>>
>>
>> --- a/drivers/md/dm-dedup-hash.c
>>
>> +++ b/drivers/md/dm-dedup-hash.c
>>
>> @@ -77,8 +77,7 @@ static int get_next_slot(struct hash_des
>>
>>       int count = 0;
>>
>>
>>
>>       do {
>>
>> -             if (count == DEDUP_HASH_DESC_COUNT)
>>
>> -                     BUG();
>>
>> +             BUG_ON(count == DEDUP_HASH_DESC_COUNT);
>>
>>
>>
>>               count++;
>>
>>               num = atomic_long_inc_return(&(desc_table->slot_counter));
>>
>
>> From: Fengguang Wu <fengguang.wu@intel.com>
>>
>> Subject: [PATCH] dm-dedup: fix coccinelle warnings
>>
>> TO: Mike Snitzer <snitzer@redhat.com>
>>
>> CC: Vasily Tarasov <tarasov@vasily.name>
>>
>> CC: linux-raid@vger.kernel.org (open list:SOFTWARE RAID
>>
>> CC: linux-kernel@vger.kernel.org
>>
>>
>>
>> drivers/md/dm-dedup-rw.c:219:2-5: WARNING: Use BUG_ON
>>
>>
>>
>>  Use BUG_ON instead of a if condition followed by BUG.
>>
>>
>>
>> Semantic patch information:
>>
>>  This makes an effort to find cases where BUG() follows an if
>>
>>  condition on an expression and replaces the if condition and BUG()
>>
>>  with a BUG_ON having the conditional expression of the if statement
>>
>>  as argument.
>>
>>
>>
>> Generated by: scripts/coccinelle/misc/bugon.cocci
>>
>>
>>
>> CC: Vasily Tarasov <tarasov@vasily.name>
>>
>> CC: Mike Snitzer <snitzer@redhat.com>
>>
>> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
>>
>> ---
>>
>>
>>
>> Please take the patch only if it's a positive warning. Thanks!
>>
>>
>>
>>  dm-dedup-rw.c |    3 +--
>>
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>>
>>
>> --- a/drivers/md/dm-dedup-rw.c
>>
>> +++ b/drivers/md/dm-dedup-rw.c
>>
>> @@ -215,8 +215,7 @@ static struct bio *prepare_bio_without_p
>>
>>       my_zero_fill_bio(clone);
>>
>>
>>
>>       r = merge_data(dc, clone->bi_io_vec->bv_page, bio);
>>
>> -     if (r < 0)
>>
>> -             BUG();
>>
>> +     BUG_ON(r < 0);
>>
>>  out:
>>
>>       return clone;
>>
>>  }
>>
>
>> From: Fengguang Wu <fengguang.wu@intel.com>
>>
>> Subject: [PATCH] dm-dedup: fix coccinelle warnings
>>
>> TO: Mike Snitzer <snitzer@redhat.com>
>>
>> CC: Vasily Tarasov <tarasov@vasily.name>
>>
>> CC: linux-raid@vger.kernel.org (open list:SOFTWARE RAID
>>
>> CC: linux-kernel@vger.kernel.org
>>
>>
>>
>> drivers/md/dm-dedup-target.c:784:3-6: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:788:3-6: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:652:2-5: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:658:3-6: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:724:3-6: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:729:2-5: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:292:2-5: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:161:3-6: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:165:3-6: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:169:2-5: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:180:2-5: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:190:2-5: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:194:2-5: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:220:3-6: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:228:3-6: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:234:2-5: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:242:3-6: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:250:3-6: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:254:3-6: WARNING: Use BUG_ON
>>
>> drivers/md/dm-dedup-target.c:130:2-5: WARNING: Use BUG_ON
>>
>>
>>
>>  Use BUG_ON instead of a if condition followed by BUG.
>>
>>
>>
>> Semantic patch information:
>>
>>  This makes an effort to find cases where BUG() follows an if
>>
>>  condition on an expression and replaces the if condition and BUG()
>>
>>  with a BUG_ON having the conditional expression of the if statement
>>
>>  as argument.
>>
>>
>>
>> Generated by: scripts/coccinelle/misc/bugon.cocci
>>
>>
>>
>> CC: Vasily Tarasov <tarasov@vasily.name>
>>
>> CC: Mike Snitzer <snitzer@redhat.com>
>>
>> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
>>
>> ---
>>
>>
>>
>> Please take the patch only if it's a positive warning. Thanks!
>>
>>
>>
>>  dm-dedup-target.c |   60 ++++++++++++++++++------------------------------------
>>
>>  1 file changed, 20 insertions(+), 40 deletions(-)
>>
>>
>>
>> --- a/drivers/md/dm-dedup-target.c
>>
>> +++ b/drivers/md/dm-dedup-target.c
>>
>> @@ -126,8 +126,7 @@ static int write_to_new_block(struct ded
>>
>>
>>
>>       r = dc->kvs_lbn_pbn->kvs_insert(dc->kvs_lbn_pbn, (void *)&lbn,
>>
>>               sizeof(lbn), (void *)&lbnpbn_value, sizeof(lbnpbn_value));
>>
>> -     if (r < 0)
>>
>> -             BUG();
>>
>> +     BUG_ON(r < 0);
>>
>>
>>
>>       return r;
>>
>>  }
>>
>> @@ -157,16 +156,13 @@ static int handle_write_no_hash(struct d
>>
>>               r = dc->kvs_hash_pbn->kvs_insert(dc->kvs_hash_pbn, (void *)hash,
>>
>>                               dc->crypto_key_size, (void *)&hashpbn_value,
>>
>>                               sizeof(hashpbn_value));
>>
>> -             if (r < 0)
>>
>> -                     BUG();
>>
>> +             BUG_ON(r < 0);
>>
>>
>>
>>               r = dc->mdops->inc_refcount(dc->bmd, pbn_new);
>>
>> -             if (r < 0)
>>
>> -                     BUG();
>>
>> +             BUG_ON(r < 0);
>>
>>
>>
>>               goto out;
>>
>> -     } else if (r < 0)
>>
>> -             BUG();
>>
>> +     } else BUG_ON(r < 0);
>>
>>
>>
>>       /* LBN->PBN mappings exist */
>>
>>       dc->overwrites++;
>>
>> @@ -176,8 +172,7 @@ static int handle_write_no_hash(struct d
>>
>>
>>
>>       pbn_old = lbnpbn_value.pbn;
>>
>>       r = dc->mdops->dec_refcount(dc->bmd, pbn_old);
>>
>> -     if (r < 0)
>>
>> -             BUG();
>>
>> +     BUG_ON(r < 0);
>>
>>
>>
>>       dc->logical_block_counter--;
>>
>>
>>
>> @@ -186,12 +181,10 @@ static int handle_write_no_hash(struct d
>>
>>       r = dc->kvs_hash_pbn->kvs_insert(dc->kvs_hash_pbn, (void *)hash,
>>
>>                               dc->crypto_key_size, (void *)&hashpbn_value,
>>
>>                               sizeof(hashpbn_value));
>>
>> -     if (r < 0)
>>
>> -             BUG();
>>
>> +     BUG_ON(r < 0);
>>
>>
>>
>>       r = dc->mdops->inc_refcount(dc->bmd, pbn_new);
>>
>> -     if (r < 0)
>>
>> -             BUG();
>>
>> +     BUG_ON(r < 0);
>>
>>  out:
>>
>>       return r;
>>
>>  }
>>
>> @@ -216,42 +209,36 @@ static int handle_write_with_hash(struct
>>
>>               dc->newwrites++;
>>
>>
>>
>>               r = dc->mdops->inc_refcount(dc->bmd, pbn_new);
>>
>> -             if (r < 0)
>>
>> -                     BUG();
>>
>> +             BUG_ON(r < 0);
>>
>>
>>
>>               lbnpbn_value.pbn = pbn_new;
>>
>>
>>
>>               r = dc->kvs_lbn_pbn->kvs_insert(dc->kvs_lbn_pbn, (void *)&lbn,
>>
>>                               sizeof(lbn), (void *)&lbnpbn_value,
>>
>>                               sizeof(lbnpbn_value));
>>
>> -             if (r < 0)
>>
>> -                     BUG();
>>
>> +             BUG_ON(r < 0);
>>
>>
>>
>>               dc->logical_block_counter++;
>>
>>
>>
>>               goto out;
>>
>> -     } else if (r < 0)
>>
>> -             BUG();
>>
>> +     } else BUG_ON(r < 0);
>>
>>
>>
>>       /* LBN->PBN mapping entry exists */
>>
>>       dc->overwrites++;
>>
>>       pbn_old = lbnpbn_value.pbn;
>>
>>       if (pbn_new != pbn_old) {
>>
>>               r = dc->mdops->inc_refcount(dc->bmd, pbn_new);
>>
>> -             if (r < 0)
>>
>> -                     BUG();
>>
>> +             BUG_ON(r < 0);
>>
>>
>>
>>               new_lbnpbn_value.pbn = pbn_new;
>>
>>
>>
>>               r = dc->kvs_lbn_pbn->kvs_insert(dc->kvs_lbn_pbn, (void *)&lbn,
>>
>>                       sizeof(lbn), (void *)&new_lbnpbn_value,
>>
>>                       sizeof(new_lbnpbn_value));
>>
>> -             if (r < 0)
>>
>> -                     BUG();
>>
>> +             BUG_ON(r < 0);
>>
>>
>>
>>               r = dc->mdops->dec_refcount(dc->bmd, pbn_old);
>>
>> -             if (r < 0)
>>
>> -                     BUG();
>>
>> +             BUG_ON(r < 0);
>>
>>
>>
>>               goto out;
>>
>>       }
>>
>> @@ -288,8 +275,7 @@ static void handle_write(struct dedup_co
>>
>>       lbn = bio_lbn(dc, bio);
>>
>>
>>
>>       r = compute_hash_bio(dc->desc_table, bio, hash);
>>
>> -     if (r)
>>
>> -             BUG();
>>
>> +     BUG_ON(r);
>>
>>
>>
>>       r = dc->kvs_hash_pbn->kvs_lookup(dc->kvs_hash_pbn, hash,
>>
>>                               dc->crypto_key_size, &hashpbn_value, &vsize);
>>
>> @@ -648,14 +634,12 @@ static int dm_dedup_ctr_fn(struct dm_tar
>>
>>       }
>>
>>
>>
>>       r = dc->mdops->flush_meta(md);
>>
>> -     if (r < 0)
>>
>> -             BUG();
>>
>> +     BUG_ON(r < 0);
>>
>>
>>
>>       if (!unformatted && dc->mdops->get_private_data) {
>>
>>               r = dc->mdops->get_private_data(md, (void **)&data,
>>
>>                               sizeof(struct on_disk_stats));
>>
>> -             if (r < 0)
>>
>> -                     BUG();
>>
>> +             BUG_ON(r < 0);
>>
>>
>>
>>               logical_block_counter = data->logical_block_counter;
>>
>>               physical_block_counter = data->physical_block_counter;
>>
>> @@ -720,13 +704,11 @@ static void dm_dedup_dtr_fn(struct dm_ta
>>
>>
>>
>>               ret = dc->mdops->set_private_data(dc->bmd, &data,
>>
>>                               sizeof(struct on_disk_stats));
>>
>> -             if (ret < 0)
>>
>> -                     BUG();
>>
>> +             BUG_ON(ret < 0);
>>
>>       }
>>
>>
>>
>>       ret = dc->mdops->flush_meta(dc->bmd);
>>
>> -     if (ret < 0)
>>
>> -             BUG();
>>
>> +     BUG_ON(ret < 0);
>>
>>
>>
>>       flush_workqueue(dc->workqueue);
>>
>>       destroy_workqueue(dc->workqueue);
>>
>> @@ -780,12 +762,10 @@ static int cleanup_hash_pbn(void *key, i
>>
>>       if (test_bit(pbn_val, ms_data->bitmap) == 0) {
>>
>>               ret = dc->kvs_hash_pbn->kvs_delete(dc->kvs_hash_pbn,
>>
>>                                                       key, ksize);
>>
>> -             if (ret < 0)
>>
>> -                     BUG();
>>
>> +             BUG_ON(ret < 0);
>>
>>
>>
>>               r = dc->mdops->dec_refcount(ms_data->dc->bmd, pbn_val);
>>
>> -             if (r < 0)
>>
>> -                     BUG();
>>
>> +             BUG_ON(r < 0);
>>
>>
>>
>>               ms_data->cleanup_count++;
>>
>>       }
>>
>
>> From: Fengguang Wu <fengguang.wu@intel.com>
>>
>> Subject: [PATCH] dm-dedup: fix coccinelle warnings
>>
>> TO: Mike Snitzer <snitzer@redhat.com>
>>
>> CC: Vasily Tarasov <tarasov@vasily.name>
>>
>> CC: linux-raid@vger.kernel.org (open list:SOFTWARE RAID
>>
>> CC: linux-kernel@vger.kernel.org
>>
>>
>>
>> drivers/md/dm-dedup-rw.c:168:14-20: ERROR: application of sizeof to pointer
>>
>>
>>
>>  sizeof when applied to a pointer typed expression gives the size of
>>
>>  the pointer
>>
>>
>>
>> Generated by: scripts/coccinelle/misc/noderef.cocci
>>
>>
>>
>> CC: Vasily Tarasov <tarasov@vasily.name>
>>
>> CC: Mike Snitzer <snitzer@redhat.com>
>>
>> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
>>
>> ---
>>
>>
>>
>>  dm-dedup-rw.c |    2 +-
>>
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>
>>
>> --- a/drivers/md/dm-dedup-rw.c
>>
>> +++ b/drivers/md/dm-dedup-rw.c
>>
>> @@ -165,7 +165,7 @@ static struct bio *prepare_bio_with_pbn(
>>
>>       struct page_list *pl;
>>
>>       struct bio *clone = NULL;
>>
>>
>>
>> -     pl = kmalloc(sizeof(pl), GFP_NOIO);
>>
>> +     pl = kmalloc(sizeof(*pl), GFP_NOIO);
>>
>>       if (!pl)
>>
>>               goto out;
>>
>>
>>
>
>> From: Fengguang Wu <fengguang.wu@intel.com>
>>
>> Subject: [PATCH] dm-dedup: fix coccinelle warnings
>>
>> TO: Mike Snitzer <snitzer@redhat.com>
>>
>> CC: Vasily Tarasov <tarasov@vasily.name>
>>
>> CC: linux-raid@vger.kernel.org (open list:SOFTWARE RAID
>>
>> CC: linux-kernel@vger.kernel.org
>>
>>
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/xmmintrin.h:109:9-12: Unneeded variable: "__Y". Return "__Y" on line 110
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h:1180:9-12: Unneeded variable: "__Y". Return "__Y" on line 1181
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h:1173:10-13: Unneeded variable: "__Y". Return "__Y" on line 1174
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h:1187:10-13: Unneeded variable: "__Y". Return "__Y" on line 1188
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/emmintrin.h:93:10-13: Unneeded variable: "__Y". Return "__Y" on line 94
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/emmintrin.h:743:10-13: Unneeded variable: "__Y". Return "__Y" on line 744
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h:115:9-12: Unneeded variable: "__Y". Return "__Y" on line 116
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h:123:10-13: Unneeded variable: "__Y". Return "__Y" on line 124
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h:131:10-13: Unneeded variable: "__Y". Return "__Y" on line 132
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/xmmintrin.h:109:9-12: Unneeded variable: "__Y". Return "__Y" on line 110
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h:1180:9-12: Unneeded variable: "__Y". Return "__Y" on line 1181
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h:1173:10-13: Unneeded variable: "__Y". Return "__Y" on line 1174
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h:1187:10-13: Unneeded variable: "__Y". Return "__Y" on line 1188
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/emmintrin.h:93:10-13: Unneeded variable: "__Y". Return "__Y" on line 94
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/emmintrin.h:743:10-13: Unneeded variable: "__Y". Return "__Y" on line 744
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h:115:9-12: Unneeded variable: "__Y". Return "__Y" on line 116
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h:123:10-13: Unneeded variable: "__Y". Return "__Y" on line 124
>>
>> /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h:131:10-13: Unneeded variable: "__Y". Return "__Y" on line 132
>>
>> drivers/md/dm-dedup-target.c:750:5-8: Unneeded variable: "ret". Return "0" on line 761
>>
>>
>>
>>
>>
>>  Removes unneeded variable used to store return value.
>>
>>
>>
>> Generated by: scripts/coccinelle/misc/returnvar.cocci
>>
>>
>>
>> CC: Vasily Tarasov <tarasov@vasily.name>
>>
>> CC: Mike Snitzer <snitzer@redhat.com>
>>
>> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
>>
>> ---
>>
>>
>>
>> Please take the patch only if it's a positive warning. Thanks!
>>
>>
>>
>>  /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h |    6 ------
>>
>>  /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h     |    6 ------
>>
>>  /usr/lib/gcc/x86_64-linux-gnu/4.9/include/emmintrin.h     |    4 ----
>>
>>  /usr/lib/gcc/x86_64-linux-gnu/4.9/include/xmmintrin.h     |    2 --
>>
>>  drivers/md/dm-dedup-target.c                              |    3 +--
>>
>>  5 files changed, 1 insertion(+), 20 deletions(-)
>>
>>
>>
>> --- /usr/lib/gcc/x86_64-linux-gnu/4.9/include/xmmintrin.h
>>
>> @@ -106,7 +106,6 @@ typedef float __v4sf __attribute__ ((__v
>>
>>  extern __inline __m128 __attribute__((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm_undefined_ps (void)
>>
>>  {
>>
>> -  __m128 __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> --- /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h
>>
>> @@ -1170,21 +1170,18 @@ _mm256_movemask_ps (__m256 __A)
>>
>>  extern __inline __m256d __attribute__((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm256_undefined_pd (void)
>>
>>  {
>>
>> -  __m256d __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>>  extern __inline __m256 __attribute__((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm256_undefined_ps (void)
>>
>>  {
>>
>> -  __m256 __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>>  extern __inline __m256i __attribute__((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm256_undefined_si256 (void)
>>
>>  {
>>
>> -  __m256i __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> --- /usr/lib/gcc/x86_64-linux-gnu/4.9/include/emmintrin.h
>>
>> @@ -90,7 +90,6 @@ _mm_setr_pd (double __W, double __X)
>>
>>  extern __inline __m128d __attribute__((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm_undefined_pd (void)
>>
>>  {
>>
>> -  __m128d __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> @@ -740,7 +739,6 @@ _mm_move_epi64 (__m128i __A)
>>
>>  extern __inline __m128i __attribute__((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm_undefined_si128 (void)
>>
>>  {
>>
>> -  __m128i __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> --- /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h
>>
>> @@ -112,7 +112,6 @@ extern __inline __m512
>>
>>  __attribute__ ((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm512_undefined_ps (void)
>>
>>  {
>>
>> -  __m512 __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> @@ -120,7 +119,6 @@ extern __inline __m512d
>>
>>  __attribute__ ((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm512_undefined_pd (void)
>>
>>  {
>>
>> -  __m512d __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> @@ -128,7 +126,6 @@ extern __inline __m512i
>>
>>  __attribute__ ((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm512_undefined_si512 (void)
>>
>>  {
>>
>> -  __m512i __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> --- /usr/lib/gcc/x86_64-linux-gnu/4.9/include/xmmintrin.h
>>
>> @@ -106,7 +106,6 @@ typedef float __v4sf __attribute__ ((__v
>>
>>  extern __inline __m128 __attribute__((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm_undefined_ps (void)
>>
>>  {
>>
>> -  __m128 __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> --- /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avxintrin.h
>>
>> @@ -1170,21 +1170,18 @@ _mm256_movemask_ps (__m256 __A)
>>
>>  extern __inline __m256d __attribute__((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm256_undefined_pd (void)
>>
>>  {
>>
>> -  __m256d __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>>  extern __inline __m256 __attribute__((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm256_undefined_ps (void)
>>
>>  {
>>
>> -  __m256 __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>>  extern __inline __m256i __attribute__((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm256_undefined_si256 (void)
>>
>>  {
>>
>> -  __m256i __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> --- /usr/lib/gcc/x86_64-linux-gnu/4.9/include/emmintrin.h
>>
>> @@ -90,7 +90,6 @@ _mm_setr_pd (double __W, double __X)
>>
>>  extern __inline __m128d __attribute__((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm_undefined_pd (void)
>>
>>  {
>>
>> -  __m128d __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> @@ -740,7 +739,6 @@ _mm_move_epi64 (__m128i __A)
>>
>>  extern __inline __m128i __attribute__((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm_undefined_si128 (void)
>>
>>  {
>>
>> -  __m128i __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> --- /usr/lib/gcc/x86_64-linux-gnu/4.9/include/avx512fintrin.h
>>
>> @@ -112,7 +112,6 @@ extern __inline __m512
>>
>>  __attribute__ ((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm512_undefined_ps (void)
>>
>>  {
>>
>> -  __m512 __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> @@ -120,7 +119,6 @@ extern __inline __m512d
>>
>>  __attribute__ ((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm512_undefined_pd (void)
>>
>>  {
>>
>> -  __m512d __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> @@ -128,7 +126,6 @@ extern __inline __m512i
>>
>>  __attribute__ ((__gnu_inline__, __always_inline__, __artificial__))
>>
>>  _mm512_undefined_si512 (void)
>>
>>  {
>>
>> -  __m512i __Y = __Y;
>>
>>    return __Y;
>>
>>  }
>>
>>
>>
>> --- a/drivers/md/dm-dedup-target.c
>>
>> +++ b/drivers/md/dm-dedup-target.c
>>
>> @@ -747,7 +747,6 @@ static void dm_dedup_dtr_fn(struct dm_ta
>>
>>  static int mark_lbn_pbn_bitmap(void *key, int32_t ksize,
>>
>>               void *value, int32_t vsize, void *data)
>>
>>  {
>>
>> -     int ret = 0;
>>
>>       struct mark_and_sweep_data *ms_data =
>>
>>               (struct mark_and_sweep_data *)data;
>>
>>       uint64_t pbn_val = *((uint64_t *)value);
>>
>> @@ -758,7 +757,7 @@ static int mark_lbn_pbn_bitmap(void *key
>>
>>
>>
>>       bitmap_set(ms_data->bitmap, pbn_val, 1);
>>
>>
>>
>> -     return ret;
>>
>> +     return 0;
>>
>>  }
>>
>>
>>
>>  static int cleanup_hash_pbn(void *key, int32_t ksize, void *value,
>>
>
>
> ----- End forwarded message -----
>
