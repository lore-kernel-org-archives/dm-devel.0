From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/2] dm-writecache
Date: Tue, 13 Feb 2018 20:24:27 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1802132023450.6481@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1711222135371.2330@file01.intranet.prod.int.rdu2.redhat.com>
	<CAA9_cmcRe8KXO+jWy8knqg4EMCgBYF1JAdgR=A2qHkVES+i9ZA@mail.gmail.com>
	<alpine.LRH.2.02.1711272238130.9280@file01.intranet.prod.int.rdu2.redhat.com>
	<CAPcyv4jTuSLDiO1TZhCrJGxMWiWK-KNXKPf-DZH1xDeXVAaUgQ@mail.gmail.com>
	<alpine.LRH.2.02.1712050003070.13380@file01.intranet.prod.int.rdu2.redhat.com>
	<CAPcyv4i=XfG-pQYHKLKvwP_SeMxc+PaWOJYSGQ0rsbJ=9GC6iQ@mail.gmail.com>
	<alpine.LRH.2.02.1802131648030.31130@file01.intranet.prod.int.rdu2.redhat.com>
	<CAPcyv4hD6cTzaMoZ4p9O+GhcmD4se7vTAaYFjRzU1Aicopaziw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPcyv4hD6cTzaMoZ4p9O+GhcmD4se7vTAaYFjRzU1Aicopaziw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids



On Tue, 13 Feb 2018, Dan Williams wrote:

> On Tue, Feb 13, 2018 at 2:00 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> >
> > On Fri, 8 Dec 2017, Dan Williams wrote:
> >
> >> > > > when we write to
> >> > > > persistent memory using cached write instructions and use dax_flush
> >> > > > afterwards to flush cache for the affected range, the performance is about
> >> > > > 350MB/s. It is practically unusable - worse than low-end SSDs.
> >> > > >
> >> > > > On the other hand, the movnti instruction can sustain performance of one
> >> > > > 8-byte write per clock cycle. We don't have to flush cache afterwards, the
> >> > > > only thing that must be done is to flush the write-combining buffer with
> >> > > > the sfence instruction. Movnti has much better throughput than dax_flush.
> >> > >
> >> > > What about memcpy_flushcache?
> >> >
> >> > but
> >> >
> >> > - using memcpy_flushcache is overkill if we need just one or two 8-byte
> >> > writes to the metadata area. Why not use movnti directly?
> >> >
> >>
> >> The driver performs so many 8-byte moves that the cost of the
> >> memcpy_flushcache() function call significantly eats into your
> >> performance?
> >
> > I've measured it on Skylake i7-6700 - and the dm-writecache driver has 2%
> > lower throughput when it uses memcpy_flushcache() to update it metadata
> > instead of explicitly coded "movnti" instructions.
> >
> > I've created this patch - it doesn't change API in any way, but it
> > optimizes memcpy_flushcache for 4, 8 and 16-byte writes (that is what my
> > driver mostly uses). With this patch, I can remove the explicit "asm"
> > statements from my driver. Would you consider commiting this patch to the
> > kernel?
> >
> > Mikulas
> >
> >
> 
> Yes, this looks good to me. You can send it to the x86 folks with my:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> ...or let me know and I can chase it through the -tip tree. Either way
> works for me.

If you have access to some tree that will be merged, you can commit the 
patch there.

Mikulas
