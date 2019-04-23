From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v2 56/79] docs: Documentation/*.txt: rename all ReST
	files to *.rst
Date: Tue, 23 Apr 2019 23:38:16 +0200
Message-ID: <20190423213816.GE16353@zn.tnic>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
	<cda57849a6462ccc72dcd360b30068ab6a1021c4.1555938376.git.mchehab+samsung@kernel.org>
	<20190423083135.GA11158@hirez.programming.kicks-ass.net>
	<20190423125519.GA7104@redhat.com>
	<20190423130132.GT4038@hirez.programming.kicks-ass.net>
	<20190423103053.07cf2149@lwn.net>
	<20190423171158.GG12232@hirez.programming.kicks-ass.net>
	<20190423172006.GD16353@zn.tnic> <20190423170409.7b1370ac@coco.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190423170409.7b1370ac-qA1ZUp+OV9c@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab+samsung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Farhan Ali <alifm-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Halil Pasic <pasic-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, tboot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, openipmi-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nicholas Piggin <npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sean Paul <sean-p7yTbzM4H96eqtR555YLDQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-wireless@v
List-Id: dm-devel.ids

On Tue, Apr 23, 2019 at 05:05:02PM -0300, Mauro Carvalho Chehab wrote:
> That's my view about how that specific file would be after
> converted to ReST:
> 
> 	https://git.linuxtv.org/mchehab/experimental.git/tree/Documentation/x86/x86_64/mm.rst?h=convert_rst_renames
> 
> I don't have any troubles reading/understanding it as a plain text
> file,

If that is all the changes it would need, then I guess that's ok. Btw,
those rst-conversion patches don't really show what got changed. Dunno
if git can even show that properly. I diffed the two files by hand to
see what got changed, see end of mail.

So I guess if table in rst means, one needs to draw rows and columns, I
guess that's ok. It's not like I have to do it every day.

But exactly this - *having* to do rst formatting would mean a lot of
getting used to and people writing something which is not necessarily
correct rst and someone else fixing up after them.

Another pain point is changing the file paths. Without cscope I would've
been cursing each time I'm looking for kernel-parameters.txt, for
example. First of all, it is in Documentation/admin-guide/ now and then
there's Documentation/admin-guide/kernel-parameters.rst too.

I guess the .rst sucks in the .txt file and shows it monospaced. Oh
well.

So* I'd suggest having as less markup in those files as possible and if
it is needed, automate adding the needed markup, as Jon suggested.

The perfect example was the one which Peter gave and I had to paste in a
thread today:

"The memory allocations via :c:func:`kmalloc`, :c:func:`vmalloc`,
:c:func:`kmem_cache_alloc` and"

That is very unreadable.

Anyway, stuff like that. Just giving my feedback here in case you're
interested. :-)

> and its html output is also nice (although Sphinx 1.7.8 seems to
> have some issues when parsing some cells - probably due to some bug):
> 
> 	https://www.infradead.org/~mchehab/rst_conversion/x86/x86_64/mm.html

I don't know how that looks in your browser but in mine those addresses
are not in monospaced font and there's no properly reading them.

And yap, the cells parsing fun I see too.

> Changbin's approach was somewhat close to what you want. He simply
> prepended the tables with ::, in order to show them as plain old
> ascii:
> 
> 	https://lore.kernel.org/lkml/20190423162932.21428-60-changbin.du-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org/

Yap, that's better.

I mean, the file is just as readable in plain old ASCII, if not even
more so. At least to me but I prefer simple things so...

> 
> Both equally works, from ReST conversion PoV. I'm fine ether way.
> 
> I prefer my approach, as, IMHO, it is visually nicer on both text and
> html versions, but his approach is likely easier to maintain, as doing
> ascii artwork by hand is sometimes painful.

Yap.

Thx.

---
--- mm.old	2019-04-23 23:18:55.954335784 +0200
+++ mm.new	2019-04-23 23:18:48.122335821 +0200
@@ -18,51 +18,68 @@ Notes:
    notation than "16 EB", which few will recognize at first sight as 16 exabytes.
    It also shows it nicely how incredibly large 64-bit address space is.
 
-========================================================================================================================
-    Start addr    |   Offset   |     End addr     |  Size   | VM area description
-========================================================================================================================
-                  |            |                  |         |
- 0000000000000000 |    0       | 00007fffffffffff |  128 TB | user-space virtual memory, different per mm
-__________________|____________|__________________|_________|___________________________________________________________
-                  |            |                  |         |
- 0000800000000000 | +128    TB | ffff7fffffffffff | ~16M TB | ... huge, almost 64 bits wide hole of non-canonical
-                  |            |                  |         |     virtual memory addresses up to the -128 TB
-                  |            |                  |         |     starting offset of kernel mappings.
-__________________|____________|__________________|_________|___________________________________________________________
-                                                            |
-                                                            | Kernel-space virtual memory, shared between all processes:
-____________________________________________________________|___________________________________________________________
-                  |            |                  |         |
- ffff800000000000 | -128    TB | ffff87ffffffffff |    8 TB | ... guard hole, also reserved for hypervisor
- ffff880000000000 | -120    TB | ffff887fffffffff |  0.5 TB | LDT remap for PTI
- ffff888000000000 | -119.5  TB | ffffc87fffffffff |   64 TB | direct mapping of all physical memory (page_offset_base)
- ffffc88000000000 |  -55.5  TB | ffffc8ffffffffff |  0.5 TB | ... unused hole
- ffffc90000000000 |  -55    TB | ffffe8ffffffffff |   32 TB | vmalloc/ioremap space (vmalloc_base)
- ffffe90000000000 |  -23    TB | ffffe9ffffffffff |    1 TB | ... unused hole
- ffffea0000000000 |  -22    TB | ffffeaffffffffff |    1 TB | virtual memory map (vmemmap_base)
- ffffeb0000000000 |  -21    TB | ffffebffffffffff |    1 TB | ... unused hole
- ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN shadow memory
-__________________|____________|__________________|_________|____________________________________________________________
-                                                            |
-                                                            | Identical layout to the 56-bit one from here on:
-____________________________________________________________|____________________________________________________________
-                  |            |                  |         |
- fffffc0000000000 |   -4    TB | fffffdffffffffff |    2 TB | ... unused hole
-                  |            |                  |         | vaddr_end for KASLR
- fffffe0000000000 |   -2    TB | fffffe7fffffffff |  0.5 TB | cpu_entry_area mapping
- fffffe8000000000 |   -1.5  TB | fffffeffffffffff |  0.5 TB | ... unused hole
- ffffff0000000000 |   -1    TB | ffffff7fffffffff |  0.5 TB | %esp fixup stacks
- ffffff8000000000 | -512    GB | ffffffeeffffffff |  444 GB | ... unused hole
- ffffffef00000000 |  -68    GB | fffffffeffffffff |   64 GB | EFI region mapping space
- ffffffff00000000 |   -4    GB | ffffffff7fffffff |    2 GB | ... unused hole
- ffffffff80000000 |   -2    GB | ffffffff9fffffff |  512 MB | kernel text mapping, mapped to physical address 0
- ffffffff80000000 |-2048    MB |                  |         |
- ffffffffa0000000 |-1536    MB | fffffffffeffffff | 1520 MB | module mapping space
- ffffffffff000000 |  -16    MB |                  |         |
-    FIXADDR_START | ~-11    MB | ffffffffff5fffff | ~0.5 MB | kernel-internal fixmap range, variable size and offset
- ffffffffff600000 |  -10    MB | ffffffffff600fff |    4 kB | legacy vsyscall ABI
- ffffffffffe00000 |   -2    MB | ffffffffffffffff |    2 MB | ... unused hole
-__________________|____________|__________________|_________|___________________________________________________________
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|   Start addr    |   Offset   |     End addr     |  Size   | VM area description                                       |
++=================+============+==================+=========+===========================================================+
+|                 |            |                  |         |                                                           |
+|0000000000000000 |    0       | 00007fffffffffff |  128 TB | user-space virtual memory, different per mm               |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|                 |            |                  |         |                                                           |
+|0000800000000000 | +128    TB | ffff7fffffffffff | ~16M TB | ... huge, almost 64 bits wide hole of non-canonical       |
+|                 |            |                  |         | virtual memory addresses up to the -128 TB                |
+|                 |            |                  |         | starting offset of kernel mappings.                       |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|                      **Kernel-space virtual memory, shared between all processes:**                                   |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffff800000000000 | -128    TB | ffff87ffffffffff |    8 TB | ... guard hole, also reserved for hypervisor              |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffff880000000000 | -120    TB | ffff887fffffffff |  0.5 TB | LDT remap for PTI                                         |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffff888000000000 | -119.5  TB | ffffc87fffffffff |   64 TB | direct mapping of all physical memory (page_offset_base)  |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffc88000000000 |  -55.5  TB | ffffc8ffffffffff |  0.5 TB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffc90000000000 |  -55    TB | ffffe8ffffffffff |   32 TB | vmalloc/ioremap space (vmalloc_base)                      |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffe90000000000 |  -23    TB | ffffe9ffffffffff |    1 TB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffea0000000000 |  -22    TB | ffffeaffffffffff |    1 TB | virtual memory map (vmemmap_base)                         |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffeb0000000000 |  -21    TB | ffffebffffffffff |    1 TB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffec0000000000 |  -20    TB | fffffbffffffffff |   16 TB | KASAN shadow memory                                       |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|                         **Identical layout to the 56-bit one from here on:**                                          |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|fffffc0000000000 |   -4    TB | fffffdffffffffff |    2 TB | ... unused hole                                           |
+|                 |            |                  |         | vaddr_end for KASLR                                       |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|fffffe0000000000 |   -2    TB | fffffe7fffffffff |  0.5 TB | cpu_entry_area mapping                                    |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|fffffe8000000000 |   -1.5  TB | fffffeffffffffff |  0.5 TB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffff0000000000 |   -1    TB | ffffff7fffffffff |  0.5 TB | %esp fixup stacks                                         |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffff8000000000 | -512    GB | ffffffeeffffffff |  444 GB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffef00000000 |  -68    GB | fffffffeffffffff |   64 GB | EFI region mapping space                                  |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffff00000000 |   -4    GB | ffffffff7fffffff |    2 GB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffff80000000 |   -2    GB | ffffffff9fffffff |  512 MB | kernel text mapping, mapped to physical address 0         |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffff80000000 |-2048    MB |                  |         |                                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffffa0000000 |-1536    MB | fffffffffeffffff | 1520 MB | module mapping space                                      |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffffff000000 |  -16    MB |                  |         |                                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|   FIXADDR_START | ~-11    MB | ffffffffff5fffff | ~0.5 MB | kernel-internal fixmap range, variable size and offset    |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffffff600000 |  -10    MB | ffffffffff600fff |    4 kB | legacy vsyscall ABI                                       |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffffffe00000 |   -2    MB | ffffffffffffffff |    2 MB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
 
 
 ====================================================
@@ -76,51 +93,66 @@ Notes:
    offset and many of the regions expand to support the much larger physical
    memory supported.
 
-========================================================================================================================
-    Start addr    |   Offset   |     End addr     |  Size   | VM area description
-========================================================================================================================
-                  |            |                  |         |
- 0000000000000000 |    0       | 00ffffffffffffff |   64 PB | user-space virtual memory, different per mm
-__________________|____________|__________________|_________|___________________________________________________________
-                  |            |                  |         |
- 0100000000000000 |  +64    PB | feffffffffffffff | ~16K PB | ... huge, still almost 64 bits wide hole of non-canonical
-                  |            |                  |         |     virtual memory addresses up to the -64 PB
-                  |            |                  |         |     starting offset of kernel mappings.
-__________________|____________|__________________|_________|___________________________________________________________
-                                                            |
-                                                            | Kernel-space virtual memory, shared between all processes:
-____________________________________________________________|___________________________________________________________
-                  |            |                  |         |
- ff00000000000000 |  -64    PB | ff0fffffffffffff |    4 PB | ... guard hole, also reserved for hypervisor
- ff10000000000000 |  -60    PB | ff10ffffffffffff | 0.25 PB | LDT remap for PTI
- ff11000000000000 |  -59.75 PB | ff90ffffffffffff |   32 PB | direct mapping of all physical memory (page_offset_base)
- ff91000000000000 |  -27.75 PB | ff9fffffffffffff | 3.75 PB | ... unused hole
- ffa0000000000000 |  -24    PB | ffd1ffffffffffff | 12.5 PB | vmalloc/ioremap space (vmalloc_base)
- ffd2000000000000 |  -11.5  PB | ffd3ffffffffffff |  0.5 PB | ... unused hole
- ffd4000000000000 |  -11    PB | ffd5ffffffffffff |  0.5 PB | virtual memory map (vmemmap_base)
- ffd6000000000000 |  -10.5  PB | ffdeffffffffffff | 2.25 PB | ... unused hole
- ffdf000000000000 |   -8.25 PB | fffffbffffffffff |   ~8 PB | KASAN shadow memory
-__________________|____________|__________________|_________|____________________________________________________________
-                                                            |
-                                                            | Identical layout to the 47-bit one from here on:
-____________________________________________________________|____________________________________________________________
-                  |            |                  |         |
- fffffc0000000000 |   -4    TB | fffffdffffffffff |    2 TB | ... unused hole
-                  |            |                  |         | vaddr_end for KASLR
- fffffe0000000000 |   -2    TB | fffffe7fffffffff |  0.5 TB | cpu_entry_area mapping
- fffffe8000000000 |   -1.5  TB | fffffeffffffffff |  0.5 TB | ... unused hole
- ffffff0000000000 |   -1    TB | ffffff7fffffffff |  0.5 TB | %esp fixup stacks
- ffffff8000000000 | -512    GB | ffffffeeffffffff |  444 GB | ... unused hole
- ffffffef00000000 |  -68    GB | fffffffeffffffff |   64 GB | EFI region mapping space
- ffffffff00000000 |   -4    GB | ffffffff7fffffff |    2 GB | ... unused hole
- ffffffff80000000 |   -2    GB | ffffffff9fffffff |  512 MB | kernel text mapping, mapped to physical address 0
- ffffffff80000000 |-2048    MB |                  |         |
- ffffffffa0000000 |-1536    MB | fffffffffeffffff | 1520 MB | module mapping space
- ffffffffff000000 |  -16    MB |                  |         |
-    FIXADDR_START | ~-11    MB | ffffffffff5fffff | ~0.5 MB | kernel-internal fixmap range, variable size and offset
- ffffffffff600000 |  -10    MB | ffffffffff600fff |    4 kB | legacy vsyscall ABI
- ffffffffffe00000 |   -2    MB | ffffffffffffffff |    2 MB | ... unused hole
-__________________|____________|__________________|_________|___________________________________________________________
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|   Start addr    |   Offset   |     End addr     |  Size   | VM area description                                       |
++=================+============+==================+=========+===========================================================+
+|0000000000000000 |    0       | 00ffffffffffffff |   64 PB | user-space virtual memory, different per mm               |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|0100000000000000 |  +64    PB | feffffffffffffff | ~16K PB | ... huge, still almost 64 bits wide hole of non-canonical |
+|                 |            |                  |         | virtual memory addresses up to the -64 PB                 |
+|                 |            |                  |         | starting offset of kernel mappings.                       |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|                       **Kernel-space virtual memory, shared between all processes:**                                  |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ff00000000000000 |  -64    PB | ff0fffffffffffff |    4 PB | ... guard hole, also reserved for hypervisor              |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ff10000000000000 |  -60    PB | ff10ffffffffffff | 0.25 PB | LDT remap for PTI                                         |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ff11000000000000 |  -59.75 PB | ff90ffffffffffff |   32 PB | direct mapping of all physical memory (page_offset_base)  |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ff91000000000000 |  -27.75 PB | ff9fffffffffffff | 3.75 PB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffa0000000000000 |  -24    PB | ffd1ffffffffffff | 12.5 PB | vmalloc/ioremap space (vmalloc_base)                      |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffd2000000000000 |  -11.5  PB | ffd3ffffffffffff |  0.5 PB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffd4000000000000 |  -11    PB | ffd5ffffffffffff |  0.5 PB | virtual memory map (vmemmap_base)                         |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffd6000000000000 |  -10.5  PB | ffdeffffffffffff | 2.25 PB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffdf000000000000 |   -8.25 PB | fffffbffffffffff |   ~8 PB | KASAN shadow memory                                       |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|                           **Identical layout to the 47-bit one from here on:**                                        |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|fffffc0000000000 |   -4    TB | fffffdffffffffff |    2 TB | ... unused hole                                           |
+|                 |            |                  |         | vaddr_end for KASLR                                       |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|fffffe0000000000 |   -2    TB | fffffe7fffffffff |  0.5 TB | cpu_entry_area mapping                                    |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|fffffe8000000000 |   -1.5  TB | fffffeffffffffff |  0.5 TB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffff0000000000 |   -1    TB | ffffff7fffffffff |  0.5 TB | %esp fixup stacks                                         |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffff8000000000 | -512    GB | ffffffeeffffffff |  444 GB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffef00000000 |  -68    GB | fffffffeffffffff |   64 GB | EFI region mapping space                                  |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffff00000000 |   -4    GB | ffffffff7fffffff |    2 GB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffff80000000 |   -2    GB | ffffffff9fffffff |  512 MB | kernel text mapping, mapped to physical address 0         |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffff80000000 |-2048    MB |                  |         |                                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffffa0000000 |-1536    MB | fffffffffeffffff | 1520 MB | module mapping space                                      |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffffff000000 |  -16    MB |                  |         |                                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|   FIXADDR_START | ~-11    MB | ffffffffff5fffff | ~0.5 MB | kernel-internal fixmap range, variable size and offset    |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffffff600000 |  -10    MB | ffffffffff600fff |    4 kB | legacy vsyscall ABI                                       |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
+|ffffffffffe00000 |   -2    MB | ffffffffffffffff |    2 MB | ... unused hole                                           |
++-----------------+------------+------------------+---------+-----------------------------------------------------------+
 
 Architecture defines a 64-bit virtual address. Implementations can support
 less. Currently supported are 48- and 57-bit virtual addresses. Bits 63

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
