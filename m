From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: block: Fix a WRITE SAME BUG_ON
Date: Fri, 1 Feb 2019 17:03:40 +0100
Message-ID: <f7b05928-316c-4c73-b04b-bba38ea60b27@redhat.com>
References: <20190125021107.4595-1-zhangxiaoxu5@huawei.com>
	<CAMeeMh_=UVGwo-=9WtBXRmiHTXnLAswqis97bM-aiuwnzPU0QQ@mail.gmail.com>
	<20190128221441.GA24102@redhat.com> <yq1lg34f4i7.fsf@oracle.com>
	<CAMeeMh85T_qui=LWd0u=b_oMN5XLqowqkvLuYGBM2Ae6tS-mzg@mail.gmail.com>
	<20190131103924.GA22503@infradead.org>
	<CAMeeMh-uxiee7rKutnr3jrMjzkc8=R2Y3DPPBLvLYjqSwjfi_w@mail.gmail.com>
	<20190201073527.GA14758@infradead.org>
	<CAMeeMh-wAZ8377sMrnyQZUt2HT1hB02DHSROJURLmPsaZPkeQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAMeeMh-wAZ8377sMrnyQZUt2HT1hB02DHSROJURLmPsaZPkeQQ@mail.gmail.com>
Content-Language: en-MW
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Dorminy <jdorminy@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 2/1/19 3:09 PM, John Dorminy wrote:
> I didn't know such a thing existed... does it work on any block
> device? Where do I read more about this?


Use sg_write_same(8) from package sg3_utils.

For instance 'sg_write_same --in=foobarfile --lba=0 --num=20000 
--xferlen=512 /dev/sdwhatever'

will read the pattern to write same from file 'foobarfile' with length 
explicitely set to 512 bytes
(rather than derived from foobarfile's size) and write it 20000 times 
starting at LBA 0 to /dev/sdwhatever.

> --lba=
>
> On Fri, Feb 1, 2019 at 2:35 AM Christoph Hellwig <hch@infradead.org> wrote:
>> On Thu, Jan 31, 2019 at 02:41:52PM -0500, John Dorminy wrote:
>>>> On Wed, Jan 30, 2019 at 09:08:50AM -0500, John Dorminy wrote:
>>>>> (I use WRITE_SAME to fill devices with a particular pattern in order
>>>>> to catch failures to initialize disk structures appropriately,
>>>>> personally, but it's just for convenience/speed.)
>>>> How do you use it?  We don't have a user interface to generate
>>>> REQ_OP_WRITE_SAME requests.
>>> A not-checked-in test module, similar to Zhang Xiaoxu's reproducer,
>>> exposing a sysfs node to trigger filling a block device with a test
>>> pattern.
>> Any reason you don't just use SCSI/NVMe passthrough directly from
>> userspace for that?
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
