From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack
 overflow: ide-cd related? dm-related?
Date: Mon, 25 Feb 2008 12:30:41 -0800
Message-ID: <20080225123041.401da103.akpm@linux-foundation.org>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix>
	<m363wepa3a.fsf@telia.com> <87oda6p9st.fsf@hades.wkstn.nix>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87oda6p9st.fsf@hades.wkstn.nix>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nix <nix@esperi.org.uk>
Cc: Peter Osterlund <petero2@telia.com>, Jan Kara <jack@ucw.cz>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, 24 Feb 2008 17:02:26 +0000 Nix <nix@esperi.org.uk> wrote:

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

udf_process_sequence() seems to be another victim of gcc inlining.

udf_add_entry() defines a couple of 256-byte local arrays.
