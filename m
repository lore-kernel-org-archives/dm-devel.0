From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Re: Possible bug in multipathd (getting a segfault)
Date: Tue, 20 Nov 2007 11:34:37 +0100
Message-ID: <1195554877.6329.31.camel@sanderbal>
References: <1195480602.6074.3.camel@sanderbal> <47419854.2000508@linpro.no>
	<1195484847.6074.16.camel@sanderbal>	<20071119185021.GA23100@us.ibm.com>
	<1195506996.11489.23.camel@sanderbal> <47428E96.2090008@linpro.no>
	<1195551419.6329.14.camel@sanderbal> <4742AD9E.7060601@linpro.no>
	<1195553418.6329.23.camel@sanderbal>  <4742B51F.2050907@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4742B51F.2050907@linpro.no>
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


On Tue, 2007-11-20 at 11:21 +0100, Tore Anderson wrote:
> * S. J. van Harmelen
> 
> > Could you specify the steps I have to take to create the backtrace a
> > bit more as I have not done this before.
> > 
> > I run a debian etch server with a custom compiled 2.6.23.1 kernel
> > when I get the error.
> 
> Debian strips all their binaries by default, so you need to recompile
> multipath-tools and reinstall it:
> 
> $ export DEB_BUILD_OPTIONS=nostrip
> $ apt-get build-dep multipath-tools
> $ apt-get --compile source multipath-tools
> $ dpkg -i multipath-tools*deb

I guess I don't have to do that as I compiled the multipath-tools
myself?

wget http://christophe.varoqui.free.fr/.../multipath-tools-0.4.8.tar.bz2
tar jxf multipath-tools-0.4.8.tar.bz2 
cd multipath-tools-0.4.8/
make
make install

I did compile them when running the 2.6.22.2 kernel though. Should I
recompile them when running the 2.6.23.1 kernel, or doesn't that matter?

> 
> Then start multipathd from a shell that has core dumps enabled (make
> sure it's not already running):
> 
> $ ulimit -c unlimited
> $ multipathd
> 
> Wait for a segfault to happen, and you should have gotten a file named
> "core" in your current directory (or maybe in the root directory since
> multipathd chdir()s there, I'm not sure) that contains the backtrace.
> We need to extract it with GDB, though, so run:
> 
> $ gdb /sbin/multipathd /path/to/core
> (gdb) bt full

Oke, the segfault happens right at the start (and only at the start), so
that shouldn't be a problem. But I have to stop the running mulipathd
and that seems like a problem. This machine is running in production :)

So that will have to wait until I get a maintance window I guess...

> 
> ...and post the resulting backtrace here.  Hopefully a developer (not
> me, unfortunately) will be able to make sense of it.
> 
> Another thing you might want to try is to use your 2.6.23.1 with the
> same configuration as your 2.6.22.x (ie. don't use hwhandler rdac), and
> see if the segfaults still occur.
> 
> Regards
