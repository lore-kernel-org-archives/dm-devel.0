From: "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Subject: Re: block: Fix a WRITE SAME BUG_ON
Date: Tue, 12 Feb 2019 11:11:29 +0800
Message-ID: <d693e299-3c7d-b3cb-e8c7-a1f94bba4697@huawei.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190201161803.GA21124@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Heinz Mauelshagen <heinzm@redhat.com>, John Dorminy <jdorminy@redhat.com>
Cc: axboe@kernel.dk, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Any progress about the problme?
Should we disable the write same when stack the different LBA disks?

On 2/2/2019 12:18 AM, Christoph Hellwig wrote:
> On Fri, Feb 01, 2019 at 05:03:40PM +0100, Heinz Mauelshagen wrote:
>> On 2/1/19 3:09 PM, John Dorminy wrote:
>>> I didn't know such a thing existed... does it work on any block
>>> device? Where do I read more about this?
>>
>>
>> Use sg_write_same(8) from package sg3_utils.
>>
>> For instance 'sg_write_same --in=foobarfile --lba=0 --num=20000
>> --xferlen=512 /dev/sdwhatever'
>>
>> will read the pattern to write same from file 'foobarfile' with length
>> explicitely set to 512 bytes
>> (rather than derived from foobarfile's size) and write it 20000 times
>> starting at LBA 0 to /dev/sdwhatever.
> 
> Yeah.  Note that this will only work on SCSI disks (and maybe ATA
> for a very specific corner case).  But for actual devices and not
> remappers the same is true of REQ_OP_WRITE_SAME.
> 
> .
> 
