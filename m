Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 444ADC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 13 May 2022 03:41:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-LcPRd-sHNqydyos56AArqQ-1; Thu, 12 May 2022 23:41:28 -0400
X-MC-Unique: LcPRd-sHNqydyos56AArqQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C41A91C04B76;
	Fri, 13 May 2022 03:41:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EFA1715392D0;
	Fri, 13 May 2022 03:41:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B13921932207;
	Fri, 13 May 2022 03:41:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C4DFB194975B
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 May 2022 03:41:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A831BC15E73; Fri, 13 May 2022 03:41:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A42CEC15D67
 for <dm-devel@redhat.com>; Fri, 13 May 2022 03:41:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AF6390EE41
 for <dm-devel@redhat.com>; Fri, 13 May 2022 03:41:23 +0000 (UTC)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-H1_RHkDJMvaLLYYOExQcOQ-1; Thu, 12 May 2022 23:41:21 -0400
X-MC-Unique: H1_RHkDJMvaLLYYOExQcOQ-1
Received: by mail-pf1-f175.google.com with SMTP id p8so6568327pfh.8
 for <dm-devel@redhat.com>; Thu, 12 May 2022 20:41:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=JaD/7HsV0lHA07q8V2RCBkaHsJJjfnySNbAofgOVR+s=;
 b=tMKx1bq15nZAdUKP9BY7udsQYTrrF38hdGEJzY3FSbveEok/Dz+PRLOVlXYJDtb6wv
 +6rr8rdEBuBoXoKZ/MklseRTqBpNayorzXuddz8LYtFmsWQWcjy14W9BxB/vO6X8nFK6
 VilFmYW3913fY3mdBhhhrAoZ6YxHgbN+BQE+sdUPKMj6d+65K4LCF9x5dkEg/Zqj4bkJ
 vsr9qhMl1HWU4OsikStwLBnhc9G/xB097W0YOji8B/dmIAXb/fMyE0xJc/accf19593O
 xAn9qnunbpccgzKYA73SORjh/YXoFmXodqaE25U85eHS1g4fA13oBwIQKqX6/kAzoqG1
 5lGQ==
X-Gm-Message-State: AOAM533L8WbkKY0cJ+/nyiR1146CjMtVdyOA7AiDWxj+jd1c/2ytgAgM
 rYb9iOofKM8w15o8Rz6pDfFc9rc9TFlvtDEJDTtq25X1CwnvRA==
X-Google-Smtp-Source: ABdhPJztXj3NI4LlWRYrTyoHNrGuFPmTDU30zBctcBdUbZiL2txSy8W/riK1TBgLzTUumv2yr+YHO2k/aNd90/TW10s=
X-Received: by 2002:a63:1117:0:b0:399:2df0:7fb9 with SMTP id
 g23-20020a631117000000b003992df07fb9mr2395090pgl.40.1652413280701; Thu, 12
 May 2022 20:41:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220422224508.440670-1-jane.chu@oracle.com>
 <20220422224508.440670-4-jane.chu@oracle.com>
 <CAPcyv4i7xi=5O=HSeBEzvoLvsmBB_GdEncbasMmYKf3vATNy0A@mail.gmail.com>
 <CAPcyv4id8AbTFpO7ED_DAPren=eJQHwcdY8Mjx18LhW+u4MdNQ@mail.gmail.com>
 <Ynt3WlpcJwuqffDX@zn.tnic> <5aa1c9aacc5a4086a904440641062669@intel.com>
In-Reply-To: <5aa1c9aacc5a4086a904440641062669@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 May 2022 20:41:09 -0700
Message-ID: <CAPcyv4hOD--eFPX9v4U0iowzQZVfOX2KgNYQU7Cb+WSnZmWpiw@mail.gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v9 3/7] mce: fix set_mce_nospec to always
 unmap the whole page
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
Cc: "chu, jane" <jane.chu@oracle.com>, Linux NVDIMM <nvdimm@lists.linux.dev>,
 "Jiang, Dave" <dave.jiang@intel.com>, Mike Snitzer <snitzer@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>,
 "Wang, Jue" <juew@google.com>, X86 ML <x86@kernel.org>,
 david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 "Hansen, Dave" <dave.hansen@intel.com>,
 device-mapper development <dm-devel@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, "Lutomirski,
 Andy" <luto@kernel.org>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 11, 2022 at 10:17 AM Luck, Tony <tony.luck@intel.com> wrote:
>
> > I - just like you - am waiting for Tony to say whether he still needs
> > this whole_page() thing. I already suggested removing it so I'm fine
> > with this patch.
>
> IIRC this new patch effectively reverts back to the original behavior that
> I implemented back at the dawn of time. I.e. just always mark the whole
> page "not present" and don't try to mess with UC mappings to allow
> partial (but non-speculative) access to the not-poisoned parts of the
> page.
>
> If that is the case ... then Acked-by: Tony Luck <tony.luck@intel.com>
>
> If I've misunderstood ... then please explain what it is doing.

You are correct. The page is always marked not present as far as the
page-offlining code is concerned, back to the way it always was.

The code in the pmem driver that repairs the page now knows that the
page is to be kept "not present" until the poison is cleared and
clear_mce_nospec() returns the mapping to typical write-back caching.

There is no support for what the UC case previously allowed which was
reading the good lines around the one bad line, just handle overwrites
to clear poison and restore access.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

