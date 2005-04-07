From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: pre8
Date: Thu, 07 Apr 2005 00:30:04 -0700
Message-ID: <4254E17C.1030900@us.ibm.com>
References: <20050405213223.GJ9049@agk.surrey.redhat.com>	<20050406063240.GC12408@averon.dyndns.org>	<4254082E.1010101@us.ibm.com>
	<1112812815.8118.156.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1112812815.8118.156.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

christophe varoqui wrote:
> On mer, 2005-04-06 at 09:02 -0700, Mike Christie wrote:
> 
>>Christophe Varoqui wrote:
>>
>>>On Tue, Apr 05, 2005 at 10:32:23PM +0100, Alasdair G Kergon wrote:
>>>
>>>
>>>>I appear to have almost succeeded in squeezing 0.4.4-pre8 into 
>>>>RHEL4 U1, but I doubt I'll be allowed any more updates now except 
>>>>for severe bugs.
>>>>
>>>
>>>Just to let you you know what I think is still needed before 0.4.4 :
>>>
>>>o memory allocation error paths audit (mostly done in pre9)
>>
>>The pathcheckers use sgio, right? The block layer sg io code does some 
>>allocations with GFP_KERNEL (bio_copy_user and bio_map_user for 
>>example), so if you are relying on that path for failback I think you 
>>will be in trouble.
>>
> 
> Indeed.
> Do you have suggestions to work around this issue ?
> 

For the bio allocation couldn't they just be made to do atomic 
allocations or ones that wait but do not cause IO (__GFP_WAIT/GFP_NOIO?)?

The other allocations could be made to not use GFP_KERNEL too, but they 
of course do not have mempools like the bios so there would still be 
that problem. At least we are not going to block on a write to the same 
disk we are trying to failback though.

Instead, what if the daemon that drives the path testing stays in the 
kernel, but the component that sends the command was in a dm-multipath 
module? We would never need more than one command per queue for testing 
outstanding, so if there was a path testing handler in the kernel the 
daemon would instruct that handler to send off its command. The testing 
handler would just have a command and other resources preallocated or 
use the kernel's preallocated resources, like using blk_get_request 
which uses the queue's mempool, when it could. And then it would just 
insert the command like the hw_handlers do - the preallocation is like 
the hw_handlers too. Maybe at that point though people would just 
consider putting the whole thing in the kernel since my idea seems like 
a hack to bypass the sg io paths instead of fixing them (or maybe the sg 
io paths were not supposed to be used for failback and failover?).

For iscsi I had begun to make a tester that just writes to a transport 
class sysfs file (another allocation :) I know, but it does not have to 
be sysfs - it is just what everyone happened to be using at the time), 
which in turn instructs the driver to send a iscsi ping. This is similar 
to above.


> Regards,
