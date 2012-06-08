From: Brian Bunker <brian@purestorage.com>
Subject: Re: different LUN numbers under the same dm device
Date: Fri, 8 Jun 2012 09:35:53 -0700
Message-ID: <F9D694F1-5E66-4B09-AF2B-DA2F56CAC492@purestorage.com>
References: <8DCD6D08-35CE-48CC-AC54-7436265C32CB@purestorage.com>
	<20120606203507.GC16432@redhat.com>
	<A1C07741-D139-45F5-A877-A5E5DC792AD3@purestorage.com>
	<20120607223954.GC3211@ether.msp.redhat.com>
	<F6378CE3-200B-4AF4-97BC-B3A310231420@purestorage.com>
	<4FD1A2BF.2090109@suse.de> <4FD1AF59.3040101@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4FD1AF59.3040101@cs.wisc.edu>
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

Mike,

Here is what is returned by the device when it is available meaning that the LUN is available to the initiator. I am giving you the VPD page code 0x83 since I believe that is what multipath is using. If you want the output of something else let me know. It is trivial to get:

[root@vminirhl61 ~]# sg_inq /dev/sg0
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  version=0x06  [SPC-4]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
  SCCS=1  ACC=0  TPGS=1  3PC=0  Protect=0  BQue=0
  EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=96 (0x60)   Peripheral device type: disk
 Vendor identification: PURE    
 Product identification: FlashArray      
 Product revision level: 100 
 Unit serial number: 436FC2124DA7883E00010003

[root@vminirhl61 ~]# sg_inq -p 0x83 /dev/sg0
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 20
    designator_type: NAA,  code_set: Binary
    associated with the addressed logical unit
      NAA 6, IEEE Company_id: 0x24a937
      Vendor Specific Identifier: 0x436fc212
      Vendor Specific Identifier Extension: 0x4da7883e00010003
      [0x624a9370436fc2124da7883e00010003]
  Designation descriptor number 2, descriptor length: 47
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: PURE    
      vendor specific: FlashArray:436FC2124DA7883E00010003
  Designation descriptor number 3, descriptor length: 8
    transport: Fibre Channel (FCP-2)
    designator_type: Relative target port,  code_set: Binary
    associated with the target port
      Relative target port: 0x3
  Designation descriptor number 4, descriptor length: 8
    transport: Fibre Channel (FCP-2)
    designator_type: Target port group,  code_set: Binary
    associated with the target port
      Target port group: 0x0
  Designation descriptor number 5, descriptor length: 8
    designator_type: Logical unit group,  code_set: Binary
    associated with the addressed logical unit
      Logical unit group: 0x0
  Designation descriptor number 6, descriptor length: 36
    transport: Fibre Channel (FCP-2)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target port
      SCSI name string:
      naa.21000024ff229d7a,t,0x0001

When I go and take away access to this LUN from the initiator the inquiry becomes:
[root@vminirhl61 ~]# sg_inq /dev/sg0
standard INQUIRY: [qualifier indicates no connected lu]
  PQual=1  Device_type=31  RMB=0  version=0x06  [SPC-4]
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  BQue=0
  EncServ=0  MultiP=1 (VS=0)  [MChngr=0]  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
  [SPI: Clocking=0x0  QAS=0  IUS=0]
    length=96 (0x60)   Peripheral device type: no physical device on this lu
 Vendor identification: PURE    
 Product identification: FlashArray      
 Product revision level: 100

[root@vminirhl61 ~]# sg_inq -p 0x83 /dev/sg0
VPD INQUIRY: Device Identification page
  Designation descriptor number 1, descriptor length: 12
    designator_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: PURE    
  Designation descriptor number 2, descriptor length: 8
    transport: Fibre Channel (FCP-2)
    designator_type: Relative target port,  code_set: Binary
    associated with the target port
      Relative target port: 0x4
  Designation descriptor number 3, descriptor length: 36
    transport: Fibre Channel (FCP-2)
    designator_type: SCSI name string,  code_set: UTF-8
    associated with the target port
      SCSI name string:
      naa.21000024ff229d7a,t,0x0001

If you try to access this LUN when it doesn't have access permissions you will get the following SCSI error:

sd 3:0:0:2: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 3:0:0:2: [sdf] Sense Key : Illegal Request [current] 
sd 3:0:0:2: [sdf] Add. Sense: Logical unit not supported
sd 3:0:0:2: [sdf] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sdf, sector 0

As far as the NAA number for different LUN's, we have the requirement that each LUN on our array has a different NAA number as you would expect. How those LUN's are presented to the host however there is no such restriction. For example, you could present the array's LUN 1 masked as LUN 10 to the initiator and then later masked that same LUN to the initiator as LUN 12 or any other number. In that case LUN 10 and later LUN 12 would have the same NAA number since they are in fact talking to the same actual LUN on the array. This is what I think multipath is having trouble with.

Hopefully that helps.

Thanks,
Brian

On Jun 8, 2012, at 12:52 AM, Mike Christie wrote:

> On 06/08/2012 01:59 AM, Hannes Reinecke wrote:
>> (Third mail on this topic .. I really should've read the entire
>> thread before answering. But there you go.)
>> 
>> On 06/08/2012 01:26 AM, Brian Bunker wrote:
>>> The answer is yes they did have that LUN NAA value that comes from page code 0x83 in inquiry.
>>> Then the LUN was unmasked from that initiator. That initiator is
>> holding on to those device
>>> names in multipath. If you query them when they are in the state
>> that I show in the
>>> multipath -ll result, they will not return an NAA number at all in
>> page code 0x83 or
>>> a serial number in page code 0x80. They will instead return a PQ
>> of 1 meaning that the
>>> LUN is capable of supporting a peripheral device but is not currently.
>>> 
>> Hehe.
>> 
>>> I understand about LUN's needing different NAA numbers and ours do, and we also have
>>> different LUN serial numbers for each LUN on the target. An
>> initiator doesn't always
>>> have to access to all LUN's that it once did. It is the re-use of
>> dm devices that
>>> seems to cause this result.
>>> 
>> No, rather a problem with the SCSI stack. multipath normally relies
>> on udev to keep track of any device events, like LUNs coming and
>> going. But this only works reliably if these events are triggered
>> via the underlying transport, like FC RSCN et al.
>> 
>> 'Real' scsi events which will get transmitted via Sense codes are
>> not evaluated further, sadly.
>> 
>> So short-term you are supposed to call 'rescan-scsi-bus.sh -r'
>> whenever you made any LUN assigment changes on the array.
>> Mid-term we already agreed on implementing some proper sense code
>> handling in the SCSI midlayer.
>> However, as usual in these cases, real life interfered and I've been
>> busy with other things.
>> But it's definitely on the agenda.
>> 
> 
> I think this is a bug in multipath though. Even though we are not
> handling sense that would indicate the path/device is not longer valid
> (PQ changed values) if it was sent, it would make sense that when
> multipath is assembling devices it would not create a device with
> different NAA/UUID values. So multipath should not make a device that
> includes sde, sdd, sdar and sdba but where sde and sdd have a different
> UUID than sdar and sdba, right?
> 
> Brian, what is the device returning in this case for sde and sdd? Does
> it return a error, or is it returning invalid data thinking the OS would
> check the PQ value first? If it returns a error what is the sense, asc
> and ascq?
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

Brian Bunker
brian@purestorage.com
