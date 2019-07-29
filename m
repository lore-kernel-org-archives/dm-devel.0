From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH] md/raid0: Fail BIOs if their underlying
 block device is gone
Date: Mon, 29 Jul 2019 17:27:15 -0300
Message-ID: <053c88e1-06ec-0db1-de8f-68f63a3a1305@canonical.com>
References: <20190729193359.11040-1-gpiccoli@canonical.com>
	<20190730011850.2f19e140@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190730011850.2f19e140@natsu>
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
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-block@vger.kernel.org, Song Liu <songliubraving@fb.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, jay.vosburgh@canonical.com
List-Id: dm-devel.ids



On 29/07/2019 17:18, Roman Mamedov wrote:
> On Mon, 29 Jul 2019 16:33:59 -0300
> "Guilherme G. Piccoli" <gpiccoli@canonical.com> wrote:
> 
>> Currently md/raid0 is not provided with any mechanism to validate if
>> an array member got removed or failed. The driver keeps sending BIOs
>> regardless of the state of array members. This leads to the following
>> situation: if a raid0 array member is removed and the array is mounted,
>> some user writing to this array won't realize that errors are happening
>> unless they check kernel log or perform one fsync per written file.
>>
>> In other words, no -EIO is returned and writes (except direct ones) appear
>> normal. Meaning the user might think the wrote data is correctly stored in
>> the array, but instead garbage was written given that raid0 does stripping
>> (and so, it requires all its members to be working in order to not corrupt
>> data).
> 
> If that's correct, then this seems to be a critical weak point in cases when
> we have a RAID0 as a member device in RAID1/5/6/10 arrays.
> 

Hi Roman, I don't think this is usual setup. I understand that there are
RAID10 (also known as RAID 0+1) in which we can have like 4 devices, and
they pair in 2 sets of two disks using stripping, then these sets are
paired using mirroring. This is handled by raid10 driver however, so it
won't suffer for this issue.

I don't think it's common or even makes sense to back a raid1 with 2
pure raid0 devices.
Thanks for your comment!
Cheers,


Guilherme
