From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
 filesystems, and dm/md.
Date: Thu, 31 May 2007 08:28:02 -0400
Message-ID: <465EBF52.5010204@tmr.com>
References: <18006.38689.818186.221707@notabene.brown>	<465AEAA5.7000407@tmr.com>
	<18014.6347.753050.606896@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <18014.6347.753050.606896@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

Neil Brown wrote:
> On Monday May 28, davidsen@tmr.com wrote:
>   
>> There are two things I'm not sure you covered.
>>
>> First, disks which don't support flush but do have a "cache dirty" 
>> status bit you can poll at times like shutdown. If there are no drivers 
>> which support these, it can be ignored.
>>     
>
> There are really devices like that?  So to implement a flush, you have
> to stop sending writes and wait and poll - maybe poll every
> millisecond?
>   

Yes, there really are (or were). But I don't think that there are 
drivers, so it's not an issue.
> That wouldn't be very good for performance....  maybe you just
> wouldn't bother with barriers on that sort of device?
>   

That is why there are no drivers...
> Which reminds me:  What is the best way to turn off barriers?
> Several filesystems have "-o nobarriers" or "-o barriers=0",
> or the inverse.
>   

If they can function usefully without, the admin gets to make that choice.
> md/raid currently uses barriers to write metadata, and there is no
> way to turn that off.  I'm beginning to wonder if that is best.
>   

I don't see how you can have reliable operation without it, particularly 
WRT bitmap.
> Maybe barrier support should be a function of the device.  i.e. the
> filesystem or whatever always sends barrier requests where it thinks
> it is appropriate, and the block device tries to honour them to the
> best of its ability, but if you run
>    blockdev --enforce-barriers=no /dev/sda
> then you lose some reliability guarantees, but gain some throughput (a
> bit like the 'async' export option for nfsd).
>
>   
Since this is device dependent, it really should be in the device 
driver, and requests should have status of success, failure, or feature 
unavailability.


>> Second, NAS (including nbd?). Is there enough information to handle this  "really right?"
>>     
>
> NAS means lots of things, including NFS and CIFS where this doesn't
> apply.
>   

Well, we're really talking about network attached devices rather than 
network filesystems. I guess people do lump them together.

> For 'nbd', it is entirely up to the protocol.  If the protocol allows
> a barrier flag to be sent to the server, then barriers should just
> work.  If it doesn't, then either the server disables write-back
> caching, or flushes every request, or you lose all barrier
> guarantees. 
>   

Pretty much agrees with what I said above, it's at a level closer to the 
device, and status should come back from the physical i/o request.
> For 'iscsi', I guess it works just the same as SCSI...
>   

Hopefully.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979
