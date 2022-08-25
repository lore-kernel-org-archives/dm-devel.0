Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 277DFC0502E
	for <dm-devel@archiver.kernel.org>; Mon, 29 Aug 2022 05:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661752584;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sWrCiwtuT1UrxkDP1tcudfoeLigGhBPBPalqz5Qu0Ng=;
	b=L9W3DPHKIekgSelSUl9bLk9rT6/O/Rp8rueidN+0QbRIihHQS++M72dcdFLmAexQ65xU7g
	SoDjGQsFENb4XWgF1kqdaCYY+eeLyJcULhIWE5aTGV3iHaEEUWumZwXj55kF+tkbRWrxjD
	nVqVyms63aPLLTglr4wfqrJOIqUa9Ww=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-WnNqk2WXMv-j2-Mdgye6ew-1; Mon, 29 Aug 2022 01:56:21 -0400
X-MC-Unique: WnNqk2WXMv-j2-Mdgye6ew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D71585A589;
	Mon, 29 Aug 2022 05:56:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 019482026D4C;
	Mon, 29 Aug 2022 05:56:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 94F301946A49;
	Mon, 29 Aug 2022 05:56:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 486B71946A43
 for <dm-devel@listman.corp.redhat.com>; Thu, 25 Aug 2022 15:32:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2D8374C816; Thu, 25 Aug 2022 15:32:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 296844C819
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 15:32:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F82D805AF5
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 15:32:43 +0000 (UTC)
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com
 [209.85.167.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-206-K-efvt0mP7yGV-Wf36bOiA-1; Thu, 25 Aug 2022 11:32:41 -0400
X-MC-Unique: K-efvt0mP7yGV-Wf36bOiA-1
Received: by mail-oi1-f174.google.com with SMTP id t140so14818427oie.8
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 08:32:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=BF1zNrYrm57PzI0kOZgixgNUjiOGt1ff9+aE0AWJYQI=;
 b=S94A9+qKHmpBKXHYvQIq6g5Kw+9bj0cAtXhDPWGWpec/CQkv+bysN4c6PLRisU4iAU
 S2d+NMjzD1S5JJRbzMD37g9kEoKo2aC/Hiz7s3lCTo5k0m2US8s3GOLlmjRQnq8y7nVy
 qhFloaKTiW2xiAXj7MKbbbaF5XMrSKuCRNvImdZvJa/bFFWEvDxjXYRivwpBjHOsRGse
 7xRleAaz+Qc15TxnENvQ56GHRtazYkziwi5CTaaCDrx8Kuc7RSG6Rt1U6DutLQPPIoJ6
 W4EakHNVfhrDkyQomSX8A5MB2XMqrQFb2rk/RluLVuFhmRml4B6Js2ABDY7BrzGTfwiB
 qKDg==
X-Gm-Message-State: ACgBeo0u3WWH4Y5LJmcjQMwZW6VpLw9jcSvW+53hWQ6hPBHidunpCL48
 zHyN1j8k0vKeGD5Wdhjmj0ukwCPgryyQXA==
X-Google-Smtp-Source: AA6agR6xgQOvRHh0Xpw66yQJILg6p62fn1Ec60f0139FQZBTITexrWL6rg6YPMeIsZiZGlqXjRn94A==
X-Received: by 2002:a54:4e8e:0:b0:343:fe9:9516 with SMTP id
 c14-20020a544e8e000000b003430fe99516mr2026272oiy.198.1661441560290; 
 Thu, 25 Aug 2022 08:32:40 -0700 (PDT)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com.
 [209.85.210.42]) by smtp.gmail.com with ESMTPSA id
 k4-20020a056870570400b0010f07647598sm5499865oap.7.2022.08.25.08.32.36
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 25 Aug 2022 08:32:37 -0700 (PDT)
Received: by mail-ot1-f42.google.com with SMTP id
 t11-20020a05683014cb00b0063734a2a786so14128015otq.11
 for <dm-devel@redhat.com>; Thu, 25 Aug 2022 08:32:36 -0700 (PDT)
X-Received: by 2002:a05:6830:58:b0:637:1974:140a with SMTP id
 d24-20020a056830005800b006371974140amr1607371otp.362.1661441556115; Thu, 25
 Aug 2022 08:32:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20220112211258.21115-8-chang.seok.bae@intel.com>
 <CAE=gft4P2iGJDiYJccZFR1VnNomQB7Uo522r2gvrfNY9oKz5jg@mail.gmail.com>
 <763bddd2-2fc3-a857-0dff-a5ae4ae1f298@intel.com>
 <CAE=gft5VajfoAT6hVxiCzAMYiDV+pHRbC-F7s4+qK94qa0og5w@mail.gmail.com>
 <6f2dcc0c-99a2-8698-13ae-d5cbea9945b0@intel.com>
In-Reply-To: <6f2dcc0c-99a2-8698-13ae-d5cbea9945b0@intel.com>
From: Evan Green <evgreen@chromium.org>
Date: Thu, 25 Aug 2022 08:31:59 -0700
X-Gmail-Original-Message-ID: <CAE=gft6sO85RBpfdXnR=_r=KGmVrx0mnBOHK7XadNk00gDr-WA@mail.gmail.com>
Message-ID: <CAE=gft6sO85RBpfdXnR=_r=KGmVrx0mnBOHK7XadNk00gDr-WA@mail.gmail.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Mon, 29 Aug 2022 05:56:16 +0000
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Aug 24, 2022 at 6:06 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
>
> On 8/24/2022 3:52 PM, Evan Green wrote:
> >
> > Whatever we ended up landing in the ChromeOS tree (which I think was
> > v4 of this series) actively hit this bug in hibernation, which is how
> > I found it. I couldn't get a full backtrace because the backtracing
> > code tripped over itself as well for some reason. If the next patch in
> > this series is different from what we landed in ChromeOS, then maybe
> > your description is correct, but I haven't dug in to understand the
> > delta.
>
> So the change from v4 is simply dropping CBC mode. Marvin who reported
> another issue told me that he pushed the fix to some Chrome repository.
> But I don't know that's the same repo that you mentioned. Are you able
> to locate that tree if possible?

I see. The only ChromeOS tree I'm aware of where keylocker has landed
is our 5.10 tree. This is the change where it landed:
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/3373776/12

>
> Also, it would be nice to have more detail about that hibernation bug.

Here's the log I've got that pointed me down this path:
https://pastebin.com/VvR1EHvE

Relevant bit pasted below:

<6>[43486.263035] Enabling non-boot CPUs ...
<6>[43486.263081] x86: Booting SMP configuration:
<6>[43486.263082] smpboot: Booting Node 0 Processor 1 APIC 0x1
<2>[43486.264010] kernel tried to execute NX-protected page - exploit
attempt? (uid: 0)
<1>[43486.264019] BUG: unable to handle page fault for address: ffffffff94b483a6
<1>[43486.264021] #PF: supervisor instruction fetch in kernel mode
<1>[43486.264023] #PF: error_code(0x0011) - permissions violation
<6>[43486.264025] PGD 391c0e067 P4D 391c0e067 PUD 391c0f063 PMD
10006c063 PTE 8000000392148163
<4>[43486.264031] Oops: 0011 [#1] PREEMPT SMP NOPTI
<4>[43486.264035] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G U
5.10.136-19391-gadfe4d4b8c04 #1
b640352a7a0e5f1522aed724296ad63f90c007df
<4>[43486.264036] Hardware name: Google Primus/Primus, BIOS
Google_Primus.14505.145.0 06/23/2022
<4>[43486.264042] RIP: 0010:load_keylocker+0x0/0x7f
<4>[43486.264044] Code: 02 46 0a 0c 07 08 44 0b 24 00 00 00 10 26 00
00 44 d5 e9 ff dd 00 00 00 00 41 0e 10 86 02 43 0d 06 42 8d 03 49 8c
04 02 61 0a <0c> 07 08 48 0b 00 24 00 00 00 38 26 00 00 fc d5 e9 ff ba
00 00 00
<4>[43486.264046] RSP: 0000:ffffb1c7000afe50 EFLAGS: 00010046
<4>[43486.264048] RAX: ffffffff9483a898 RBX: ffff8d64ef855440 RCX:
0000000000310800
<4>[43486.264049] RDX: 0000000000310800 RSI: 0000000000000000 RDI:
00000000003f0ea0
<4>[43486.264051] RBP: ffffb1c7000afe88 R08: 0000000000000000 R09:
0000000000003000
<4>[43486.264052] R10: 0000000000000500 R11: ffffffff92c6c775 R12:
ffff8d64ef8554c0
<4>[43486.264053] R13: 0000000000000000 R14: 0000000000000082 R15:
ffff8d64ef855460
<4>[43486.264055] FS: 0000000000000000(0000) GS:ffff8d64ef840000(0000)
knlGS:0000000000000000
<4>[43486.264057] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[43486.264058] CR2: ffffffff94b483a6 CR3: 0000000391c0c001 CR4:
00000000003f0ea0
<4>[43486.264063] invalid opcode: 0000 [#2] PREEMPT SMP NOPTI
<4>[43486.264065] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G U
5.10.136-19391-gadfe4d4b8c04 #1
b640352a7a0e5f1522aed724296ad63f90c007df
<4>[43486.264066] Hardware name: Google Primus/Primus, BIOS
Google_Primus.14505.145.0 06/23/2022
<4>[43486.264069] RIP: 0010:__show_regs+0x2ed/0x338
<4>[43486.264071] Code: 81 fc 00 04 00 00 75 44 48 f7 05 ca 83 90 01
10 00 00 00 0f 84 fa fd ff ff 31 d2 48 f7 05 b7 83 90 01 10 00 00 00
74 07 31 c9 <0f> 01 ee 89 c2 48 c7 c7 90 38 29 94 4c 89 f6 48 83 c4 28
5b 41 5c
<4>[43486.264072] RSP: 0000:ffffb1c7000afc90 EFLAGS: 00010046
<4>[43486.264074] RAX: 00000000ffff0ff0 RBX: 0000000000000000 RCX:
0000000000000000
<4>[43486.264075] RDX: 0000000000000000 RSI: 0000000000000004 RDI:
ffffffff94cf27f4
<4>[43486.264076] RBP: ffffb1c7000afce0 R08: 0000000000000000 R09:
00000000ffffdfff
<4>[43486.264078] R10: ffffffff94658600 R11: 3fffffffffffffff R12:
0000000000000400
<4>[43486.264079] R13: ffff8d64ef840000 R14: ffffffff9435d0a9 R15:
00000000ffff0ff0
<4>[43486.264080] FS: 0000000000000000(0000) GS:ffff8d64ef840000(0000)
knlGS:0000000000000000
<4>[43486.264082] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[43486.264083] CR2: ffffffff94b483a6 CR3: 0000000391c0c001 CR4:
00000000003f0ea0
<4>[43486.264085] invalid opcode: 0000 [#3] PREEMPT SMP NOPTI
<4>[43486.264086] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G U
5.10.136-19391-gadfe4d4b8c04 #1
b640352a7a0e5f1522aed724296ad63f90c007df
<4>[43486.264088] Hardware name: Google Primus/Primus, BIOS
Google_Primus.14505.145.0 06/23/2022
<4>[43486.264089] RIP: 0010:__show_regs+0x2ed/0x338

I landed this change, though I'm still working on verifying the issue
goes away with this fix:
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/3851401

I don't have direct access to this machine, but I wonder if a simple
cpu hotplug might also exercise this path.
-Evan

>
> Thanks,
> Chang
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

