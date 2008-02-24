From: Nix <nix@esperi.org.uk>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow: ide-cd related? dm-related?
Date: Sun, 24 Feb 2008 17:02:26 +0000
Message-ID: <87oda6p9st.fsf@hades.wkstn.nix>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix>
	<m363wepa3a.fsf@telia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753465AbYBXRDT@vger.kernel.org>
In-Reply-To: <m363wepa3a.fsf@telia.com> (Peter Osterlund's message of "Sun, 24 Feb 2008 17:56:09 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Osterlund <petero2@telia.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 24 Feb 2008, Peter Osterlund told this:

> Nix <nix@esperi.org.uk> writes:
>> But while I'd normally blame pktcdvd there's only one pktcdvd function
>> in these tracebacks (pkt_open) and it's not got a significant stack
>> footprint.
>
> Did you verify that with "make checkstack" or just by looking at the
> source code? On my system, pkt_open() consumes 584 bytes because the
> compiler decides to inline lots of functions that would not normally
> be part of long call chains. The following patch fixes that problem on
> my system.

I just looked at the source; I forgot `make checkstack' existed.

On this system:

0xc0263e0f pkt_open [vmlinux]:                          556

which is nearly as bad.

(As an aside, I'm surprised I didn't oops when packet-writing as well:

0xc021270d udf_process_sequence [vmlinux]:              692
0xc020f43d udf_add_entry [vmlinux]:                     628

owch. I guess that's called via a shorter call chain...)


I'll try the patch after this series of backups is done :)

-- 
`The rest is a tale of post and counter-post.' --- Ian Rawlings
                                                   describes USENET
