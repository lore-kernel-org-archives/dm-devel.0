From: "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Subject: Re: block: Fix a WRITE SAME BUG_ON
Date: Mon, 18 Feb 2019 22:10:51 +0800
Message-ID: <22afb417-1bc6-d638-def7-aa3dcc9bcd31@huawei.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <6a00e005-656e-7b3c-6b86-1430f3e7e623@huawei.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, John Dorminy <jdorminy@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

ping.

Anyone can help merge this patch? or any other solutions?

On 2/14/2019 5:36 PM, zhangxiaoxu (A) wrote:
> Any comments about the patch?
> 
> On 2/14/2019 10:31 AM, Martin K. Petersen wrote:
>>
>> zhangxiaoxu,
>>
>>> Any progress about the problme?
>>> Should we disable the write same when stack the different LBA disks?
>>
>> Yes, please.
>>
