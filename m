From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: Re: [PATCH v3 1/6] IMA: generalize keyring specific measurement
 constructs
Date: Fri, 11 Sep 2020 09:19:01 -0700
Message-ID: <1a456a10-bb49-206b-9fb9-cc996eea6e29@linux.microsoft.com>
References: <20200828015704.6629-1-tusharsu@linux.microsoft.com>
 <20200828015704.6629-2-tusharsu@linux.microsoft.com>
 <4802c73c2ed22c64ea4f315d3115ead919c3205e.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <4802c73c2ed22c64ea4f315d3115ead919c3205e.camel@linux.ibm.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Mimi Zohar <zohar@linux.ibm.com>, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On 2020-08-31 4:55 a.m., Mimi Zohar wrote:
> On Thu, 2020-08-27 at 18:56 -0700, Tushar Sugandhi wrote:
>> IMA functions such as ima_match_keyring(), process_buffer_measurement(),
>> ima_match_policy() etc. handle data specific to keyrings. Currently,
>> these constructs are not generic to handle any func specific data.
>> This makes it harder to extend without code duplication.
>>
>> Refactor the keyring specific measurement constructs to be generic and
>> reusable in other measurement scenarios.
> 
> Mostly this patch changes the variable name from keyring to func_data,
> which is good.  Other changes should be minimized.
> 
The only other change in this patch is introduction of
bool allow_empty_opt_list, which is needed as per my comment below.

Maybe I can move "allow_empty_opt_list" to a new patch after this one in
this series.

>>
>> Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
>> ---
> 
> <snip>
> 
>> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
>> index fe1df373c113..8866e84d0062 100644
>> --- a/security/integrity/ima/ima_policy.c
>> +++ b/security/integrity/ima/ima_policy.c
>> @@ -451,15 +451,21 @@ int ima_lsm_policy_change(struct notifier_block *nb, unsigned long event,
>>   }
>>   
>>   /**
>> - * ima_match_keyring - determine whether the keyring matches the measure rule
>> - * @rule: a pointer to a rule
>> - * @keyring: name of the keyring to match against the measure rule
>> + * ima_match_rule_data - determine whether the given func_data matches
>> + *			 the measure rule data
>> + * @rule: IMA policy rule
>> + * @opt_list: rule data to match func_data against
>> + * @func_data: data to match against the measure rule data
>> + * @allow_empty_opt_list: If true matches all func_data
>>    * @cred: a pointer to a credentials structure for user validation
>>    *
>> - * Returns true if keyring matches one in the rule, false otherwise.
>> + * Returns true if func_data matches one in the rule, false otherwise.
>>    */
>> -static bool ima_match_keyring(struct ima_rule_entry *rule,
>> -			      const char *keyring, const struct cred *cred)
>> +static bool ima_match_rule_data(struct ima_rule_entry *rule,
>> +				const struct ima_rule_opt_list *opt_list,
> 
> Ok
> 
>> +				const char *func_data,
>> +				bool allow_empty_opt_list,
> 
> As the policy is loaded, shouldn't the rules should be checked, not
> here on usage?
> 
> Mimi

Since "keyrings=" is optional, I cannot check the rule at load time for
keyrings. func=KEY_CHECK may or may not have "keyrings=", and both are
valid scenarios.

However "critical_kernel_data_sources=" is mandatory for 
func=CRITICAL_DATA.

So I am already making that check at policy load time.

See patch 5/6 – function ima_match_rules(), where I check for
IMA_DATA_SOURCES.

+       case CRITICAL_DATA:
<snip>
+               if (!(entry->flags & IMA_DATA_SOURCES) ||
<snip>
+                       return false;
+

Since ima_match_rule_data (this function) handles both func=KEY_CHECK 
and func=CRITICAL_DATA, we have to use the bool "allow_empty_opt_list"
to differentiate between the two scenarios – whether the rule is
optional or not for a given func.

> 
>> +				const struct cred *cred)
>>   {
>>   	bool matched = false;
>>   	size_t i;
>>
