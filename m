From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: DM-RAID1 data corruption
Date: Tue, 23 Jun 2009 12:44:13 -0400
Message-ID: <4A41065D.10804@redhat.com>
References: <Pine.LNX.4.64.0904141618220.701@hs20-bc2-1.build.redhat.com>	<20090415031210.GA11881@us.ibm.com>
	<49E645DA.4010204@redhat.com>	<20090416024959.GB19876@us.ibm.com>
	<49E7B029.20906@redhat.com>	<Pine.LNX.4.64.0904200552590.27291@hs20-bc2-1.build.redhat.com>
	<20090623010930.GA13392@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090623010930.GA13392@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: malahal@us.ibm.com
Cc: dm-devel@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

>> MD-RAID1 solves this problem by having counters in superblocks on both 
>> legs. If some leg dies, the counter on the other devices is increased. If 
>> the dead disk comes online again, it is found that it has old counter and 
>> cannot be trusted.
>>
>> Would it be possible to extend a logical volume when converting it to a 
>> raid1 and use the last area of the volume as a superblock?
>>
>> Mikulas
> 
> This is an old thread, I am just trying to revitalize it! :-) How about
> dm-raid1 taking superblock storage as arguments in the command line,
> just like the log device? The superblock storage is entirely managed by
> the kernel, LVM just allocates it. Error handling can be instant this
> way. LVM can auto convert the exiting mirrors to this kind of mirrors if
> space is available.

Interesting idea. The superblock storage managed by kernel is really
important to handle an error quickly inside the kernel.

According to Mikulas's comment, superblocks are located on each legs
and contains a counter. Do you have an idea to separate a superblock
device like the log device? Or do you mean to add a parameter to
enable superblock like "--superblock"? It might be helpful if you
could describe some command line examples.

Thanks,
Taka
