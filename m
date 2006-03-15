From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] New interface for dm-io to handle timed requests
Date: Wed, 15 Mar 2006 13:16:15 -0600
Message-ID: <441867FF.7090107@cs.wisc.edu>
References: <OFA18B9D5F.C030F341-ONC1257132.00548304-C1257132.005565B1@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OFA18B9D5F.C030F341-ONC1257132.00548304-C1257132.005565B1@de.ibm.com>
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

Stefan Bader wrote:
> dm-devel-bounces@redhat.com wrote on 14.03.2006 21:15:10:
> 
> 
>>Stefan Bader wrote:
>>
>>>The ideal solution would be to have an interface in the block layer 
> 
> that 
> 
>>>allows us to cancel any submitted requests. But since such a change 
> 
> will 
> 
>>>take quite a lot discussions and work, we want to emulate such a 
>>>behavior in the dm core for now.
>>>
>>
>>The scsi people and some block people have been talking about moving 
>>more error handling functionality into the block layer for a while and 
>>it is slowing moving that way. It could probably be done faster if 
>>people did not concentrate on one subsystem :)
>>
> 
> 
> It is not that much about error handling. More about policy. If the
> subsystem decides that io took enough time or maybe it just doesn't
> want to go on (could be a force umount...) it would be nice to be
> able to stop lower level drivers from doing error recovery. Thus
> the idea of stopping a submitted request.

Ah ok sorry, I think I call it error handling becuase if a command is 
running  on the disk or on the transport then for LLDs like scsi 
canceling the command is part of our error handling code. Sorry for the 
confusion.

But setting the limit for the command's running time can be moved to the 
block layer away from the llds and higher levels so we can all 
coordinate this. If the command times out the block layer can begin to 
cancel the command and call into the LLD (we would actually have to 
stack the cancel command callout like the request_fns or do the block 
request queue as message queue junk) to handle the lower level details 
of how to cancel it.

> 
> The changes to the core now shall fake this as long as there isn't
> such a functionality in the kernel with an interface that can handle
> this.
> 
> 
>>Maybe you should post to lkml and linux-scsi and get some responses from 
> 
> 
>>them before adding it to dm core. If a post already went out to those 
>>list my fault for missing it.
>>
> 
> No it didn't. I guess lkml is a good point. I am not sure about 
> linux-scsi.
> As it is not related specifically to scsi...
> 


Well, you need to convert linux-scsi and many people on the list have 
been thinking about how to do it so that is why I suggested it.
