From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH] md/raid0: Fail BIOs if their underlying
 block device is gone
Date: Thu, 1 Aug 2019 22:43:48 +0000
Message-ID: <72C166DF-3984-4330-8C60-BBDA07358771@fb.com>
References: <20190729193359.11040-1-gpiccoli@canonical.com>
	<87zhkwl6ya.fsf@notabene.neil.brown.name>
	<6400083b-3cf3-cbc6-650a-c3ae6629b14c@canonical.com>
	<CAPhsuW69YrpHqBCOob2b5wzzWS9FM087sfe3iC0odX8kZWRwmA@mail.gmail.com>
	<CAPhsuW5zB=Kik4rq9YA-xBer7Z-h-23QV4WSCWe-jvhFgGc0Cw@mail.gmail.com>
	<9674ca8f-4325-3023-8a1d-39782103f55d@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9674ca8f-4325-3023-8a1d-39782103f55d@canonical.com>
Content-Language: en-US
Content-ID: <1DB28A5D09FE504C800002670C1FD648@namprd15.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: Neil F Brown <nfbrown@suse.com>, Song Liu <liu.song.a23@gmail.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids



> On Aug 1, 2019, at 1:28 PM, Guilherme G. Piccoli <gpiccoli@canonical.com> wrote:
> 
> 
> 
> On 31/07/2019 16:56, Song Liu wrote:
>> On Wed, Jul 31, 2019 at 12:54 PM Song Liu <liu.song.a23@gmail.com> wrote:
>>> 
>>> On Tue, Jul 30, 2019 at 5:31 AM Guilherme G. Piccoli
>>> <gpiccoli@canonical.com> wrote:
>>>> 
>>>> On 29/07/2019 21:08, NeilBrown wrote:
>>>>> [...]
>>>>>> +    if (unlikely(test_bit(MD_BROKEN, &mddev->flags))) {
>>>>>> +            bio_io_error(bio);
>>>>>> +            return BLK_QC_T_NONE;
>>>>>> +    }
>>>>> 
>>>>> I think this should only fail WRITE requests, not READ requests.
>>>>> 
>>>>> Otherwise the patch is probably reasonable.
>>>>> 
>>>>> NeilBrown
>>>> 
>>>> Thanks for the feedback Neil! I thought about it; it seemed to me better
>>>> to deny/fail the reads instead of returning "wrong" reads, since a file
>>>> read in a raid0 will be incomplete if one member is missing.
>>>> But it's fine for me to change that in the next iteration of this patch.
>>> 
>>> For reads at block/page level, we will either get EIO or valid data, right?
>>> 
>>> If that's not the case, we should fail all writes.
>> 
>> Oops, I meant all _reads_.
> 
> Hi Song, thanks for the feedback! After changing the patch and testing a
> bit, it behaves exactly as you said, we got either valid data read from
> the healthy devices or -EIO for the data tentatively read from the
> failed/missing array members.

Thanks for testing this out. 

> 
> So, I'll resubmit with that change. Also, I've noticed clearing the
> BROKEN flag seem unnecessary, if user stops the array in order to fix
> the missing member, it'll require a re-assembly and the array is gonna
> work again.
> 
> Do you / Neil considers this fix relevant to md/linear too? If so, I can
> also include that in the V2.

Yes, please also include fix for md/linear. 

Song
