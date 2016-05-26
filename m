From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Snapshot origin table as P/PO snapshot with /dev/null
Date: Thu, 26 May 2016 16:16:22 +0200
Message-ID: <3b01279f-55ad-32de-6ab5-fbd6358ad229@redhat.com>
References: <alpine.LRH.2.02.1605261011410.14462@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1605261011410.14462@file01.intranet.prod.int.rdu2.redhat.com>
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

On 26.5.2016 16:12, Mikulas Patocka wrote:
>
>
> On Thu, 26 May 2016, Navin P.S wrote:
>
>> Hi, Can you please help me with the below query that i posted to dm-devel ?
>>
>> On Thu, May 26, 2016 at 5:07 AM, Navin P.S <navinp1912@gmail.com> wrote:
>>       Hi,  If i have a snapshot origin created using dmsetup create table with a mapping  real device  with (major,minor) =(8,18) and lets name it /dev/mapper/dmso
>>       . Now the set of reads are writes done from /dev/mapper/dmso have some values (R,W).
>>
>> Had i been creating a persistent snapshot using (P or PO) mode with origin device as /dev/null and COW device is my real device (maj,min)=8,18 and it is named as
>> /dev/mapper/dmsp. Now if i do the exact same reads and writes that i did to dmso (snapshot-origin) , will get i the same set of output values (R,W).
>>
>> In my experiment i did. So i'm asking is there a case where it differs ?
>>
>> Also i looked at the code in drivers/md/dm-snap.c and i find that both the drivers snapshot and snapshot-origin use the same __orgin_write . So my
>> partial/incomplete understanding is that it works from the read/write view point from /dev/mapper/dmsp.
>>
>> I'll not be using the snapshot-merge feature , so merging to /dev/null is irrelevant here.
>>
>> Regards,
>> -- Navin
>
> Hi
>
> The snapshot target doesn't accept /dev/null because it requires a block
> device and /dev/null is chatected device.
>
> You can use the "zero" device mapper target to create a block device that
> returns zeroes on reads and that discards writes. You can use this zero
> device as an origin to the dm-snapshot target.
>
> With LVM, you can use this functionality with lvcreate --virtualsize
> switch.
>


Just a minor clarification - if you have any 'recent' version of lvm2
this functionality is handled via thin-provisioning by default.

So if you really want to use 'old' snapshot target - just use:

lvcreate --type snapshot -Lrealsize  -Vvirtualsize  vg


And if you want to see exact ioctl sequencing - then use lvcreate -vvvv.

Regards

Zdenek
