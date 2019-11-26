From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: dm clone: Add to the documentation index
Date: Tue, 26 Nov 2019 17:48:14 +0200
Message-ID: <6c74fc5b-46f4-018b-005a-ded2ee570320@arrikto.com>
References: <2044145.ITN4Tc4rAJ@archlinux>
	<6635828b-2ca6-c4d4-fc70-46e9a0bd2ed5@arrikto.com>
	<20191126154048.GB2025@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191126154048.GB2025@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: diegocg@gmail.com, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On 11/26/19 5:40 PM, Mike Snitzer wrote:
> On Tue, Nov 26 2019 at  7:00am -0500,
> Nikos Tsironis <ntsironis@arrikto.com> wrote:
> 
>> From: Diego Calleja <diegocg@gmail.com>
>>
>> It was missing from the initial commit
>>
>> Signed-off-by: Diego Calleja <diegocg@gmail.com>
>>
>> ---
>>   Documentation/admin-guide/device-mapper/index.rst | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/admin-guide/device-mapper/index.rst b/
>> Documentation/admin-guide/device-mapper/index.rst
>> index c77c58b8f67b..d8dec8911eb3 100644
>> --- a/Documentation/admin-guide/device-mapper/index.rst
>> +++ b/Documentation/admin-guide/device-mapper/index.rst
>> @@ -8,6 +8,7 @@ Device Mapper
>>       cache-policies
>>       cache
>>       delay
>> +    dm-clone
>>       dm-crypt
>>       dm-flakey
>>       dm-init
>> -- 
>> 2.24.0
> 
> I've picked this up:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.5&id=484e0d2b11e1fdd0d17702b282eb2ed56148385f
> 
> Nikos, please note that if you send a patch on someone else's behalf you
> should add you Signed-off-by.  I've updated the commit header
> accordingly.

You are right, I am sorry. I will keep that in mind the next time.

Thanks,
Nikos

> 
> Mike
> 
