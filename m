From: Nikolay Borisov <n.borisov@siteground.com>
Subject: Re: Cannot delete lvm thin volume
Date: Mon, 19 Oct 2015 19:22:38 +0300
Message-ID: <CAJFSNy5SEiR414ZPk1U2s2ex_=r=vj6Jz8Xdyn0guKt3De-qcQ@mail.gmail.com>
References: <5620EC96.3090205@kyup.com> <56250358.4050701@redhat.com>
	<56250943.1060108@kyup.com> <56251081.7070703@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56251081.7070703@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, SiteGround Operations <operations@siteground.com>, zkabelac@redhat.com
List-Id: dm-devel.ids

On Mon, Oct 19, 2015 at 6:47 PM, Heinz Mauelshagen <heinzm@redhat.com> wrote:
>
> fuser and lsof can only report open files of active processes.
>
> You should check the following as well:
>
> grep c13537_2k /proc/{mounts,swaps}
> dmsetup table|grep 252:6
> losetup -a | grep dm-6

Okay, the next time this situation occurs I will do that and
report back (this time to the correct mailing list :) if I find anything?

>
> Heinz
>
>
> On 10/19/2015 05:16 PM, Nikolay Borisov wrote:
>>
>>
>> On 10/19/2015 05:51 PM, Heinz Mauelshagen wrote:
>>>
>>> Nikolay,
>>>
>>> this is a question for linux-lvm.
>>
>> Right, will know from now on .
>>
>>> You're saying the fs is not mounted but the lv is open as of
>>> your lvdisplay output, thus you can't lvremove it.
>>
>> How can I see which is the actual user of it? As I stated previously
>> fuser and lsof didn't show anything relevant. Is there some additional
>> tools from the lvm suite that I can see to obtain such information?
>>
>>>
>>> Heinz
>>>
>>>
>>> On 10/16/2015 02:24 PM, Nikolay Borisov wrote:
>>>>
>>>> Hello I have the following thin volume, which I'd like to delete:
>>>>
>>>> lvdisplay -v /dev/coregroup/c13537_2k
>>>>       Using logical volume(s) on command line.
>>>>     --- Logical volume ---
>>>>     LV Path                /dev/coregroup/c13537_2k
>>>>     LV Name                c13537_2k
>>>>     VG Name                coregroup
>>>>     LV UUID                LBPr0i-uac8-i3Co-5B3M-A6Bv-q8iv-kSRLRr
>>>>     LV Write Access        read/write
>>>>     LV Creation host, time xxxxx.net, 2015-10-14 02:02:45 -0500
>>>>     LV Pool name           corepool
>>>>     LV Status              available
>>>>     # open                 1
>>>>     LV Size                1.80 TiB
>>>>     Mapped size            42.11%
>>>>     Current LE             471808
>>>>     Segments               1
>>>>     Allocation             inherit
>>>>     Read ahead sectors     auto
>>>>     - currently set to     256
>>>>     Block device           252:6
>>>>
>>>> dmsetup info coregroup-c13537_2k
>>>> Name:              coregroup-c13537_2k
>>>> State:             ACTIVE
>>>> Read Ahead:        256
>>>> Tables present:    LIVE
>>>> Open count:        1
>>>> Event number:      1
>>>> Major, minor:      252, 6
>>>> Number of targets: 1
>>>> UUID:
>>>> LVM-M8PwSxzGcsZQTtdgzfixsr08ZAlNpAbALBPr0iuac8i3Co5B3MA6Bvq8ivkSRLRr
>>>>
>>>> dmsetup status
>>>> coregroup-c13537_2k: 0 3865051136 thin 1627684864 3865042943
>>>>
>>>> The version of the software is:
>>>> lvremove --version
>>>>     LVM version:     2.02.118(2)-RHEL6 (2015-09-08)
>>>>     Library version: 1.02.95-RHEL6 (2015-09-08)
>>>>     Driver version:  4.26.0
>>>>
>>>> And the kernel is 3.12.47.
>>>>
>>>> When I run 'lvremove -f /dev/coregroup/c13537_2k' I get the following
>>>> error: Logical volume coregroup/c13537_2k contains a filesystem in use.
>>>> I also get the same error when I try to deactivate the volume.
>>>>
>>>> fuser doesn't report anything and the volume is not mounted anywhere. I
>>>> have also acquired an ftrace trace from executing lvremove but there are
>>>> multiple invocation of the dm_ioctl function and I'm not sure which one
>>>> is the relevant. So if you tell me what information in particular you
>>>> need I'd post it here.
>>>>
>>>> Regards,
>>>> Nikolay
>>>>
>>>> --
>>>> dm-devel mailing list
>>>> dm-devel@redhat.com
>>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
>
