Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F683C04AA5
	for <dm-devel@archiver.kernel.org>; Thu, 25 Aug 2022 08:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661415882;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=c2/3q5aviKYsHl2fK0+FLXOdqoUcWi7fPUQKPJY+wMo=;
	b=WprFNb1FrOwZkbF4h7MCkiGUFhGzwgyKzK8NIF4mxM2K6FDGKRL9H9oavmLx0nFNl/FRwd
	BhkisqtxwlCQtCdUSMKu5OZQhUxTBjeItmT0VQ49u3owgQv1ZJGjAhlVtu4tIixbvc2VJX
	LGUlt2mme6ZH/CJOAuKYmdZbE9YQBBU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-UVCWCFElPKGJ4r25jNVMhQ-1; Thu, 25 Aug 2022 04:24:38 -0400
X-MC-Unique: UVCWCFElPKGJ4r25jNVMhQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 306D11C1394B;
	Thu, 25 Aug 2022 08:24:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1A7671415117;
	Thu, 25 Aug 2022 08:24:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DBFD91946A77;
	Thu, 25 Aug 2022 08:24:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 16BE61946A43
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 22:53:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B4BCD40B40C8; Wed, 24 Aug 2022 22:53:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B0AA740CF8EF
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 22:53:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9926E1C006A7
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 22:53:13 +0000 (UTC)
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com
 [209.85.160.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-435-M4qF30fnPvimOS1WIzPhsw-1; Wed, 24 Aug 2022 18:53:11 -0400
X-MC-Unique: M4qF30fnPvimOS1WIzPhsw-1
Received: by mail-oa1-f46.google.com with SMTP id
 586e51a60fabf-11c4d7d4683so22724725fac.8
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 15:53:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=BYUw2X0viByhVZ/+dJN6TRVhaDQVcxTsg6s3mNZcPzI=;
 b=XoyDkUDwV6heamjKuResqFf181LbgxdhoWKGndr9nPjOqCaptoqYIUvtcLMXLymhT1
 xq/utMlV7ln0JcA3tyCkOxoKxbHfxhRUklDdyuKSgYeu9Wpb/kzIcALwBgn3f0HEW8ut
 qVAtL8SopGQhOGkH036XgM5BtaEmCnJwB4JAx3oP0VXwfhUJlBN1eTfPrshd98HCAFPX
 EzbPPOvFpHARnMDygVbiOQ4L1w6bc+boq1pu7EmxjtxVdlJcgMe0oNZIVzRxU++6Lk82
 0D3/EI9XoTmyB8nrcfnI5uK4cj0tkDf3coZgGtnR96it4nF819Ic2Soc3XuuMaE6BzfV
 9zNw==
X-Gm-Message-State: ACgBeo2iJzaz80S8Ic/omqWCXdAmLYsMGTQkHIa/LL5pT1gC2HHEXW6b
 KFZ+WcXnj2ijQE6UZDlfyuSZbjB6SVHlJQ==
X-Google-Smtp-Source: AA6agR5BKweu2jZVW9xRrDSpLGtjhtCHFx8NBSoyIcXaM+JRYWXiSGJo8Q8kzjiVn/f9TvZjBfikDA==
X-Received: by 2002:a05:6870:2d1:b0:11c:c06e:fb51 with SMTP id
 r17-20020a05687002d100b0011cc06efb51mr4555140oaf.261.1661381591005; 
 Wed, 24 Aug 2022 15:53:11 -0700 (PDT)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com.
 [209.85.210.42]) by smtp.gmail.com with ESMTPSA id
 97-20020a9d04ea000000b00636a8dafdc9sm4838057otm.2.2022.08.24.15.53.08
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 24 Aug 2022 15:53:09 -0700 (PDT)
Received: by mail-ot1-f42.google.com with SMTP id
 r1-20020a056830418100b0063938f634feso5552968otu.8
 for <dm-devel@redhat.com>; Wed, 24 Aug 2022 15:53:08 -0700 (PDT)
X-Received: by 2002:a05:6830:58:b0:637:1974:140a with SMTP id
 d24-20020a056830005800b006371974140amr364549otp.362.1661381588181; Wed, 24
 Aug 2022 15:53:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20220112211258.21115-8-chang.seok.bae@intel.com>
 <CAE=gft4P2iGJDiYJccZFR1VnNomQB7Uo522r2gvrfNY9oKz5jg@mail.gmail.com>
 <763bddd2-2fc3-a857-0dff-a5ae4ae1f298@intel.com>
In-Reply-To: <763bddd2-2fc3-a857-0dff-a5ae4ae1f298@intel.com>
From: Evan Green <evgreen@chromium.org>
Date: Wed, 24 Aug 2022 15:52:32 -0700
X-Gmail-Original-Message-ID: <CAE=gft5VajfoAT6hVxiCzAMYiDV+pHRbC-F7s4+qK94qa0og5w@mail.gmail.com>
Message-ID: <CAE=gft5VajfoAT6hVxiCzAMYiDV+pHRbC-F7s4+qK94qa0og5w@mail.gmail.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Thu, 25 Aug 2022 08:24:35 +0000
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Aug 24, 2022 at 3:21 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
>
> On 8/23/2022 8:49 AM, Evan Green wrote:
> > On Wed, Jan 12, 2022 at 1:21 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
> >>
> <snip>
> >> +
> >> +static void __init load_keylocker(void)
> >
> > I am late to this party by 6 months, but:
> > load_keylocker() cannot be __init, as it gets called during SMP core onlining.
>
> Yeah, it looks like the case with this patch only.
>
> But the next patch [1] limits the call during boot time only:
>
>         if (c == &boot_cpu_data) {
>                 ...
>                 load_keylocker();
>                 ...
>         } else {
>                 ...
>                 if (!kl_setup.initialized) {
>                         load_keylocker();
>                 } else if (valid_kl) {
>                         rc = copy_keylocker();
>                         ...
>                 }
>         }
>
> kl_setup.initialized is set by native_smp_cpus_done() ->
> destroy_keylocker_data() when CPUs are booted. Then load_keylocker() is
> not called because the root key (aka IWKey) is no longer available in
> memory.
>
> Now this 'valid_kl' flag should be always on unless the root key backup
> is corrupted. Then copy_keylocker() loads the root key from the backup
> in the platform state.
>
> So I think the onlining CPU won't call it.
>
> Maybe this bit can be much clarified in a separate (new) patch, instead
> of being part of another like [1].

Whatever we ended up landing in the ChromeOS tree (which I think was
v4 of this series) actively hit this bug in hibernation, which is how
I found it. I couldn't get a full backtrace because the backtracing
code tripped over itself as well for some reason. If the next patch in
this series is different from what we landed in ChromeOS, then maybe
your description is correct, but I haven't dug in to understand the
delta.

-Evan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

