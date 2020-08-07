From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [dm-devel] [RFC PATCH v5 00/11] Integrity Policy Enforcement
 LSM (IPE)
Date: Fri, 07 Aug 2020 14:40:54 -0400
Message-ID: <268edec96cbe7d2626c9158b806e8865b6b1b8ed.camel@linux.ibm.com>
References: <20200728213614.586312-1-deven.desai@linux.microsoft.com>
         <20200802115545.GA1162@bug> <20200802140300.GA2975990@sasha-vm>
         <20200802143143.GB20261@amd>
         <1596386606.4087.20.camel@HansenPartnership.com>
         <fb35a1f7-7633-a678-3f0f-17cf83032d2b@linux.microsoft.com>
         <1596639689.3457.17.camel@HansenPartnership.com>
         <alpine.LRH.2.21.2008050934060.28225@namei.org>
         <b08ae82102f35936427bf138085484f75532cff1.camel@linux.ibm.com>
         <alpine.LRH.2.21.2008060949410.20084@namei.org>
         <eb7a2f5b5cd22cf9231aa0fd8fdb77c729a83428.camel@linux.ibm.com>
         <alpine.LRH.2.21.2008080240350.13040@namei.org>
         <4a764c86a824a4b931dd7f130ce7afce7df140e4.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <4a764c86a824a4b931dd7f130ce7afce7df140e4.camel@linux.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Morris <jmorris@namei.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Deven Bowers <deven.desai@linux.microsoft.com>, Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>, snitzer@redhat.com, dm-devel@redhat.com, tyhicks@linux.microsoft.com, agk@redhat.com, paul@paul-moore.com, corbet@lwn.net, nramas@linux.microsoft.com, serge@hallyn.com, pasha.tatashin@soleen.com, jannh@google.com, linux-block@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, mdsakib@microsoft.com, linux-kernel@vger.kernel.org, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, jaskarankhurana@linux.microsoft.com
List-Id: dm-devel.ids

On Fri, 2020-08-07 at 13:31 -0400, Mimi Zohar wrote:
> On Sat, 2020-08-08 at 02:41 +1000, James Morris wrote:
> > On Thu, 6 Aug 2020, Mimi Zohar wrote:
> > 
> > > On Thu, 2020-08-06 at 09:51 +1000, James Morris wrote:
> > > > On Wed, 5 Aug 2020, Mimi Zohar wrote:
> > > > 
> > > > > If block layer integrity was enough, there wouldn't have been a need
> > > > > for fs-verity.   Even fs-verity is limited to read only filesystems,
> > > > > which makes validating file integrity so much easier.  From the
> > > > > beginning, we've said that fs-verity signatures should be included in
> > > > > the measurement list.  (I thought someone signed on to add that support
> > > > > to IMA, but have not yet seen anything.)
> > > > > 
> > > > > Going forward I see a lot of what we've accomplished being incorporated
> > > > > into the filesystems.  When IMA will be limited to defining a system
> > > > > wide policy, I'll have completed my job.
> > > > 
> > > > What are your thoughts on IPE being a standalone LSM? Would you prefer to 
> > > > see its functionality integrated into IMA?
> > > 
> > > Improving the integrity subsystem would be preferred.
> > > 
> > 
> > Are you planning to attend Plumbers? Perhaps we could propose a BoF 
> > session on this topic.
> 
> That sounds like a good idea.

Other than it is already sold out.

Mimi
