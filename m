From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: block: Fix a WRITE SAME BUG_ON
Date: Tue, 19 Feb 2019 18:10:39 -0500
Message-ID: <yq1tvgzl6hc.fsf@oracle.com>
References: <20190125021107.4595-1-zhangxiaoxu5@huawei.com>
	<CAMeeMh_=UVGwo-=9WtBXRmiHTXnLAswqis97bM-aiuwnzPU0QQ@mail.gmail.com>
	<20190128221441.GA24102@redhat.com> <yq1lg34f4i7.fsf@oracle.com>
	<CAMeeMh85T_qui=LWd0u=b_oMN5XLqowqkvLuYGBM2Ae6tS-mzg@mail.gmail.com>
	<20190131103924.GA22503@infradead.org>
	<CAMeeMh-uxiee7rKutnr3jrMjzkc8=R2Y3DPPBLvLYjqSwjfi_w@mail.gmail.com>
	<20190201073527.GA14758@infradead.org>
	<CAMeeMh-wAZ8377sMrnyQZUt2HT1hB02DHSROJURLmPsaZPkeQQ@mail.gmail.com>
	<f7b05928-316c-4c73-b04b-bba38ea60b27@redhat.com>
	<20190201161803.GA21124@infradead.org>
	<d693e299-3c7d-b3cb-e8c7-a1f94bba4697@huawei.com>
	<yq1lg2jqex7.fsf@oracle.com>
	<6a00e005-656e-7b3c-6b86-1430f3e7e623@huawei.com>
	<22afb417-1bc6-d638-def7-aa3dcc9bcd31@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <22afb417-1bc6-d638-def7-aa3dcc9bcd31@huawei.com> (zhangxiaoxu's
	message of "Mon, 18 Feb 2019 22:10:51 +0800")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, John Dorminy <jdorminy@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


Hi Zhang,

> ping.
>
> Anyone can help merge this patch? or any other solutions?

+	/* If the logical block size is different, forbid write same */
+	if (t->logical_block_size != b->logical_block_size &&
+	    t->max_write_same_sectors != UINT_MAX)
+		t->max_write_same_sectors = 0;
+	else
+		t->max_write_same_sectors = min(t->max_write_same_sectors,
+						b->max_write_same_sectors);
+

I am not particularly keen on this UINT_MAX magic. I would prefer to
have the stacking driver default for lbs be set to 0 so the stacking
function could avoid special-casing the first iteration. But I am not
sure whether that would break any assumptions in DM/MD wrt. the logical
block size being non-zero prior to calling the stacking function.

Mike? Any comments?

If we stick with the UINT_MAX check, the comment should at least point
out why it's there.

-- 
Martin K. Petersen	Oracle Linux Engineering
