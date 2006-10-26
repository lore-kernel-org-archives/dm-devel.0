From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: [RFC] Change to the mirror table map
Date: Thu, 26 Oct 2006 11:35:26 -0500
Message-ID: <bb75a9150126238f861887620df81322@redhat.com>
References: <1161291378.26135.3.camel@hydrogen.msp.redhat.com>
	<20061024093047.GB4792@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061024093047.GB4792@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mauelshagen@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com
List-Id: dm-devel.ids

I've been giving this more thought, and trying to code up a proof of  
concept.  It hasn't been going as well as I'd like, and I could use  
some more input.

Coding up the constructor is pretty easy for virtually any scenario we  
might imagine.  The evolving ideas below make sense in that we can  
simply pass on the sections to functions and don't have to rework the  
interfaces for the log constructor or path selection constructor.   
However, things start to break down when we look at the "status"  
function.  When we print the "STATUSTYPE_TABLE", it should produce  
information in the same form as the mapping table.  Currently, the log  
and path selection modules print their own portions of that information  
- into a string that is shared with the parent (mirror in this case).   
That hurts our ability to specify the number of arguments for a  
particular section, and destroys the ability to interleave sections  
(e.g. 'devices 7 2 253:3 0 rr_min=1000 253:4 0 rr_min=1000')

We could remember the mapping table string and simply print that out -  
bypassing the submodules.  Or, we could alter the submodules in some  
way.  (Perhaps adding a function like "status_args" that would tell us  
ahead of time how many arguments there are - allowing us to write "log  
<#log_args>" before calling log_status.)

While we are thinking about this, I'd like to also include the  
'features' idea into the mirror mapping table.  For example: 'features  
<#feature args> <features>', where <features> might be 'handle_errors'  
and 'allow_io_delay 120'.

Right now, I'm leaning toward adding the additional function  
"status_args" and adding the 'features' section as a new section.

Thoughts/advice are welcome,
  brassow

On Oct 24, 2006, at 4:30 AM, Heinz Mauelshagen wrote:

> On Thu, Oct 19, 2006 at 03:56:18PM -0500, Jonathan Brassow wrote:
>> The impetus for this was the desire to add read balancing to mirroring
>> and have it share code with multipath.
>
> Makes sense.
>
>>
>>  brassow
>>
>> ORIGINAL:
>> <start> <length> mirror \
>> <log_type> <#log_params> <log_params> \
>> <#mirrors> <device1> <offset1> ... <deviceN> <offsetN>
>>
>> Example:
>> 0 1024000 mirror \
>> disk 3 253:2 1024 block_on_error \
>> 2 253:3 0 253:4 0
>>
>>
>> MODIFIED:
>>                           [-------- logging section ---------] [-  
>> mirror devices section -] [--------------- read balancing section  
>> -------------]
>> 0 71014400 mirror format2 log 4 disk 253:2 1024 block_on_error  
>> devices 2 1 253:3 S 253:4 A  read-balance 8 round-robin 0 2 1 253:3  
>> 1000 253:4 1000
>> ^    ^       ^       ^     ^  ^  ^   <^^^^^^^^^^^^^^^^^^^^^^^>    ^    
>>  ^ ^   ^   ^              ^       ^  
>> <^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^>
>> |    |       |       |     |  |  |   |                            |    
>>  | |   |   |              |       | |
>> |    |       |       |     |  |  |   |                            |    
>>  | |   |   |              |       | same as multipath
>> |    |       |       |     |  |  |   |                            |    
>>  | |   |   |              |       # read-balance args
>> |    |       |       |     |  |  |   |                            |    
>>  | |   |   |              read-balance section indicator
>> |    |       |       |     |  |  |   |                            |    
>>  | |   |   Device status (slave/active/dead)
>> |    |       |       |     |  |  |   |                            |    
>>  | |   Device
>> |    |       |       |     |  |  |   |                            |    
>>  | # of device args
>> |    |       |       |     |  |  |   |                            |    
>>  # of devices
>> |    |       |       |     |  |  |   |                             
>> device section indicator
>> |    |       |       |     |  |  |   log type specific args
>> |    |       |       |     |  |  log type
>> |    |       |       |     |  # of log args
>> |    |       |       |     log section indicator
>> |    |       |       target table format
>> |    |       target name
>> |    target length in 512-byte blocks
>> starting offset of target
>>
>> New features:
>> ====================================================================== 
>> ==========
>> I've added a format argument ("format2" in example).  It is always  
>> the first
>> argument to the mirror target.  If it isn't present, we can assume  
>> the original
>> format.  If it is present, we can use the format specified.
>
> Makes sense for backward compatibility and makes parsing easy.
>
>>
>> The mapping table is broken up into sections.  The sections are  
>> allowed to be
>> in any order, and we should be able to add sections in the future if
>> necessary.
>>
>> The logging section starts with the keyword 'log' and is followed by  
>> the number
>> of log arguments.  No changes to the dm_create_dirty_log function  
>> should be
>> necessary.
>
> Again an advantage for parsing.
>
>>
>> The devices section starts with the keyword 'devices' and is followed  
>> by the
>> number of devices then the number of per device arguments.  This is  
>> not
>> consistent with the other sections.  It may be better to have the  
>> keyword
>> followed by the argument count, followed by the per device argument  
>> count.
>> Something like:
>>     devices 5 1 253:3 S 253:4 A
>> or
>>     devices 5 2 253:3 S 253:4 A
>> depending on if you want to include the device in the per device  
>> argument
>> count.  Notice that I have done away with the 'offset' parameter  
>> found in
>> the original.
>
> Keep it: we need it to easier support things like lvm pvmove and for  
> metadata
> at the beginning of the mapped devices.
>
>> Multipath doesn't have that, and neither does mirroring
>> when specifying the log device.  For the above example, I did add an
>> additional per device parameter to specify the status of a device.  I  
>> was
>> imagining a scenario where IBM's slave context might be specified, or
>> a new mirror device is added to the set.  With the indicator, you  
>> could
>> tell which devices were in-sync, and which ones needed recovery.
>> (Perhaps that is better left to an additional section, since it is not
>> yet known how this functionality would be added.)
>
> Yes, we can have a device-properties or domething section after the  
> devices
> one once that hash been sorted.
>
>>
>> The read balancing section starts with the keyword 'read-balance' and  
>> is
>> followed by the number of read balancing arguments.  After that, it is
>> just like multipathing.  If we were certain that the devices section  
>> did
>> not need any device specific arguments, we could combine the devices  
>> section
>> and the read-balance section.  (This could be the case if we decided  
>> to
>> add a section for initial device status and didn't need the offset  
>> argument.)
>> Mirror does need to keep it's own list of devices, however; and it  
>> might be
>> nice to be able to parse that section separate - rather than parse the
>> read-balancing section twice.
>>
>> Multipath takes the approach of having positional arguments (e.g. the  
>> 'number
>> of features' argument is in a known place).  If we took this  
>> approach, we
>> could eliminate the keywords.  However, I think I prefer the ability  
>> to
>> identify sections.
>
> I agree. Much more flexible for enhancements and for the ease of  
> parsing.
>
> Heinz
>
>>
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
> =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 
> =-=-=-=-
>
> Heinz Mauelshagen                                 Red Hat GmbH
> Consulting Development Engineer                   Am Sonnenhang 11
> Storage Development                               56242 Marienrachdorf
>                                                   Germany
> Mauelshagen@RedHat.com                            PHONE +49  171  
> 7803392
>                                                   FAX   +49 2626 924446
> =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 
> =-=-=-=-
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
