From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Device-mapper target driver for Write tracking
Date: Wed, 19 Oct 2016 16:48:20 +0200
Message-ID: <ae2760e6-e9cf-8f87-4318-d6cab62990ce@redhat.com>
References: <20161019105354.GA17598@sirius.lan>
	<889366e1-8432-658d-2582-4c7aa7a07dea@redhat.com>
	<20161019142034.GA19799@sirius.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161019142034.GA19799@sirius.lan>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, info@xp8.de
List-Id: dm-devel.ids

Dne 19.10.2016 v 16:20 Daniel Armbruster napsal(a):
> On 13:43 Wed 19 Oct     , Zdenek Kabelac wrote:
>> Dne 19.10.2016 v 12:53 Daniel Armbruster napsal(a):
>>> Hi List,
>>>
>>> I'm looking for a device-mapper target driver giving me the possibility to
>>> track/log WRITE requests. The idea is to track those WRITE requests within a
>>> Bitmap e.g. 1:LV-EXTEND (for LVM2). I read already the device-mapper
>>> documentation under
>>>
>>> https://www.kernel.org/doc/Documentation/device-mapper/
>>>
>>> but didn't find an appropriate module which would suite my needs.
>>>
>>> Is there any work happening on this to leverage? Any kind of help is
>>> appreciated.
>>>
>>> Many thanks in advance.
>>
>>
>> Hi
>>
>>
>> Not exactly sure what you are trying to do but 2 things to look at:
>>
>> Maybe  'dmstats' with it's region logic may cover your 'wanted' operation.
>>
>> The kernel dm target to check would be  'era' which keeps trace
>> of written blocks.
>>
>> Regards
>>
>> Zdenek
>>
>>
>>
> Hi Zdenek,
>
> thanks for your help.
>
> I'm trying to implement a synchronization tool which performs backups in an
> intelligent way. Since using a snapshot is only partly an option (the snapshot
> could fill up and the snapshot_autoextend_* practicality of LVM2 isn't stable
> enough under heavy load) I was thinking about the possibility of an additional
> device which keeps trace of written blocks. To improve performance I aim at
> reducing the data throughput. That's why I was thinking about a Bitmap e.g.
> 1:LV-EXTEND.
>

Hi

Old snapshot is OLD - switch to thin-provisioning - that's the real fix for
your problem.

Less nice suggest could be to simply use BIG enough snapshot you can't fulfill 
before it gets resized -  computable from disk write speed.
Clearly you can't win this fight with few MB sized snapshot -
few GB solves it...

> I thought already about the DM statistics module. Is there any performance
> impact when collecting statistics for a given volume (except of the
> additionally allocated memory used)? Is there a possibility to quantify it?

I'm afraid you will need to measure yourself - depends on huge number of 
settings - but should be still very small compared with rotational drives.

Regards

Zdenek
