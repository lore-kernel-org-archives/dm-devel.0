From: Vasily Tarasov <tarasov@vasily.name>
Subject: Re: [PATCH RFCv2 10/10] dm-dedup: documentation
Date: Tue, 3 Feb 2015 11:20:57 -0500
Message-ID: <CAFTzLMNr_atABZdGjf3e0TCDsvLyG0A8x7ah4KYBkvxYtF9==A@mail.gmail.com>
References: <53ffb65d.144d320a.0fce.12eb@mx.google.com>
	<20150130185500.GB8364@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150130185500.GB8364@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

On Fri, Jan 30, 2015 at 1:55 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Aug 28, 2014 at 06:16:50PM -0400, Vasily Tarasov wrote:
>
> [..]
>> +Example
>> +=======
>> +
>> +Decide on metadata and data devices:
>> +   # META_DEV=/dev/sdX
>> +   # DATA_DEV=/dev/sdY
>> +
>> +Compute target size assuming 1.5 dedup ratio:
>> +   # DATA_DEV_SIZE=`blockdev --getsz $DATA_DEV`
>> +   # TARGET_SIZE=`expr $DATA_DEV_SIZE \* 10 / 15`
>
> Is above correct? With dm dedupe ratio of 1.5, target size
> should be (15/10) * DATA_DEV_SIZE and not vice-a-versa?
>

You're right, that's a misprint, fixed it.

>> +
>> +Reset metadata device:
>> +   # dd if=/dev/zero of=$META_DEV bs=4096 count=1
>> +
>> +Setup a target:
>> +     echo "0 $TARGET_SIZE dedup $META_DEV $DATA_DEV 4096 md5 cowbtree 100" |\
>> +                             dmsetup create mydedup
>> +
>
> I setup a target and did "dmsetup table" and "dmsetup status" and they
> both seem to be outputting same thing. I think output of "dmsetup table"
> is wrong. As per the man page of dmsetup, you are supposed to output
> the table in a format which can be directly feedback into tagrget for
> loading.
>
> #dmsetup table
> testdedup: 0 2930287752 dedup 244190646 244190646 0 0 4096 8:32 8:48 0 0
> 0 0 0 0
>
> #dmsetup status
> testdedup: 0 2930287752 dedup 244190646 244190646 0 0 4096 8:32 8:48 0 0
> 0 0 0 0
>

Interesting, I actually didn't know that "dmsetup table" output should
be in a format suitable for "dmsetup create/load". Will fix this!

Thanks,
Vasily
