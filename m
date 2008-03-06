From: Jan Kara <jack@suse.cz>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow: ide-cd related? dm-related?
Date: Thu, 6 Mar 2008 17:14:59 +0100
Message-ID: <20080306161459.GB3702@atrey.karlin.mff.cuni.cz>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix> <m363wepa3a.fsf@telia.com> <87oda6p9st.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934426AbYCFQPS@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87oda6p9st.fsf@hades.wkstn.nix>
Sender: linux-kernel-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

> On 24 Feb 2008, Peter Osterlund told this:
> 
> > Nix <nix@esperi.org.uk> writes:
> >> But while I'd normally blame pktcdvd there's only one pktcdvd function
> >> in these tracebacks (pkt_open) and it's not got a significant stack
> >> footprint.
> >
> > Did you verify that with "make checkstack" or just by looking at the
> > source code? On my system, pkt_open() consumes 584 bytes because the
> > compiler decides to inline lots of functions that would not normally
> > be part of long call chains. The following patch fixes that problem on
> > my system.
> 
> I just looked at the source; I forgot `make checkstack' existed.
> 
> On this system:
> 
> 0xc0263e0f pkt_open [vmlinux]:                          556
> 
> which is nearly as bad.
> 
> (As an aside, I'm surprised I didn't oops when packet-writing as well:
> 
> 0xc021270d udf_process_sequence [vmlinux]:              692
> 0xc020f43d udf_add_entry [vmlinux]:                     628
> 
> owch. I guess that's called via a shorter call chain...)
> 
> 
> I'll try the patch after this series of backups is done :)
  If you are interested, linux-next or -mm tree should contain a patch now
that fixes the problem...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
