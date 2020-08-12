From: Chuck Lever <chucklever@gmail.com>
Subject: Re: [dm-devel] [RFC PATCH v5 00/11] Integrity Policy Enforcement LSM
 (IPE)
Date: Wed, 12 Aug 2020 10:45:56 -0400
Message-ID: <20F82AFA-D0AC-479B-AB1D-0D354AE19498@gmail.com>
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
 <1597159969.4325.21.camel@HansenPartnership.com>
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1597159969.4325.21.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, James Morris <jmorris@namei.org>, Deven Bowers <deven.desai@linux.microsoft.com>, Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>, snitzer@redhat.com, dm-devel@redhat.com, tyhicks@linux.microsoft.com, agk@redhat.com, Paul Moore <paul@paul-moore.com>, Jonathan Corbet <corbet@lwn.net>, nramas@linux.microsoft.com, serge@hallyn.com, pasha.tatashin@soleen.com, Jann Horn <jannh@google.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, mdsakib@microsoft.com, open list <linux-kernel@vger.kernel.org>, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-integrity@vger.kernel.org, jaskarankhurana@linu
List-Id: dm-devel.ids



> On Aug 11, 2020, at 11:32 AM, James Bottomley =
<James.Bottomley@HansenPartnership.com> wrote:
>=20
> On Tue, 2020-08-11 at 10:48 -0400, Chuck Lever wrote:
>>> On Aug 11, 2020, at 1:43 AM, James Bottomley
>>> <James.Bottomley@HansenPartnership.com> wrote:
>>> On Mon, 2020-08-10 at 19:36 -0400, Chuck Lever wrote:
> [...]
>>>> Thanks for the help! I just want to emphasize that documentation
>>>> (eg, a specification) will be critical for remote filesystems.
>>>>=20
>>>> If any of this is to be supported by a remote filesystem, then we
>>>> need an unencumbered description of the new metadata format
>>>> rather than code. GPL-encumbered formats cannot be contributed to
>>>> the NFS standard, and are probably difficult for other
>>>> filesystems that are not Linux-native, like SMB, as well.
>>>=20
>>> I don't understand what you mean by GPL encumbered formats.  The
>>> GPL is a code licence not a data or document licence.
>>=20
>> IETF contributions occur under a BSD-style license incompatible
>> with the GPL.
>>=20
>> https://trustee.ietf.org/trust-legal-provisions.html
>>=20
>> Non-Linux implementers (of OEM storage devices) rely on such
>> standards processes to indemnify them against licensing claims.
>=20
> Well, that simply means we won't be contributing the Linux
> implementation, right?

At the present time, there is nothing but the Linux implementation.
There's no English description, there's no specification of the
formats, the format is described only by source code.

The only way to contribute current IMA metadata formats to an open
standards body like the IETF is to look at encumbered code first.
We would effectively be contributing an implementation in this case.

(I'm not saying the current formats should or should not be
contributed; merely that there is a legal stumbling block to doing
so that can be avoided for newly defined formats).


> Well, let me put the counterpoint: I can write a book about how linux
> device drivers work (which includes describing the data formats)


Our position is that someone who reads that book and implements those
formats under a non-GPL-compatible license would be in breach of the
GPL.

The point of the standards process is to indemnify implementing
and distributing under _any_ license what has been published by the
standards body. That legally enables everyone to use the published
protocol/format in their own code no matter how it happens to be
licensed.


> Fine, good grief, people who take a sensible view of this can write =
the
> data format down and publish it under any licence you like then you =
can
> pick it up again safely.


That's what I proposed. Write it down under the IETF Trust legal
provisions license. And I volunteered to do that.

All I'm saying is that description needs to come before code.


--
Chuck Lever
chucklever@gmail.com
