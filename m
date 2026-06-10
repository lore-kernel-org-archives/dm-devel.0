Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AC340D570
	for <dm-devel@lists.linux.dev>; Wed, 10 Jun 2026 22:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781129389; cv=none; b=EH7F9OcMeNFrB9gWZUgFFn41PH+uK9thaGLPl8mV79vAl6vJaX/dvDG2GhvpAOTTe/dizazr/SV4iYrMlzLRmdxK1IXAX/a8hc53R0qCwrDftv45UC7j32WkLXg6uf/geMgEfe3pswErQ0dwumqnIwV6FxpS8s2Q1ODAaT9eE9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781129389; c=relaxed/simple;
	bh=9xB+gC2Tc3XO+5+Ua49bhxtMlpeEfpgR8gIrvh1jOeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=fgexfbnz4CwteMwQoDI3CNDHnWMA6rfAoxY7bILt61GX1XXuGeZaw7DuHW0p1LCyyDVXg0id+BfNmZSz3iJKDVq6bRY+xjxZNWGZ7UQhyJljW9l8yo0CEalMzXLHUw4MBflMj8LcVVBTEGaak7Stc0jePj26DEZTPSmXMpen4PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gEWP53y9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gEWP53y9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781129384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLi8tWXCqVRUiDP2wf7QZwI8FVL9J85kpqMunTDLDQs=;
	b=gEWP53y9LycMK7feWQ6afma6W5NmnMZ5q5TipObvVS9dzxwp+or9OPnRMaG3bc23ep+53C
	LiCfgO1YVooXkA2PnUSMZ1YLZfdb2/Lmy9PfvxTAMoXeEwQ//AX0Qjn/UGl6PxmB1aQ78h
	1gTXxQpGV2s5rNsG/nYSRh0bEt5LkuQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-192--JAaxJ3HPYmGOj47OE2m6Q-1; Wed,
 10 Jun 2026 18:09:40 -0400
X-MC-Unique: -JAaxJ3HPYmGOj47OE2m6Q-1
X-Mimecast-MFC-AGG-ID: -JAaxJ3HPYmGOj47OE2m6Q_1781129379
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D8B21964CF2;
	Wed, 10 Jun 2026 22:09:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B30D61954B05;
	Wed, 10 Jun 2026 22:09:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 65AM9bwG615192
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 18:09:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 65AM9b1j615191;
	Wed, 10 Jun 2026 18:09:37 -0400
Date: Wed, 10 Jun 2026 18:09:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Martin Wilck <mwilck@suse.com>,
        Christophe Varoqui <christophe.varoqui@opensvc.com>,
        DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH 1/1] multipath-tools: update third-party valgrind headers
 to v3.28
Message-ID: <aingoZvGkFxy8Wvs@redhat.com>
References: <20260608085547.41471-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260608085547.41471-1-xose.vazquez@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1kyEO2pTX8OenvXEjrSAzaWuxc1fzZdZYXq8k45xDVc_1781129379
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 08, 2026 at 10:55:47AM +0200, Xose Vazquez Perez wrote:
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  third-party/valgrind/drd.h      |    6 +-
>  third-party/valgrind/valgrind.h | 1182 +++++++++++++++++++++++++++++--
>  2 files changed, 1138 insertions(+), 50 deletions(-)

Is valgrind 3.28 released yet? I only see 3.27.1.

-Ben

> 
> diff --git a/third-party/valgrind/drd.h b/third-party/valgrind/drd.h
> index d63b3dd2..679954e5 100644
> --- a/third-party/valgrind/drd.h
> +++ b/third-party/valgrind/drd.h
> @@ -3,7 +3,7 @@
>  
>    Notice that the following BSD-style license applies to this one
>    file (drd.h) only.  The rest of Valgrind is licensed under the
> -  terms of the GNU General Public License, version 2, unless
> +  terms of the GNU General Public License, version 3, unless
>    otherwise indicated.  See the COPYING file in the source
>    distribution for details.
>  
> @@ -12,7 +12,7 @@
>    This file is part of DRD, a Valgrind tool for verification of
>    multithreaded programs.
>  
> -  Copyright (C) 2006-2017 Bart Van Assche <bvanassche@acm.org>.
> +  Copyright (C) 2006-2020 Bart Van Assche <bvanassche@acm.org>.
>    All rights reserved.
>  
>    Redistribution and use in source and binary forms, with or without
> @@ -50,7 +50,7 @@
>  
>    Notice that the above BSD-style license applies to this one file
>    (drd.h) only.  The entire rest of Valgrind is licensed under
> -  the terms of the GNU General Public License, version 2.  See the
> +  the terms of the GNU General Public License, version 3.  See the
>    COPYING file in the source distribution for details.
>  
>    ----------------------------------------------------------------
> diff --git a/third-party/valgrind/valgrind.h b/third-party/valgrind/valgrind.h
> index 1633b318..3caae1f9 100644
> --- a/third-party/valgrind/valgrind.h
> +++ b/third-party/valgrind/valgrind.h
> @@ -3,7 +3,7 @@
>  
>     Notice that the following BSD-style license applies to this one
>     file (valgrind.h) only.  The rest of Valgrind is licensed under the
> -   terms of the GNU General Public License, version 2, unless
> +   terms of the GNU General Public License, version 3, unless
>     otherwise indicated.  See the COPYING file in the source
>     distribution for details.
>  
> @@ -49,7 +49,7 @@
>  
>     Notice that the above BSD-style license applies to this one file
>     (valgrind.h) only.  The entire rest of Valgrind is licensed under
> -   the terms of the GNU General Public License, version 2.  See the
> +   the terms of the GNU General Public License, version 3.  See the
>     COPYING file in the source distribution for details.
>  
>     ---------------------------------------------------------------- 
> @@ -89,7 +89,7 @@
>          || (__VALGRIND_MAJOR__ == 3 && __VALGRIND_MINOR__ >= 6))
>  */
>  #define __VALGRIND_MAJOR__    3
> -#define __VALGRIND_MINOR__    14
> +#define __VALGRIND_MINOR__    28
>  
>  
>  #include <stdarg.h>
> @@ -110,6 +110,9 @@
>  */
>  #undef PLAT_x86_darwin
>  #undef PLAT_amd64_darwin
> +#undef PLAT_x86_freebsd
> +#undef PLAT_amd64_freebsd
> +#undef PLAT_arm64_freebsd
>  #undef PLAT_x86_win32
>  #undef PLAT_amd64_win64
>  #undef PLAT_x86_linux
> @@ -122,6 +125,8 @@
>  #undef PLAT_s390x_linux
>  #undef PLAT_mips32_linux
>  #undef PLAT_mips64_linux
> +#undef PLAT_nanomips_linux
> +#undef PLAT_riscv64_linux
>  #undef PLAT_x86_solaris
>  #undef PLAT_amd64_solaris
>  
> @@ -130,12 +135,19 @@
>  #  define PLAT_x86_darwin 1
>  #elif defined(__APPLE__) && defined(__x86_64__)
>  #  define PLAT_amd64_darwin 1
> -#elif (defined(__MINGW32__) && !defined(__MINGW64__)) \
> +#elif defined(__FreeBSD__) && defined(__i386__)
> +#  define PLAT_x86_freebsd 1
> +#elif defined(__FreeBSD__) && defined(__amd64__)
> +#  define PLAT_amd64_freebsd 1
> +#elif defined(__FreeBSD__) && defined(__aarch64__) && !defined(__arm__)
> +#  define PLAT_arm64_freebsd 1
> +#elif (defined(__MINGW32__) && defined(__i386__)) \
>        || defined(__CYGWIN32__) \
>        || (defined(_WIN32) && defined(_M_IX86))
>  #  define PLAT_x86_win32 1
> -#elif defined(__MINGW64__) \
> -      || (defined(_WIN64) && defined(_M_X64))
> +#elif (defined(__MINGW32__) && defined(__x86_64__)) \
> +      || (defined(_WIN32) && defined(_M_X64))
> +/* __MINGW32__ and _WIN32 are defined in 64 bit mode as well. */
>  #  define PLAT_amd64_win64 1
>  #elif defined(__linux__) && defined(__i386__)
>  #  define PLAT_x86_linux 1
> @@ -157,8 +169,12 @@
>  #  define PLAT_s390x_linux 1
>  #elif defined(__linux__) && defined(__mips__) && (__mips==64)
>  #  define PLAT_mips64_linux 1
> -#elif defined(__linux__) && defined(__mips__) && (__mips!=64)
> +#elif defined(__linux__) && defined(__mips__) && (__mips==32)
>  #  define PLAT_mips32_linux 1
> +#elif defined(__linux__) && defined(__nanomips__)
> +#  define PLAT_nanomips_linux 1
> +#elif defined(__linux__) && defined(__riscv) && (__riscv_xlen == 64)
> +#  define PLAT_riscv64_linux 1
>  #elif defined(__sun) && defined(__i386__)
>  #  define PLAT_x86_solaris 1
>  #elif defined(__sun) && defined(__x86_64__)
> @@ -250,11 +266,11 @@
>     inline asm stuff to be useful.
>  */
>  
> -/* ----------------- x86-{linux,darwin,solaris} ---------------- */
> +/* -------------- x86-{linux,darwin,solaris,freebsd} ------------- */
>  
>  #if defined(PLAT_x86_linux)  ||  defined(PLAT_x86_darwin)  \
>      ||  (defined(PLAT_x86_win32) && defined(__GNUC__)) \
> -    ||  defined(PLAT_x86_solaris)
> +    ||  defined(PLAT_x86_solaris) || defined(PLAT_x86_freebsd)
>  
>  typedef
>     struct { 
> @@ -315,7 +331,7 @@ typedef
>   } while (0)
>  
>  #endif /* PLAT_x86_linux || PLAT_x86_darwin || (PLAT_x86_win32 && __GNUC__)
> -          || PLAT_x86_solaris */
> +          || PLAT_x86_solaris || PLAT_x86_freebsd */
>  
>  /* ------------------------- x86-Win32 ------------------------- */
>  
> @@ -390,10 +406,11 @@ valgrind_do_client_request_expr(uintptr_t _zzq_default, uintptr_t _zzq_request,
>  
>  #endif /* PLAT_x86_win32 */
>  
> -/* ----------------- amd64-{linux,darwin,solaris} --------------- */
> +/* -------------- amd64-{linux,darwin,solaris,freebsd} ------------ */
>  
>  #if defined(PLAT_amd64_linux)  ||  defined(PLAT_amd64_darwin) \
>      ||  defined(PLAT_amd64_solaris) \
> +    ||  defined(PLAT_amd64_freebsd) \
>      ||  (defined(PLAT_amd64_win64) && defined(__GNUC__))
>  
>  typedef
> @@ -454,7 +471,8 @@ typedef
>                      );                                           \
>   } while (0)
>  
> -#endif /* PLAT_amd64_linux || PLAT_amd64_darwin || PLAT_amd64_solaris */
> +#endif /* PLAT_amd64_linux || PLAT_amd64_darwin
> +          || PLAT_amd64_solaris || PLAT_amd64_freebsd */
>  
>  /* ------------------------- amd64-Win64 ------------------------- */
>  
> @@ -757,9 +775,9 @@ typedef
>  
>  #endif /* PLAT_arm_linux */
>  
> -/* ------------------------ arm64-linux ------------------------- */
> +/* -------------------- arm64-{linux,freebsd} -------------------- */
>  
> -#if defined(PLAT_arm64_linux)
> +#if defined(PLAT_arm64_linux) || defined(PLAT_arm64_freebsd)
>  
>  typedef
>     struct { 
> @@ -824,7 +842,7 @@ typedef
>                      );                                           \
>   } while (0)
>  
> -#endif /* PLAT_arm64_linux */
> +#endif /* PLAT_arm64_linux || PLAT_arm64_freebsd */
>  
>  /* ------------------------ s390x-linux ------------------------ */
>  
> @@ -872,7 +890,8 @@ typedef
>                      /* results = r3 */                           \
>                      "lgr %0, 3\n\t"                              \
>                      : "=d" (_zzq_result)                         \
> -                    : "a" (&_zzq_args[0]), "0" (_zzq_default)    \
> +                    : "a" (&_zzq_args[0]),                       \
> +                      "0" ((unsigned long int)_zzq_default)      \
>                      : "cc", "2", "3", "memory"                   \
>                     );                                            \
>     _zzq_result;                                                  \
> @@ -1045,6 +1064,156 @@ typedef
>  
>  #endif /* PLAT_mips64_linux */
>  
> +#if defined(PLAT_nanomips_linux)
> +
> +typedef
> +   struct {
> +      unsigned int nraddr; /* where's the code? */
> +   }
> +   OrigFn;
> +/*
> +   8000 c04d  srl  zero, zero, 13
> +   8000 c05d  srl  zero, zero, 29
> +   8000 c043  srl  zero, zero,  3
> +   8000 c053  srl  zero, zero, 19
> +*/
> +
> +#define __SPECIAL_INSTRUCTION_PREAMBLE "srl[32] $zero, $zero, 13 \n\t" \
> +                                       "srl[32] $zero, $zero, 29 \n\t" \
> +                                       "srl[32] $zero, $zero, 3  \n\t" \
> +                                       "srl[32] $zero, $zero, 19 \n\t"
> +
> +#define VALGRIND_DO_CLIENT_REQUEST_EXPR(                          \
> +       _zzq_default, _zzq_request,                                \
> +       _zzq_arg1, _zzq_arg2, _zzq_arg3, _zzq_arg4, _zzq_arg5)     \
> +  __extension__                                                   \
> +  ({ volatile unsigned int _zzq_args[6];                          \
> +    volatile unsigned int _zzq_result;                            \
> +    _zzq_args[0] = (unsigned int)(_zzq_request);                  \
> +    _zzq_args[1] = (unsigned int)(_zzq_arg1);                     \
> +    _zzq_args[2] = (unsigned int)(_zzq_arg2);                     \
> +    _zzq_args[3] = (unsigned int)(_zzq_arg3);                     \
> +    _zzq_args[4] = (unsigned int)(_zzq_arg4);                     \
> +    _zzq_args[5] = (unsigned int)(_zzq_arg5);                     \
> +    __asm__ volatile("move $a7, %1\n\t" /* default */             \
> +                     "move $t0, %2\n\t" /* ptr */                 \
> +                     __SPECIAL_INSTRUCTION_PREAMBLE               \
> +                     /* $a7 = client_request( $t0 ) */            \
> +                     "or[32] $t0, $t0, $t0\n\t"                   \
> +                     "move %0, $a7\n\t"     /* result */          \
> +                     : "=r" (_zzq_result)                         \
> +                     : "r" (_zzq_default), "r" (&_zzq_args[0])    \
> +                     : "$a7", "$t0", "memory");                   \
> +    _zzq_result;                                                  \
> +  })
> +
> +#define VALGRIND_GET_NR_CONTEXT(_zzq_rlval)                         \
> +  { volatile OrigFn* _zzq_orig = &(_zzq_rlval);                     \
> +    volatile unsigned long int __addr;                              \
> +    __asm__ volatile(__SPECIAL_INSTRUCTION_PREAMBLE                 \
> +                     /* $a7 = guest_NRADDR */                       \
> +                     "or[32] $t1, $t1, $t1\n\t"                     \
> +                     "move %0, $a7"     /*result*/                  \
> +                     : "=r" (__addr)                                \
> +                     :                                              \
> +                     : "$a7");                                      \
> +    _zzq_orig->nraddr = __addr;                                     \
> +  }
> +
> +#define VALGRIND_CALL_NOREDIR_T9                                    \
> +                     __SPECIAL_INSTRUCTION_PREAMBLE                 \
> +                     /* call-noredir $25 */                         \
> +                     "or[32] $t2, $t2, $t2\n\t"
> +
> +#define VALGRIND_VEX_INJECT_IR()                                    \
> + do {                                                               \
> +    __asm__ volatile(__SPECIAL_INSTRUCTION_PREAMBLE                 \
> +                     "or[32] $t3, $t3, $t3\n\t"                     \
> +                    );                                              \
> + } while (0)
> +
> +#endif
> +
> +/* ----------------------- riscv64-linux ------------------------ */
> +
> +#if defined(PLAT_riscv64_linux)
> +
> +typedef
> +   struct {
> +      unsigned long int nraddr; /* where's the code? */
> +   }
> +   OrigFn;
> +
> +#define __SPECIAL_INSTRUCTION_PREAMBLE                            \
> +            ".option push\n\t"                                    \
> +            ".option norvc\n\t"                                   \
> +            "srli zero, zero, 3\n\t"                              \
> +            "srli zero, zero, 13\n\t"                             \
> +            "srli zero, zero, 51\n\t"                             \
> +            "srli zero, zero, 61\n\t"
> +
> +#define __SPECIAL_INSTRUCTION_POSTAMBLE                           \
> +            ".option pop\n\t"                                     \
> +
> +#define VALGRIND_DO_CLIENT_REQUEST_EXPR(                          \
> +        _zzq_default, _zzq_request,                               \
> +        _zzq_arg1, _zzq_arg2, _zzq_arg3, _zzq_arg4, _zzq_arg5)    \
> +                                                                  \
> +  __extension__                                                   \
> +  ({volatile unsigned long int  _zzq_args[6];                     \
> +    volatile unsigned long int  _zzq_result;                      \
> +    _zzq_args[0] = (unsigned long int)(_zzq_request);             \
> +    _zzq_args[1] = (unsigned long int)(_zzq_arg1);                \
> +    _zzq_args[2] = (unsigned long int)(_zzq_arg2);                \
> +    _zzq_args[3] = (unsigned long int)(_zzq_arg3);                \
> +    _zzq_args[4] = (unsigned long int)(_zzq_arg4);                \
> +    _zzq_args[5] = (unsigned long int)(_zzq_arg5);                \
> +    __asm__ volatile("mv a3, %1\n\t" /*default*/                  \
> +                     "mv a4, %2\n\t" /*ptr*/                      \
> +                     __SPECIAL_INSTRUCTION_PREAMBLE               \
> +                     /* a3 = client_request ( a4 ) */             \
> +                     "or a0, a0, a0\n\t"                          \
> +                     __SPECIAL_INSTRUCTION_POSTAMBLE              \
> +                     "mv %0, a3"     /*result*/                   \
> +                     : "=r" (_zzq_result)                         \
> +                     : "r" ((unsigned long int)(_zzq_default)),   \
> +                       "r" (&_zzq_args[0])                        \
> +                     : "memory", "a3", "a4");                     \
> +    _zzq_result;                                                  \
> +  })
> +
> +#define VALGRIND_GET_NR_CONTEXT(_zzq_rlval)                       \
> +  { volatile OrigFn* _zzq_orig = &(_zzq_rlval);                   \
> +    unsigned long int __addr;                                     \
> +    __asm__ volatile(__SPECIAL_INSTRUCTION_PREAMBLE               \
> +                     /* a3 = guest_NRADDR */                      \
> +                     "or a1, a1, a1\n\t"                          \
> +                     __SPECIAL_INSTRUCTION_POSTAMBLE              \
> +                     "mv %0, a3"                                  \
> +                     : "=r" (__addr)                              \
> +                     :                                            \
> +                     : "memory", "a3"                             \
> +                    );                                            \
> +    _zzq_orig->nraddr = __addr;                                   \
> +  }
> +
> +#define VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                    \
> +                     __SPECIAL_INSTRUCTION_PREAMBLE               \
> +                     /* branch-and-link-to-noredir t0 */          \
> +                     "or a2, a2, a2\n\t"                          \
> +                     __SPECIAL_INSTRUCTION_POSTAMBLE
> +
> +#define VALGRIND_VEX_INJECT_IR()                                 \
> + do {                                                            \
> +    __asm__ volatile(__SPECIAL_INSTRUCTION_PREAMBLE              \
> +                     "or a3, a3, a3\n\t"                         \
> +                     __SPECIAL_INSTRUCTION_POSTAMBLE             \
> +                     : : : "memory"                              \
> +                    );                                           \
> + } while (0)
> +
> +#endif /* PLAT_riscv64_linux */
> +
>  /* Insert assembly code for other platforms here... */
>  
>  #endif /* NVALGRIND */
> @@ -1075,7 +1244,7 @@ typedef
>  
>  /* Use these to write the name of your wrapper.  NOTE: duplicates
>     VG_WRAP_FUNCTION_Z{U,Z} in pub_tool_redir.h.  NOTE also: inserts
> -   the default behaviour equivalence class tag "0000" into the name.
> +   the default behaviour equivalance class tag "0000" into the name.
>     See pub_tool_redir.h for details -- normally you don't need to
>     think about this, though. */
>  
> @@ -1142,10 +1311,10 @@ typedef
>     do { volatile unsigned long _junk;                             \
>          CALL_FN_W_7W(_junk,fnptr,arg1,arg2,arg3,arg4,arg5,arg6,arg7); } while (0)
>  
> -/* ----------------- x86-{linux,darwin,solaris} ---------------- */
> +/* -------------- x86-{linux,darwin,solaris,freebsd} ------------- */
>  
>  #if defined(PLAT_x86_linux)  ||  defined(PLAT_x86_darwin) \
> -    ||  defined(PLAT_x86_solaris)
> +    ||  defined(PLAT_x86_solaris)  || defined(PLAT_x86_freebsd)
>  
>  /* These regs are trashed by the hidden call.  No need to mention eax
>     as gcc can already see that, plus causes gcc to bomb. */
> @@ -1572,12 +1741,13 @@ typedef
>        lval = (__typeof__(lval)) _res;                             \
>     } while (0)
>  
> -#endif /* PLAT_x86_linux || PLAT_x86_darwin || PLAT_x86_solaris */
> +#endif /* PLAT_x86_linux || PLAT_x86_darwin
> +          || PLAT_x86_solaris || PLAT_x86_freebsd */
>  
> -/* ---------------- amd64-{linux,darwin,solaris} --------------- */
> +/* ------------- amd64-{linux,darwin,solaris,freebsd} ------------ */
>  
>  #if defined(PLAT_amd64_linux)  ||  defined(PLAT_amd64_darwin) \
> -    ||  defined(PLAT_amd64_solaris)
> +    ||  defined(PLAT_amd64_solaris)  ||  defined(PLAT_amd64_freebsd)
>  
>  /* ARGREGS: rdi rsi rdx rcx r8 r9 (the rest on stack in R-to-L order) */
>  
> @@ -1620,11 +1790,11 @@ typedef
>     and say that %r15 is trashed instead.  gcc seems happy to go with
>     that.
>  
> -   Oh .. and this all needs to be conditionalized so that it is
> +   Oh .. and this all needs to be conditionalised so that it is
>     unchanged from before this commit, when compiled with older gccs
>     that don't support __builtin_dwarf_cfa.  Furthermore, since
>     this header file is freestanding, it has to be independent of
> -   config.h, and so the following conditionalization cannot depend on
> +   config.h, and so the following conditionalisation cannot depend on
>     configure time checks.
>  
>     Although it's not clear from
> @@ -1673,7 +1843,7 @@ typedef
>  /* NB 9 Sept 07.  There is a nasty kludge here in all these CALL_FN_
>     macros.  In order not to trash the stack redzone, we need to drop
>     %rsp by 128 before the hidden call, and restore afterwards.  The
> -   nastiness is that it is only by luck that the stack still appears
> +   nastyness is that it is only by luck that the stack still appears
>     to be unwindable during the hidden call - since then the behaviour
>     of any routine using this macro does not match what the CFI data
>     says.  Sigh.
> @@ -2126,7 +2296,8 @@ typedef
>        lval = (__typeof__(lval)) _res;                                  \
>     } while (0)
>  
> -#endif /* PLAT_amd64_linux || PLAT_amd64_darwin || PLAT_amd64_solaris */
> +#endif /* PLAT_amd64_linux || PLAT_amd64_darwin
> +          || PLAT_amd64_solaris || PLAT_amd64_freebsd */
>  
>  /* ------------------------ ppc32-linux ------------------------ */
>  
> @@ -4200,9 +4371,9 @@ typedef
>  
>  #endif /* PLAT_arm_linux */
>  
> -/* ------------------------ arm64-linux ------------------------ */
> +/* ------------------- arm64-{linux,freebsd} -------------------- */
>  
> -#if defined(PLAT_arm64_linux)
> +#if defined(PLAT_arm64_linux) || defined(PLAT_arm64_freebsd)
>  
>  /* These regs are trashed by the hidden call. */
>  #define __CALLER_SAVED_REGS \
> @@ -4649,7 +4820,7 @@ typedef
>        lval = (__typeof__(lval)) _res;                             \
>     } while (0)
>  
> -#endif /* PLAT_arm64_linux */
> +#endif /* PLAT_arm64_linux || PLAT_arm64_freebsd */
>  
>  /* ------------------------- s390x-linux ------------------------- */
>  
> @@ -4667,7 +4838,7 @@ typedef
>        "lgr 1,%1\n\t" /* copy the argvec pointer in r1 */          \
>        "lgr 7,11\n\t"                                              \
>        "lgr 11,%2\n\t"                                             \
> -      ".cfi_def_cfa r11, 0\n\t"
> +      ".cfi_def_cfa 11, 0\n\t"
>  #  define VALGRIND_CFI_EPILOGUE                                   \
>        "lgr 11, 7\n\t"                                             \
>        ".cfi_restore_state\n\t"
> @@ -4687,8 +4858,16 @@ typedef
>     r14 in s390_irgen_noredir (VEX/priv/guest_s390_irgen.c) to give the
>     function a proper return address. All others are ABI defined call
>     clobbers. */
> -#define __CALLER_SAVED_REGS "0","1","2","3","4","5","14", \
> -                           "f0","f1","f2","f3","f4","f5","f6","f7"
> +#if defined(__VX__) || defined(__S390_VX__)
> +#define __CALLER_SAVED_REGS "0", "1", "2", "3", "4", "5", "14",   \
> +      "v0", "v1", "v2", "v3", "v4", "v5", "v6", "v7",             \
> +      "v8", "v9", "v10", "v11", "v12", "v13", "v14", "v15",       \
> +      "v16", "v17", "v18", "v19", "v20", "v21", "v22", "v23",     \
> +      "v24", "v25", "v26", "v27", "v28", "v29", "v30", "v31"
> +#else
> +#define __CALLER_SAVED_REGS "0", "1", "2", "3", "4", "5", "14",   \
> +      "f0", "f1", "f2", "f3", "f4", "f5", "f6", "f7"
> +#endif
>  
>  /* Nb: Although r11 is modified in the asm snippets below (inside 
>     VALGRIND_CFI_PROLOGUE) it is not listed in the clobber section, for
> @@ -4710,9 +4889,9 @@ typedef
>           "aghi 15,-160\n\t"                                      \
>           "lg 1, 0(1)\n\t"  /* target->r1 */                      \
>           VALGRIND_CALL_NOREDIR_R1                                \
> -         "lgr %0, 2\n\t"                                         \
>           "aghi 15,160\n\t"                                       \
>           VALGRIND_CFI_EPILOGUE                                   \
> +         "lgr %0, 2\n\t"                                         \
>           : /*out*/   "=d" (_res)                                 \
>           : /*in*/    "d" (&_argvec[0]) __FRAME_POINTER           \
>           : /*trash*/ "cc", "memory", __CALLER_SAVED_REGS,"7"     \
> @@ -4734,9 +4913,9 @@ typedef
>           "lg 2, 8(1)\n\t"                                        \
>           "lg 1, 0(1)\n\t"                                        \
>           VALGRIND_CALL_NOREDIR_R1                                \
> -         "lgr %0, 2\n\t"                                         \
>           "aghi 15,160\n\t"                                       \
>           VALGRIND_CFI_EPILOGUE                                   \
> +         "lgr %0, 2\n\t"                                         \
>           : /*out*/   "=d" (_res)                                 \
>           : /*in*/    "a" (&_argvec[0]) __FRAME_POINTER           \
>           : /*trash*/ "cc", "memory", __CALLER_SAVED_REGS,"7"     \
> @@ -4759,9 +4938,9 @@ typedef
>           "lg 3,16(1)\n\t"                                        \
>           "lg 1, 0(1)\n\t"                                        \
>           VALGRIND_CALL_NOREDIR_R1                                \
> -         "lgr %0, 2\n\t"                                         \
>           "aghi 15,160\n\t"                                       \
>           VALGRIND_CFI_EPILOGUE                                   \
> +         "lgr %0, 2\n\t"                                         \
>           : /*out*/   "=d" (_res)                                 \
>           : /*in*/    "a" (&_argvec[0]) __FRAME_POINTER           \
>           : /*trash*/ "cc", "memory", __CALLER_SAVED_REGS,"7"     \
> @@ -4786,9 +4965,9 @@ typedef
>           "lg 4,24(1)\n\t"                                        \
>           "lg 1, 0(1)\n\t"                                        \
>           VALGRIND_CALL_NOREDIR_R1                                \
> -         "lgr %0, 2\n\t"                                         \
>           "aghi 15,160\n\t"                                       \
>           VALGRIND_CFI_EPILOGUE                                   \
> +         "lgr %0, 2\n\t"                                         \
>           : /*out*/   "=d" (_res)                                 \
>           : /*in*/    "a" (&_argvec[0]) __FRAME_POINTER           \
>           : /*trash*/ "cc", "memory", __CALLER_SAVED_REGS,"7"     \
> @@ -4815,9 +4994,9 @@ typedef
>           "lg 5,32(1)\n\t"                                        \
>           "lg 1, 0(1)\n\t"                                        \
>           VALGRIND_CALL_NOREDIR_R1                                \
> -         "lgr %0, 2\n\t"                                         \
>           "aghi 15,160\n\t"                                       \
>           VALGRIND_CFI_EPILOGUE                                   \
> +         "lgr %0, 2\n\t"                                         \
>           : /*out*/   "=d" (_res)                                 \
>           : /*in*/    "a" (&_argvec[0]) __FRAME_POINTER           \
>           : /*trash*/ "cc", "memory", __CALLER_SAVED_REGS,"7"     \
> @@ -4846,9 +5025,9 @@ typedef
>           "lg 6,40(1)\n\t"                                        \
>           "lg 1, 0(1)\n\t"                                        \
>           VALGRIND_CALL_NOREDIR_R1                                \
> -         "lgr %0, 2\n\t"                                         \
>           "aghi 15,160\n\t"                                       \
>           VALGRIND_CFI_EPILOGUE                                   \
> +         "lgr %0, 2\n\t"                                         \
>           : /*out*/   "=d" (_res)                                 \
>           : /*in*/    "a" (&_argvec[0]) __FRAME_POINTER           \
>           : /*trash*/ "cc", "memory", __CALLER_SAVED_REGS,"6","7" \
> @@ -4880,9 +5059,9 @@ typedef
>           "mvc 160(8,15), 48(1)\n\t"                              \
>           "lg 1, 0(1)\n\t"                                        \
>           VALGRIND_CALL_NOREDIR_R1                                \
> -         "lgr %0, 2\n\t"                                         \
>           "aghi 15,168\n\t"                                       \
>           VALGRIND_CFI_EPILOGUE                                   \
> +         "lgr %0, 2\n\t"                                         \
>           : /*out*/   "=d" (_res)                                 \
>           : /*in*/    "a" (&_argvec[0]) __FRAME_POINTER           \
>           : /*trash*/ "cc", "memory", __CALLER_SAVED_REGS,"6","7" \
> @@ -4916,9 +5095,9 @@ typedef
>           "mvc 168(8,15), 56(1)\n\t"                              \
>           "lg 1, 0(1)\n\t"                                        \
>           VALGRIND_CALL_NOREDIR_R1                                \
> -         "lgr %0, 2\n\t"                                         \
>           "aghi 15,176\n\t"                                       \
>           VALGRIND_CFI_EPILOGUE                                   \
> +         "lgr %0, 2\n\t"                                         \
>           : /*out*/   "=d" (_res)                                 \
>           : /*in*/    "a" (&_argvec[0]) __FRAME_POINTER           \
>           : /*trash*/ "cc", "memory", __CALLER_SAVED_REGS,"6","7" \
> @@ -4954,9 +5133,9 @@ typedef
>           "mvc 176(8,15), 64(1)\n\t"                              \
>           "lg 1, 0(1)\n\t"                                        \
>           VALGRIND_CALL_NOREDIR_R1                                \
> -         "lgr %0, 2\n\t"                                         \
>           "aghi 15,184\n\t"                                       \
>           VALGRIND_CFI_EPILOGUE                                   \
> +         "lgr %0, 2\n\t"                                         \
>           : /*out*/   "=d" (_res)                                 \
>           : /*in*/    "a" (&_argvec[0]) __FRAME_POINTER           \
>           : /*trash*/ "cc", "memory", __CALLER_SAVED_REGS,"6","7" \
> @@ -4994,9 +5173,9 @@ typedef
>           "mvc 184(8,15), 72(1)\n\t"                              \
>           "lg 1, 0(1)\n\t"                                        \
>           VALGRIND_CALL_NOREDIR_R1                                \
> -         "lgr %0, 2\n\t"                                         \
>           "aghi 15,192\n\t"                                       \
>           VALGRIND_CFI_EPILOGUE                                   \
> +         "lgr %0, 2\n\t"                                         \
>           : /*out*/   "=d" (_res)                                 \
>           : /*in*/    "a" (&_argvec[0]) __FRAME_POINTER           \
>           : /*trash*/ "cc", "memory", __CALLER_SAVED_REGS,"6","7" \
> @@ -5036,9 +5215,9 @@ typedef
>           "mvc 192(8,15), 80(1)\n\t"                              \
>           "lg 1, 0(1)\n\t"                                        \
>           VALGRIND_CALL_NOREDIR_R1                                \
> -         "lgr %0, 2\n\t"                                         \
>           "aghi 15,200\n\t"                                       \
>           VALGRIND_CFI_EPILOGUE                                   \
> +         "lgr %0, 2\n\t"                                         \
>           : /*out*/   "=d" (_res)                                 \
>           : /*in*/    "a" (&_argvec[0]) __FRAME_POINTER           \
>           : /*trash*/ "cc", "memory", __CALLER_SAVED_REGS,"6","7" \
> @@ -5080,9 +5259,9 @@ typedef
>           "mvc 200(8,15), 88(1)\n\t"                              \
>           "lg 1, 0(1)\n\t"                                        \
>           VALGRIND_CALL_NOREDIR_R1                                \
> -         "lgr %0, 2\n\t"                                         \
>           "aghi 15,208\n\t"                                       \
>           VALGRIND_CFI_EPILOGUE                                   \
> +         "lgr %0, 2\n\t"                                         \
>           : /*out*/   "=d" (_res)                                 \
>           : /*in*/    "a" (&_argvec[0]) __FRAME_POINTER           \
>           : /*trash*/ "cc", "memory", __CALLER_SAVED_REGS,"6","7" \
> @@ -5126,9 +5305,9 @@ typedef
>           "mvc 208(8,15), 96(1)\n\t"                              \
>           "lg 1, 0(1)\n\t"                                        \
>           VALGRIND_CALL_NOREDIR_R1                                \
> -         "lgr %0, 2\n\t"                                         \
>           "aghi 15,216\n\t"                                       \
>           VALGRIND_CFI_EPILOGUE                                   \
> +         "lgr %0, 2\n\t"                                         \
>           : /*out*/   "=d" (_res)                                 \
>           : /*in*/    "a" (&_argvec[0]) __FRAME_POINTER           \
>           : /*trash*/ "cc", "memory", __CALLER_SAVED_REGS,"6","7" \
> @@ -5678,6 +5857,422 @@ typedef
>  
>  #endif /* PLAT_mips32_linux */
>  
> +/* ------------------------- nanomips-linux -------------------- */
> +
> +#if defined(PLAT_nanomips_linux)
> +
> +/* These regs are trashed by the hidden call. */
> +#define __CALLER_SAVED_REGS "$t4", "$t5", "$a0", "$a1", "$a2",     \
> +"$a3", "$a4", "$a5", "$a6", "$a7", "$t0", "$t1", "$t2", "$t3",     \
> +"$t8","$t9", "$at"
> +
> +/* These CALL_FN_ macros assume that on mips-linux, sizeof(unsigned
> +   long) == 4. */
> +
> +#define CALL_FN_W_v(lval, orig)                                   \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[1];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      __asm__ volatile(                                           \
> +         "lw $t9, 0(%1)\n\t"                                      \
> +         VALGRIND_CALL_NOREDIR_T9                                 \
> +         "move %0, $a0\n"                                         \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "r" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS                \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_W(lval, orig, arg1)                             \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[2];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      __asm__ volatile(                                           \
> +         "lw $t9, 0(%1)\n\t"                                      \
> +         "lw $a0, 4(%1)\n\t"                                      \
> +         VALGRIND_CALL_NOREDIR_T9                                 \
> +         "move %0, $a0\n"                                         \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "r" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS                \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_WW(lval, orig, arg1,arg2)                       \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[3];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      __asm__ volatile(                                           \
> +         "lw $t9, 0(%1)\n\t"                                      \
> +         "lw $a0, 4(%1)\n\t"                                      \
> +         "lw $a1, 8(%1)\n\t"                                      \
> +         VALGRIND_CALL_NOREDIR_T9                                 \
> +         "move %0, $a0\n"                                         \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "r" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS                \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_WWW(lval, orig, arg1,arg2,arg3)                 \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[4];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      __asm__ volatile(                                           \
> +         "lw $t9, 0(%1)\n\t"                                      \
> +         "lw $a0, 4(%1)\n\t"                                      \
> +         "lw $a1, 8(%1)\n\t"                                      \
> +         "lw $a2,12(%1)\n\t"                                      \
> +         VALGRIND_CALL_NOREDIR_T9                                 \
> +         "move %0, $a0\n"                                         \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "r" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS                \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_WWWW(lval, orig, arg1,arg2,arg3,arg4)           \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[5];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      __asm__ volatile(                                           \
> +         "lw $t9, 0(%1)\n\t"                                      \
> +         "lw $a0, 4(%1)\n\t"                                      \
> +         "lw $a1, 8(%1)\n\t"                                      \
> +         "lw $a2,12(%1)\n\t"                                      \
> +         "lw $a3,16(%1)\n\t"                                      \
> +         VALGRIND_CALL_NOREDIR_T9                                 \
> +         "move %0, $a0\n"                                         \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "r" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS                \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_5W(lval, orig, arg1,arg2,arg3,arg4,arg5)        \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[6];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      __asm__ volatile(                                           \
> +         "lw $t9, 0(%1)\n\t"                                      \
> +         "lw $a0, 4(%1)\n\t"                                      \
> +         "lw $a1, 8(%1)\n\t"                                      \
> +         "lw $a2,12(%1)\n\t"                                      \
> +         "lw $a3,16(%1)\n\t"                                      \
> +         "lw $a4,20(%1)\n\t"                                      \
> +         VALGRIND_CALL_NOREDIR_T9                                 \
> +         "move %0, $a0\n"                                         \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "r" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS                \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +#define CALL_FN_W_6W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6)   \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[7];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      __asm__ volatile(                                           \
> +         "lw $t9, 0(%1)\n\t"                                      \
> +         "lw $a0, 4(%1)\n\t"                                      \
> +         "lw $a1, 8(%1)\n\t"                                      \
> +         "lw $a2,12(%1)\n\t"                                      \
> +         "lw $a3,16(%1)\n\t"                                      \
> +         "lw $a4,20(%1)\n\t"                                      \
> +         "lw $a5,24(%1)\n\t"                                      \
> +         VALGRIND_CALL_NOREDIR_T9                                 \
> +         "move %0, $a0\n"                                         \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "r" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS                \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_7W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,   \
> +                                 arg7)                            \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[8];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      _argvec[7] = (unsigned long)(arg7);                         \
> +      __asm__ volatile(                                           \
> +         "lw $t9, 0(%1)\n\t"                                      \
> +         "lw $a0, 4(%1)\n\t"                                      \
> +         "lw $a1, 8(%1)\n\t"                                      \
> +         "lw $a2,12(%1)\n\t"                                      \
> +         "lw $a3,16(%1)\n\t"                                      \
> +         "lw $a4,20(%1)\n\t"                                      \
> +         "lw $a5,24(%1)\n\t"                                      \
> +         "lw $a6,28(%1)\n\t"                                      \
> +         VALGRIND_CALL_NOREDIR_T9                                 \
> +         "move %0, $a0\n"                                         \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "r" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS                \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_8W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,   \
> +                                 arg7,arg8)                       \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[9];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      _argvec[7] = (unsigned long)(arg7);                         \
> +      _argvec[8] = (unsigned long)(arg8);                         \
> +      __asm__ volatile(                                           \
> +         "lw $t9, 0(%1)\n\t"                                      \
> +         "lw $a0, 4(%1)\n\t"                                      \
> +         "lw $a1, 8(%1)\n\t"                                      \
> +         "lw $a2,12(%1)\n\t"                                      \
> +         "lw $a3,16(%1)\n\t"                                      \
> +         "lw $a4,20(%1)\n\t"                                      \
> +         "lw $a5,24(%1)\n\t"                                      \
> +         "lw $a6,28(%1)\n\t"                                      \
> +         "lw $a7,32(%1)\n\t"                                      \
> +         VALGRIND_CALL_NOREDIR_T9                                 \
> +         "move %0, $a0\n"                                         \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "r" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS                \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_9W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,   \
> +                                 arg7,arg8,arg9)                  \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[10];                         \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      _argvec[7] = (unsigned long)(arg7);                         \
> +      _argvec[8] = (unsigned long)(arg8);                         \
> +      _argvec[9] = (unsigned long)(arg9);                         \
> +      __asm__ volatile(                                           \
> +         "addiu $sp, $sp, -16  \n\t"                              \
> +         "lw $t9,36(%1)        \n\t"                              \
> +         "sw $t9, 0($sp)       \n\t"                              \
> +         "lw $t9, 0(%1)        \n\t"                              \
> +         "lw $a0, 4(%1)        \n\t"                              \
> +         "lw $a1, 8(%1)        \n\t"                              \
> +         "lw $a2,12(%1)        \n\t"                              \
> +         "lw $a3,16(%1)        \n\t"                              \
> +         "lw $a4,20(%1)        \n\t"                              \
> +         "lw $a5,24(%1)        \n\t"                              \
> +         "lw $a6,28(%1)        \n\t"                              \
> +         "lw $a7,32(%1)        \n\t"                              \
> +         VALGRIND_CALL_NOREDIR_T9                                 \
> +         "move %0, $a0         \n\t"                              \
> +         "addiu $sp, $sp, 16   \n\t"                              \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "r" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS                \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_10W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,  \
> +                                  arg7,arg8,arg9,arg10)           \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[11];                         \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      _argvec[7] = (unsigned long)(arg7);                         \
> +      _argvec[8] = (unsigned long)(arg8);                         \
> +      _argvec[9] = (unsigned long)(arg9);                         \
> +      _argvec[10] = (unsigned long)(arg10);                       \
> +      __asm__ volatile(                                           \
> +         "addiu $sp, $sp, -16  \n\t"                              \
> +         "lw $t9,36(%1)        \n\t"                              \
> +         "sw $t9, 0($sp)       \n\t"                              \
> +         "lw $t9,40(%1)        \n\t"                              \
> +         "sw $t9, 4($sp)       \n\t"                              \
> +         "lw $t9, 0(%1)        \n\t"                              \
> +         "lw $a0, 4(%1)        \n\t"                              \
> +         "lw $a1, 8(%1)        \n\t"                              \
> +         "lw $a2,12(%1)        \n\t"                              \
> +         "lw $a3,16(%1)        \n\t"                              \
> +         "lw $a4,20(%1)        \n\t"                              \
> +         "lw $a5,24(%1)        \n\t"                              \
> +         "lw $a6,28(%1)        \n\t"                              \
> +         "lw $a7,32(%1)        \n\t"                              \
> +         VALGRIND_CALL_NOREDIR_T9                                 \
> +         "move %0, $a0         \n\t"                              \
> +         "addiu $sp, $sp, 16   \n\t"                              \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "r" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS                \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_11W(lval, orig, arg1,arg2,arg3,arg4,arg5,       \
> +                                  arg6,arg7,arg8,arg9,arg10,      \
> +                                  arg11)                          \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[12];                         \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      _argvec[7] = (unsigned long)(arg7);                         \
> +      _argvec[8] = (unsigned long)(arg8);                         \
> +      _argvec[9] = (unsigned long)(arg9);                         \
> +      _argvec[10] = (unsigned long)(arg10);                       \
> +      _argvec[11] = (unsigned long)(arg11);                       \
> +      __asm__ volatile(                                           \
> +         "addiu $sp, $sp, -16  \n\t"                              \
> +         "lw $t9,36(%1)        \n\t"                              \
> +         "sw $t9, 0($sp)       \n\t"                              \
> +         "lw $t9,40(%1)        \n\t"                              \
> +         "sw $t9, 4($sp)       \n\t"                              \
> +         "lw $t9,44(%1)        \n\t"                              \
> +         "sw $t9, 8($sp)       \n\t"                              \
> +         "lw $t9, 0(%1)        \n\t"                              \
> +         "lw $a0, 4(%1)        \n\t"                              \
> +         "lw $a1, 8(%1)        \n\t"                              \
> +         "lw $a2,12(%1)        \n\t"                              \
> +         "lw $a3,16(%1)        \n\t"                              \
> +         "lw $a4,20(%1)        \n\t"                              \
> +         "lw $a5,24(%1)        \n\t"                              \
> +         "lw $a6,28(%1)        \n\t"                              \
> +         "lw $a7,32(%1)        \n\t"                              \
> +         VALGRIND_CALL_NOREDIR_T9                                 \
> +         "move %0, $a0         \n\t"                              \
> +         "addiu $sp, $sp, 16   \n\t"                              \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "r" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS                \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_12W(lval, orig, arg1,arg2,arg3,arg4,arg5,       \
> +                                  arg6,arg7,arg8,arg9,arg10,      \
> +                                  arg11,arg12)                    \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[13];                         \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      _argvec[7] = (unsigned long)(arg7);                         \
> +      _argvec[8] = (unsigned long)(arg8);                         \
> +      _argvec[9] = (unsigned long)(arg9);                         \
> +      _argvec[10] = (unsigned long)(arg10);                       \
> +      _argvec[11] = (unsigned long)(arg11);                       \
> +      _argvec[12] = (unsigned long)(arg12);                       \
> +      __asm__ volatile(                                           \
> +         "addiu $sp, $sp, -16  \n\t"                              \
> +         "lw $t9,36(%1)        \n\t"                              \
> +         "sw $t9, 0($sp)       \n\t"                              \
> +         "lw $t9,40(%1)        \n\t"                              \
> +         "sw $t9, 4($sp)       \n\t"                              \
> +         "lw $t9,44(%1)        \n\t"                              \
> +         "sw $t9, 8($sp)       \n\t"                              \
> +         "lw $t9,48(%1)        \n\t"                              \
> +         "sw $t9,12($sp)       \n\t"                              \
> +         "lw $t9, 0(%1)        \n\t"                              \
> +         "lw $a0, 4(%1)        \n\t"                              \
> +         "lw $a1, 8(%1)        \n\t"                              \
> +         "lw $a2,12(%1)        \n\t"                              \
> +         "lw $a3,16(%1)        \n\t"                              \
> +         "lw $a4,20(%1)        \n\t"                              \
> +         "lw $a5,24(%1)        \n\t"                              \
> +         "lw $a6,28(%1)        \n\t"                              \
> +         "lw $a7,32(%1)        \n\t"                              \
> +         VALGRIND_CALL_NOREDIR_T9                                 \
> +         "move %0, $a0         \n\t"                              \
> +         "addiu $sp, $sp, 16   \n\t"                              \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "r" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS                \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#endif /* PLAT_nanomips_linux */
> +
>  /* ------------------------- mips64-linux ------------------------- */
>  
>  #if defined(PLAT_mips64_linux)
> @@ -6098,6 +6693,456 @@ typedef
>  
>  #endif /* PLAT_mips64_linux */
>  
> +/* ----------------------- riscv64-linux ----------------------- */
> +
> +#if defined(PLAT_riscv64_linux)
> +
> +/* These regs are trashed by the hidden call. */
> +#define __CALLER_SAVED_REGS \
> +     "ra",                                                        \
> +     "t0", "t1", "t2", "t3", "t4", "t5", "t6",                    \
> +     "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7",              \
> +     "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7",      \
> +     "ft8", "ft9", "ft10", "ft11",                                \
> +     "fa0", "fa1", "fa2", "fa3", "fa4", "fa5", "fa6", "fa7"
> +
> +/* s11 is callee-saved, so we can use it to save and restore sp around
> +   the hidden call. */
> +#define VALGRIND_ALIGN_STACK               \
> +      "mv s11, sp\n\t"                     \
> +      "andi sp, sp, 0xfffffffffffffff0\n\t"
> +#define VALGRIND_RESTORE_STACK             \
> +      "mv sp, s11\n\t"
> +
> +/* These CALL_FN_ macros assume that on riscv64-linux,
> +   sizeof(unsigned long) == 8. */
> +
> +#define CALL_FN_W_v(lval, orig)                                   \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[1];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      __asm__ volatile(                                           \
> +         VALGRIND_ALIGN_STACK                                     \
> +         "ld t0, 0(%1) \n\t"  /* target->t0 */                    \
> +         VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                   \
> +         VALGRIND_RESTORE_STACK                                   \
> +         "mv %0, a0\n"                                            \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "0" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS, "s11"         \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_W(lval, orig, arg1)                             \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[2];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      __asm__ volatile(                                           \
> +         VALGRIND_ALIGN_STACK                                     \
> +         "ld a0, 8(%1) \n\t"                                      \
> +         "ld t0, 0(%1) \n\t"  /* target->t0 */                    \
> +         VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                   \
> +         VALGRIND_RESTORE_STACK                                   \
> +         "mv %0, a0\n"                                            \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "0" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS, "s11"         \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_WW(lval, orig, arg1,arg2)                       \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[3];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      __asm__ volatile(                                           \
> +         VALGRIND_ALIGN_STACK                                     \
> +         "ld a0, 8(%1) \n\t"                                      \
> +         "ld a1, 16(%1) \n\t"                                     \
> +         "ld t0, 0(%1) \n\t"  /* target->t0 */                    \
> +         VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                   \
> +         VALGRIND_RESTORE_STACK                                   \
> +         "mv %0, a0\n"                                            \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "0" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS, "s11"         \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_WWW(lval, orig, arg1,arg2,arg3)                 \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[4];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      __asm__ volatile(                                           \
> +         VALGRIND_ALIGN_STACK                                     \
> +         "ld a0, 8(%1) \n\t"                                      \
> +         "ld a1, 16(%1) \n\t"                                     \
> +         "ld a2, 24(%1) \n\t"                                     \
> +         "ld t0, 0(%1) \n\t"  /* target->t0 */                    \
> +         VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                   \
> +         VALGRIND_RESTORE_STACK                                   \
> +         "mv %0, a0\n"                                            \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "0" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS, "s11"         \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_WWWW(lval, orig, arg1,arg2,arg3,arg4)           \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[5];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      __asm__ volatile(                                           \
> +         VALGRIND_ALIGN_STACK                                     \
> +         "ld a0, 8(%1) \n\t"                                      \
> +         "ld a1, 16(%1) \n\t"                                     \
> +         "ld a2, 24(%1) \n\t"                                     \
> +         "ld a3, 32(%1) \n\t"                                     \
> +         "ld t0, 0(%1) \n\t"  /* target->t0 */                    \
> +         VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                   \
> +         VALGRIND_RESTORE_STACK                                   \
> +         "mv %0, a0"                                              \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "0" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS, "s11"         \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_5W(lval, orig, arg1,arg2,arg3,arg4,arg5)        \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[6];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      __asm__ volatile(                                           \
> +         VALGRIND_ALIGN_STACK                                     \
> +         "ld a0, 8(%1) \n\t"                                      \
> +         "ld a1, 16(%1) \n\t"                                     \
> +         "ld a2, 24(%1) \n\t"                                     \
> +         "ld a3, 32(%1) \n\t"                                     \
> +         "ld a4, 40(%1) \n\t"                                     \
> +         "ld t0, 0(%1) \n\t"  /* target->t0 */                    \
> +         VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                   \
> +         VALGRIND_RESTORE_STACK                                   \
> +         "mv %0, a0"                                              \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "0" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS, "s11"         \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_6W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6)   \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[7];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      __asm__ volatile(                                           \
> +         VALGRIND_ALIGN_STACK                                     \
> +         "ld a0, 8(%1) \n\t"                                      \
> +         "ld a1, 16(%1) \n\t"                                     \
> +         "ld a2, 24(%1) \n\t"                                     \
> +         "ld a3, 32(%1) \n\t"                                     \
> +         "ld a4, 40(%1) \n\t"                                     \
> +         "ld a5, 48(%1) \n\t"                                     \
> +         "ld t0, 0(%1) \n\t"  /* target->t0 */                    \
> +         VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                   \
> +         VALGRIND_RESTORE_STACK                                   \
> +         "mv %0, a0"                                              \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "0" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS, "s11"         \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_7W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,   \
> +                                 arg7)                            \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[8];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      _argvec[7] = (unsigned long)(arg7);                         \
> +      __asm__ volatile(                                           \
> +         VALGRIND_ALIGN_STACK                                     \
> +         "ld a0, 8(%1) \n\t"                                      \
> +         "ld a1, 16(%1) \n\t"                                     \
> +         "ld a2, 24(%1) \n\t"                                     \
> +         "ld a3, 32(%1) \n\t"                                     \
> +         "ld a4, 40(%1) \n\t"                                     \
> +         "ld a5, 48(%1) \n\t"                                     \
> +         "ld a6, 56(%1) \n\t"                                     \
> +         "ld t0, 0(%1) \n\t"  /* target->t0 */                    \
> +         VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                   \
> +         VALGRIND_RESTORE_STACK                                   \
> +         "mv %0, a0"                                              \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "0" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS, "s11"         \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_8W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,   \
> +                                 arg7,arg8)                       \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[9];                          \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      _argvec[7] = (unsigned long)(arg7);                         \
> +      _argvec[8] = (unsigned long)(arg8);                         \
> +      __asm__ volatile(                                           \
> +         VALGRIND_ALIGN_STACK                                     \
> +         "ld a0, 8(%1) \n\t"                                      \
> +         "ld a1, 16(%1) \n\t"                                     \
> +         "ld a2, 24(%1) \n\t"                                     \
> +         "ld a3, 32(%1) \n\t"                                     \
> +         "ld a4, 40(%1) \n\t"                                     \
> +         "ld a5, 48(%1) \n\t"                                     \
> +         "ld a6, 56(%1) \n\t"                                     \
> +         "ld a7, 64(%1) \n\t"                                     \
> +         "ld t0, 0(%1) \n\t"  /* target->t0 */                    \
> +         VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                   \
> +         VALGRIND_RESTORE_STACK                                   \
> +         "mv %0, a0"                                              \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "0" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS, "s11"         \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_9W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,   \
> +                                 arg7,arg8,arg9)                  \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[10];                         \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      _argvec[7] = (unsigned long)(arg7);                         \
> +      _argvec[8] = (unsigned long)(arg8);                         \
> +      _argvec[9] = (unsigned long)(arg9);                         \
> +      __asm__ volatile(                                           \
> +         VALGRIND_ALIGN_STACK                                     \
> +         "addi sp, sp, -16 \n\t"                                  \
> +         "ld a0, 8(%1) \n\t"                                      \
> +         "ld a1, 16(%1) \n\t"                                     \
> +         "ld a2, 24(%1) \n\t"                                     \
> +         "ld a3, 32(%1) \n\t"                                     \
> +         "ld a4, 40(%1) \n\t"                                     \
> +         "ld a5, 48(%1) \n\t"                                     \
> +         "ld a6, 56(%1) \n\t"                                     \
> +         "ld a7, 64(%1) \n\t"                                     \
> +         "ld t0, 72(%1) \n\t"                                     \
> +         "sd t0, 0(sp)  \n\t"                                     \
> +         "ld t0, 0(%1) \n\t"  /* target->t0 */                    \
> +         VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                   \
> +         VALGRIND_RESTORE_STACK                                   \
> +         "mv %0, a0"                                              \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "0" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS, "s11"         \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_10W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,  \
> +                                  arg7,arg8,arg9,arg10)           \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[11];                         \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      _argvec[7] = (unsigned long)(arg7);                         \
> +      _argvec[8] = (unsigned long)(arg8);                         \
> +      _argvec[9] = (unsigned long)(arg9);                         \
> +      _argvec[10] = (unsigned long)(arg10);                       \
> +      __asm__ volatile(                                           \
> +         VALGRIND_ALIGN_STACK                                     \
> +         "addi sp, sp, -16 \n\t"                                  \
> +         "ld a0, 8(%1) \n\t"                                      \
> +         "ld a1, 16(%1) \n\t"                                     \
> +         "ld a2, 24(%1) \n\t"                                     \
> +         "ld a3, 32(%1) \n\t"                                     \
> +         "ld a4, 40(%1) \n\t"                                     \
> +         "ld a5, 48(%1) \n\t"                                     \
> +         "ld a6, 56(%1) \n\t"                                     \
> +         "ld a7, 64(%1) \n\t"                                     \
> +         "ld t0, 72(%1) \n\t"                                     \
> +         "sd t0, 0(sp)  \n\t"                                     \
> +         "ld t0, 80(%1) \n\t"                                     \
> +         "sd t0, 8(sp)  \n\t"                                     \
> +         "ld t0, 0(%1) \n\t"  /* target->t0 */                    \
> +         VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                   \
> +         VALGRIND_RESTORE_STACK                                   \
> +         "mv %0, a0"                                              \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "0" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS, "s11"         \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_11W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,  \
> +                                  arg7,arg8,arg9,arg10,arg11)     \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[12];                         \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      _argvec[7] = (unsigned long)(arg7);                         \
> +      _argvec[8] = (unsigned long)(arg8);                         \
> +      _argvec[9] = (unsigned long)(arg9);                         \
> +      _argvec[10] = (unsigned long)(arg10);                       \
> +      _argvec[11] = (unsigned long)(arg11);                       \
> +      __asm__ volatile(                                           \
> +         VALGRIND_ALIGN_STACK                                     \
> +         "addi sp, sp, -32 \n\t"                                  \
> +         "ld a0, 8(%1) \n\t"                                      \
> +         "ld a1, 16(%1) \n\t"                                     \
> +         "ld a2, 24(%1) \n\t"                                     \
> +         "ld a3, 32(%1) \n\t"                                     \
> +         "ld a4, 40(%1) \n\t"                                     \
> +         "ld a5, 48(%1) \n\t"                                     \
> +         "ld a6, 56(%1) \n\t"                                     \
> +         "ld a7, 64(%1) \n\t"                                     \
> +         "ld t0, 72(%1) \n\t"                                     \
> +         "sd t0, 0(sp)  \n\t"                                     \
> +         "ld t0, 80(%1) \n\t"                                     \
> +         "sd t0, 8(sp)  \n\t"                                     \
> +         "ld t0, 88(%1) \n\t"                                     \
> +         "sd t0, 16(sp)  \n\t"                                    \
> +         "ld t0, 0(%1) \n\t"  /* target->t0 */                    \
> +         VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                   \
> +         VALGRIND_RESTORE_STACK                                   \
> +         "mv %0, a0"                                              \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "0" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS, "s11"         \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#define CALL_FN_W_12W(lval, orig, arg1,arg2,arg3,arg4,arg5,arg6,  \
> +                                  arg7,arg8,arg9,arg10,arg11,     \
> +                                  arg12)                          \
> +   do {                                                           \
> +      volatile OrigFn        _orig = (orig);                      \
> +      volatile unsigned long _argvec[13];                         \
> +      volatile unsigned long _res;                                \
> +      _argvec[0] = (unsigned long)_orig.nraddr;                   \
> +      _argvec[1] = (unsigned long)(arg1);                         \
> +      _argvec[2] = (unsigned long)(arg2);                         \
> +      _argvec[3] = (unsigned long)(arg3);                         \
> +      _argvec[4] = (unsigned long)(arg4);                         \
> +      _argvec[5] = (unsigned long)(arg5);                         \
> +      _argvec[6] = (unsigned long)(arg6);                         \
> +      _argvec[7] = (unsigned long)(arg7);                         \
> +      _argvec[8] = (unsigned long)(arg8);                         \
> +      _argvec[9] = (unsigned long)(arg9);                         \
> +      _argvec[10] = (unsigned long)(arg10);                       \
> +      _argvec[11] = (unsigned long)(arg11);                       \
> +      _argvec[12] = (unsigned long)(arg12);                       \
> +      __asm__ volatile(                                           \
> +         VALGRIND_ALIGN_STACK                                     \
> +         "addi sp, sp, -32 \n\t"                                  \
> +         "ld a0, 8(%1) \n\t"                                      \
> +         "ld a1, 16(%1) \n\t"                                     \
> +         "ld a2, 24(%1) \n\t"                                     \
> +         "ld a3, 32(%1) \n\t"                                     \
> +         "ld a4, 40(%1) \n\t"                                     \
> +         "ld a5, 48(%1) \n\t"                                     \
> +         "ld a6, 56(%1) \n\t"                                     \
> +         "ld a7, 64(%1) \n\t"                                     \
> +         "ld t0, 72(%1) \n\t"                                     \
> +         "sd t0, 0(sp)  \n\t"                                     \
> +         "ld t0, 80(%1) \n\t"                                     \
> +         "sd t0, 8(sp)  \n\t"                                     \
> +         "ld t0, 88(%1) \n\t"                                     \
> +         "sd t0, 16(sp)  \n\t"                                    \
> +         "ld t0, 96(%1) \n\t"                                     \
> +         "sd t0, 24(sp)  \n\t"                                    \
> +         "ld t0, 0(%1) \n\t"  /* target->t0 */                    \
> +         VALGRIND_BRANCH_AND_LINK_TO_NOREDIR_T0                   \
> +         VALGRIND_RESTORE_STACK                                   \
> +         "mv %0, a0"                                              \
> +         : /*out*/   "=r" (_res)                                  \
> +         : /*in*/    "0" (&_argvec[0])                            \
> +         : /*trash*/ "memory", __CALLER_SAVED_REGS, "s11"         \
> +      );                                                          \
> +      lval = (__typeof__(lval)) _res;                             \
> +   } while (0)
> +
> +#endif /* PLAT_riscv64_linux */
> +
>  /* ------------------------------------------------------------------ */
>  /* ARCHITECTURE INDEPENDENT MACROS for CLIENT REQUESTS.               */
>  /*                                                                    */
> @@ -6124,8 +7169,10 @@ typedef
>     ENTRIES, NOR DELETE ANY -- add new ones at the end of the most
>     relevant group. */
>  typedef
> -   enum { VG_USERREQ__RUNNING_ON_VALGRIND  = 0x1001,
> -          VG_USERREQ__DISCARD_TRANSLATIONS = 0x1002,
> +   enum { VG_USERREQ__RUNNING_ON_VALGRIND      = 0x1001,
> +          VG_USERREQ__DISCARD_TRANSLATIONS     = 0x1002,
> +          VG_USERREQ__VALGRIND_REPLACES_MALLOC = 0x1003,
> +          VG_USERREQ__VALGRIND_GET_TOOLNAME    = 0x1004,
>  
>            /* These allow any function to be called from the simulated
>               CPU but run on the real CPU.  Nb: the first arg passed to
> @@ -6146,6 +7193,10 @@ typedef
>               command. */
>            VG_USERREQ__GDB_MONITOR_COMMAND = 0x1202,
>  
> +          /* Allows the client program to change a dynamic command line
> +             option.  */
> +          VG_USERREQ__CLO_CHANGE = 0x1203,
> +
>            /* These are useful and can be interpreted by any tool that
>               tracks malloc() et al, by using vg_replace_malloc.c. */
>            VG_USERREQ__MALLOCLIKE_BLOCK = 0x1301,
> @@ -6224,6 +7275,30 @@ typedef
>      VALGRIND_DO_CLIENT_REQUEST_STMT(VG_USERREQ__DISCARD_TRANSLATIONS,  \
>                                      _qzz_addr, _qzz_len, 0, 0, 0)
>  
> +/* Returns 1 if the tool replaces malloc (e.g., memcheck). Returns 0
> +   if the tool does not replace malloc (e.g., cachegrind and callgrind)
> +   or if the executable is not running under VALGRIND. */
> +#define VALGRIND_REPLACES_MALLOC                                          \
> +    (unsigned)VALGRIND_DO_CLIENT_REQUEST_EXPR(0 /* if not */,             \
> +                                    VG_USERREQ__VALGRIND_REPLACES_MALLOC, \
> +                                    0, 0, 0, 0, 0)
> +
> +/* Get the running tool name as a string.
> +   Returns the required length (including terminating nul) for the input
> +   zzbuf. Returns 0 and the contents of zzbuf are not modified
> +   if not running under Valgrind.
> +   zzbuf may be NULL, which can be used to query the required buffer
> +   length before making a real request for the tool name.
> +   zzbuflen should be the length of zzbuf.
> +   The returned string in zzbuf will be nul terminated. If zzbuf is too
> +   small to contain the tool name then the name will be truncated */
> +#define VALGRIND_GET_TOOLNAME(zzbuf,zzbuflen)                          \
> +    (unsigned)VALGRIND_DO_CLIENT_REQUEST_EXPR(0,                       \
> +                                    VG_USERREQ__VALGRIND_GET_TOOLNAME, \
> +                                    (char*)(zzbuf),                    \
> +                                    (zzbuflen),                        \
> +                                    0, 0, 0)
> +
>  #define VALGRIND_INNER_THREADS(_qzz_addr)                               \
>     VALGRIND_DO_CLIENT_REQUEST_STMT(VG_USERREQ__INNER_THREADS,           \
>                                     _qzz_addr, 0, 0, 0, 0)
> @@ -6628,8 +7703,19 @@ VALGRIND_PRINTF_BACKTRACE(const char *format, ...)
>                                     command, 0, 0, 0, 0)
>  
>  
> +/* Change the value of a dynamic command line option.
> +   Note that unknown or not dynamically changeable options
> +   will cause a warning message to be output.  */
> +#define VALGRIND_CLO_CHANGE(option)                           \
> +   VALGRIND_DO_CLIENT_REQUEST_STMT(VG_USERREQ__CLO_CHANGE, \
> +                                   option, 0, 0, 0, 0)
> +
> +
>  #undef PLAT_x86_darwin
>  #undef PLAT_amd64_darwin
> +#undef PLAT_x86_freebsd
> +#undef PLAT_amd64_freebsd
> +#undef PLAT_arm64_freebsd
>  #undef PLAT_x86_win32
>  #undef PLAT_amd64_win64
>  #undef PLAT_x86_linux
> @@ -6641,6 +7727,8 @@ VALGRIND_PRINTF_BACKTRACE(const char *format, ...)
>  #undef PLAT_s390x_linux
>  #undef PLAT_mips32_linux
>  #undef PLAT_mips64_linux
> +#undef PLAT_nanomips_linux
> +#undef PLAT_riscv64_linux
>  #undef PLAT_x86_solaris
>  #undef PLAT_amd64_solaris
>  
> -- 
> 2.54.0

