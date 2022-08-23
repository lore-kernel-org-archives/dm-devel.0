Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF36BC32793
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 07:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661326625;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NY1Ku7+DSG7tTNQh8XgRgnlSUrwqFQ2mglaXdH+MiFs=;
	b=CvlTYYZepDSlyzDTOo+oRFhtTUb/+YKAq5gbo5foyg5Cc/e6TrEfq3My9SQIBZCXM8w8fX
	gVMSOWvNC7zKXNKTbu3UeU7fDAC1i4gVNz5/VjPIPVn46fwxUX1YOW0fdMuvODFyeZMKDi
	zyOGJA8bb28LNDfeASfq4q0ov7g1u8Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-J9Jy6A7ONQm-lczohlFvXA-1; Wed, 24 Aug 2022 03:37:01 -0400
X-MC-Unique: J9Jy6A7ONQm-lczohlFvXA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54C5F8037AF;
	Wed, 24 Aug 2022 07:37:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3F298C15BC5;
	Wed, 24 Aug 2022 07:37:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2CB861946A42;
	Wed, 24 Aug 2022 07:37:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 88F8A1946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 15:49:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6D17D1121319; Tue, 23 Aug 2022 15:49:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 695041121315
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 15:49:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F43D101A54E
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 15:49:59 +0000 (UTC)
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com
 [209.85.160.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-672-3I7-IFvzPzO20OKTbdYHsA-1; Tue, 23 Aug 2022 11:49:57 -0400
X-MC-Unique: 3I7-IFvzPzO20OKTbdYHsA-1
Received: by mail-oa1-f43.google.com with SMTP id
 586e51a60fabf-11d08d7ece2so10572540fac.0
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 08:49:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=I+MhWIFw4wylC1ozMc1I6NteP9cQs0GMyFhEeS/9x94=;
 b=GOtutqXylDVVQaLXMSRXefidCrsqlAFBacFvuem6VFfaV36IYbTQ4bBtg4mDOjpJWs
 S3YNnrtTzYXft38OZH2FLft0PZNtdutuRxNG9EnWL4KLelEHTH0PVUraVdWQjh8y3ZMj
 ojEskShzShoGQlUssBFoPW0CsZS47h0fYWhIN2bkoStGk+v84bDz9n2QuobfQxKwQj+r
 nTGYcTDWRectSCuU3ZRmyv+0/Z8kAPQ+TeLN0BrvelKzaSRwHlgbzYl8yM6WYryLquNA
 VO0KXbnMWvG1BsF4bcdmOyPbHjFlghHrfa4jkM07uL69HZOpDe788fixQ4B5v+vMR5in
 wVpg==
X-Gm-Message-State: ACgBeo1T2pXXEOFSj4aYYHf58CwKumToebW+WLG2z1TFU5pGJPy8tPCD
 2T5QogvKBSMMinhRL1Rtdw/tnGFD9Jz2zA==
X-Google-Smtp-Source: AA6agR7aQgvk5FSldvHIDKe04hWRZD146rhOcbLDvukdYwjTBRRmg8kYMVMGqPLwpJu4h8tcz0qtVw==
X-Received: by 2002:a05:6870:3914:b0:11c:7f09:96fa with SMTP id
 b20-20020a056870391400b0011c7f0996famr1691143oap.50.1661269796827; 
 Tue, 23 Aug 2022 08:49:56 -0700 (PDT)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com.
 [209.85.210.46]) by smtp.gmail.com with ESMTPSA id
 f21-20020a4abb15000000b00448a3ecdc9dsm2835281oop.22.2022.08.23.08.49.55
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 23 Aug 2022 08:49:56 -0700 (PDT)
Received: by mail-ot1-f46.google.com with SMTP id
 m21-20020a9d6ad5000000b00638df677850so10057731otq.5
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 08:49:55 -0700 (PDT)
X-Received: by 2002:a05:6830:58:b0:637:1974:140a with SMTP id
 d24-20020a056830005800b006371974140amr9735586otp.362.1661269795464; Tue, 23
 Aug 2022 08:49:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20220112211258.21115-8-chang.seok.bae@intel.com>
In-Reply-To: <20220112211258.21115-8-chang.seok.bae@intel.com>
From: Evan Green <evgreen@chromium.org>
Date: Tue, 23 Aug 2022 08:49:18 -0700
X-Gmail-Original-Message-ID: <CAE=gft4P2iGJDiYJccZFR1VnNomQB7Uo522r2gvrfNY9oKz5jg@mail.gmail.com>
Message-ID: <CAE=gft4P2iGJDiYJccZFR1VnNomQB7Uo522r2gvrfNY9oKz5jg@mail.gmail.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Wed, 24 Aug 2022 07:36:57 +0000
Subject: Re: [dm-devel] [PATCH v5 07/12] x86/cpu/keylocker: Load an internal
 wrapping key at boot-time
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: ravi.v.shankar@intel.com, dave.hansen@linux.intel.com,
 herbert@gondor.apana.org.au, x86@kernel.org,
 Dan Williams <dan.j.williams@intel.com>, LKML <linux-kernel@vger.kernel.org>,
 mingo@kernel.org, Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
 linux-crypto@vger.kernel.org, luto@kernel.org,
 Thomas Gleixner <tglx@linutronix.de>, bp@suse.de,
 Ard Biesheuvel <ardb@kernel.org>, charishma1.gairuboyina@intel.com,
 kumar.n.dwarakanath@intel.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jan 12, 2022 at 1:21 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
>
> The Internal Wrapping Key (IWKey) is an entity of Key Locker to encode a
> clear text key into a key handle. This key is a pivot in protecting user
> keys. So the value has to be randomized before being loaded in the
> software-invisible CPU state.
>
> IWKey needs to be established before the first user. Given that the only
> proposed Linux use case for Key Locker is dm-crypt, the feature could be
> lazily enabled when the first dm-crypt user arrives, but there is no
> precedent for late enabling of CPU features and it adds maintenance burden
> without demonstrative benefit outside of minimizing the visibility of
> Key Locker to userspace.
>
> The kernel generates random bytes and load them at boot time. These bytes
> are flushed out immediately.
>
> Setting the CR4.KL bit does not always enable the feature so ensure the
> dynamic CPU bit (CPUID.AESKLE) is set before loading the key.
>
> Given that the Linux Key Locker support is only intended for bare metal
> dm-crypt consumption, and that switching IWKey per VM is untenable,
> explicitly skip Key Locker setup in the X86_FEATURE_HYPERVISOR case.
>
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> Changes from RFC v2:
> * Make bare metal only.
> * Clean up the code (e.g. dynamically allocate the key cache).
>   (Dan Williams)
> * Massage the changelog.
> * Move out the LOADIWKEY wrapper and the Key Locker CPUID defines.
>
> Note, Dan wonders that given that the only proposed Linux use case for
> Key Locker is dm-crypt, the feature could be lazily enabled when the
> first dm-crypt user arrives, but as Dave notes there is no precedent
> for late enabling of CPU features and it adds maintenance burden
> without demonstrative benefit outside of minimizing the visibility of
> Key Locker to userspace.
> ---
>  arch/x86/include/asm/keylocker.h |  9 ++++
>  arch/x86/kernel/Makefile         |  1 +
>  arch/x86/kernel/cpu/common.c     |  5 +-
>  arch/x86/kernel/keylocker.c      | 79 ++++++++++++++++++++++++++++++++
>  arch/x86/kernel/smpboot.c        |  2 +
>  5 files changed, 95 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/kernel/keylocker.c
>
> diff --git a/arch/x86/include/asm/keylocker.h b/arch/x86/include/asm/keylocker.h
> index e85dfb6c1524..820ac29c06d9 100644
> --- a/arch/x86/include/asm/keylocker.h
> +++ b/arch/x86/include/asm/keylocker.h
> @@ -5,6 +5,7 @@
>
>  #ifndef __ASSEMBLY__
>
> +#include <asm/processor.h>
>  #include <linux/bits.h>
>  #include <asm/fpu/types.h>
>
> @@ -28,5 +29,13 @@ struct iwkey {
>  #define KEYLOCKER_CPUID_EBX_WIDE       BIT(2)
>  #define KEYLOCKER_CPUID_EBX_BACKUP     BIT(4)
>
> +#ifdef CONFIG_X86_KEYLOCKER
> +void setup_keylocker(struct cpuinfo_x86 *c);
> +void destroy_keylocker_data(void);
> +#else
> +#define setup_keylocker(c) do { } while (0)
> +#define destroy_keylocker_data() do { } while (0)
> +#endif
> +
>  #endif /*__ASSEMBLY__ */
>  #endif /* _ASM_KEYLOCKER_H */
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 2ff3e600f426..e15efa238497 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -144,6 +144,7 @@ obj-$(CONFIG_PERF_EVENTS)           += perf_regs.o
>  obj-$(CONFIG_TRACING)                  += tracepoint.o
>  obj-$(CONFIG_SCHED_MC_PRIO)            += itmt.o
>  obj-$(CONFIG_X86_UMIP)                 += umip.o
> +obj-$(CONFIG_X86_KEYLOCKER)            += keylocker.o
>
>  obj-$(CONFIG_UNWINDER_ORC)             += unwind_orc.o
>  obj-$(CONFIG_UNWINDER_FRAME_POINTER)   += unwind_frame.o
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 0083464de5e3..23b4aa437c1e 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -57,6 +57,8 @@
>  #include <asm/microcode_intel.h>
>  #include <asm/intel-family.h>
>  #include <asm/cpu_device_id.h>
> +#include <asm/keylocker.h>
> +
>  #include <asm/uv/uv.h>
>  #include <asm/sigframe.h>
>
> @@ -1595,10 +1597,11 @@ static void identify_cpu(struct cpuinfo_x86 *c)
>         /* Disable the PN if appropriate */
>         squash_the_stupid_serial_number(c);
>
> -       /* Set up SMEP/SMAP/UMIP */
> +       /* Setup various Intel-specific CPU security features */
>         setup_smep(c);
>         setup_smap(c);
>         setup_umip(c);
> +       setup_keylocker(c);
>
>         /* Enable FSGSBASE instructions if available. */
>         if (cpu_has(c, X86_FEATURE_FSGSBASE)) {
> diff --git a/arch/x86/kernel/keylocker.c b/arch/x86/kernel/keylocker.c
> new file mode 100644
> index 000000000000..87d775a65716
> --- /dev/null
> +++ b/arch/x86/kernel/keylocker.c
> @@ -0,0 +1,79 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +/*
> + * Setup Key Locker feature and support internal wrapping key
> + * management.
> + */
> +
> +#include <linux/random.h>
> +#include <linux/poison.h>
> +
> +#include <asm/fpu/api.h>
> +#include <asm/keylocker.h>
> +#include <asm/tlbflush.h>
> +
> +static __initdata struct keylocker_setup_data {
> +       struct iwkey key;
> +} kl_setup;
> +
> +static void __init generate_keylocker_data(void)
> +{
> +       get_random_bytes(&kl_setup.key.integrity_key,  sizeof(kl_setup.key.integrity_key));
> +       get_random_bytes(&kl_setup.key.encryption_key, sizeof(kl_setup.key.encryption_key));
> +}
> +
> +void __init destroy_keylocker_data(void)
> +{
> +       memset(&kl_setup.key, KEY_DESTROY, sizeof(kl_setup.key));
> +}
> +
> +static void __init load_keylocker(void)

I am late to this party by 6 months, but:
load_keylocker() cannot be __init, as it gets called during SMP core onlining.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

