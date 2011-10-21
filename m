From: Yathindra <ydev@cs.utah.edu>
Subject: Re: Simulating faulty disk
Date: Fri, 21 Oct 2011 09:00:03 -0600
Message-ID: <4EA188F3.4000206@cs.utah.edu>
References: <4E9F9321.8090704@cs.utah.edu> <4E9FE97E.4030209@redhat.com>
	<4EA04201.1050702@cs.utah.edu> <4EA044A9.6070406@redhat.com>
	<4EA05072.10107@cs.utah.edu> <4EA05D0A.7030909@redhat.com>
	<4EA06020.9000708@cs.utah.edu> <4EA13A52.60902@redhat.com>
	<4EA18610.3050900@cs.utah.edu> <4EA1881B.5070607@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EA1881B.5070607@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Ok :)  Bryn is there a more elaborate document which shows simple examples
to work with device mapper. For a newbie like me it would be really helpful.

Thanks,
Yathi

On 10/21/2011 8:56 AM, Bryn M. Reeves wrote:
> On 10/21/2011 03:47 PM, Yathindra wrote:
>> dmsetup create d0 --table="0 `blockdev --getsize /dev/sdb` delay
>> /dev/sdb 0 500"
>> dmsetup create f0 --table="0 `blockdev --getsize /dev/mapper/d0` flakey
>> /dev/mapper/d0 0 9 1"
>> mkfs -t ext3 /dev/mapper/f0
>> ...
>> ...
>> ext2fs_mkdir: Attempt to read block from filesystem resulted in short
>> read while creating root dir
>>
>> Can we even mount such a device ?
>
> It's a flakey device :)
>
> With that table you'll have a device that is failing write I/Os for 1s 
> in every ten. If that coincides with mkfs trying to write to the 
> device it will create a corrupted file system.
>
> Depending on what you are trying to test you may want to put data on 
> the device first.
>
> Regards,
> Bryn.
