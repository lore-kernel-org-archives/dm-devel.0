From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [dm-devel] [RFC PATCH v5 00/11] Integrity Policy Enforcement
 LSM (IPE)
Date: Mon, 10 Aug 2020 12:35:56 -0400
Message-ID: <4664ab7dc3b324084df323bfa4670d5bfde76e66.camel@linux.ibm.com>
References: <20200728213614.586312-1-deven.desai@linux.microsoft.com>
         <20200802115545.GA1162@bug> <20200802140300.GA2975990@sasha-vm>
         <20200802143143.GB20261@amd>
         <1596386606.4087.20.camel@HansenPartnership.com>
         <fb35a1f7-7633-a678-3f0f-17cf83032d2b@linux.microsoft.com>
         <1596639689.3457.17.camel@HansenPartnership.com>
         <alpine.LRH.2.21.2008050934060.28225@namei.org>
         <b08ae82102f35936427bf138085484f75532cff1.camel@linux.ibm.com>
         <329E8DBA-049E-4959-AFD4-9D118DEB176E@gmail.com>
         <da6f54d0438ee3d3903b2c75fcfbeb0afdf92dc2.camel@linux.ibm.com>
         <1597073737.3966.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1597073737.3966.12.camel@HansenPartnership.com>
Sender: linux-block-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Chuck Lever <chucklever@gmail.com>, James Morris <jmorris@namei.org>
Cc: Deven Bowers <deven.desai@linux.microsoft.com>, Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>, snitzer@redhat.com, dm-devel@redhat.com, tyhicks@linux.microsoft.com, agk@redhat.com, Paul Moore <paul@paul-moore.com>, Jonathan Corbet <corbet@lwn.net>, nramas@linux.microsoft.com, serge@hallyn.com, pasha.tatashin@soleen.com, Jann Horn <jannh@google.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, mdsakib@microsoft.com, open list <linux-kernel@vger.kernel.org>, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-integrity@vger.kernel.org, jaskarankhurana@linux.microsoft.com
List-Id: dm-devel.ids

On Mon, 2020-08-10 at 08:35 -0700, James Bottomley wrote:
> On Sun, 2020-08-09 at 13:16 -0400, Mimi Zohar wrote:
> > On Sat, 2020-08-08 at 13:47 -0400, Chuck Lever wrote:
> > > > On Aug 5, 2020, at 2:15 PM, Mimi Zohar <zohar@linux.ibm.com>
> > > > wrote:
> > 
> > <snip>
> > 
> > > > If block layer integrity was enough, there wouldn't have been a
> > > > need for fs-verity.   Even fs-verity is limited to read only
> > > > filesystems, which makes validating file integrity so much
> > > > easier.  From the beginning, we've said that fs-verity signatures
> > > > should be included in the measurement list.  (I thought someone
> > > > signed on to add that support to IMA, but have not yet seen
> > > > anything.)
> > > 
> > > Mimi, when you and I discussed this during LSS NA 2019, I didn't
> > > fully understand that you expected me to implement signed Merkle
> > > trees for all filesystems. At the time, it sounded to me like you
> > > wanted signed Merkle trees only for NFS files. Is that still the
> > > case?
> > 
> > I definitely do not expect you to support signed Merkle trees for all
> > filesystems.  My interested is from an IMA perspective of measuring
> > and verifying the fs-verity Merkle tree root (and header info)
> > signature. This is independent of which filesystems support it.
> > 
> > > The first priority (for me, anyway) therefore is getting the
> > > ability to move IMA metadata between NFS clients and servers
> > > shoveled into the NFS protocol, but that's been blocked for various
> > > legal reasons.
> > 
> > Up to now, verifying remote filesystem file integrity has been out of
> > scope for IMA.   With fs-verity file signatures I can at least grasp
> > how remote file integrity could possibly work.  I don't understand
> > how remote file integrity with existing IMA formats could be
> > supported. You might want to consider writing a whitepaper, which
> > could later be used as the basis for a patch set cover letter.
> 
> I think, before this, we can help with the basics (and perhaps we
> should sort them out before we start documenting what we'll do).

I'm not opposed to doing that, but you're taking this discussion in a
totally different direction.  The current discussion is about NFSv4
supporting the existing IMA signatures, not only fs-verity signatures. 
I'd like to understand how that is possible and for the community to
weigh in on whether it makes sense.

> The
> first basic is that a merkle tree allows unit at a time verification.
> First of all we should agree on the unit.  Since we always fault a page
> at a time, I think our merkle tree unit should be a page not a block. 
> Next, we should agree where the check gates for the per page accesses
> should be ... definitely somewhere in readpage, I suspect and finally
> we should agree how the merkle tree is presented at the gate.  I think
> there are three ways:
> 
>    1. Ahead of time transfer:  The merkle tree is transferred and verified
>       at some time before the accesses begin, so we already have a
>       verified copy and can compare against the lower leaf.
>    2. Async transfer:  We provide an async mechanism to transfer the
>       necessary components, so when presented with a unit, we check the
>       log n components required to get to the root
>    3. The protocol actually provides the capability of 2 (like the SCSI
>       DIF/DIX), so to IMA all the pieces get presented instead of IMA
>       having to manage the tree
> 
> There are also a load of minor things like how we get the head hash,
> which must be presented and verified ahead of time for each of the
> above 3.
 
I was under the impression that IMA support for fs-verity signatures
would be limited to including the fs-verity signature in the
measurement list and verifying the fs-verity signature.   As fs-verity
is limited to immutable files, this could be done on file open.  fs-
verity would be responsible for enforcing the block/page data
integrity.   From a local filesystem perspective, I think that is all
that is necessary.

In terms of remote file systems,  the main issue is transporting and
storing the Merkle tree.  As fs-verity is limited to immutable files,
this could still be done on file open.

Mimi
