From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] dm-writecache
Date: Fri, 24 Nov 2017 21:43:30 -0800
Message-ID: <CAA9_cmcRe8KXO+jWy8knqg4EMCgBYF1JAdgR=A2qHkVES+i9ZA@mail.gmail.com>
References: <alpine.LRH.2.02.1711222135371.2330@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1711222135371.2330@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 22, 2017 at 6:36 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> Hi
>
> Here I'm sending slighly update dm-writecache target.
>

I would expect some theory of operation documentation in the changelog
or in Documentation/ for a new driver.

> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
[..]
> +/*
> + * The clflushopt instruction is very slow on Broadwell, so we use non-temporal
> + * stores instead.
> + */

The clflushopt instruction's first instantiation in a cpu was after
Broadwell. Also, the performance of clflushopt does not much matter
when running on a system without ADR (asynchronous DRAM refresh) where
flushing the cpu cache can just leave the writes stranded on their way
to the DIMM. ADR is not available on general purpose servers until
ACPI 6.x NFIT-defined persistent memory platforms.

> +#ifdef CONFIG_X86_64

In general something is broken if we end up with per-arch ifdefs like
this in drivers to handle persistent memory. This should be using the
pmem api or extensions of it, and we need to settle on a mechanism for
upper-level drivers to ask if pmem is driving platform protected
persistent memory.

> +#define NT_STORE(dest, src)    asm ("movnti %1, %0" : "=m"(dest) : "r"(src))
> +#define FLUSH_RANGE(dax, ptr, size)  do { } while (0)
> +#define COMMIT_FLUSHED()       wmb()
> +#else
> +#define NT_STORE(dest, src)    ACCESS_ONCE(dest) = (src)
> +#define FLUSH_RANGE            dax_flush
> +#define COMMIT_FLUSHED()       do { } while (0)

Is this just for test purposes? How does the user discover that they
are running in a degraded mode as far as persistence guarantees? I
think we should be falling back DM_WRITECACHE_ONLY_SSD mode if we're
not on a pmem platform.
