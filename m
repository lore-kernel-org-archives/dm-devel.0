From: David Huffman <dm-devel@storix.com>
Subject: Re: Determine partition prefix used for mpath devices
Date: Wed, 24 Mar 2010 11:31:11 -0700
Message-ID: <4BAA5A6F.6020300@storix.com>
References: <4BA8EAD3.2050009@storix.com> <4BAA38DA.7050107@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BAA38DA.7050107@suse.de>
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

Hannes Reinecke wrote:
> David Huffman wrote:
>   
>> Hannes Reinecke wrote:
>>     
>>> David Huffman wrote:
>>>  
>>>       
>>>> In a script, I need to somehow determine what prefix is being used for
>>>> partitions as set by UDEV. It seems that the naming convention is in
>>>> flux and could change frequently. When using user_friendly_names the
>>>> prefix is set using kpartx within udev rules. My problem is I need to
>>>> know what the prefix is so my scripts know what device naming convention
>>>> to look for.
>>>>
>>>> Here are the different iterations of naming schemes:
>>>>
>>>> mpath0p1
>>>> mpath0-part1
>>>> mpathap1
>>>> mpatha-part1
>>>>
>>>> Is there a way other than grepping through the udev rules to determine
>>>> what the prefix is? The partitions may not exist so I cannot just look
>>>> to see what they are. I need to know BEFORE I create partitions. I know
>>>> this is a strange request, but I am working with a lot of code that was
>>>> designed before multipath was available and using the sys naming is not
>>>> an option (i.e. /disk/by-id/wwid).
>>>>
>>>>     
>>>>         
>>> I wouldn't rely on the device-mapper table names, as they could be pretty
>>> much everything.
>>>
>>> To handle this situation I've patches up multipath and kpartx to provide
>>> UUID prefixes, which normally can't be influenced from userspace.
>>> Multipath devices carry the prefix 'mpath-', kpartx generated devices
>>> carry the prefix 'part<num>-'.
>>> So by checking the prefix you pretty much know which program generated
>>> this particular device.
>>>
>>> Cheers,
>>>
>>> Hannes
>>>   
>>>       
>> Humm.. Maybe I did not explain myself well enough because I do not
>> understand your response. I am trying to determine what prefix is
>> currently being used for the partitions by kpartx.
>>
>> Example:
>> If I am on a SLES9 SP4 system there is a udev rule that states to use
>> kpartx -a -p -part so that the prefix is "-part". Partitions that are
>> created later are named [alias|mpath|uuid]a-part1.
>> If I am on a RHEL 5.1 system, there is a udev rule that states to use
>> kpartx -a -p p so that the prefix is "p".
>> Partitions that are created later are named [alias|uuid|mpath]0p1
>>
>> Right now, the only way I can find out what prefix is used for
>> partitions is to grep and awk through the udev rule (which is
>> unreliable). I am looking for a better way to see what prefix is
>> currently being used by kpartx.
>>
>>     
> Ah. Leads to the question: Why?
> What's the whole point of the exercise?
>   
I am working on scripts that query disk and partition information that 
is later used to recreate the devices during system recovery. To 
determine if a device is supported, I have a list of "known" naming 
schemes to look for. For example sd[a-z][a-z][1-15]. The user is 
required to use "user_friendly_names" in multipath.conf. This reduces 
the naming schemes to something a bit more more predictable.

When the partition is created, I need to be able to "find" that 
partition. Otherwise, it ignores devices that are unknown/unsupported 
(such as powerpath devices). The original system might have used 
internal scsi disks, but the restored system could be using mpath 
devices. This prevents me from relying on what was used before. At the 
time I am creating a partition table, I may know the disk name, but the 
partition names could be different.  Because this is used in customer 
environments, we do not want to force them to re-write their udev rules 
to use a specific partition prefix with kpartx. It's bad enough we 
enforce "user_friendly_names".

I am working with legacy code that is not easily changed (supporting 
systems back to 2.4 kernels). This is all happening in a minimal 
environment much like an initrd and needs to be non-interactive.
>   
>> When you state that you have a patch to provide UUID prefixes, I do not
>> understand. If you are not using "user_friendly_names yes" in
>> multipath.conf, isn't it already the uuid? How does this change the
>> naming of the partitions used? Right now it could be "-part" or "p".
>>
>>     
> Nothing to do with multipath.
>
> If you do a 'dmsetup info' you'll see something like:
> Name:              3600508b40008ddd70000500000250000
> State:             ACTIVE
> Read Ahead:        1024
> Tables present:    LIVE
> Open count:        1
> Event number:      19
> Major, minor:      253, 11
> Number of targets: 1
> UUID: mpath-3600508b40008ddd70000500000250000
>
> The last line is the UUID I'm talking about.
>
>   
This may come in handy to not force "user_friendly_names" in the future. 
As long as there is SOMETHING that I can use to determine if a device is 
a multipath device.
>> Sorry but my limited knowledge of the naming schemes is probably
>> confusing the issue. It appears that there are too many players on the
>> field when it comes to naming these devices. (UDEV, multipath,
>> device-mapper)
>>
>>     
> Again, what do you need it for?
> The whole exercise is already quite cumbersome if
> you have only _one_ device-mapper device for a partition;
> however, nothing prevents you on calling kpartx (or
> some other tools) again with a different prefix
> and hence a different name.
>   
> So you'll end up with several device-mapper tables
> with identical definitions but different names.
> Which one will you pick then?
>
> Cheers,
>
> Hannes
>   
I am just trying to pick the one that is used by default by udev. If 
there are multiple udev rules that contradict each other, then I guess I 
can address that. However, I have not seen any distros that do this by 
default and the majority of users will never do that. I have to first 
address the inconsistencies between distros on what partition prefix is 
used. So to sum it up, if I am going to create a partition on an mpath 
device, is there a way (other than grepping through udev rules) to 
determine what prefix will be used? That way I can add that to my 
"known" list of naming schemes so I do not ignore the device.

Thanks,
David
