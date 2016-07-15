From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: write directly to device mapper snapshot origin
 device ?
Date: Fri, 15 Jul 2016 14:35:04 +0200
Message-ID: <331dd729-34be-a1fa-abfe-c4ad21e7541c@redhat.com>
References: <CAA=4086wdhAxNsWjAYgZG3bWORV2vF3YpMQk9OTjAg22MJi07Q@mail.gmail.com>
	<CAA=4086b_9xz32cU+DnuUMGU=rZhWZ=+UVfjwq0AKnX3C7k3qA@mail.gmail.com>
	<alpine.LRH.2.02.1607150738100.5034@file01.intranet.prod.int.rdu2.redhat.com>
	<CAA=4086fe1a02vm8VWHyCpUD15pO_2vBsiVhcik1kx8Xt+5EYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAA=4086fe1a02vm8VWHyCpUD15pO_2vBsiVhcik1kx8Xt+5EYA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Navin P.S" <navinp1912@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 15.7.2016 v 14:15 Navin P.S napsal(a):
> On Fri, Jul 15, 2016 at 5:21 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>>
>>
>> On Fri, 15 Jul 2016, Navin P.S wrote:
>>
>>> Resend ..
>>>
>>> On Thu, Jul 14, 2016 at 7:55 PM, Navin P.S <navinp1912@gmail.com> wrote:
>>>> Hi,
>>>>   Can i do dd if=/dev/zero of=/dev/mapper/dmo count=20 ? where dmo is
>>>> a dm snapshot origin created through dmsetup command. Instead of
>>>> /dev/zero i can write valid devices.
>>>>
>>>> I could create the dmo through some lvm2 commands.
>>
>> lvcreate -s
>>
>>>> Is direct write
>>>> with 4k (page size values ) allowed when it is mapped to 2 block
>>>> devices in linear mode ?
>>>>
>>>>
>>>> Regards,
>>>> -- Navin
>>>
>>> I'm seeing  OOM followed by reboot of host machine.
>>> Does this mean this device cannot to exported to containers for writing ?
>>
>> The snapshot driver requires 32 bytes of memory for one chunk (the chunk
>> size is selected with the "-c" switch to lvcreate). You should set system
>> memory according to that.
>>
>> Mikulas
>>
>>> -- Navin
>>>
>
>
>
>
> Are origin devices readonly ?
>
> When i do dd if=/dev/zero of=/dev/mapper/ff count=10, it kills all the
> process says OOM.
>
> How do you go about debugging this ? I'm running 4.7.0-rc7+ .
>
>
> root@vm-xenial-foo:~# dmsetup info
> Name:              cryptie4-ff
> State:             ACTIVE
> Read Ahead:        256
> Tables present:    LIVE
> Open count:        0
> Event number:      0
> Major, minor:      251, 0
> Number of targets: 2
>
> Name:              ff
> State:             ACTIVE
> Read Ahead:        256
> Tables present:    LIVE
> Open count:        0
> Event number:      0
> Major, minor:      251, 1
> Number of targets: 1
>
> root@vm-xenial-foo:~# dmsetup status
> cryptie4-ff: 0 102400 linear
> cryptie4-ff: 102400 122880 linear
> ff: 0 102400 snapshot-origin
> root@vm-xenial-foo:~#

Hi

Maybe you should have started with reading documenation for snapshot target ?

linux/Documentation/device-mapper/snapshot.txt

If you don't like to read much doc - I'd highly recommend to stay at 'lvm2' 
command level and create snapshot via  'lvcreate -s'

Regards

Zdenek
