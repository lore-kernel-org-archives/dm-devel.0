From: Sasha Levin <sashal@kernel.org>
Subject: Re: [RFC PATCH v5 00/11] Integrity Policy Enforcement LSM (IPE)
Date: Sun, 2 Aug 2020 10:03:00 -0400
Message-ID: <20200802140300.GA2975990@sasha-vm>
References: <20200728213614.586312-1-deven.desai@linux.microsoft.com>
 <20200802115545.GA1162@bug>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200802115545.GA1162@bug>
Sender: owner-linux-security-module@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Deven Bowers <deven.desai@linux.microsoft.com>, agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, viro@zeniv.linux.org.uk, paul@paul-moore.com, eparis@redhat.com, jannh@google.com, dm-devel@redhat.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-audit@redhat.com, tyhicks@linux.microsoft.com, linux-kernel@vger.kernel.org, corbet@lwn.net, jaskarankhurana@linux.microsoft.com, mdsakib@microsoft.com, nramas@linux.microsoft.com, pasha.tatashin@soleen.com
List-Id: dm-devel.ids

On Sun, Aug 02, 2020 at 01:55:45PM +0200, Pavel Machek wrote:
>Hi!
>
>> IPE is a Linux Security Module which allows for a configurable
>> policy to enforce integrity requirements on the whole system. It
>> attempts to solve the issue of Code Integrity: that any code being
>> executed (or files being read), are identical to the version that
>> was built by a trusted source.
>
>How is that different from security/integrity/ima?

Maybe if you would have read the cover letter all the way down to the
5th paragraph which explains how IPE is different from IMA we could
avoided this mail exchange...

-- 
Thanks,
Sasha
