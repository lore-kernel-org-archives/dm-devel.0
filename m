From: Chuck Lever <chucklever@gmail.com>
Subject: Re: [dm-devel] [RFC PATCH v5 00/11] Integrity Policy Enforcement LSM
 (IPE)
Date: Thu, 13 Aug 2020 10:56:17 -0400
Message-ID: <49A45475-20D8-456E-92AD-F63DBC71F900@gmail.com>
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
 <2CA41152-6445-4716-B5EE-2D14E5C59368@gmail.com>
 <1597246946.7293.9.camel@HansenPartnership.com>
 <3F328A12-25DD-418B-A7D0-64DA09236E1C@gmail.com>
 <1597329763.3708.13.camel@HansenPartnership.com>
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1597329763.3708.13.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, James Morris <jmorris@namei.org>, Deven Bowers <deven.desai@linux.microsoft.com>, Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>, snitzer@redhat.com, dm-devel@redhat.com, tyhicks@linux.microsoft.com, agk@redhat.com, Paul Moore <paul@paul-moore.com>, Jonathan Corbet <corbet@lwn.net>, nramas@linux.microsoft.com, serge@hallyn.com, pasha.tatashin@soleen.com, Jann Horn <jannh@google.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, mdsakib@microsoft.com, open list <linux-kernel@vger.kernel.org>, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-integrity@vger.kernel.org, jaskarankhurana@linu
List-Id: dm-devel.ids



> On Aug 13, 2020, at 10:42 AM, James Bottomley =
<James.Bottomley@HansenPartnership.com> wrote:
>=20
> On Thu, 2020-08-13 at 10:21 -0400, Chuck Lever wrote:
>>> On Aug 12, 2020, at 11:42 AM, James Bottomley <James.Bottomley@Hans
>>> enPartnership.com> wrote:
> [...]
>>> For most people the security mechanism of local xattrs is
>>> sufficient.  If you're paranoid, you don't believe it is and you
>>> use EVM.
>>=20
>> When IMA metadata happens to be stored in local filesystems in
>> a trusted xattr, it's going to enjoy the protection you describe
>> without needing the addition of a cryptographic signature.
>>=20
>> However, that metadata doesn't live its whole life there. It
>> can reside in a tar file, it can cross a network, it can live
>> on a back-up tape. I think we agree that any time that metadata
>> is in transit or at rest outside of a Linux local filesystem, it
>> is exposed.
>>=20
>> Thus I'm interested in a metadata protection mechanism that does
>> not rely on the security characteristics of a particular storage
>> container. For me, a cryptographic signature fits that bill
>> nicely.
>=20
> Sure, but one of the points about IMA is a separation of mechanism =
from
> policy.  Signed hashes (called appraisal in IMA terms) is just one
> policy you can decide to require or not or even make it conditional on
> other things.

AFAICT, the current EVM_IMA_DIGSIG and EVM_PORTABLE_DIGSIG formats are
always signed. The policy choice is whether or not to verify the
signature, not whether or not the metadata format is signed.


--
Chuck Lever
chucklever@gmail.com
