From: Ross Anderson <rosander@dsotm.net>
Subject: Re: kpartx fails 4k block partition *changed**
Date: Thu, 13 Mar 2014 10:00:45 -0500
Message-ID: <5321C81D.8040005@dsotm.net>
References: <531F3AFE.4070008@gmail.com> <5320DDA1.3060309@dsotm.net>
	<5321900C.3030008@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5321900C.3030008@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Greetings,

I apologize I've riposted a updated pastebin. The dm seemed to have 
become confused with multiple luns being attached and detached before 
this post. A soft reboot of the system re-mapped and produced much 
different results. Now upon start up the 4k devices are not listed under 
lsblk as DM but only as their raw paths. Multipath has created the 
device without partition. I can manually execute kpartx and the dm parts 
are added. So now I'm not sure if this is a multipath problem or udev 
rules.

http://pastebin.com/Nnd4Ym4W

Thanks
Ross


On 3/13/2014 6:01 AM, Bryn M. Reeves wrote:
> On 03/12/2014 10:20 PM, Ross Anderson wrote:
>> Under 0.50 multipath tools release, partitions are not being created for
>> devices that are 4k Native.  This is under kernel 3.13.6, udev-208.
>>
>> http://pastebin.com/Nnd4Ym4W
> The devices below don't appear in your lsblk output so it's hard to say
> whether the partitions kpartx prints for the devices are valid or not:
>
>>      ##kpartx sfx4k
>>      sfx4k1 : 0 2056 sfx4k 2048
>>      sfx4k2 : 0 165068760 sfx4k 8192
>>      ##kpartx samplelib
>>      samplelib1 : 0 2056 samplelib 2048
>>      samplelib2 : 0 1171863512 samplelib 8192
> That said the tables above look perfectly plausible. It would help to
> verify that if you could post the partition tables the devices contain
> (preferably in sector units).
>
>> kpartx -a 2 /dev/dm-2
>> failed to stat() 2
> What's that '2' doing there? The only thing kpartx expects following the
> '-a' is the whole disk device:
>
>      SYNOPSIS
>         kpartx [-a | -d | -l] [-v] wholedisk
>
> What happens when you run 'kpartx -a /dev/mapper/sfx4k? (or samplelib).
>
> Regards,
> Bryn.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
