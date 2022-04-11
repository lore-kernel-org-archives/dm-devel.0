Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7821FC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 22:07:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-qdS3KMZtM6el6mzpmngtWg-1; Mon, 11 Apr 2022 18:07:28 -0400
X-MC-Unique: qdS3KMZtM6el6mzpmngtWg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5624E101AA42;
	Mon, 11 Apr 2022 22:07:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C3B440BB05;
	Mon, 11 Apr 2022 22:07:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CD5581940368;
	Mon, 11 Apr 2022 22:07:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BF8501940365
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 22:07:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD266C44B17; Mon, 11 Apr 2022 22:07:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A958EC35993
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 22:07:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90C9C101A52C
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 22:07:23 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-VAPcSWBmNn6ViS0VdfyOVA-1; Mon, 11 Apr 2022 18:07:21 -0400
X-MC-Unique: VAPcSWBmNn6ViS0VdfyOVA-1
Received: by mail-pl1-f173.google.com with SMTP id s10so7529317plg.9
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 15:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=uGTALhbZONK07EnTqNzLb5OFo7sOJ1WnH/JS/fksxZ4=;
 b=wtdgQ8oIISl9g71Hzb4ZdbG0rP+R1rulHS/VJ8lb7GuU97i8J9Xpog9EqlEvNzzP/G
 dqISgViBAJRwabPSLyV0fE6wo9ITXJ++joRqYoGj8Mm+GI2edJbfKzFozBgOGVtD0h1K
 cv0JPWYLEjozTZ5WtWNSyfA+pOHaFemLQscI4g2aaZ98jywWaKFq3uf3uHU6aas3g8nP
 W506Yop4rC+WRSxP+oGhNzHq5ECIeUUNUKSAFp3qVbKHh6eJ9vgGgNNkSP29kyTF5OsD
 EcfCcHisFy+D2bCJiLGwMPyhMyX2ZgzHM9IOaeNY6ajWOw778goz1tcpqzClXfEpXzyu
 r62w==
X-Gm-Message-State: AOAM530z/JpdH/F6beJ8WdpTzr3bfisDdlXfaUrEzroqOLFRmsCA/LDu
 WctovU5HI4en4SJ2QM8t/u/3PF7ufuxO9+K7tVr0Jg==
X-Google-Smtp-Source: ABdhPJynx2l3cB2Gnxdh26yL6kd+AAVfXhzzqC3Ft2s9qeSNSOaR3yfL83lS+0+wlt4mWc4yp2miJE+sHJq1HcNQSls=
X-Received: by 2002:a17:902:eb92:b0:158:4cc9:698e with SMTP id
 q18-20020a170902eb9200b001584cc9698emr11070951plg.147.1649714840717; Mon, 11
 Apr 2022 15:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-2-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-2-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Apr 2022 15:07:10 -0700
Message-ID: <CAPcyv4gr7YzrmqNhA-S8h-nRhpr8OHhUkn16c8jiL1U3ypp1wQ@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v7 1/6] x86/mm: fix comment
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
 Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
 X86 ML <x86@kernel.org>, david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 device-mapper development <dm-devel@redhat.com>,
 Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> There is no _set_memory_prot internal helper, while coming across
> the code, might as well fix the comment.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  arch/x86/mm/pat/set_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index abf5ed76e4b7..38af155aaba9 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -1816,7 +1816,7 @@ static inline int cpa_clear_pages_array(struct page **pages, int numpages,
>  }
>
>  /*
> - * _set_memory_prot is an internal helper for callers that have been passed
> + * __set_memory_prot is an internal helper for callers that have been passed
>   * a pgprot_t value from upper layers and a reservation has already been taken.
>   * If you want to set the pgprot to a specific page protocol, use the
>   * set_memory_xx() functions.
> --
> 2.18.4
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

