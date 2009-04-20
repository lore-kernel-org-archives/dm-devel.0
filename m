From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: DM-RAID1 data corruption
Date: Mon, 20 Apr 2009 13:08:24 -0400
Message-ID: <49ECAC08.3040705@redhat.com>
References: <Pine.LNX.4.64.0904141618220.701@hs20-bc2-1.build.redhat.com>
	<20090415031210.GA11881@us.ibm.com> <49E645DA.4010204@redhat.com>
	<20090416024959.GB19876@us.ibm.com> <49E7B029.20906@redhat.com>
	<Pine.LNX.4.64.0904200552590.27291@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904200552590.27291@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Mikulas Patocka wrote:
>>> Of course, we can do something in the log itself but it will not fix
>>> "corelog" mirrors, more over the system can't auto recover after a
>>> missing log alone.
>> Yes, storing information on the log device does not save "corelog"
>> mirrors, so we might need some area to keep information on mirror
>> legs.
>>
>> Thanks,
>> Taka
> 
> MD-RAID1 solves this problem by having counters in superblocks on both 
> legs. If some leg dies, the counter on the other devices is increased. If 
> the dead disk comes online again, it is found that it has old counter and 
> cannot be trusted.
> 
> Would it be possible to extend a logical volume when converting it to a 
> raid1 and use the last area of the volume as a superblock?

I agree with this idea. lvm metadata is managed by counters and I think
this method would work for this issue as well.

In addition, I think this sort of superblock is necessary not only
for fixing the data corruption issue but also for introducing faster
blockage algorithm which disables failed mirror legs in kernel.

Thanks,
Taka
