From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] memcpy_flushcache: use cache flusing for larger lengths
Date: Tue, 7 Apr 2020 09:09:30 -0700
Message-ID: <583AD128-5B10-4414-A35B-FEACF30B7C5A@amacapital.net>
References: <alpine.LRH.2.02.2004071029270.8662@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.2004071029270.8662@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids


> On Apr 7, 2020, at 8:01 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>=20
> =EF=BB=BF[ resending this to x86 maintainers ]
>=20
> Hi
>=20
> I tested performance of various methods how to write to optane-based
> persistent memory, and found out that non-temporal stores achieve=20
> throughput 1.3 GB/s. 8 cached stores immediatelly followed by clflushopt=20=

> or clwb achieve throughput 1.6 GB/s.
>=20
> memcpy_flushcache uses non-temporal stores, I modified it to use cached=20=

> stores + clflushopt and it improved performance of the dm-writecache=20
> target significantly:
>=20
> dm-writecache throughput:
> (dd if=3D/dev/zero of=3D/dev/mapper/wc bs=3D64k oflag=3Ddirect)
> writecache block size   512             1024            2048            40=
96
> movnti                  496 MB/s        642 MB/s        725 MB/s        74=
4 MB/s
> clflushopt              373 MB/s        688 MB/s        1.1 GB/s        1.=
2 GB/s
>=20
> For block size 512, movnti works better, for larger block sizes,=20
> clflushopt is better.
>=20
> I was also testing the novafs filesystem, it is not upstream, but it=20
> benefitted from similar change in __memcpy_flushcache and=20
> __copy_user_nocache:
> write throughput on big files - movnti: 662 MB/s, clwb: 1323 MB/s
> write throughput on small files - movnti: 621 MB/s, clwb: 1013 MB/s
>=20
>=20
> I submit this patch for __memcpy_flushcache that improves dm-writecache=20=

> performance.
>=20
> Other ideas - should we introduce memcpy_to_pmem instead of modifying=20
> memcpy_flushcache and move this logic there? Or should I modify the=20
> dm-writecache target directly to use clflushopt with no change to the=20
> architecture-specific code?
>=20
> Mikulas
>=20
>=20
>=20
>=20
> From: Mikulas Patocka <mpatocka@redhat.com>
>=20
> I tested dm-writecache performance on a machine with Optane nvdimm and it
> turned out that for larger writes, cached stores + cache flushing perform
> better than non-temporal stores. This is the throughput of dm-writecache
> measured with this command:
> dd if=3D/dev/zero of=3D/dev/mapper/wc bs=3D64 oflag=3Ddirect
>=20
> block size    512        1024        2048        4096
> movnti        496 MB/s    642 MB/s    725 MB/s    744 MB/s
> clflushopt    373 MB/s    688 MB/s    1.1 GB/s    1.2 GB/s
>=20
> We can see that for smaller block, movnti performs better, but for larger
> blocks, clflushopt has better performance.
>=20
> This patch changes the function __memcpy_flushcache accordingly, so that
> with size >=3D 768 it performs cached stores and cache flushing. Note that=

> we must not use the new branch if the CPU doesn't have clflushopt - in
> that case, the kernel would use inefficient "clflush" instruction that has=

> very bad performance.
>=20
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>=20
> ---
> arch/x86/lib/usercopy_64.c |   36 ++++++++++++++++++++++++++++++++++++
> 1 file changed, 36 insertions(+)
>=20
> Index: linux-2.6/arch/x86/lib/usercopy_64.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/x86/lib/usercopy_64.c    2020-03-24 15:15:36.64494=
5091 -0400
> +++ linux-2.6/arch/x86/lib/usercopy_64.c    2020-03-30 07:17:51.450290007 -=
0400
> @@ -152,6 +152,42 @@ void __memcpy_flushcache(void *_dst, con
>            return;
>    }
>=20
> +    if (static_cpu_has(X86_FEATURE_CLFLUSHOPT) && size >=3D 768 && likely=
(boot_cpu_data.x86_clflush_size =3D=3D 64)) {
> +        while (!IS_ALIGNED(dest, 64)) {
> +            asm("movq    (%0), %%r8\n"
> +                "movnti  %%r8,   (%1)\n"
> +                :: "r" (source), "r" (dest)
> +                : "memory", "r8");
> +            dest +=3D 8;
> +            source +=3D 8;
> +            size -=3D 8;
> +        }
> +        do {
> +            asm("movq    (%0), %%r8\n"
> +                "movq   8(%0), %%r9\n"
> +                "movq  16(%0), %%r10\n"
> +                "movq  24(%0), %%r11\n"
> +                "movq    %%r8,   (%1)\n"
> +                "movq    %%r9,  8(%1)\n"
> +                "movq   %%r10, 16(%1)\n"
> +                "movq   %%r11, 24(%1)\n"
> +                "movq  32(%0), %%r8\n"
> +                "movq  40(%0), %%r9\n"
> +                "movq  48(%0), %%r10\n"
> +                "movq  56(%0), %%r11\n"
> +                "movq    %%r8, 32(%1)\n"
> +                "movq    %%r9, 40(%1)\n"
> +                "movq   %%r10, 48(%1)\n"
> +                "movq   %%r11, 56(%1)\n"
> +                :: "r" (source), "r" (dest)
> +                : "memory", "r8", "r9", "r10", "r11");

Does this actually work better than the corresponding C code?

Also, that memory clobber probably isn=E2=80=99t doing your code generation a=
ny favors.  Experimentally, you have the constraints wrong. An =E2=80=9Cr=E2=
=80=9D constraint doesn=E2=80=99t tell GCC that you are dereferencing the po=
inter.  You need to use =E2=80=9Cm=E2=80=9D with a correctly-sized type.  Bu=
t I bet plain C is at least as good.

> +            clflushopt((void *)dest);
> +            dest +=3D 64;
> +            source +=3D 64;
> +            size -=3D 64;
> +        } while (size >=3D 64);
> +    }
> +
>    /* 4x8 movnti loop */
>    while (size >=3D 32) {
>        asm("movq    (%0), %%r8\n"
>=20
