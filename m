From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: block mapping
Date: Thu, 29 Sep 2011 17:27:45 +0300
Message-ID: <CALLzPKb8O853Zaedf_Dv1pSjzUPAMoVVE0=qY9vu77zxVz=SLw@mail.gmail.com>
References: <CALLzPKaWVR5=+S7QtHRpPBkDR5SVsZEAhbUn+G09o1S9JhjFOw@mail.gmail.com>
	<4E8475E3.7020907@redhat.com>
	<CALLzPKZappmw5wVJzN6biH9zUQB_nRueELrSi7yS4nfu-rTazA@mail.gmail.com>
	<4E847E5F.5090008@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4E847E5F.5090008@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 29, 2011 at 5:19 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> Dne 29.9.2011 16:10, Kasatkin, Dmitry napsal(a):
>> Hello,
>>
>>
>> On Thu, Sep 29, 2011 at 4:42 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
>>> Dne 29.9.2011 15:35, Kasatkin, Dmitry napsal(a):
>>>> Hello All,
>>>>
>>>> I would like to implement such block device, which can store
>>>> additional information along with the block data.
>>>> For example. so if file system has 4k block, I would like to store
>>>> 4k+256b of additional information...
>>>>
>>>> Can such block device be implemented with device mapper?
>>>>
>>>
>>> Yes - i.e.the old snapshot target stores the block and it's remapping info
>>> (thought the size info is much smaller then 256b)
>>>
>>
>> 1. Old snapshot target? Where is it...
>>
>
> kernel/drivers/md/dm-snap-persistent.c
>
>
>> 2. Isn't it stores some data at the beginning of the block device - in
>> the header..
>
> A bit more complicated that this - but yes, quite straightforward target.
>

Thanks

>
> Zdenek
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
