From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [dm-devel] blk_abort_queue on failed paths?
Date: Fri, 5 Jun 2009 00:56:54 -0700
Message-ID: <20090605075654.GA3758@linux.vnet.ibm.com>
References: <448b15030906021555j4e476193kcf69e019992dc592@mail.gmail.com> <4A26ED7D.1010203@cs.wisc.edu> <4A280DDF.7070205@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A280DDF.7070205@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: dm-devel.ids

Mike Christie <michaelc@cs.wisc.edu> wrote:
> Mike Christie wrote:
>> adding linux-scsi and Mike Anderson
>>
>> David Strand wrote:
>>> After updating to kernel 2.6.28 I found that when I performed some
>>> cable break testing during device i/o, I would get unwanted device or
>>> host resets. Ultimately I traced it back to this patch:
>>>
 
>>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=224cb3e981f1b2f9f93dbd49eaef505d17d894c2 
>>> 
>>>
>>>
>>> The call to blk_abort_queue causes the block layer to call
>>> scsi_times_out for pending i/o, which can (or will) ultimately lead to
>>> device, and/or bus and/or host resets, which of course cause all the
>>> other devices significant disruption.
>>>
>>
>> What driver were you using? 
>
> Oh yeah, I do not think this should happen in new kernels if the driver  
> is failing the IO with DID_TRANSPORT_DISRUPTED when it is deleting the  
> rport. That should cause the IO to requeue and wait for fast io fail to  
> fire.
>
> Maybe we just need to convert some more drivers?

Yes, I am seeing this in my test runs using a DS4K storage device and the
RDAC device handler.
"Jun  5 00:39:58 elm3c244 kernel: [  873.180267] sd 1:0:0:1: [sdd] Result:
hostbyte=DID_TRANSPORT_DISRUPTED driverbyte=DRIVER_OK"

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
