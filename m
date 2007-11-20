From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Possible bug in multipathd (getting a segfault)
Date: Tue, 20 Nov 2007 11:10:18 +0100
Message-ID: <1195553418.6329.23.camel@sanderbal>
References: <1195480602.6074.3.camel@sanderbal> <47419854.2000508@linpro.no>
	<1195484847.6074.16.camel@sanderbal>	<20071119185021.GA23100@us.ibm.com>
	<1195506996.11489.23.camel@sanderbal> <47428E96.2090008@linpro.no>
	<1195551419.6329.14.camel@sanderbal>  <4742AD9E.7060601@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4742AD9E.7060601@linpro.no>
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

On Tue, 2007-11-20 at 10:49 +0100, Tore Anderson wrote:
> * S. J. van Harmelen
> 
> > When I do use a 2.6.23.x kernel with the RDAC hardware handler I get the
> > following error: multipathd[6895]: segfault at
> > 000000000000000a rip 00002b251f24394f rsp 00007fff8bfaa730 error 4 
> 
> This is indicative of a bug in multipathd.  It might or might not be
> serious, but I guess Christophe Varoqui would be interested in seeing a
> backtrace of the segfault in any case...
> 
> Try running multipathd (make sure it's not stripped of debugging
> symbols) with core dumps enabled ("ulimit -c unlimited"), and get a
> backtrace ("gdb /sbin/multipathd core" - then run "bt full").

I just changed the subject, because this is realy another issue then
what we where talking about before.

Could you specify the steps I have to take to create the backtrace a bit
more as I have not done this before.

I run a debian etch server with a custom compiled 2.6.23.1 kernel when I
get the error.

Sander
