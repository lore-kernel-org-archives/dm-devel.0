From: Eric Ren <zren@suse.com>
Subject: Re: [Report] crash tool cannot resolve struct dm_table
 properly
Date: Tue, 13 Jun 2017 18:06:36 +0800
Message-ID: <e61a0134-c768-8ed6-8af7-54f584d2177c@suse.com>
References: <ed7ae3a8-f053-fb4b-8523-c09b8c725ed9@suse.com>
	<e9d01427-b93e-37b6-8ef4-ccc0de714d70@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e9d01427-b93e-37b6-8ef4-ccc0de714d70@linux.vnet.ibm.com>
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
To: Steffen Maier <maier@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Steffen,

On 04/13/17 18:22, Steffen Maier wrote:
> On 04/13/2017 04:01 AM, Eric Ren wrote:
>> Hi Mikulas,
>>
>> When inspecting on coredump with crash tool, I find that 'dm_table'
>> cannot be resolved properly as follows:
>>
>> ===
>> crash> struct dm_table
>> struct dm_table {
>>     int undefined__;
>> }
>> SIZE: 4
>> ===
>>
>> Looks this issue is introduced by 83d5e5b (dm: optimize use SRCU and
>> RCU) with this code:
>> ===
>> +/*
>> + * A dummy definition to make RCU happy.
>> + * struct dm_table should never be dereferenced in this file.
>>  + */ +struct dm_table {
>> + int undefined__;
>> +};
>> +
>> ===
>>
>> It stops me from looking into dm_table when analyzing coredump. Is there
>> any workaround?
>> or can be fixed somehow?
>
> Does this help somewhat?:
>
> https://www.redhat.com/archives/dm-devel/2015-December/msg00042.html
>
> As workaround for eppic scripts in crash, we currently re-define struct dm_table in eppic 
> scripts, because "set scope dm_table_create" has not always worked as we liked. Sometimes 
> "whatis dm_table_create" and again "set scope dm_table_create" worked and we put this in 
> .crashrc, but eventually gave up and kept our struct re-define.

Yes, playing with "set" or "gdb ptype" commands doesn't always work. Could you please share 
your eppic scripts and steps how to use it?

Thanks in advance,
Eric
