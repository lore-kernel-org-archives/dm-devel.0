From: Brian Bunker <brian@purestorage.com>
Subject: Re: different LUN numbers under the same dm device
Date: Thu, 7 Jun 2012 16:26:35 -0700
Message-ID: <F6378CE3-200B-4AF4-97BC-B3A310231420@purestorage.com>
References: <8DCD6D08-35CE-48CC-AC54-7436265C32CB@purestorage.com>
	<20120606203507.GC16432@redhat.com>
	<A1C07741-D139-45F5-A877-A5E5DC792AD3@purestorage.com>
	<20120607223954.GC3211@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120607223954.GC3211@ether.msp.redhat.com>
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
List-Id: dm-devel.ids

The answer is yes they did have that LUN NAA value that comes from page code 0x83 in inquiry. Then the LUN was unmasked from that initiator. That initiator is holding on to those device names in multipath. If you query them when they are in the state that I show in the multipath -ll result, they will not return an NAA number at all in page code 0x83 or a serial number in page code 0x80. They will instead return a PQ of 1 meaning that the LUN is capable of supporting a peripheral device but is not currently.

I understand about LUN's needing different NAA numbers and ours do, and we also have different LUN serial numbers for each LUN on the target. An initiator doesn't alway have to access to all LUN's that it once did. It is the re-use of dm devices that seems to cause this result.

Thanks,
Brian

On Jun 7, 2012, at 3:39 PM, Benjamin Marzinski wrote:

> On Wed, Jun 06, 2012 at 01:59:02PM -0700, Brian Bunker wrote:
>> Mike,
>> 
>> The devices for LUN 12 are failed and correspond to LUN's not currently shared to the initiator at all. They were at one point and were likely used by dm-11 for its underlying paths. The inquiry data of those LUN's when the problem happened was like this:
>> 
>> [root@r13init32 ~]# sg_inq /dev/sde
>> standard INQUIRY: [qualifier indicates no connected LU]
>>  PQual=1  Device_type=31  RMB=0  version=0x06  [SPC-4]
>>  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
>>  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  BQue=0
>>  EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>>  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
>>  [SPI: Clocking=0x0  QAS=0  IUS=0]
>>    length=96 (0x60)   Peripheral device type: no physical device on this lu
>> Vendor identification: PURE    
>> Product identification: FlashArray      
>> Product revision level: 100 
>> 
>> There is no NAA number, page code 0x83 or LUN serial number available, page code 0x80 since there is no LUN 12 attached as a disk device at the time multipath -ll was run. Different LUN's from our array would ever have the same NAA value, what I think you are calling UUID. 
>> 
>> The sequence is something like share a LUN from the array with two paths to the initiator, a dm device gets created presumably like this at first (except that the status would be active and ready and not failed and faulty:
>> 
>>  3624a93700a14254d729923840001000b dm-11 PURE,FlashArray
>>  size=500G features='0' hwhandler='0' wp=rw
>>   `-+- policy='round-robin 0' prio=1 status=active
>>   |- 1:0:0:12 sde  8:64   failed faulty running
>>   |- 0:0:0:12 sdd  8:48   failed faulty running
>> 
>> Then that LUN 12 is taken away from the initiator and the dm device dm-11 is reused later by LUN 10 when it is shared to the initiator, but the LUN 12 devices still remain as part of the dm device. Then I would expect:
>> 
>> 3624a93700a14254d729923840001000b dm-11 PURE,FlashArray
>> size=500G features='0' hwhandler='0' wp=rw
>> `-+- policy='round-robin 0' prio=1 status=active
>>   |- 0:0:0:10 sdar 66:176 active ready  running
>>   !- 1:0:0:10 sdba 67:64  active ready  running
>> 
>> Thanks,
>> Brian
> 
> So, did sde and sdd (the paths for the multipath device for LUN 12)
> originally have the wwid of 3624a93700a14254d729923840001000b.  Do
> sdar and sdba actually have the wwid of
> 3624a93700a14254d729923840001000b.  You can check this by running
> 
> # scsi_id --whitelisted --device=<devname>
> 
> for example
> 
> # scsi_id --whitelisted --device=/dev/sde
> 
> If all of these scsi devices return the same value, then multipath
> has no way of knowing that they don't belong together. If not, I'd
> like to know which devices don't really have that UUID.
> 
> -Ben
> 
>> 
>> On Jun 6, 2012, at 1:35 PM, Mike Snitzer wrote:
>> 
>>> On Wed, Jun 06 2012 at  3:27pm -0400,
>>> Brian Bunker <brian@purestorage.com> wrote:
>>> 
>>>> Our company produces a multiple port Fibre Channel storage array. We
>>>> are continually plagued by this problem. We get a dm device which
>>>> combines paths for different LUN's. We would like to understand why
>>>> this is happening. Wouldn't this problem almost certainly lead to a
>>>> data corruption?
>>>> 
>>>> Thanks,
>>>> Brian
>>>> 
>>>> 3624a93700a14254d729923840001000b dm-11 PURE,FlashArray
>>>> size=500G features='0' hwhandler='0' wp=rw
>>>> `-+- policy='round-robin 0' prio=1 status=active
>>>> |- 1:0:0:12 sde  8:64   failed faulty running
>>>> |- 0:0:0:12 sdd  8:48   failed faulty running
>>>> |- 0:0:0:10 sdar 66:176 active ready  running
>>>> `- 1:0:0:10 sdba 67:64  active ready  running
>>>> 
>>>> Of the 4 paths to dm-11, we can see two paths are for LUN 10 and the
>>>> other two are for LUN 12. We have 24 other dm devices which have only
>>>> the expected 2 paths.
>>> 
>>> Multipath considers all LUNs with the same UUID to be the same LUN.
>>> 
>>> So you should first try to understand why all of these paths were held
>>> to have the same UUID (3624a93700a14254d729923840001000b).
>> 
>> Brian Bunker
>> brian@purestorage.com
>> 
>> 
>> 
>> 
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Brian Bunker
brian@purestorage.com
