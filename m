From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH v4 02/12] security: add ipe lsm evaluation loop and
 audit system
Date: Fri, 17 Jul 2020 16:16:43 -0700
Message-ID: <4b0c9925-d163-46a2-bbcb-74deb7446540@infradead.org>
References: <20200717230941.1190744-1-deven.desai@linux.microsoft.com>
 <20200717230941.1190744-3-deven.desai@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200717230941.1190744-3-deven.desai@linux.microsoft.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Deven Bowers <deven.desai@linux.microsoft.com>, agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, viro@zeniv.linux.org.uk, paul@paul-moore.com, eparis@redhat.com, jannh@google.com, dm-devel@redhat.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-audit@redhat.com
Cc: tyhicks@linux.microsoft.com, linux-kernel@vger.kernel.org, corbet@lwn.net, sashal@kernel.org, jaskarankhurana@linux.microsoft.com, mdsakib@microsoft.com, nramas@linux.microsoft.com, pasha.tatshin@soleen.com
List-Id: dm-devel.ids

On 7/17/20 4:09 PM, Deven Bowers wrote:
> +config SECURITY_IPE_PERMISSIVE_SWITCH
> +	bool "Enable the ability to switch IPE to permissive mode"
> +	default y
> +	help
> +	  This option enables two ways of switching IPE to permissive mode,
> +	  a sysctl (if enabled), `ipe.enforce`, or a kernel command line
> +	  parameter, `ipe.enforce`. If either of these are set to 0, files

	                                               is set

> +	  will be subject to IPE's policy, audit messages will be logged, but
> +	  the policy will not be enforced.
> +
> +	  If unsure, answer Y.


-- 
~Randy
