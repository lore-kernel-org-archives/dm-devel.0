From: Nayna <nayna@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v2 00/12] Integrity Policy Enforcement LSM (IPE)
Date: Tue, 7 Apr 2020 17:31:54 -0400
Message-ID: <c1466cc8-8a08-708a-4629-234485bb833e@linux.vnet.ibm.com>
References: <20200406221439.1469862-1-deven.desai@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200406221439.1469862-1-deven.desai@linux.microsoft.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: deven.desai@linux.microsoft.com
Cc: agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, tyhicks@linux.microsoft.com, pasha.tatashin@soleen.com, sashal@kernel.org, jaskarankhurana@linux.microsoft.com, nramas@linux.microsoft.com, mdsakib@linux.microsoft.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


On 4/6/20 6:14 PM, deven.desai@linux.microsoft.com wrote:
> From: Deven Bowers <deven.desai@linux.microsoft.com>
>
> Changelog:
> ------------------------------------
>
> v1: Introduced
>
> v2:
>    Split the second patch of the previous series into two.
>    Minor corrections in the cover-letter and documentation
>    comments regarding CAP_MAC_ADMIN checks in IPE.
>
> Overview:
> ------------------------------------
> IPE is a Linux Security Module, which allows for a configurable
> policy to enforce integrity requirements on the whole system. It
> attempts to solve the issue of Code Integrity: that any code being
> executed (or files being read), are identical to the version that
> was built by a trusted source.

Can you please clarify the "motivation" for this patch set more clearly? 
It seems to define a policy layer on top of dm-verity, which may be 
compiled into the kernel. In the motivation, can you please also make it 
explicit why existing mechanisms cannot be extended to achieve your purpose?

Also, AFIK, the changelog should be moved to the end of the patch 
description.

Thanks & Regards,

     - Nayna
