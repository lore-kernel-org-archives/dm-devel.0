From: Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v5 05/11] fs: add security blob and hooks for
 block_device
Date: Tue, 28 Jul 2020 16:55:30 -0700
Message-ID: <f6bda37a-e6f8-3de9-2bae-25d2296f3424@linux.microsoft.com>
References: <20200728213614.586312-1-deven.desai@linux.microsoft.com>
 <20200728213614.586312-6-deven.desai@linux.microsoft.com>
 <ef0fff6f-410a-6444-f1e3-03499a2f52b7@schaufler-ca.com>
 <20200728224003.GC951209@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200728224003.GC951209@ZenIV.linux.org.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>
Cc: agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, paul@paul-moore.com, eparis@redhat.com, jannh@google.com, dm-devel@redhat.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-audit@redhat.com, tyhicks@linux.microsoft.com, linux-kernel@vger.kernel.org, corbet@lwn.net, sashal@kernel.org, jaskarankhurana@linux.microsoft.com, mdsakib@microsoft.com, nramas@linux.microsoft.com, pasha.tatashin@soleen.com
List-Id: dm-devel.ids



On 7/28/2020 3:40 PM, Al Viro wrote:
> On Tue, Jul 28, 2020 at 03:22:59PM -0700, Casey Schaufler wrote:
> 
>>> +	hlist_for_each_entry(p, &security_hook_heads.bdev_setsecurity, list) {
>>> +		rc = p->hook.bdev_setsecurity(bdev, name, value, size);
>>> +
>>> +		if (rc == -ENOSYS)
>>> +			rc = 0;
>>> +
>>> +		if (rc != 0)
>>
>> Perhaps:
>> 		else if (rc != 0)
>>
>>> +			break;
>>> +	}
>>> +
>>> +	return rc;
> 
> 	hlist_for_each_entry(p, &security_hook_heads.bdev_setsecurity, list) {
> 		rc = p->hook.bdev_setsecurity(bdev, name, value, size);
> 		if (rc && rc != -ENOSYS)
> 			return rc;
> 	}
> 	return 0;
> 
> Easier to reason about that way...
> 

Yeah, this is cleaner. I'll make the change for v6.
