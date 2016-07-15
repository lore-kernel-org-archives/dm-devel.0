From: "Navin P.S" <navinp1912@gmail.com>
Subject: Re: write directly to device mapper snapshot origin
	device ?
Date: Sat, 16 Jul 2016 00:28:03 +0530
Message-ID: <CAA=4085XUEvi4+DS229JfvygJ8Q7Usskf5TCumAtJ5BsKSZ8JQ@mail.gmail.com>
References: <CAA=4086wdhAxNsWjAYgZG3bWORV2vF3YpMQk9OTjAg22MJi07Q@mail.gmail.com>
	<CAA=4086b_9xz32cU+DnuUMGU=rZhWZ=+UVfjwq0AKnX3C7k3qA@mail.gmail.com>
	<alpine.LRH.2.02.1607150738100.5034@file01.intranet.prod.int.rdu2.redhat.com>
	<CAA=4086fe1a02vm8VWHyCpUD15pO_2vBsiVhcik1kx8Xt+5EYA@mail.gmail.com>
	<331dd729-34be-a1fa-abfe-c4ad21e7541c@redhat.com>
	<CAA=4087yxn8zKiHkuGavv4P=8M1DSN3W1c3n_=20+tHVuR=uSw@mail.gmail.com>
	<cd3fedfb-7afe-6c9f-898b-bb6fc10c7a95@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cd3fedfb-7afe-6c9f-898b-bb6fc10c7a95@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jul 15, 2016 at 6:14 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> Dne 15.7.2016 v 14:40 Navin P.S napsal(a):
>
>> On Fri, Jul 15, 2016 at 6:05 PM, Zdenek Kabelac <zkabelac@redhat.com>
>> wrote:
>>>
>>> Dne 15.7.2016 v 14:15 Navin P.S napsal(a):
>>>
>>>> On Fri, Jul 15, 2016 at 5:21 PM, Mikulas Patocka <mpatocka@redhat.com>
>>>> wrote:
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> On Fri, 15 Jul 2016, Navin P.S wrote:
>>>>>
>>>>>> Resend ..
>>>>>>
>>>>>> On Thu, Jul 14, 2016 at 7:55 PM, Navin P.S <navinp1912@gmail.com>
>>>>>> wrote:
>>>>>>>
>>>>>>>
>>>>>>> Hi,
>>>>>>>   Can i do dd if=/dev/zero of=/dev/mapper/dmo count=20 ? where dmo is
>>>>>>> a dm snapshot origin created through dmsetup command. Instead of
>>>>>>> /dev/zero i can write valid devices.
>>>>>>>
>>>>>>> I could create the dmo through some lvm2 commands.
>>>>>
>>>>>
>>>>>
>>>>> lvcreate -s
>>>>>
>>>>>>> Is direct write
>>>>>>> with 4k (page size values ) allowed when it is mapped to 2 block
>>>>>>> devices in linear mode ?
>>>>>>>
>>>>>>>
>>>>>>> Regards,
>>>>>>> -- Navin
>>>>>>
>>>>>>
>>>>>>
>>>>>> I'm seeing  OOM followed by reboot of host machine.
>>>>>> Does this mean this device cannot to exported to containers for
>>>>>> writing
>>>>>> ?
>>>>>
>>>>>
>>>>>
>>>>> The snapshot driver requires 32 bytes of memory for one chunk (the
>>>>> chunk
>>>>> size is selected with the "-c" switch to lvcreate). You should set
>>>>> system
>>>>> memory according to that.
>>>>>
>>>>> Mikulas
>>>>>
>>>>>> -- Navin
>>>>>>
>>>>
>>>>
>>>>
>>>>
>>>> Are origin devices readonly ?
>>>>
>>>> When i do dd if=/dev/zero of=/dev/mapper/ff count=10, it kills all the
>>>> process says OOM.
>>>>
>
>>
>> Can you please paste the snippet ?
>
>
>
> 1) a device containing the original mapping table of the source volume;
> 2) a device used as the <COW device>;
> 3) a "snapshot" device, combining #1 and #2, which is the visible snapshot
>    volume;
> 4) the "original" volume (which uses the device number used by the original
>    source volume), whose table is replaced by a "snapshot-origin" mapping
>    from device #1.
>

1,2,3,4 doesn't say you can't write to snapshot-origin ? Does it ?
If you setup the table with dmsetup -r explicitly it means readonly.

Also if direct writes are not supposed to be done, only merging why
not setup readonly and
then create it in read-write during merging.


-- 
-- Navin
