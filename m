Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD29CC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 23:56:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-SjJVVIhNO3uVj3S280EIPg-1; Mon, 11 Apr 2022 19:56:15 -0400
X-MC-Unique: SjJVVIhNO3uVj3S280EIPg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDA9785A5BE;
	Mon, 11 Apr 2022 23:56:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8641A40CF915;
	Mon, 11 Apr 2022 23:56:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 33CF11949762;
	Mon, 11 Apr 2022 23:56:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A697C1949762
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 23:56:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7F093C44B1A; Mon, 11 Apr 2022 23:56:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AD9AC15D40
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 23:56:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A51C1C02321
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 23:56:11 +0000 (UTC)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-Mv2b0l47M3GDxPl7-VAIVQ-1; Mon, 11 Apr 2022 19:56:10 -0400
X-MC-Unique: Mv2b0l47M3GDxPl7-VAIVQ-1
Received: by mail-pl1-f172.google.com with SMTP id f10so15236925plr.6
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 16:56:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=u4J7Bf/GotxjJfY4hYTghw/TTioM2LYvPTAkJWjY17E=;
 b=VoVo+ti3KIMCDO8K54dx1rbM3ODcncsUkDJCGJaRoAIaN05xVP3EqNpy25PxbogjQc
 ch3elKKRXx33CpkierD2fwzDxAQ8WKqxAapCqJGCuFhosEaWeY8bkJJ7dXoKoh7Vq5Ft
 ctZIXqStIk45WhSWvJKpSpsyJ6oipGcyK/QHXjpFefb6wATWHwEufZTjXJY2B0OspCB7
 gPWomOr6hzzBlIeU+gXv1apaZ7W1bAUlLPJS+ThsuTF2GuDw0AgRwHUI/txUzV8ihlwg
 Y1k7aqcAaP53xAmRMJMqSDFAns2MwoonfHNUF+QHr3CBIjXi2V1GFekl3W9VkjiSdTft
 oDjg==
X-Gm-Message-State: AOAM5320LfnPEyaaJhtXcOEoahv6LDahq3CBSMLiO+cCW+DDaikhf4kv
 Qu3NMIKGPqosns8oL9Md5v6RzC2F0bOlL4jhTMPlLw==
X-Google-Smtp-Source: ABdhPJwz526LJSdeFPj6/c7PsF49maypY+wjW8NyQ8pIICoB0k38/TF9Lk5dkB3kd2++yFgVX8lzKCKbNtcxf9v/5dw=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr34383349pll.132.1649721368525; Mon, 11
 Apr 2022 16:56:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-5-jane.chu@oracle.com>
 <Yk0i/pODntZ7lbDo@infradead.org>
 <196d51a3-b3cc-02ae-0d7d-ee6fbb4d50e4@oracle.com>
 <Yk52415cnFa39qil@infradead.org>
In-Reply-To: <Yk52415cnFa39qil@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Apr 2022 16:55:58 -0700
Message-ID: <CAPcyv4gfF4AhxD_vqCS9CTRraj8GAMDYQ7Zb411+FvxhF4ccOw@mail.gmail.com>
To: Christoph Hellwig <hch@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v7 4/6] dax: add DAX_RECOVERY flag and
 .recovery_write dev_pgmap_ops
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
Cc: Jane Chu <jane.chu@oracle.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "snitzer@redhat.com" <snitzer@redhat.com>,
 "djwong@kernel.org" <djwong@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "david@fromorbit.com" <david@fromorbit.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "vgoyal@redhat.com" <vgoyal@redhat.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>, "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 6, 2022 at 10:31 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Apr 06, 2022 at 05:32:31PM +0000, Jane Chu wrote:
> > Yes, I believe Dan was motivated by avoiding the dm dance as a result of
> > adding .recovery_write to dax_operations.
> >
> > I understand your point about .recovery_write is device specific and
> > thus not something appropriate for device agnostic ops.
> >
> > I can see 2 options so far -
> >
> > 1)  add .recovery_write to dax_operations and do the dm dance to hunt
> > down to the base device that actually provides the recovery action
>
> That would be my preference.  But I'll wait for Dan to chime in.

Yeah, so the motivation was avoiding plumbing recovery through stacked
lookups when the recovery is specific to a pfn and the provider of
that pfn, but I also see it from Christoph's perspective that the only
agent that cares about recovery is the fsdax I/O path. Certainly
having ->dax_direct_access() take a DAX_RECOVERY flag and the op
itself go through the pgmap is a confusing split that I did not
anticipate when I made the suggestion. Since that flag must be there,
then the ->recovery_write() should also stay relative to a dax device.

Apologies for the thrash Jane.

One ask though, please separate plumbing the new flag argument to
->dax_direct_access() and plumbing the new operation into preparation
patches before filling them in with the new goodness.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

