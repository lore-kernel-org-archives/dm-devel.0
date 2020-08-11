From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [dm-devel] [RFC PATCH v5 00/11] Integrity Policy Enforcement
 LSM (IPE)
Date: Tue, 11 Aug 2020 08:32:49 -0700
Message-ID: <1597159969.4325.21.camel@HansenPartnership.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <16C3BF97-A7D3-488A-9D26-7C9B18AD2084@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Chuck Lever <chucklever@gmail.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, James Morris <jmorris@namei.org>, Deven Bowers <deven.desai@linux.microsoft.com>, Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>, snitzer@redhat.com, dm-devel@redhat.com, tyhicks@linux.microsoft.com, agk@redhat.com, Paul Moore <paul@paul-moore.com>, Jonathan Corbet <corbet@lwn.net>, nramas@linux.microsoft.com, serge@hallyn.com, pasha.tatashin@soleen.com, Jann Horn <jannh@google.com>, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, mdsakib@microsoft.com, open list <linux-kernel@vger.kernel.org>, eparis@redhat.com, linux-security-module@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-integrity@vger.kernel.org, jaskarankhurana@linu
List-Id: dm-devel.ids

On Tue, 2020-08-11 at 10:48 -0400, Chuck Lever wrote:
> > On Aug 11, 2020, at 1:43 AM, James Bottomley
> > <James.Bottomley@HansenPartnership.com> wrote:
> > On Mon, 2020-08-10 at 19:36 -0400, Chuck Lever wrote:
[...]
> > > Thanks for the help! I just want to emphasize that documentation
> > > (eg, a specification) will be critical for remote filesystems.
> > > 
> > > If any of this is to be supported by a remote filesystem, then we
> > > need an unencumbered description of the new metadata format
> > > rather than code. GPL-encumbered formats cannot be contributed to
> > > the NFS standard, and are probably difficult for other
> > > filesystems that are not Linux-native, like SMB, as well.
> > 
> > I don't understand what you mean by GPL encumbered formats.  The
> > GPL is a code licence not a data or document licence.
> 
> IETF contributions occur under a BSD-style license incompatible
> with the GPL.
> 
> https://trustee.ietf.org/trust-legal-provisions.html
> 
> Non-Linux implementers (of OEM storage devices) rely on such
> standards processes to indemnify them against licensing claims.

Well, that simply means we won't be contributing the Linux
implementation, right? However, IETF doesn't require BSD for all
implementations, so that's OK.

> Today, there is no specification for existing IMA metadata formats,
> there is only code. My lawyer tells me that because the code that
> implements these formats is under GPL, the formats themselves cannot
> be contributed to, say, the IETF without express permission from the
> authors of that code. There are a lot of authors of the Linux IMA
> code, so this is proving to be an impediment to contribution. That
> blocks the ability to provide a fully-specified NFS protocol
> extension to support IMA metadata formats.

Well, let me put the counterpoint: I can write a book about how linux
device drivers work (which includes describing the data formats), for
instance, without having to get permission from all the authors ... or
is your lawyer taking the view we should be suing Jonathan Corbet,
Alessandro Rubini, and Greg Kroah-Hartman for licence infringement?  In
fact do they think we now have a huge class action possibility against
O'Reilly  and a host of other publishers ...

> > The way the spec process works in Linux is that we implement or
> > evolve a data format under a GPL implementaiton, but that
> > implementation doesn't implicate the later standardisation of the
> > data format and people are free to reimplement under any licence
> > they choose.
> 
> That technology transfer can happen only if all the authors of that
> prototype agree to contribute to a standard. That's much easier if
> that agreement comes before an implementation is done. The current
> IMA code base is more than a decade old, and there are more than a
> hundred authors who have contributed to that base.
> 
> Thus IMO we want an unencumbered description of any IMA metadata
> format that is to be contributed to an open standards body (as it
> would have to be to extend, say, the NFS protocol).

Fine, good grief, people who take a sensible view of this can write the
data format down and publish it under any licence you like then you can
pick it up again safely.  Would CC0 be OK? ... neither GPL nor BSD are
document licences and we shouldn't perpetuate bad practice by licensing
documentation under them.

James
