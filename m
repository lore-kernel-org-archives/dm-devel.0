From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: linux-next oops
Date: Wed, 10 Oct 2012 11:58:05 +0900
Message-ID: <5074E43D.8070407@ce.jp.nec.com>
References: <20121009153003.92EA7801A1@viridian.itc.virginia.edu>
	<Pine.LNX.4.64.1210091955260.28143@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1210091955260.28143@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Mikulas,

On 10/10/12 08:57, Mikulas Patocka wrote:
> On Tue, 9 Oct 2012, Bill Pemberton wrote:
> 
>> I'm seeing an oops with the patch
>> http://people.redhat.com/agk/patches/linux/editing/dm-store-dm_target_io-in-bio-front_pad.patch
>> in linux-next (commit 24d047b).
>>
>> I'll attach the dmesg output from a crash.  I bisected it down to this
>> one patch and verified that reverting it results in a kernel that
>> boots normally.  It appears that this will crash any linux-next kernel
>> since 20120918 -- I've not tried them all, but I have tried a few.
>>
>> The machines where this happens are Dell PowerEdge SC1425

I haven't actually tried linux-next but
the following code misses actual cloning after alloc_tio().
(Your patch removed bio_clone_bioset())
Doesn't it cause flush request to be issued unprepared?

1121 static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
1122                                    unsigned request_nr, sector_t len)
1123 {
1124         struct dm_target_io *tio = alloc_tio(ci, ti, ci->bio->bi_max_vecs);
1125         struct bio *clone = &tio->clone;
1126
1127         tio->info.target_request_nr = request_nr;
1128
1129         /*
1130          * Discard requests require the bio's inline iovecs be initialized.
1131          * ci->bio->bi_max_vecs is BIO_INLINE_VECS anyway, for both flush
1132          * and discard, so no need for concern about wasted bvec allocations.
1133          */
1134
1135         if (len) {
1136                 clone->bi_sector = ci->sector;
1137                 clone->bi_size = to_bytes(len);
1138         }
1139
1140         __map_bio(ti, tio);

-- 
Jun'ichi Nomura, NEC Corporation
