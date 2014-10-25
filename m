From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: fix corrupted thin pool
Date: Sat, 25 Oct 2014 22:18:42 +0200
Message-ID: <544C05A2.8090004@redhat.com>
References: <CACaajQsU_z8pwUGMHfD1y2dVkP_gKgajM6bBV1wFpxpF_7m1nA@mail.gmail.com>	<544B9ADD.6040607@redhat.com>
	<CACaajQsG+2hPqp93yU77TBTOwy2EA_zHbV=pNqiq8dpsqPXzfw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACaajQsG+2hPqp93yU77TBTOwy2EA_zHbV=pNqiq8dpsqPXzfw@mail.gmail.com>
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
Cc: LVM <linux-lvm@redhat.com>
List-Id: dm-devel.ids

Dne 25.10.2014 v 20:41 Vasiliy Tolstov napsal(a):
> 2014-10-25 16:43 GMT+04:00 Zdenek Kabelac <zkabelac@redhat.com>:
>> I'm not sure how you could do that 'by a mistake' since LVM is printing
>> pretty BIG WARNING that any vgcfgrestore with thin should be done after big
>> thinking and requires even extra --force option.
>>
>> But anyway -  if you have  /etc/lvm/archive - you should probably be able to
>> find the 'right' version of lvm2 metadata for your kernel metadata.
>>
>> However 'normally' you could be off the sequence number only by one! so
>> I'm quite curious what you've been able to make such big difference.
>>
>> If you could - package /etc/lvm/archive  so I could get closer look where
>> the lvm2 has holes to allow such operations ?
>>
>> Which version of lvm2 and kernel is here in use ?
>>
>> Have you been manipulating with  thin-pool's metadata in any way ?
>>
>> Regards
>>
>> Zdenek
>
>
> I can't provide old archive data =(, Now i only have this error..
> Also in lvm conf i have issue_discards =1

There is 'internal' metadata archive then -

dd if=/dev/your_pv_volume  of=/tmp/1st.megabyte   bs=1M count=1

It's will capture first megabyte of your PV where are embedded
metadata of your Volume group.

If you are not skilled enough - tar.gz and send this file to me.

Zdenek
