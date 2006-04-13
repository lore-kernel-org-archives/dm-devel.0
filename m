From: Abhishek Gupta <agupta@cs.ubc.ca>
Subject: Re: Synchronizing writes between kernel space and user
	space.
Date: Wed, 12 Apr 2006 18:07:03 -0700 (PDT)
Message-ID: <Pine.GSO.4.60.0604121753180.22940@cascade.cs.ubc.ca>
References: <Pine.GSO.4.60.0604121711320.22940@cascade.cs.ubc.ca>
	<200604121950.15246.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200604121950.15246.kevcorry@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kevin Corry <kevcorry@us.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

First of all apologies but since this was an I/O problem, I thought that 
some of you might have come across it before.

I am writing an extension of the device mapper which supports recursive 
snapshots. The idea is to use a radix tree for logical to physical address 
translations and make a read-only copy of the root while taking snapshots. 
Now a crazy thing I have been trying is allocating blocks on 
demand and for that my module consults a bitmap kept aside for the entire 
disk. I was thinking of pushing volume deletion and creation to user 
space which will result in bitmap updates from the user space. So, the 
problem now is that what functions would allow my module to safely lock 
up 
the buffers holding the bitmap during block allocation.

I tried lock_page()/unlock_page() and that worked but I felt that it is 
too coarse grained for smaller sized buffers.

I am sorry if some of you find it irrelevant to the dm-devel community. 
All I am seeking is expert advice.

Thanks

Abhishek

On Wed, 12 Apr 2006, Kevin Corry wrote:

> Date: Wed, 12 Apr 2006 19:50:15 -0500
> From: Kevin Corry <kevcorry@us.ibm.com>
> To: dm-devel@redhat.com
> Cc: Abhishek Gupta <agupta@cs.ubc.ca>
> Subject: Re: [dm-devel] Synchronizing writes between kernel space and user
>     space.
> 
> On Wed April 12 2006 7:16 pm, Abhishek Gupta wrote:
>> Can anyone tell me the synchronization calls to be used if writes
>> to a device are being done from both user space and kernel space. I
>> noticed that lock_page()/unlock_page() is one set of functions that
>> can be used. Obviously, this is too coarse grained, if buffers are smaller
>> than the page size. The functions lock_buffer()/unlock_buffer() do not
>> seem to do the trick.
>
> What do you mean by doing writes from both user space and kernel space? Is
> there something in particular you're trying to synchronize?
>
> This question doesn't seem specific to device-mapper. I'd suggest posting this
> on lkml to get a wider range of responses.
>
> --
> Kevin Corry
> kevcorry@us.ibm.com
> http://www.ibm.com/linux/
> http://evms.sourceforge.net/
>
