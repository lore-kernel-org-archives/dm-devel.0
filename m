From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Re: Possible bug in multipathd (getting a segfault)
Date: Tue, 20 Nov 2007 12:25:50 +0100
Message-ID: <1195557950.6329.56.camel@sanderbal>
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

Oke, then I will give this a try this evening and post the results here
for de developers...

Thanks!

> 
> Regards
