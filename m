From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [PATCH v2] dm-crypt: add ability to use keys from
 the kernel key retention service
Date: Thu, 17 Nov 2016 21:06:22 +0100
Message-ID: <ff5e69b1-f43c-35c8-6a32-4d7732919075@redhat.com>
References: <afaabcf3-0ea0-375d-c0f2-6892dd70de2a@gmail.com>
	<1479329231-4572-1-git-send-email-okozina@redhat.com>
	<8d8a7521-b69a-9616-410d-be8866580508@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8d8a7521-b69a-9616-410d-be8866580508@virtuozzo.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrey Ryabinin <aryabinin@virtuozzo.com>, dm-devel@redhat.com
Cc: mpatocka@redhat.com, agk@redhat.com, snitzer@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

On 11/17/2016 05:35 PM, Andrey Ryabinin wrote:
> On 11/16/2016 11:47 PM, Ondrej Kozina wrote:
>> (Please still consider it to be RFC only, I need to modify the uspace teststuite
>> again due to changes in key_string format. Also the changes to dm-crypt documentation
>> will follow before final submit. Feature wide I'd consider the patch being complete
>> unless any bugs would emerge)
>>
>> The kernel key service is a generic way to store keys for the use of
>> other subsystems. Currently there is no way to use kernel keys in dm-crypt.
>> This patch aims to fix that. Instead of key userspace may pass a key
>> description with preceding ':'. So message that constructs encryption
>> mapping now looks like this:
>>
>>   <cipher> [<key>|:<key_string>] <iv_offset> <dev_path> <start> [<#opt_params> <opt_params>]
>>
>> where <key_string> is in format: <key_size>:<key_type>:<key_description>
>>
>> Currently we only support two elementary key types: 'user' and 'logon'.
>> Keys may be loaded in dm-crypt either via <key_string> or using
>> classical method and pass the key in hex representation directly.
>>
>
> I think we need to hexify key description too, because it can contain spaces.

I see. You're right the kernel key description may really contain 
whitespace chars, bummer. Well what I'm thinking atm is rejecting any 
keys with descriptions containing whitespaces. But let me ask Mike or 
Alasdair what do they think about it.

> <key_size> seems like unnecessary complication. Kernel knows key_size, it doesn't need
> that information from userspace.

Milan already explained that. I just add that general rule for dm tables 
is what you input via load ioctl() you should get back exactly the same 
via table status ioctl(). And also there's no other way how to get 
dm-crypt key size if you input it via kernel keyring key.

> Handling different types is probably an overkill too. If it works with logon keys,
> why would we need to use 'user' keys?

Well your original patch used 'user' type so I assumed you have good 
reason to use it. But anyway it's not so painful to add option to choose 
from 2 different key types imo. Loading tables is not a hot path.

O.
