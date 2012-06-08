From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: different LUN numbers under the same dm device
Date: Fri, 08 Jun 2012 02:52:57 -0500
Message-ID: <4FD1AF59.3040101@cs.wisc.edu>
References: <8DCD6D08-35CE-48CC-AC54-7436265C32CB@purestorage.com>
	<20120606203507.GC16432@redhat.com>
	<A1C07741-D139-45F5-A877-A5E5DC792AD3@purestorage.com>
	<20120607223954.GC3211@ether.msp.redhat.com>
	<F6378CE3-200B-4AF4-97BC-B3A310231420@purestorage.com>
	<4FD1A2BF.2090109@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4FD1A2BF.2090109@suse.de>
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

On 06/08/2012 01:59 AM, Hannes Reinecke wrote:
> (Third mail on this topic .. I really should've read the entire
> thread before answering. But there you go.)
> 
> On 06/08/2012 01:26 AM, Brian Bunker wrote:
>> The answer is yes they did have that LUN NAA value that comes from page code 0x83 in inquiry.
>> Then the LUN was unmasked from that initiator. That initiator is
> holding on to those device
>> names in multipath. If you query them when they are in the state
> that I show in the
>> multipath -ll result, they will not return an NAA number at all in
> page code 0x83 or
>> a serial number in page code 0x80. They will instead return a PQ
> of 1 meaning that the
>> LUN is capable of supporting a peripheral device but is not currently.
>>
> Hehe.
> 
>> I understand about LUN's needing different NAA numbers and ours do, and we also have
>> different LUN serial numbers for each LUN on the target. An
> initiator doesn't always
>> have to access to all LUN's that it once did. It is the re-use of
> dm devices that
>> seems to cause this result.
>>
> No, rather a problem with the SCSI stack. multipath normally relies
> on udev to keep track of any device events, like LUNs coming and
> going. But this only works reliably if these events are triggered
> via the underlying transport, like FC RSCN et al.
> 
> 'Real' scsi events which will get transmitted via Sense codes are
> not evaluated further, sadly.
> 
> So short-term you are supposed to call 'rescan-scsi-bus.sh -r'
> whenever you made any LUN assigment changes on the array.
> Mid-term we already agreed on implementing some proper sense code
> handling in the SCSI midlayer.
> However, as usual in these cases, real life interfered and I've been
> busy with other things.
> But it's definitely on the agenda.
> 

I think this is a bug in multipath though. Even though we are not
handling sense that would indicate the path/device is not longer valid
(PQ changed values) if it was sent, it would make sense that when
multipath is assembling devices it would not create a device with
different NAA/UUID values. So multipath should not make a device that
includes sde, sdd, sdar and sdba but where sde and sdd have a different
UUID than sdar and sdba, right?

Brian, what is the device returning in this case for sde and sdd? Does
it return a error, or is it returning invalid data thinking the OS would
check the PQ value first? If it returns a error what is the sense, asc
and ascq?
