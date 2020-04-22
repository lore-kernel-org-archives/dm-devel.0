From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC PATCH v3 05/12] fs: add security blob and hooks for
 block_device
Date: Wed, 22 Apr 2020 09:55:15 -0700
Message-ID: <ff87e1ff-b9bf-5879-0154-c72990ce608b@schaufler-ca.com>
References: <20200415162550.2324-1-deven.desai@linux.microsoft.com>
 <20200415162550.2324-6-deven.desai@linux.microsoft.com>
 <alpine.LRH.2.21.2004230234420.12318@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.2004230234420.12318@namei.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <jmorris@namei.org>, deven.desai@linux.microsoft.com
Cc: agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, "Serge E. Hallyn" <serge@hallyn.com>, zohar@linux.ibm.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, jannh@google.com, tyhicks@linux.microsoft.com, pasha.tatashin@soleen.com, sashal@kernel.org, jaskarankhurana@linux.microsoft.com, nramas@linux.microsoft.com, mdsakib@linux.microsoft.com, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Stephen Smalley <sds@tycho.nsa.gov>, Chad Sellers <csellers@tresys.com>, John Johansen <john.johansen@canonical.com>, Casey Schaufler <casey@schaufler-ca.com>
List-Id: dm-devel.ids

On 4/22/2020 9:42 AM, James Morris wrote:
> On Wed, 15 Apr 2020, deven.desai@linux.microsoft.com wrote:
>
>> From: Deven Bowers <deven.desai@linux.microsoft.com>
>>
>> Add a security blob and associated allocation, deallocation and set hooks
>> for a block_device structure.
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Is there any feedback from block or LSM folk on the addition of a security 
> blob for block_device here?

The addition of a blob looks to have been done correctly.
As for it's use, I haven't had the chance to review the patches that
use it. I didn't see a patch that implements the hooks in a LSM,
but that could just be me. 

>
> IPE uses this is to track the status of integrity verification of e.g. 
> DM-Verity devices, per this code from a subsequent patch:
>
>
> +       ret = security_bdev_setsecurity(dm_table_get_md(v->ti->table)->bdev,
> +                                       DM_VERITY_SIGNATURE_SEC_NAME,
> +                                       v->sig->sig, v->sig->sig_size);
>
>
