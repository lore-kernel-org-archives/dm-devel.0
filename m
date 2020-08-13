From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [dm-devel] [RFC PATCH v5 00/11] Integrity Policy Enforcement
 LSM (IPE)
Date: Thu, 13 Aug 2020 07:42:43 -0700
Message-ID: <1597329763.3708.13.camel@HansenPartnership.com>
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
         <1597170509.4325.55.camel@HansenPartnership.com>
         <2CA41152-6445-4716-B5EE-2D14E5C59368@gmail.com>
         <1597246946.7293.9.camel@HansenPartnership.com>
         <3F328A12-25DD-418B-A7D0-64DA09236E1C@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3F328A12-25DD-418B-A7D0-64DA09236E1C@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chuck Lever <chucklever@gmail.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, James Morris <jmorris@namei.org>, Deven Bowers <deven.desai@linux.microsoft.com>, Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>, snitzer@redhat.com, dm-devel@redhat.com, tyhicks@linux.microsoft.com, agk@redhat.com, Paul Moore <paul@paul-moore.com>, Jonathan Corbet <corbet@lwn.net>, nramas@linux.microsoft.com, serge@hallyn.com, pasha.tatashin@soleen.com, Jann Horn <jannh@google.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, mdsakib@microsoft.com, open list <linux-kernel@vger.kernel.org>, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-integrity@vger.kernel.org, jaskarankhurana@linu
List-Id: dm-devel.ids

On Thu, 2020-08-13 at 10:21 -0400, Chuck Lever wrote:
> > On Aug 12, 2020, at 11:42 AM, James Bottomley <James.Bottomley@Hans
> > enPartnership.com> wrote:
[...]
> > For most people the security mechanism of local xattrs is
> > sufficient.  If you're paranoid, you don't believe it is and you
> > use EVM.
> 
> When IMA metadata happens to be stored in local filesystems in
> a trusted xattr, it's going to enjoy the protection you describe
> without needing the addition of a cryptographic signature.
> 
> However, that metadata doesn't live its whole life there. It
> can reside in a tar file, it can cross a network, it can live
> on a back-up tape. I think we agree that any time that metadata
> is in transit or at rest outside of a Linux local filesystem, it
> is exposed.
> 
> Thus I'm interested in a metadata protection mechanism that does
> not rely on the security characteristics of a particular storage
> container. For me, a cryptographic signature fits that bill
> nicely.

Sure, but one of the points about IMA is a separation of mechanism from
policy.  Signed hashes (called appraisal in IMA terms) is just one
policy you can decide to require or not or even make it conditional on
other things.

> > > > I think Mimi's other point is actually that IMA uses a flat
> > > > hash which we derive by reading the entire file and then
> > > > watching for mutations. Since you cannot guarantee we get
> > > > notice of mutation with NFS, the entire IMA mechanism can't
> > > > really be applied in its current form and we have to resort to
> > > > chunk at a time verifications that a Merkel tree would provide.
> > > 
> > > I'm not sure what you mean by this. An NFS client relies on
> > > notification of mutation to maintain the integrity of its cache
> > > of NFS file content, and it's done that since the 1980s.
> > 
> > Mutation detection is part of the current IMA security model.  If
> > IMA sees a file mutate it has to be rehashed the next time it
> > passes the gate.  If we can't trust the NFS server, we can't trust
> > the NFS mutation notification and we have to have a different
> > mechanism to check the file.
> 
> When an NFS server lies about mtime and ctime, then NFS is completely
> broken. Untrusted NFS server doesn't mean "broken behavior" -- I
> would think that local filesystems will have the same problem if
> they can't trust a local block device to store filesystem metadata
> like indirect blocks and timestamps.
> 
> It's not clear to me that IMA as currently implemented can protect
> against broken storage devices or incorrect filesystem behavior.

IMA doesn't really care about the storage.  The gate check will fail if
the storage corrupts the file because the hashes won't match.  The
mechanism for modification notification is the province of the
filesystem and there are definitely some which don't do it (or other fs
features) correctly and thus can't use IMA.

> > > In addition to examining a file's mtime and ctime as maintained
> > > by the NFS server, a client can rely on the file's NFSv4 change
> > > attribute or an NFSv4 delegation.
> > 
> > And that's secure in the face of a malicious or compromised server?
> > 
> > The bottom line is still, I think we can't use linear hashes with
> > an open/exec/mmap gate with NFS and we have to move to chunk at a
> > time verification like that provided by a merkel tree.
> 
> That's fine until we claim that remote filesystems require one form
> of metadata and local filesystems use some other form.
> 
> To guarantee an unbroken chain of provenance, everyone has to use the
> same portable metadata format that is signed once by the content
> creator. That's essentially why I believe the Merkle-based metadata
> format must require that the tree root is signed.

Well, no, that would be optional policy.  We should certainly support
signed head hashes and require it if the policy said so, but we
shouldn't enforce it without the policy.

Suppose I'm a cloud service provider exporting files over NFS on the
control (private) network.  I use IMA to measure untrusted tenants to
get a feel for what they're doing, but since I control the NFS server,
the client and the private network, I wouldn't feel the requirement to
have signed hashes because I trust other mechanisms for the security.

James
