From: Mauro Carvalho Chehab <mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 56/79] docs: Documentation/*.txt: rename all ReST
	files to *.rst
Date: Mon, 6 May 2019 16:50:59 -0300
Message-ID: <20190506165059.51eb2959@coco.lan>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
	<cda57849a6462ccc72dcd360b30068ab6a1021c4.1555938376.git.mchehab+samsung@kernel.org>
	<20190423083135.GA11158@hirez.programming.kicks-ass.net>
	<20190423125519.GA7104@redhat.com>
	<20190423130132.GT4038@hirez.programming.kicks-ass.net>
	<20190423103053.07cf2149@lwn.net>
	<20190423171158.GG12232@hirez.programming.kicks-ass.net>
	<20190423172006.GD16353@zn.tnic> <20190423170409.7b1370ac@coco.lan>
	<20190423213816.GE16353@zn.tnic>
	<20190424065209.GC4038@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20190424065209.GC4038-Nxj+rRp3nVydTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linux Doc Mailing List <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Farhan Ali <alifm-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Halil Pasic <pasic-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, openipmi-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nicholas Piggin <npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sean Paul <sean-p7yTbzM4H96eqtR555YLDQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-wireless@v
List-Id: dm-devel.ids

Em Wed, 24 Apr 2019 08:52:09 +0200
Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> escreveu:

> On Tue, Apr 23, 2019 at 11:38:16PM +0200, Borislav Petkov wrote:
> > If that is all the changes it would need, then I guess that's ok. Btw,
> > those rst-conversion patches don't really show what got changed. Dunno
> > if git can even show that properly. I diffed the two files by hand to
> > see what got changed, see end of mail.  
> 
> That is not a happy diff; that table has gotten waay worse to read due
> to all that extra table crap.

Not that I'm proposing such change, but, as a reference, I just discovered 
today that there's a way to make it even lighter than it is while still
showing it as a table:

=================  ======== ==   ================  ===== ==  ===========================================================
    Start addr        Offset        End addr         Size    VM area description
-----------------  -----------   ----------------  --------  -----------------------------------------------------------
 0000000000000000      0         00007fffffffffff    128 TB   user-space virtual memory, different per mm

 0000800000000000   +128    TB   ffff7fffffffffff   ~16M TB   ... huge, almost 64 bits wide hole of non-canonical
                                                                  virtual memory addresses up to the -128 TB
                                                                  starting offset of kernel mappings.

-----------------  -------- --   ----------------  ----- --  -----------------------------------------------------------
-                                                            Kernel-space virtual memory, shared between all processes:
-----------------  -----------   ----------------  --------  -----------------------------------------------------------

 ffff800000000000   -128    TB   ffff87ffffffffff      8 TB   ... guard hole, also reserved for hypervisor
 ffff880000000000   -120    TB   ffff887fffffffff    0.5 TB   LDT remap for PTI
 ffff888000000000   -119.5  TB   ffffc87fffffffff     64 TB   direct mapping of all physical memory (page_offset_base)
 ffffc88000000000    -55.5  TB   ffffc8ffffffffff    0.5 TB   ... unused hole
 ffffc90000000000    -55    TB   ffffe8ffffffffff     32 TB   vmalloc/ioremap space (vmalloc_base)
 ffffe90000000000    -23    TB   ffffe9ffffffffff      1 TB   ... unused hole
 ffffea0000000000    -22    TB   ffffeaffffffffff      1 TB   virtual memory map (vmemmap_base)
 ffffeb0000000000    -21    TB   ffffebffffffffff      1 TB   ... unused hole
 ffffec0000000000    -20    TB   fffffbffffffffff     16 TB   KASAN shadow memory
-----------------  -------- --   ----------------  ----- --  -----------------------------------------------------------
-                                                            Identical layout to the 56-bit one from here on:
-----------------  -----------   ----------------  --------  -----------------------------------------------------------

 fffffc0000000000     -4    TB   fffffdffffffffff      2 TB   ... unused hole
                                                              vaddr_end for KASLR
 fffffe0000000000     -2    TB   fffffe7fffffffff    0.5 TB   cpu_entry_area mapping
 fffffe8000000000     -1.5  TB   fffffeffffffffff    0.5 TB   ... unused hole
 ffffff0000000000     -1    TB   ffffff7fffffffff    0.5 TB   %esp fixup stacks
 ffffff8000000000   -512    GB   ffffffeeffffffff    444 GB   ... unused hole
 ffffffef00000000    -68    GB   fffffffeffffffff     64 GB   EFI region mapping space
 ffffffff00000000     -4    GB   ffffffff7fffffff      2 GB   ... unused hole
 ffffffff80000000     -2    GB   ffffffff9fffffff    512 MB   kernel text mapping, mapped to physical address 0
 ffffffff80000000  -2048    MB
 ffffffffa0000000  -1536    MB   fffffffffeffffff   1520 MB   module mapping space
 ffffffffff000000    -16    MB
    FIXADDR_START   ~-11    MB   ffffffffff5fffff   ~0.5 MB   kernel-internal fixmap range, variable size and offset
 ffffffffff600000    -10    MB   ffffffffff600fff      4 kB   legacy vsyscall ABI
 ffffffffffe00000     -2    MB   ffffffffffffffff      2 MB   ... unused hole
=================  ======== ==   ================  ===== ==  ===========================================================

If one wants the table headers as such, an extra line is required:


=================  ======== ==   ================  ===== ==  ===========================================================
    Start addr        Offset        End addr         Size    VM area description
-----------------  -----------   ----------------  --------  -----------------------------------------------------------
=================  ======== ==   ================  ===== ==  ===========================================================

<snip/>

=================  ======== ==   ================  ===== ==  ===========================================================


The output using this approach and a markup to use mono-spaced cells
e. g. either using ..raw or using .. cssclass as commented before in
this thread is at:

	https://www.infradead.org/~mchehab/rst_conversion/x86/x86_64/mm_alternative.html

Just converted the first table, keeping the other as a literal block.

Thanks,
Mauro
