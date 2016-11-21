From: Ondrej Kozina <okozina@redhat.com>
Subject: Re: [PATCH v2] dm-crypt: add ability to use keys from
 the kernel key retention service
Date: Mon, 21 Nov 2016 13:23:03 +0100
Message-ID: <bb229097-56f7-0ef8-88f0-db2246a2c0c9@redhat.com>
References: <afaabcf3-0ea0-375d-c0f2-6892dd70de2a@gmail.com>
	<1479329231-4572-1-git-send-email-okozina@redhat.com>
	<8d8a7521-b69a-9616-410d-be8866580508@virtuozzo.com>
	<ff5e69b1-f43c-35c8-6a32-4d7732919075@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ff5e69b1-f43c-35c8-6a32-4d7732919075@redhat.com>
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
Cc: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

On 11/17/2016 09:06 PM, Ondrej Kozina wrote:
> On 11/17/2016 05:35 PM, Andrey Ryabinin wrote:
>> On 11/16/2016 11:47 PM, Ondrej Kozina wrote:
>>> (Please still consider it to be RFC only, I need to modify the uspace teststuite
>>> again due to changes in key_string format. Also the changes to dm-crypt documentation
>>> will follow before final submit. Feature wide I'd consider the patch being complete
>>> unless any bugs would emerge)
>>>
>>> The kernel key service is a generic way to store keys for the use of
>>> other subsystems. Currently there is no way to use kernel keys in dm-crypt.
>>> This patch aims to fix that. Instead of key userspace may pass a key
>>> description with preceding ':'. So message that constructs encryption
>>> mapping now looks like this:
>>>
>>>   <cipher> [<key>|:<key_string>] <iv_offset> <dev_path> <start> [<#opt_params> <opt_params>]
>>>
>>> where <key_string> is in format: <key_size>:<key_type>:<key_description>
>>>
>>> Currently we only support two elementary key types: 'user' and 'logon'.
>>> Keys may be loaded in dm-crypt either via <key_string> or using
>>> classical method and pass the key in hex representation directly.
>>>
>>
>> I think we need to hexify key description too, because it can contain spaces.
>
> I see. You're right the kernel key description may really contain
> whitespace chars, bummer. Well what I'm thinking atm is rejecting any
> keys with descriptions containing whitespaces. But let me ask Mike or
> Alasdair what do they think about it.

Answering myself:

so I looked at it once again in detail and I'm now convinced we actually 
don't have to do anything about it (provided we'd agree on rejecting any 
key_description containing whitespace):

every table is first processed by dm_split_args() before it's passed to 
any target driver for further processing. That's true also for message 
ioctls. In case you pass table (or message) with whitespace in 
key_description it'll fail to construct such dm-crypt target because 
number of arguments passed will not match the dm-crypt template.

key_string in format: ':32:logon:some:user key' is considered to be 2 
arguments and not single one due to the whitespace.
