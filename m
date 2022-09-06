Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A6DECAAD3
	for <dm-devel@archiver.kernel.org>; Wed,  7 Sep 2022 07:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662537491;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nnBisndCuWORoLVKFz+5NWObCQ7dtyzwh2xoR+taba0=;
	b=bJy+CLgFRkXMcEK2KOYwLw9loD+CDx9+cH8s0JU5I0iRzS1reLsD5yU5c1WVtZsMRscxV5
	KgTmr9YQvVw7M0Kful2+czXBwgbwH66Mf7NVnk9qWDMJORwnkWdq66jdRyVX5ZUK+YW9vV
	RmcZ3pjHSr20PbWuB2XuFAmeJr6ixI0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-SJD9TrhDP02kSwpN05T7-A-1; Wed, 07 Sep 2022 03:58:08 -0400
X-MC-Unique: SJD9TrhDP02kSwpN05T7-A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 263BD1C06903;
	Wed,  7 Sep 2022 07:58:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED76C4010D2A;
	Wed,  7 Sep 2022 07:58:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BB7D81946A45;
	Wed,  7 Sep 2022 07:58:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E201D1946A43
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Sep 2022 16:22:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9AC6840C1421; Tue,  6 Sep 2022 16:22:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9725540C141D
 for <dm-devel@redhat.com>; Tue,  6 Sep 2022 16:22:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D5A529AB45D
 for <dm-devel@redhat.com>; Tue,  6 Sep 2022 16:22:47 +0000 (UTC)
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com
 [209.85.160.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-331-yy-8GYBRObC4g4i9w6Q_Vg-1; Tue, 06 Sep 2022 12:22:45 -0400
X-MC-Unique: yy-8GYBRObC4g4i9w6Q_Vg-1
Received: by mail-oa1-f48.google.com with SMTP id
 586e51a60fabf-1279948d93dso9611356fac.10
 for <dm-devel@redhat.com>; Tue, 06 Sep 2022 09:22:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=A4brQTvRlh4R5wPRp39SU02kPOk/lBeJHkJkNAOJzuE=;
 b=AjmBYrl7uCmRGmM7CadB66C/bG0heU3mSVKmA9eCyfBN2e2VdpawcANmeJmy1bI6aF
 4Ie2SE6yt25CVh33g78SsL6IczqHk2h7nTrE5yXu/2QI0ZVv1T88A26oENVUO+WPyU5/
 DGJ82vZFYtbURYsZ7Y1NfeIx5CSAcSMCAR31fB4j3T3f55/bwXH8mMAyB0kBlKbZrrcf
 SUKxRrCg8kM0g4t1QUGi03t75sXviLd0lRnNodb3JUEYRGXdJwsT1ea577lROZ45Nwth
 RjI3lYjFUk4sgue+vvbicSRxUs4Z8rjDTpy1QOhdmv1NiSnXrFufgUf690M3iJMxJHsy
 Gm2Q==
X-Gm-Message-State: ACgBeo0xdgd02mMmLLtMHPcvaZiL8CoSAFZ8gaS6QWhlQtv6O5HSc5Sb
 prIT1XARaQOgeJFqZiMx/V31l231S9vdxA==
X-Google-Smtp-Source: AA6agR53dgzytKc6HyaY741fceVGMqfJOALF4kA1zHIT6/TUYlo/OoDgeXmM518pBmo/tdGKclU3gA==
X-Received: by 2002:a05:6808:238e:b0:345:3564:2a49 with SMTP id
 bp14-20020a056808238e00b0034535642a49mr9935133oib.221.1662481364937; 
 Tue, 06 Sep 2022 09:22:44 -0700 (PDT)
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com.
 [209.85.160.51]) by smtp.gmail.com with ESMTPSA id
 3-20020aca0503000000b00339befdfad0sm5505182oif.50.2022.09.06.09.22.43
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 06 Sep 2022 09:22:43 -0700 (PDT)
Received: by mail-oa1-f51.google.com with SMTP id
 586e51a60fabf-11eab59db71so29337240fac.11
 for <dm-devel@redhat.com>; Tue, 06 Sep 2022 09:22:43 -0700 (PDT)
X-Received: by 2002:a05:6808:3096:b0:342:ff93:4672 with SMTP id
 bl22-20020a056808309600b00342ff934672mr10837507oib.174.1662481362737; Tue, 06
 Sep 2022 09:22:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220112211258.21115-1-chang.seok.bae@intel.com>
 <20220112211258.21115-8-chang.seok.bae@intel.com>
 <CAE=gft4P2iGJDiYJccZFR1VnNomQB7Uo522r2gvrfNY9oKz5jg@mail.gmail.com>
 <763bddd2-2fc3-a857-0dff-a5ae4ae1f298@intel.com>
 <CAE=gft5VajfoAT6hVxiCzAMYiDV+pHRbC-F7s4+qK94qa0og5w@mail.gmail.com>
 <6f2dcc0c-99a2-8698-13ae-d5cbea9945b0@intel.com>
 <CAE=gft6sO85RBpfdXnR=_r=KGmVrx0mnBOHK7XadNk00gDr-WA@mail.gmail.com>
 <a3fd8d2d-72d0-ba13-ef77-caff2b239867@intel.com>
In-Reply-To: <a3fd8d2d-72d0-ba13-ef77-caff2b239867@intel.com>
From: Evan Green <evgreen@chromium.org>
Date: Tue, 6 Sep 2022 09:22:06 -0700
X-Gmail-Original-Message-ID: <CAE=gft7BQAwHTxoCtSu-gHZDtcETvBM-nony_nzBD8ziE_HcZw@mail.gmail.com>
Message-ID: <CAE=gft7BQAwHTxoCtSu-gHZDtcETvBM-nony_nzBD8ziE_HcZw@mail.gmail.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Wed, 07 Sep 2022 07:58:03 +0000
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Aug 31, 2022 at 4:16 PM Chang S. Bae <chang.seok.bae@intel.com> wrote:
>
> On 8/25/2022 8:31 AM, Evan Green wrote:
> >
> > Here's the log I've got that pointed me down this path:
> > https://pastebin.com/VvR1EHvE
>
>      <3>[43486.261583] x86/keylocker: The key backup access failed with
> read error.
>      <3>[43486.261584] x86/keylocker: Failed to restore internal
> wrapping key.
>
> Looks like the IWKey backup was corrupted on that system.
>
> > Relevant bit pasted below:
> >
> > <6>[43486.263035] Enabling non-boot CPUs ...
> > <6>[43486.263081] x86: Booting SMP configuration:
> > <6>[43486.263082] smpboot: Booting Node 0 Processor 1 APIC 0x1
> > <2>[43486.264010] kernel tried to execute NX-protected page - exploit
> > attempt? (uid: 0)
> > <1>[43486.264019] BUG: unable to handle page fault for address: ffffffff94b483a6
> > <1>[43486.264021] #PF: supervisor instruction fetch in kernel mode
> > <1>[43486.264023] #PF: error_code(0x0011) - permissions violation
> > <6>[43486.264025] PGD 391c0e067 P4D 391c0e067 PUD 391c0f063 PMD
> > 10006c063 PTE 8000000392148163
> > <4>[43486.264031] Oops: 0011 [#1] PREEMPT SMP NOPTI
> > <4>[43486.264035] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G U
> > 5.10.136-19391-gadfe4d4b8c04 #1
> > b640352a7a0e5f1522aed724296ad63f90c007df
> > <4>[43486.264036] Hardware name: Google Primus/Primus, BIOS
> > Google_Primus.14505.145.0 06/23/2022
> > <4>[43486.264042] RIP: 0010:load_keylocker+0x0/0x7f
>
> But, I don't get the reason why it hit this. On the wake-up path,
> copy_keylocker() is supposed to be called.

Interesting, that's helpful. I thought I had a lead based on this,
which was that in this case we were doing a hibernate to shutdown,
rather than hibernate to S4. The IWKey backup is only valid down to
S4, so a read error on resume from this type of hibernate might make
sense. I know keylocker won't successfully maintain handles across a
hibernate to shutdown and subsequent resume, but it shouldn't crash
either.

But this still doesn't explain this crash, since in this case we're
still on our way down and haven't even done the shutdown yet. We can
see the "PM: hibernation: Image created (1536412 pages copied)" log
line just before the keylocker read failure. So then it seems
something's not working with the pre-hibernate CPU hotplug path?


>
> I added some printout in there, and it looks to be fine with me:
>
>      [  218.488711] Enabling non-boot CPUs ...
>      [  218.488794] x86: Booting SMP configuration:
>      [  218.488795] smpboot: Booting Node 0 Processor 1 APIC 0x1
>      [  218.490634] x86/keylocker: restore processor (id=1)
>      [  218.491186] CPU1 is up
>      ...

How were you exercising the CPU onlining in this case? Boot, cpu
hotplug, or hibernate?
-Evan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

