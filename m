From: James Morris <jmorris@namei.org>
Subject: Re: [dm-devel] [RFC PATCH v5 00/11] Integrity Policy Enforcement
 LSM (IPE)
Date: Wed, 12 Aug 2020 07:03:12 +1000 (AEST)
Message-ID: <alpine.LRH.2.21.2008120643370.10591@namei.org>
References: <20200728213614.586312-1-deven.desai@linux.microsoft.com> <20200802115545.GA1162@bug> <20200802140300.GA2975990@sasha-vm> <20200802143143.GB20261@amd> <1596386606.4087.20.camel@HansenPartnership.com> <fb35a1f7-7633-a678-3f0f-17cf83032d2b@linux.microsoft.com>
 <1596639689.3457.17.camel@HansenPartnership.com> <alpine.LRH.2.21.2008050934060.28225@namei.org> <b08ae82102f35936427bf138085484f75532cff1.camel@linux.ibm.com> <329E8DBA-049E-4959-AFD4-9D118DEB176E@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <329E8DBA-049E-4959-AFD4-9D118DEB176E@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chuck Lever <chucklever@gmail.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Deven Bowers <deven.desai@linux.microsoft.com>, Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>, snitzer@redhat.com, dm-devel@redhat.com, tyhicks@linux.microsoft.com, agk@redhat.com, Paul Moore <paul@paul-moore.com>, Jonathan Corbet <corbet@lwn.net>, nramas@linux.microsoft.com, serge@hallyn.com, pasha.tatashin@soleen.com, Jann Horn <jannh@google.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, mdsakib@microsoft.com, open list <linux-kernel@vger.kernel.org>, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-integrity@vger.kernel.or
List-Id: dm-devel.ids

On Sat, 8 Aug 2020, Chuck Lever wrote:

> My interest is in code integrity enforcement for executables stored
> in NFS files.
> 
> My struggle with IPE is that due to its dependence on dm-verity, it
> does not seem to able to protect content that is stored separately
> from its execution environment and accessed via a file access
> protocol (FUSE, SMB, NFS, etc).

It's not dependent on DM-Verity, that's just one possible integrity 
verification mechanism, and one of two supported in this initial 
version. The other is 'boot_verified' for a verified or otherwise trusted 
rootfs. Future versions will support FS-Verity, at least.

IPE was designed to be extensible in this way, with a strong separation of 
mechanism and policy.

Whatever is implemented for NFS should be able to plug in to IPE pretty 
easily.


-- 
James Morris
<jmorris@namei.org>
