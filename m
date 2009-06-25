From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: DM-RAID1 data corruption
Date: Thu, 25 Jun 2009 12:16:24 -0400
Message-ID: <4A43A2D8.6030709@redhat.com>
References: <Pine.LNX.4.64.0904141618220.701@hs20-bc2-1.build.redhat.com>
	<20090415031210.GA11881@us.ibm.com> <49E645DA.4010204@redhat.com>
	<20090416024959.GB19876@us.ibm.com> <49E7B029.20906@redhat.com>
	<Pine.LNX.4.64.0904200552590.27291@hs20-bc2-1.build.redhat.com>
	<20090623010930.GA13392@us.ibm.com> <4A41065D.10804@redhat.com>
	<19009.38782.225681.85214@notabene.brown>
	<4A424FC3.50809@redhat.com>
	<Pine.LNX.4.64.0906251044230.18768@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0906251044230.18768@hs20-bc2-1.build.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/25/09 10:47, Mikulas Patocka wrote:
>> superblock approach may solve this data corruption issue without an
>> additional delay. When dm-raid1 detects a write error, it can disable
>> the mirror leg quickly and ask userspace to process aftertreatment.
>>
>> I would like to continue discussion how to fix this issue.
>>
>> Thanks,
>> Taka
> 
> The current code already blocks all i/os if the log fails. So if your 
> application is sensitive for it, you have to test for it anyway.

It is also a known issue. We are trying to make a log device redundant
to prevent disk replication when a log device has problem. It will
solve the delay caused by a log device failure as well.

> You can write new implementation dm-raid1.2 that will have two log devices 
> (just like md-raid has two superblocks) and can perform without userspace 
> intervention if any of the legs or logs fail.
> 
> But it is really more like rewrite --- I think it would be easier to write 
> it from scratch than to patch it over existing dm-raid1 code.

Hmm. I will look at implementation if we could add superblocks into
current code.

Thanks,
Taka
