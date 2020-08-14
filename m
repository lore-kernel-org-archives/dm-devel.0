From: Chuck Lever <chucklever@gmail.com>
Subject: Re: [dm-devel] [RFC PATCH v5 00/11] Integrity Policy Enforcement LSM
 (IPE)
Date: Fri, 14 Aug 2020 10:21:26 -0400
Message-ID: <5A966AA7-9E39-4F59-A9B7-4308AF6F3333@gmail.com>
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
 <1597161218.4325.38.camel@HansenPartnership.com>
 <02D551EF-C975-4B91-86CA-356FA0FF515C@gmail.com>
 <1597247482.7293.18.camel@HansenPartnership.com>
 <D470BA4B-EF1A-49CA-AFB9-0F7FFC4C6001@gmail.com>
 <1597331416.3708.26.camel@HansenPartnership.com>
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1597331416.3708.26.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, James Morris <jmorris@namei.org>, Deven Bowers <deven.desai@linux.microsoft.com>, Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>, snitzer@redhat.com, dm-devel@redhat.com, tyhicks@linux.microsoft.com, agk@redhat.com, Paul Moore <paul@paul-moore.com>, Jonathan Corbet <corbet@lwn.net>, nramas@linux.microsoft.com, serge@hallyn.com, pasha.tatashin@soleen.com, Jann Horn <jannh@google.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, mdsakib@microsoft.com, open list <linux-kernel@vger.kernel.org>, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-integrity@vger.kernel.org, jaskarankhurana@linu
List-Id: dm-devel.ids



> On Aug 13, 2020, at 11:10 AM, James Bottomley =
<James.Bottomley@HansenPartnership.com> wrote:
>=20
> On Thu, 2020-08-13 at 10:42 -0400, Chuck Lever wrote:
>>> On Aug 12, 2020, at 11:51 AM, James Bottomley <James.Bottomley@Hans
>>> enPartnership.com> wrote:
>>> On Wed, 2020-08-12 at 10:15 -0400, Chuck Lever wrote:
>>>>> On Aug 11, 2020, at 11:53 AM, James Bottomley
>>>>> <James.Bottomley@HansenPartnership.com> wrote:
>>>>> On Tue, 2020-08-11 at 10:48 -0400, Chuck Lever wrote:
> [...]
>>>>>>>> The client would have to reconstruct that tree again if
>>>>>>>> memory pressure caused some or all of the tree to be
>>>>>>>> evicted, so perhaps an on-demand mechanism is preferable.
>>>>>>>=20
>>>>>>> Right, but I think that's implementation detail.  Probably
>>>>>>> what we need is a way to get the log(N) verification hashes
>>>>>>> from the server and it's up to the client whether it caches
>>>>>>> them or not.
>>>>>>=20
>>>>>> Agreed, these are implementation details. But see above about
>>>>>> the trustworthiness of the intermediate hashes. If they are
>>>>>> conveyed on an untrusted network, then they can't be trusted
>>>>>> either.
>>>>>=20
>>>>> Yes, they can, provided enough of them are asked for to
>>>>> verify.  If you look at the simple example above, suppose I
>>>>> have cached H11 and H12, but I've lost the entire H2X layer.  I
>>>>> want to verify B3 so I also ask you for your copy of H24.  Then
>>>>> I generate H23 from B3 and Hash H23 and H24.  If this doesn't
>>>>> hash to H12 I know either you supplied me the wrong block or
>>>>> lied about H24.  However, if it all hashes correctly I know you
>>>>> supplied me with both the correct B3 and the correct H24.
>>>>=20
>>>> My point is there is a difference between a trusted cache and an
>>>> untrusted cache. I argue there is not much value in a cache where
>>>> the hashes have to be verified again.
>>>=20
>>> And my point isn't about caching, it's about where the tree comes
>>> from. I claim and you agree the client can get the tree from the
>>> server a piece at a time (because it can path verify it) and
>>> doesn't have to generate it itself.
>>=20
>> OK, let's focus on where the tree comes from. It is certainly
>> possible to build protocol to exchange parts of a Merkle tree.
>=20
> Which is what I think we need to extend IMA to do.
>=20
>> The question is how it might be stored on the server.
>=20
> I think the only thing the server has to guarantee to store is the =
head
> hash, possibly signed.
>=20
>> There are some underlying assumptions about the metadata storage
>> mechanism that should be stated up front.
>>=20
>> Current forms of IMA metadata are limited in size and stored in a
>> container that is read and written in a single operation. If we stick
>> with that container format, I don't see a way to store a Merkle tree
>> in there for all file sizes.
>=20
> Well, I don't think you need to.  The only thing that needs to be
> stored is the head hash.  Everything else can be reconstructed.  If =
you
> asked me to implement it locally, I'd probably put the head hash in an
> xattr but use a CAM based cache for the merkel trees and construct the
> tree on first access if it weren't already in the cache.

The contents of the security.ima xattr might be modeled after
EVM_IMA_DIGSIG:

- a format enumerator (used by all IMA metadata formats)
- the tree's unit size
- a fingerprint of the signer's certificate
  - digest algorithm name and full digest
- the root hash, always signed
  - signing algorithm name and signature

The rest of the hash tree is always stored somewhere else or
constructed on-demand.

My experience of security communities both within and outside the
IETF is that they would insist on always having a signature.

If one doesn't care about signing, a self-signed certificate can be
automatically provisioned when ima-evm-utils is installed that can
be used for those cases. That would make the signature process
invisible to any administrator who doesn't care about signed
metadata.

Because storage in NFS would cross trust boundaries, it would have
to require the use of a signed root hash. I don't want to be in the
position where copying a file with an unsigned root hash into NFS
makes it unreadable because of a change in policy.


> However, the above isn't what fs-verity does: it stores the tree in a
> hidden section of the file.  That's why I don't think we'd mandate
> anything about tree storage.  Just describe the partial retrieval
> properties we'd like and leave the rest as an implementation detail.

I'm starting to consider how much compatibility with fs-verity is
required. There are several forms of hash-tree, and a specification
of the IMA metadata format would need to describe exactly how to
form the tree root. If we want compatibility with fs-verity, then
it is reasonable to assume that this IMA metadata format might be
required to use the same hash tree construction algorithm that
fs-verity uses.

The original Merkle tree concept was patented 40 years ago. I'm not
clear yet on whether the patent encumbers the use of Merkle trees
in any way, but since their usage seems pretty widespread in P2P
and BitCoin applications, I'm guessing the answer to that is
favorable. More research needed.

There is an implementation used by several GNU utilities that is
available as a piece of GPL code. It could be a potential blocker
if that was the tree algorithm that fs-verity uses -- as discussed
in the other thread.

Apparently there are some known weaknesses in older hash tree
algorithms, including at least one CVE. We could choose a recent
algorithm, but perhaps there needs to be a degree of extensibility
in case that algorithm needs to be updated due to a subsequent
security issue.

Tree construction could include a few items besides file content to
help secure the hash further. For instance the file's size and mtime,
as well as the depth of the tree, could be included in the signature.
But that depends on whether it can be done while maintaining
compatibility with fs-verity.

I would feel better if someone with more domain expertise chimed in.


>> Thus it seems to me that we cannot begin to consider the tree-on-the-
>> server model unless there is a proposed storage mechanism for that
>> whole tree. Otherwise, the client must have the primary role in
>> unpacking and verifying the tree.
>=20
> Well, as I said,  I don't think you need to store the tree.

We basically agree there.


> You certainly could decide to store the entire tree (as fs-verity =
does) if
> it fitted your use case, but it's not required.  Perhaps even in my
> case I'd make the CAM based cache persistent, like android's dalvik
> cache.
>=20
> James
>=20
>=20
>> Storing only the tree root in the metadata means the metadata format
>> is nicely bounded in size.

--
Chuck Lever
chucklever@gmail.com
