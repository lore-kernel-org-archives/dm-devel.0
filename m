Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 213BEC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 21 Apr 2022 19:25:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-yvZg8nqXMAi0-tv7qocmnA-1; Thu, 21 Apr 2022 15:25:19 -0400
X-MC-Unique: yvZg8nqXMAi0-tv7qocmnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76DBF1014A64;
	Thu, 21 Apr 2022 19:25:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3FDC8145BEE1;
	Thu, 21 Apr 2022 19:25:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DFD611949763;
	Thu, 21 Apr 2022 19:25:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 44EAD19451EF
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Apr 2022 19:25:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1205E40EC012; Thu, 21 Apr 2022 19:25:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E13840EC002
 for <dm-devel@redhat.com>; Thu, 21 Apr 2022 19:25:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7D5E381079F
 for <dm-devel@redhat.com>; Thu, 21 Apr 2022 19:25:14 +0000 (UTC)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-_XIXREvsOzeOnJK-bGye6w-1; Thu, 21 Apr 2022 15:25:13 -0400
X-MC-Unique: _XIXREvsOzeOnJK-bGye6w-1
Received: by mail-pl1-f176.google.com with SMTP id h12so2251368plf.12
 for <dm-devel@redhat.com>; Thu, 21 Apr 2022 12:25:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=qeRjKSXDeJIH0+CQwoCMl5922pNFNUxTvF5aowm8rco=;
 b=bD1ejFj6DQy9Ox/OrWz7xFvEeUXrpMBiQ4cQ7/KxeENv+TbbRef56dU1e7WNCYnfO8
 S813L0nJ0wou1PASs2r1HUw1E0SWYHjrBt7501UoHopSZPGN0gMbhFNYh23r8QzTYuji
 DrpruBwknCnJxe8NEtj52rsUeTn6MHogQRi1mUIF2NNC/mCd32ly1X2zeuNlBFgWTDTI
 KIjqRJheWzUU0yJcLs5nSp1xqQOQh8qZ8W7+C4n3iXqgber+jFjTcOuBsjQP7Iz49x6N
 UexJwnei/tlDsKPEU7iVBrNVUNzHjxzYtkPOsaqQENiRk9EI1zd7tXtdvltOiTemrs/W
 9YlQ==
X-Gm-Message-State: AOAM533lABwunJD7RFiBdZmEFPnNu3JQpe+HfNMKjfuYRHm31oB0tj7d
 9b3z1QjMV2WAjWbmqHRpHHMrhC/3dYlHv1X/YaC6Vg==
X-Google-Smtp-Source: ABdhPJyqf0QRE4ybiwrpA4CL2rjYdR9Dfz1kuf/M+oV726c8/KeCCX7M1xEsBCAx988EvXNGhdhdyy5S+lFBAanpVRU=
X-Received: by 2002:a17:90b:4c84:b0:1d2:cadc:4e4d with SMTP id
 my4-20020a17090b4c8400b001d2cadc4e4dmr12075384pjb.8.1650569111988; Thu, 21
 Apr 2022 12:25:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220420020435.90326-1-jane.chu@oracle.com>
 <20220420020435.90326-2-jane.chu@oracle.com>
In-Reply-To: <20220420020435.90326-2-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Apr 2022 12:25:00 -0700
Message-ID: <CAPcyv4jMNvgWrh5WMY1gFN3-vKLU4eccXW3CDRrn1+=FY7D5jw@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v8 1/7] acpi/nfit: rely on mce->misc to
 determine poison granularity
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
 Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 "Darrick J. Wong" <djwong@kernel.org>, X86 ML <x86@kernel.org>,
 david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 Dave Hansen <dave.hansen@intel.com>,
 device-mapper development <dm-devel@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>,
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

On Tue, Apr 19, 2022 at 7:05 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> nfit_handle_mec() hardcode poison granularity at L1_CACHE_BYTES.
> Instead, let the driver rely on mce->misc register to determine
> the poison granularity.
>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

...I'll add the Fixes: line when applying this.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

