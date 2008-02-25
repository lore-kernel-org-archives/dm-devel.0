From: Jan Kara <jack@suse.cz>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow: ide-cd related? dm-related?
Date: Mon, 25 Feb 2008 23:48:07 +0100
Message-ID: <20080225224807.GA15700@atrey.karlin.mff.cuni.cz>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix> <m363wepa3a.fsf@telia.com> <87oda6p9st.fsf@hades.wkstn.nix> <20080225123041.401da103.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760708AbYBYWsW@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080225123041.401da103.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nix <nix@esperi.org.uk>, Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Jan Kara <jack@ucw.cz>
List-Id: dm-devel.ids

> On Sun, 24 Feb 2008 17:02:26 +0000 Nix <nix@esperi.org.uk> wrote:
> 
> > On 24 Feb 2008, Peter Osterlund told this:
> > 
> > > Nix <nix@esperi.org.uk> writes:
> > >> But while I'd normally blame pktcdvd there's only one pktcdvd function
> > >> in these tracebacks (pkt_open) and it's not got a significant stack
> > >> footprint.
> > >
> > > Did you verify that with "make checkstack" or just by looking at the
> > > source code? On my system, pkt_open() consumes 584 bytes because the
> > > compiler decides to inline lots of functions that would not normally
> > > be part of long call chains. The following patch fixes that problem on
> > > my system.
> > 
> > I just looked at the source; I forgot `make checkstack' existed.
> > 
> > On this system:
> > 
> > 0xc0263e0f pkt_open [vmlinux]:                          556
> > 
> > which is nearly as bad.
> > 
> > (As an aside, I'm surprised I didn't oops when packet-writing as well:
> > 
> > 0xc021270d udf_process_sequence [vmlinux]:              692
> > 0xc020f43d udf_add_entry [vmlinux]:                     628
> > 
> > owch. I guess that's called via a shorter call chain...)
> 
> udf_process_sequence() seems to be another victim of gcc inlining.
  Hmm, I'll have a look what we can do.

> udf_add_entry() defines a couple of 256-byte local arrays.
  Yes, exactly two of them. One is  non-trivial to get rid of - it's
used for encoding of filename before we write it, but one is used during
scanning of the directory whether the entry doesn't already exists (oh,
my!) and we can just rip that off..

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
