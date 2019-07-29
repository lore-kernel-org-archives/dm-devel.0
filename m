From: Bob Liu <bob.liu@oracle.com>
Subject: Re: memory leak in bio_copy_user_iov
Date: Mon, 29 Jul 2019 09:03:21 +0800
Message-ID: <81dcfa59-152c-4f22-2054-615662364394@oracle.com>
References: <000000000000aec4ec058ec71a3d@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000aec4ec058ec71a3d@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+03e5c8ebd22cc6c3a8cb@syzkaller.appspotmail.com>, agk@redhat.com, axboe@kernel.dk, coreteam@netfilter.org, davem@davemloft.net, dm-devel@redhat.com, hdanton@sina.com, kaber@trash.net, kadlec@blackhole.kfki.hu, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pablo@netfilter.org, shli@kernel.org, snitzer@redhat.com, syzkaller-bugs@googlegroups.com
List-Id: dm-devel.ids

On 7/29/19 8:38 AM, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 664820265d70a759dceca87b6eb200cd2b93cda8
> Author: Mike Snitzer <snitzer@redhat.com>
> Date:   Thu Feb 18 20:44:39 2016 +0000
> 
>     dm: do not return target from dm_get_live_table_for_ioctl()
> 

This(and previous bisection) look not related to the reported leak.


A possible reason may be KASAN can't recognize the failure path of bio_alloc_bioset()
where mempool_free() is called but not kmalloc(p).

But it's not a real bug, because we have the condition if (nr_iovecs > inline_vecs).

Below fix may avoid the syzbot bug report..

diff --git a/block/bio.c b/block/bio.c
index 4db1008..04a7879 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -513,8 +513,10 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned int nr_iovecs,
                        bvl = bvec_alloc(gfp_mask, nr_iovecs, &idx, &bs->bvec_pool);
                }
 
-               if (unlikely(!bvl))
-                       goto err_free;
+               if (unlikely(!bvl)) {
+                       mempool_free(p, &bs->bio_pool);
+                       return NULL;
+               }
 
                bio->bi_flags |= idx << BVEC_POOL_OFFSET;
        } else if (nr_iovecs) {
@@ -525,10 +527,6 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, unsigned int nr_iovecs,
        bio->bi_max_vecs = nr_iovecs;
        bio->bi_io_vec = bvl;
        return bio;
-
-err_free:
-       mempool_free(p, &bs->bio_pool);
-       return NULL;
 }
 EXPORT_SYMBOL(bio_alloc_bioset);


Regards, -Bob

> bisection log:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_bisect.txt-3Fx-3D13f4eb64600000&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=MNjYy_nft_s0ErmK2n89p7y2yhKmeWlxWch0z7_dsm8&e=start commit:   0011572c Merge branch 'for-5.2-fixes' of git://git.kernel...
> git tree:       upstream
> final crash:    https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_report.txt-3Fx-3D100ceb64600000&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=iviPOQNPEIjkuqBma_VWEQ9l1Ve3eOiTwads42E4ZPo&e=console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D17f4eb64600000&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=MBwnFwjEcSQfYymfv8EYt_EawVdK9vD-OAqDMutO-YY&e=kernel config:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_.config-3Fx-3Dcb38d33cd06d8d48&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZ
 h8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=SqmDUenNFS-961PGgiMW5mIUv0nIBrf0oBrzUxYZ8Do&e=dashboard link:
> https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_bug-3Fextid-3D03e5c8ebd22cc6c3a8cb&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=jKd2ocY5X94uyB8Or-OC3yffbOgClPQPlXqFnLzvvSY&e=syz repro:      https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.syz-3Fx-3D13244221a00000&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=K-C39Kcd1oEOtJKwnby-s1EyEZZA10mr9bcXZ0J9Kh0&e=C reproducer:   https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.c-3Fx-3D117b2432a00000&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB6
 5eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=7J685CwQN6_FA2KgO3Vgy1msF0zi5O0OqZj_bgvEqBE&e=
> Reported-by: syzbot+03e5c8ebd22cc6c3a8cb@syzkaller.appspotmail.com
> Fixes: 664820265d70 ("dm: do not return target from dm_get_live_table_for_ioctl()")
> 
> For information about bisection process see: https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ-23bisection&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=1ktT0U2YS_I8Zz2o-MS1YcCAzWZ6hFGtyTgvVMGM7gI&m=NfGQRVxYCfZacAKiml9Wue-G1r2h8qkuAhAMOx_uFcc&s=rs52TkiEQCrV4V8YQa2wT55HD8E-0AX9pn7MNIDcje4&e=
