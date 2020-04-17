From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: Re: [RFC] IMA: New IMA measurements for dm-crypt and selinux
Date: Thu, 16 Apr 2020 17:49:44 -0700
Message-ID: <1feebdbe-94a8-16f7-deea-704e858a40a4@linux.microsoft.com>
References: <f92bef0f-eb40-0e07-540c-321134e4b070@linux.microsoft.com>
 <b8dcaa3d-5006-2730-aa57-fb99e13c4472@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <b8dcaa3d-5006-2730-aa57-fb99e13c4472@schaufler-ca.com>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>, linux-integrity@vger.kernel.org, zohar@linux.ibm.com, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, dm-devel@redhat.com
Cc: jmorris@namei.org, chpebeni@linux.microsoft.com, nramas@linux.microsoft.com, balajib@microsoft.com, sashal@kernel.org, suredd@microsoft.com
List-Id: dm-devel.ids



On 2020-04-08 9:34 a.m., Casey Schaufler wrote:
> On 4/8/2020 3:19 AM, Tushar Sugandhi wrote:
<snip>
>>
>> B. Measuring selinux constructs:
>>      We propose to add an IMA hook in enforcing_set() present under
>>      security/selinux/include/security.h.
>>      enforcing_set() sets the selinux state to enforcing/permissive etc.
>>      and is called from key places like selinux_init(),
>>      sel_write_enforce() etc.
>>      The hook will measure various attributes related to selinux status.
>>      Majority of the attributes are present in the struct selinux_state
>>      present in security/selinux/include/security.h
>>      e.g.
>>      $sestatus
>>             SELinux status:              enabled
>>             SELinuxfs mount:             /sys/fs/selinux
>>             SELinux root directory:      /etc/selinux
>>             Loaded policy name:          default
>>             Current mode:                permissive
>>             Mode from config file:       permissive
>>             Policy MLS status:           enabled
>>             Policy deny_unknown status:  allowed
>>             Memory protection checking:  requested (insecure)
>>             Max kernel policy version:   32
>>
>>      The above attributes will be serialized into a set of key=value
>>      pairs when passed to IMA for measurement.
>>
>>      Proposed Function Signature of the IMA hook:
>>      void ima_selinux_status(void *selinux_status, int len);
>>
>> Please provide comments\feedback on the proposal.
> 
> TL;DR - Why make this SELinux specific?
> 
> Integrating IMA and SELinux is a layering violation at best.
> Why isn't this ima_lsm_status(void *lsm_status, int len)?
That seems like a good idea.
I will investigate where can I place the hook for LSM.
Please let me know if you have any recommendations.
> Or, better yet, how about ima_lsm_status(char *name, void *value, int len),
> and you pass each name/value pair separately? That makes the
> interface generally useful.
> 
> Believe it or not, there *ARE* security modules that
> are not SELinux.
> 
>>
>> Thanks,
>> Tushar
>>
>> [1] https://sourceforge.net/p/linux-ima/wiki/Home/
>> [2] https://selinuxproject.org/page/FAQ
>> [3] https://gitlab.com/cryptsetup/cryptsetup/wikis/DMCrypt
