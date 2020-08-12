From: Chuck Lever <chucklever@gmail.com>
Subject: Re: [dm-devel] [RFC PATCH v5 00/11] Integrity Policy Enforcement LSM
 (IPE)
Date: Wed, 12 Aug 2020 09:56:17 -0400
Message-ID: <2CA41152-6445-4716-B5EE-2D14E5C59368@gmail.com>
References: <20200728213614.586312-1-deven.desai@linux.microsoft.com>
 <20200802115545.GA1162@bug> <20200802140300.GA2975990@sasha-vm>
 <20200802143143.GB20261@amd> <1596386606.4087.20.camel@HansenPartnership.com>
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
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1597170509.4325.55.camel@HansenPartnership.com>
Sender: linux-block-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, James Morris <jmorris@namei.org>, Deven Bowers <deven.desai@linux.microsoft.com>, Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>, snitzer@redhat.com, dm-devel@redhat.com, tyhicks@linux.microsoft.com, agk@redhat.com, Paul Moore <paul@paul-moore.com>, Jonathan Corbet <corbet@lwn.net>, nramas@linux.microsoft.com, serge@hallyn.com, pasha.tatashin@soleen.com, Jann Horn <jannh@google.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, mdsakib@microsoft.com, open list <linux-kernel@vger.kernel.org>, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-integrity@vger.kernel.org, jaskarankhurana@linu
List-Id: dm-devel.ids



> On Aug 11, 2020, at 2:28 PM, James Bottomley =
<James.Bottomley@HansenPartnership.com> wrote:
>=20
> On Tue, 2020-08-11 at 10:48 -0400, Chuck Lever wrote:
>> Mimi's earlier point is that any IMA metadata format that involves
>> unsigned digests is exposed to an alteration attack at rest or in
>> transit, thus will not provide a robust end-to-end integrity
>> guarantee.
>=20
> I don't believe that is Mimi's point, because it's mostly not correct:
> the xattr mechanism does provide this today.  The point is the
> mechanism we use for storing IMA hashes and signatures today is xattrs
> because they have robust security properties for local filesystems =
that
> the kernel enforces.  This use goes beyond IMA, selinux labels for
> instance use this property as well.

I don't buy this for a second. If storing a security label in a
local xattr is so secure, we wouldn't have any need for EVM.


> What I think you're saying is that NFS can't provide the robust
> security for xattrs we've been relying on, so you need some other
> mechanism for storing them.

For NFS, there's a network traversal which is an attack surface.

A local xattr can be attacked as well: a device or bus malfunction
can corrupt the content of an xattr, or a privileged user can modify
it.

How does that metadata get from the software provider to the end
user? It's got to go over a network, stored in various ways, some
of which will not be trusted. To attain an unbroken chain of
provenance, that metadata has to be signed.

I don't think the question is the storage mechanism, but rather the
protection mechanism. Signing the metadata protects it in all of
these cases.


> I think Mimi's other point is actually that IMA uses a flat hash which
> we derive by reading the entire file and then watching for mutations.=20=

> Since you cannot guarantee we get notice of mutation with NFS, the
> entire IMA mechanism can't really be applied in its current form and =
we
> have to resort to chunk at a time verifications that a Merkel tree
> would provide.

I'm not sure what you mean by this. An NFS client relies on notification
of mutation to maintain the integrity of its cache of NFS file content,
and it's done that since the 1980s.

In addition to examining a file's mtime and ctime as maintained by
the NFS server, a client can rely on the file's NFSv4 change attribute
or an NFSv4 delegation.


> Doesn't this make moot any thinking about
> standardisation in NFS for the current IMA flat hash mechanism because
> we simply can't use it ... If I were to construct a prototype I'd have
> to work out and securely cache the hash of ever chunk when verifying
> the flat hash so I could recheck on every chunk read.  I think that's
> infeasible for large files.
>=20
> James
>=20

--
Chuck Lever
chucklever@gmail.com
