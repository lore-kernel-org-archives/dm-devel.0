From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: Re: [PATCH] md/raid0: Fail BIOs if their underlying
 block device is gone
Date: Fri, 16 Aug 2019 10:45:48 -0300
Message-ID: <47eea35a-c932-66e6-159e-37936b8e60f6@canonical.com>
References: <20190729193359.11040-1-gpiccoli@canonical.com>
	<87zhkwl6ya.fsf@notabene.neil.brown.name>
	<6400083b-3cf3-cbc6-650a-c3ae6629b14c@canonical.com>
	<CAPhsuW69YrpHqBCOob2b5wzzWS9FM087sfe3iC0odX8kZWRwmA@mail.gmail.com>
	<CAPhsuW5zB=Kik4rq9YA-xBer7Z-h-23QV4WSCWe-jvhFgGc0Cw@mail.gmail.com>
	<9674ca8f-4325-3023-8a1d-39782103f55d@canonical.com>
	<72C166DF-3984-4330-8C60-BBDA07358771@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <72C166DF-3984-4330-8C60-BBDA07358771@fb.com>
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
To: Song Liu <songliubraving@fb.com>
Cc: Neil F Brown <nfbrown@suse.com>, Song Liu <liu.song.a23@gmail.com>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jay Vosburgh <jay.vosburgh@canonical.com>
List-Id: dm-devel.ids

On 01/08/2019 19:43, Song Liu wrote:
> 
> [...]
>> Hi Song, thanks for the feedback! After changing the patch and testing a
>> bit, it behaves exactly as you said, we got either valid data read from
>> the healthy devices or -EIO for the data tentatively read from the
>> failed/missing array members.
> 
> Thanks for testing this out. 
> 
>>
>> So, I'll resubmit with that change. Also, I've noticed clearing the
>> BROKEN flag seem unnecessary, if user stops the array in order to fix
>> the missing member, it'll require a re-assembly and the array is gonna
>> work again.
>>
>> Do you / Neil considers this fix relevant to md/linear too? If so, I can
>> also include that in the V2.
> 
> Yes, please also include fix for md/linear. 
> 
> Song
> 

V2 just sent:
lore.kernel.org/linux-block/20190816133441.29350-1-gpiccoli@canonical.com

Thanks,


Guilherme
