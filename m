From: David Huffman <dm-devel@storix.com>
Subject: Determine partition prefix used for mpath devices
Date: Tue, 23 Mar 2010 09:22:43 -0700
Message-ID: <4BA8EAD3.2050009@storix.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
>> In a script, I need to somehow determine what prefix is being used for
>> partitions as set by UDEV. It seems that the naming convention is in
>> flux and could change frequently. When using user_friendly_names the
>> prefix is set using kpartx within udev rules. My problem is I need to
>> know what the prefix is so my scripts know what device naming convention
>> to look for.
>>
>> Here are the different iterations of naming schemes:
>>
>> mpath0p1
>> mpath0-part1
>> mpathap1
>> mpatha-part1
>>
>> Is there a way other than grepping through the udev rules to determine
>> what the prefix is? The partitions may not exist so I cannot just look
>> to see what they are. I need to know BEFORE I create partitions. I know
>> this is a strange request, but I am working with a lot of code that was
>> designed before multipath was available and using the sys naming is not
>> an option (i.e. /disk/by-id/wwid).
>>
>>     
> I wouldn't rely on the device-mapper table names, as they could be pretty
> much everything.
>
> To handle this situation I've patches up multipath and kpartx to provide
> UUID prefixes, which normally can't be influenced from userspace.
> Multipath devices carry the prefix 'mpath-', kpartx generated devices
> carry the prefix 'part<num>-'.
> So by checking the prefix you pretty much know which program generated
> this particular device.
>
> Cheers,
>
> Hannes
>   
Humm.. Maybe I did not explain myself well enough because I do not 
understand your response. I am trying to determine what prefix is 
currently being used for the partitions by kpartx.

Example:
If I am on a SLES9 SP4 system there is a udev rule that states to use 
kpartx -a -p -part so that the prefix is "-part". Partitions that are 
created later are named [alias|mpath|uuid]a-part1.
If I am on a RHEL 5.1 system, there is a udev rule that states to use 
kpartx -a -p p so that the prefix is "p".
Partitions that are created later are named [alias|uuid|mpath]0p1

Right now, the only way I can find out what prefix is used for 
partitions is to grep and awk through the udev rule (which is 
unreliable). I am looking for a better way to see what prefix is 
currently being used by kpartx.

When you state that you have a patch to provide UUID prefixes, I do not 
understand. If you are not using "user_friendly_names yes" in 
multipath.conf, isn't it already the uuid? How does this change the 
naming of the partitions used? Right now it could be "-part" or "p".

Sorry but my limited knowledge of the naming schemes is probably 
confusing the issue. It appears that there are too many players on the 
field when it comes to naming these devices. (UDEV, multipath, 
device-mapper)

Thanks
David
