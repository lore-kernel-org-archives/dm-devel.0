From: Milan Broz <gmazyland@gmail.com>
Subject: Re: Testing dm-integrity (WAS: Re: Support for data CRC)
Date: Sun, 10 Sep 2017 22:06:13 +0200
Message-ID: <bb924fb0-ba74-1f14-d1ce-ea567c641c54@gmail.com>
References: <20170821190414.long2535xppcxvvd@breakpoint.cc>
	<CAJCQCtSUS9yZfv9xLe9a5o5x8ZSkOUWC_6QaeUi6oQ_QXg4GRQ@mail.gmail.com>
	<20170822111053.7jypthbydpkn2tj4@breakpoint.cc>
	<CAJCQCtTF2bWgB1++v3XOwaPqpPxc7-0Lv+Qc_3bebb0zMDNszA@mail.gmail.com>
	<20170910194350.v5fzbgrzihpjg2pv@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170910194350.v5fzbgrzihpjg2pv@breakpoint.cc>
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
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>, dm-devel@redhat.com
Cc: xfs list <linux-xfs@vger.kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Chris Murphy <lists@colorremedies.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids


On 09/10/2017 09:43 PM, Sebastian Andrzej Siewior wrote:
> On 2017-08-22 16:37:07 [-0600], Chris Murphy wrote:
>> Documentation says either crc or hash is possible, including crc32.
>> https://www.kernel.org/doc/Documentation/device-mapper/dm-integrity.txt
>>> My idea was that if the "normal" path is faulty (and noticed by the crc
>>> check) it (xfs or the dm layer) would try to read the data via an
>>> alternative path if possible (say on RAID1/5/6).
>>
>> Yes you have to build each layer you want separately with this method.
> 
> So I tried this:
> 
> dmsetup create test-raid1 --table '0 4194304 raid raid1 3 0 region_size 1024 2 - /dev/vdc - /dev/vdd'
> 
> # creating the target (size 1)
> provided_data_sectors=1
> table="0 $provided_data_sectors integrity /dev/mapper/test-raid1 4096 - D 1 internal_hash:crc32c"
> dmsetup create dm-int --table "$table"
> dmsetup remove /dev/mapper/dm-int
> 
> # hexdumped. is there a tool for that?

There is integritysetup tool (part of cryptsetup package) that automates format and mount of dm-integrity devices.
For now in devel git, I expect we will do some release package this month.
(So no need to use dmsetup here.)

...

> at some point I expected dm-integrity to check the other disk in RAID.

The dm-integrity has no connection to RAID, it will just return EILSEQ (instead of EIO error)
to inform that the error is an data integrity error, not a media (or other) IO error.

> Isn't this possible or is my setup wrong at some point? If it is not
> possible, could it be made possible?

It is up to RAID driver to handle integrity error properly (the same should happen
for hardware DIF integrity error I guess - you can try to simulate it with scsi_debug).

Milan
