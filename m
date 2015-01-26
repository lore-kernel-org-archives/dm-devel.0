From: Marian Csontos <mcsontos@redhat.com>
Subject: Re: dm_mirror/dm_raid1 limitations ?.
Date: Mon, 26 Jan 2015 20:01:54 +0100
Message-ID: <54C68F22.5080004@redhat.com>
References: <4d982ea8-3769-46d2-ba73-2d1525faa63b@default>	<54C64C4F.6090601@redhat.com>
	<E0704006-CC32-460A-AC22-149FD2B76583@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <E0704006-CC32-460A-AC22-149FD2B76583@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 01/26/2015 04:34 PM, suresh.babu.kandukuru@oracle.com wrote:
> Heinzm,thanks for the quick reply.. We are using dmestup create
> mirror ..as we want to do that on physical San lun (block devices)
> ... Not the one ( lv create ) you mentioned below.. Is there any
> advantage going with logical volume approach lvcreate -type

One of LVM features is monitoring of mirror/raid LVs and 
removing/replacing any missing legs.

Using dmsetup directly, you have to do this manually.

>
> /Suresh
>
> Sent from my iPhone
>
>> On Jan 26, 2015, at 7:46 PM, Heinz Mauelshagen <heinzm@redhat.com>
>> wrote:
>>
>>
>>> On 01/26/2015 02:51 PM, Suresh Babu Kandukuru wrote: Use case is
>>> : Two luns are mapped from storage array to linux host which are
>>> in same SAN fabric . we want to create a mirror on the linux host
>>> with these two luns and let  host use that mirror lun .  basic
>>> tests suggest that dm_mirror working fine . when we have any
>>> intermittent path issues with between host and san array , host
>>> i/o just freeze , never returns back even after the path is
>>> online.
>>
>> Hard to tell what's happening without any kernel log.
>>
>>>
>>> Is dm_mirror viable solution here  ?. Can you point me any link
>>> which gives the limitations of dm_mirror ? . another alternate
>>> solutions you propose here ?. Thanks in advance .
>>
>> We've switched the default away from "mirror" to "raid1" in order
>> to take advantage of th MD runtime. Have you tested  "lvcreate
>> --type raid1 ..." yet? Please do.
>>
>> Regards, Heinz
>>
>>>
>>> Thanks /Suresh
>>>
>>>
>>> -- dm-devel mailing list dm-devel@redhat.com
>>> https://www.redhat.com/mailman/listinfo/dm-devel
>>
>> <Untitled.txt>
>
>
>
> -- dm-devel mailing list dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
