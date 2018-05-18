From: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: dm-writecache
Date: Fri, 18 May 2018 16:12:02 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1805181514420.28860@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1803080824210.2819@file01.intranet.prod.int.rdu2.redhat.com>
 <20180308145153.GB23262@infradead.org>
 <CAPcyv4gBUt5NYK2Lx0dMZAnENeSgKm3KaUvY9kkqB+PNPyQu4w@mail.gmail.com>
 <20180518154454.GA4902@redhat.com>
 <CAPcyv4hAZVTE7T7q7YRN6QvxfVR64c3jBpCTu-rCvNAB1-OWSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hAZVTE7T7q7YRN6QvxfVR64c3jBpCTu-rCvNAB1-OWSA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Alasdair G. Kergon" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids



On Fri, 18 May 2018, Dan Williams wrote:

> On Fri, May 18, 2018 at 8:44 AM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Thu, Mar 08 2018 at 12:08pm -0500,
> > Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Mikulas sent this useful enhancement to the memcpy_flushcache API:
> >>
> >>     https://patchwork.kernel.org/patch/10217655/
> >>
> >> ...it's in my queue to either push through -tip or add it to the next
> >> libnvdimm pull request for 4.17-rc1.
> >
> > Hi Dan,
> >
> > Seems this never actually went upstream.  I've staged it in
> > linux-dm.git's "for-next" for the time being:
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.18&id=a7e96990b5ff6206fefdc5bfe74396bb880f7e48
> >
> > But do you intend to pick it up for 4.18 inclusion?  If so I'll drop
> > it.. would just hate for it to get dropped on the floor by getting lost
> > in the shuffle between trees.
> >
> > Please avise, thanks!
> > Mike
> 
> Thanks for picking it up! I was hoping to resend it to get acks from
> x86 folks, and then yes it fell through the cracks in my patch
> tracking.
> 
> Now that I look at it again I don't think we need this hunk:
> 
> void memcpy_page_flushcache(char *to, struct page *page, size_t offset,
> size_t len)
> {
> char *from = kmap_atomic(page);
> - memcpy_flushcache(to, from + offset, len);
> + __memcpy_flushcache(to, from + offset, len);
> kunmap_atomic(from);
> }

Yes - this is not needed.

> ...and I wonder what the benefit is of the 16-byte case? I would
> assume the bulk of the benefit is limited to the 4 and 8 byte copy
> cases.

dm-writecache uses 16-byte writes frequently, so it is needed for that.

If we split 16-byte write to two 8-byte writes, it would degrade 
performance for architectures where memcpy_flushcache needs to flush the 
cache.

> Mikulas please resend with those comments addressed and include Ingo and 
> Thomas.

Mikulas
