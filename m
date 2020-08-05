From: James Morris <jmorris@namei.org>
Subject: Re: [dm-devel] [RFC PATCH v5 00/11] Integrity Policy Enforcement
 LSM (IPE)
Date: Wed, 5 Aug 2020 09:59:40 -0700 (PDT)
Message-ID: <alpine.LRH.2.21.2008050934060.28225@namei.org>
References: <20200728213614.586312-1-deven.desai@linux.microsoft.com>  <20200802115545.GA1162@bug> <20200802140300.GA2975990@sasha-vm>  <20200802143143.GB20261@amd>  <1596386606.4087.20.camel@HansenPartnership.com>  <fb35a1f7-7633-a678-3f0f-17cf83032d2b@linux.microsoft.com>
 <1596639689.3457.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1596639689.3457.17.camel@HansenPartnership.com>
Sender: linux-block-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Deven Bowers <deven.desai@linux.microsoft.com>, Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>, snitzer@redhat.com, zohar@linux.ibm.com, dm-devel@redhat.com, tyhicks@linux.microsoft.com, agk@redhat.com, paul@paul-moore.com, corbet@lwn.net, nramas@linux.microsoft.com, serge@hallyn.com, pasha.tatashin@soleen.com, jannh@google.com, linux-block@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, mdsakib@microsoft.com, linux-kernel@vger.kernel.org, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, jaskarankhurana@linux.microsoft.com
List-Id: dm-devel.ids

On Wed, 5 Aug 2020, James Bottomley wrote:

> I'll leave Mimi to answer, but really this is exactly the question that
> should have been asked before writing IPE.  However, since we have the
> cart before the horse, let me break the above down into two specific
> questions.

The question is valid and it was asked. We decided to first prototype what 
we needed and then evaluate if it should be integrated with IMA. We 
discussed this plan in person with Mimi (at LSS-NA in 2019), and presented 
a more mature version of IPE to LSS-NA in 2020, with the expectation that 
such a discussion may come up (it did not).

These patches are still part of this process and 'RFC' status.

>    1. Could we implement IPE in IMA (as in would extensions to IMA cover
>       everything).  I think the answers above indicate this is a "yes".

It could be done, if needed.

>    2. Should we extend IMA to implement it?  This is really whether from a
>       usability standpoint two seperate LSMs would make sense to cover the
>       different use cases.

One issue here is that IMA is fundamentally a measurement & appraisal 
scheme which has been extended to include integrity enforcement. IPE was 
designed from scratch to only perform integrity enforcement. As such, it 
is a cleaner design -- "do one thing and do it well" is a good design 
pattern.

In our use-case, we utilize _both_ IMA and IPE, for attestation and code 
integrity respectively. It is useful to be able to separate these 
concepts. They really are different:

- Code integrity enforcement ensures that code running locally is of known 
provenance and has not been modified prior to execution.

- Attestation is about measuring the health of a system and having that 
measurement validated by a remote system. (Local attestation is useless).

I'm not sure there is value in continuing to shoe-horn both of these into 
IMA.


>  I've got to say the least attractive thing
>       about separation is the fact that you now both have a policy parser.
>        You've tried to differentiate yours by making it more Kconfig
>       based, but policy has a way of becoming user space supplied because
>       the distros hate config options, so I think you're going to end up
>       with a policy parser very like IMAs.


-- 
James Morris
<jmorris@namei.org>
