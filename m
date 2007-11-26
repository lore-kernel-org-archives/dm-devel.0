From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Re: Possible bug in multipathd (getting a segfault)
Date: Mon, 26 Nov 2007 21:40:36 +0100
Message-ID: <1196109636.6438.147.camel@localhost>
References: <1195480602.6074.3.camel@sanderbal> <47419854.2000508@linpro.no>
	<1195484847.6074.16.camel@sanderbal>	<20071119185021.GA23100@us.ibm.com>
	<1195506996.11489.23.camel@sanderbal> <47428E96.2090008@linpro.no>
	<1195551419.6329.14.camel@sanderbal> <4742AD9E.7060601@linpro.no>
	<1195553418.6329.23.camel@sanderbal> <4742B51F.2050907@linpro.no>
	<1195554877.6329.31.camel@sanderbal>  <4742C1BD.2000904@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4742C1BD.2000904@linpro.no>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2007-11-20 at 12:15 +0100, Tore Anderson wrote:
> * S. J. van Harmelen
> 
> > I guess I don't have to do that as I compiled the multipath-tools 
> > myself?
> 
> Then you should have the debugging symbols in place, yes.
> 
> > I did compile them when running the 2.6.22.2 kernel though. Should I 
> > recompile them when running the 2.6.23.1 kernel, or doesn't that
> > matter?
> 
> Doesn't matter.
> 
> > Oke, the segfault happens right at the start (and only at the start),
> > so that shouldn't be a problem. But I have to stop the running
> > mulipathd and that seems like a problem. This machine is running in
> > production :)
> > 
> > So that will have to wait until I get a maintance window I guess...
> 
> Stopping multipathd isn't problematic.  It is only responsible for
> periodically testing paths to pre-emptively fail non-active paths or
> re-instate paths that has been failed by the kernel's dm-multipath layer.
> 
> If everything is running stable with all paths alive and well,
> restarting multipathd is nothing to worry about.

I tried it, but it doesn't give me a core dump. It only shows one line
in syslog for each time that I start multipathd. Multipathd keeps
running with no noticeable errors though.

I'm running the system with a 2.6.23.8 kernel and it shows this error
one time per start of multipathd:

kernel: multipathd[2303]: segfault at 000000000000000a rip
00002baa8765f94f rsp 00007fff23b8e370 error 4
kernel: multipathd[3742]: segfault at 000000000000000a rip
00002b09ff82394f rsp 00007fffab9ca130 error 4
kernel: multipathd[4103]: segfault at 000000000000000a rip
00002adefdbe894f rsp 00007fffad604d90 error 4

Also I noticed that I get the "DELL     ,Universal Xpor" in my multipath
-ll output. Didn't get that before. Is that something to look at?

root@storage:~# multipath -ll
360019b9000d7e1100000000000000000dm-5 DELL    ,Universal Xpor
[size=20M][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][enabled]
 \_ 1:0:0:31 sdf 8:80  [active][ready]
backup (360019b9000d7e1100000444b46be82c4) dm-2 DELL    ,MD3000        
[size=200G][features=0][hwhandler=1 rdac]
\_ round-robin 0 [prio=3][active]
 \_ 1:0:1:2  sdi 8:128 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:2  sdd 8:48  [active][ghost]
xen (360019b9000d7e11000004485473faa94) dm-1 DELL    ,MD3000        
[size=200G][features=0][hwhandler=1 rdac]
\_ round-robin 0 [prio=3][enabled]
 \_ 1:0:0:3  sde 8:64  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:3  sdj 8:144 [active][ghost]
360019b9000d7ddab0000000000000000dm-0 DELL    ,Universal Xpor
[size=20M][features=0][hwhandler=0]
\_ round-robin 0 [prio=1][enabled]
 \_ 1:0:1:31 sdk 8:160 [active][ready]
vmware (360019b9000d7e1100000444846be81b6) dm-4 DELL    ,MD3000        
[size=200G][features=0][hwhandler=1 rdac]
\_ round-robin 0 [prio=3][enabled]
 \_ 1:0:0:0  sdb 8:16  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:0  sdg 8:96  [active][ghost]
data (360019b9000d7ddab0000493846be81e5) dm-3 DELL    ,MD3000        
[size=200G][features=0][hwhandler=1 rdac]
\_ round-robin 0 [prio=3][active]
 \_ 1:0:1:1  sdh 8:112 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:1  sdc 8:32  [active][ghost]

Regards,

Sander
