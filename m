From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [dm-devel] [RFC PATCH v5 00/11] Integrity Policy Enforcement
 LSM (IPE)
Date: Thu, 13 Aug 2020 08:10:16 -0700
Message-ID: <1597331416.3708.26.camel@HansenPartnership.com>
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
         <6E907A22-02CC-42DD-B3CD-11D304F3A1A8@gmail.com>
         <1597124623.30793.14.camel@HansenPartnership.com>
         <16C3BF97-A7D3-488A-9D26-7C9B18AD2084@gmail.com>
         <1597161218.4325.38.camel@HansenPartnership.com>
         <02D551EF-C975-4B91-86CA-356FA0FF515C@gmail.com>
         <1597247482.7293.18.camel@HansenPartnership.com>
         <D470BA4B-EF1A-49CA-AFB9-0F7FFC4C6001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <D470BA4B-EF1A-49CA-AFB9-0F7FFC4C6001@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Chuck Lever <chucklever@gmail.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, James Morris <jmorris@namei.org>, Deven Bowers <deven.desai@linux.microsoft.com>, Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>, snitzer@redhat.com, dm-devel@redhat.com, tyhicks@linux.microsoft.com, agk@redhat.com, Paul Moore <paul@paul-moore.com>, Jonathan Corbet <corbet@lwn.net>, nramas@linux.microsoft.com, serge@hallyn.com, pasha.tatashin@soleen.com, Jann Horn <jannh@google.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, mdsakib@microsoft.com, open list <linux-kernel@vger.kernel.org>, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-integrity@vger.kernel.org, jaskarankhurana@linu
List-Id: dm-devel.ids

On Thu, 2020-08-13 at 10:42 -0400, Chuck Lever wrote:
> > On Aug 12, 2020, at 11:51 AM, James Bottomley <James.Bottomley@Hans
> > enPartnership.com> wrote:
> > On Wed, 2020-08-12 at 10:15 -0400, Chuck Lever wrote:
> > > > On Aug 11, 2020, at 11:53 AM, James Bottomley
> > > > <James.Bottomley@HansenPartnership.com> wrote:
> > > > On Tue, 2020-08-11 at 10:48 -0400, Chuck Lever wrote:
[...]
> > > > > > > The client would have to reconstruct that tree again if
> > > > > > > memory pressure caused some or all of the tree to be
> > > > > > > evicted, so perhaps an on-demand mechanism is preferable.
> > > > > > 
> > > > > > Right, but I think that's implementation detail.  Probably
> > > > > > what we need is a way to get the log(N) verification hashes
> > > > > > from the server and it's up to the client whether it caches
> > > > > > them or not.
> > > > > 
> > > > > Agreed, these are implementation details. But see above about
> > > > > the trustworthiness of the intermediate hashes. If they are
> > > > > conveyed on an untrusted network, then they can't be trusted
> > > > > either.
> > > > 
> > > > Yes, they can, provided enough of them are asked for to
> > > > verify.  If you look at the simple example above, suppose I
> > > > have cached H11 and H12, but I've lost the entire H2X layer.  I
> > > > want to verify B3 so I also ask you for your copy of H24.  Then
> > > > I generate H23 from B3 and Hash H23 and H24.  If this doesn't
> > > > hash to H12 I know either you supplied me the wrong block or
> > > > lied about H24.  However, if it all hashes correctly I know you
> > > > supplied me with both the correct B3 and the correct H24.
> > > 
> > > My point is there is a difference between a trusted cache and an
> > > untrusted cache. I argue there is not much value in a cache where
> > > the hashes have to be verified again.
> > 
> > And my point isn't about caching, it's about where the tree comes
> > from. I claim and you agree the client can get the tree from the
> > server a piece at a time (because it can path verify it) and
> > doesn't have to generate it itself.
> 
> OK, let's focus on where the tree comes from. It is certainly
> possible to build protocol to exchange parts of a Merkle tree.

Which is what I think we need to extend IMA to do.

>  The question is how it might be stored on the server.

I think the only thing the server has to guarantee to store is the head
hash, possibly signed.

>  There are some underlying assumptions about the metadata storage
> mechanism that should be stated up front.
> 
> Current forms of IMA metadata are limited in size and stored in a
> container that is read and written in a single operation. If we stick
> with that container format, I don't see a way to store a Merkle tree
> in there for all file sizes.

Well, I don't think you need to.  The only thing that needs to be
stored is the head hash.  Everything else can be reconstructed.  If you
asked me to implement it locally, I'd probably put the head hash in an
xattr but use a CAM based cache for the merkel trees and construct the
tree on first access if it weren't already in the cache.

However, the above isn't what fs-verity does: it stores the tree in a
hidden section of the file.  That's why I don't think we'd mandate
anything about tree storage.  Just describe the partial retrieval
properties we'd like and leave the rest as an implementation detail.

> Thus it seems to me that we cannot begin to consider the tree-on-the-
> server model unless there is a proposed storage mechanism for that
> whole tree. Otherwise, the client must have the primary role in
> unpacking and verifying the tree.

Well, as I said,  I don't think you need to store the tree.  You
certainly could decide to store the entire tree (as fs-verity does) if
it fitted your use case, but it's not required.  Perhaps even in my
case I'd make the CAM based cache persistent, like android's dalvik
cache.

James


> Storing only the tree root in the metadata means the metadata format
> is nicely bounded in size.
