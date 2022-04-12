Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B974AC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 04:58:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-Amt-0hAlP6q2-sVJuyZFTg-1; Tue, 12 Apr 2022 00:58:02 -0400
X-MC-Unique: Amt-0hAlP6q2-sVJuyZFTg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5A3F38041D3;
	Tue, 12 Apr 2022 04:58:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 607B3111E403;
	Tue, 12 Apr 2022 04:58:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 22D311949762;
	Tue, 12 Apr 2022 04:58:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 21B941947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 04:57:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0FA16C44B17; Tue, 12 Apr 2022 04:57:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BF5CC28106
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 04:57:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7FB0811E7A
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 04:57:57 +0000 (UTC)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-MgkrSirlPjKKL4sQ03mQIQ-1; Tue, 12 Apr 2022 00:57:48 -0400
X-MC-Unique: MgkrSirlPjKKL4sQ03mQIQ-1
Received: by mail-pl1-f174.google.com with SMTP id t12so3390537pll.7
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 21:57:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=8TleCaBIhpvoj6MzJmrMyC3ucMSm6WO1y+eL8xleJY4=;
 b=cz1/7Xb4xA6Q2sVzvjKNQdBN5eKYMDDbZuwMci1mmjotAeLegP2kGbTdZGQsv0vDOJ
 tA165jzFlsZ/QpkPBTNvUAyKUicgZNdreOhPYnSn7Ki2KpSDyLKzYKnkIwsEzFlbijZX
 CqwD4kxLe9IVhF0iH9yToD65Ol2jYdgqRWTEQNKPtovaK7Hr/TWV6yF9eAXF0A6723ph
 9vqELXX8croB3UhV6CGGwO9dbfI0lpD/9ImJ/O4jht60fXHaz8kYtP5Zu/QJG9styRmX
 oJuTZZTj4LDeK1Z+cdUQc9geK9slHb9Tp/OudnFzZNh1WlhoWNIhMvZ3f/jrRPMPn+72
 ZHnQ==
X-Gm-Message-State: AOAM532rb2SO0SeeD3PjnJcMR94Dhu/XuAV+Js8hrsTEeB4edQ9snz9k
 pC2HMk5C2u1NaCxi4Mp2EXMyg5IMjMLO6mg3p3FPdQ==
X-Google-Smtp-Source: ABdhPJxBATyoJAyblOakoZzlFS+GtSy3AbBTLdouj+8YmPDRCb1cpkksbCSmeWKkXDHtWwI5LR7XG/b+KrOX8AklXlQ=
X-Received: by 2002:a17:902:eb92:b0:158:4cc9:698e with SMTP id
 q18-20020a170902eb9200b001584cc9698emr12430897plg.147.1649739467468; Mon, 11
 Apr 2022 21:57:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-5-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-5-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Apr 2022 21:57:36 -0700
Message-ID: <CAPcyv4jpOss6hzPgM913v_QsZ+PB6Jzo1WV=YdUvnKZiwtfjiA@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Introduce DAX_RECOVERY flag to dax_direct_access(). The flag is
> not set by default in dax_direct_access() such that the helper
> does not translate a pmem range to kernel virtual address if the
> range contains uncorrectable errors.  When the flag is set,
> the helper ignores the UEs and return kernel virtual adderss so
> that the caller may get on with data recovery via write.

It strikes me that there is likely never going to be any other flags
to dax_direct_access() and what this option really is an access type.
I also find code changes like this error prone to read:

 -       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
 +       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, 0, &kaddr, NULL);

...i.e. without looking at the prototype, which option is the nr_pages
and which is the flags?

So how about change 'int flags' to 'enum dax_access_mode mode' where
dax_access_mode is:

/**
 * enum dax_access_mode - operational mode for dax_direct_access()
 * @DAX_ACCESS: nominal access, fail / trim access on encountering poison
 * @DAX_RECOVERY_WRITE: ignore poison and provide a pointer suitable
for use with dax_recovery_write()
 */
enum dax_access_mode {
    DAX_ACCESS,
    DAX_RECOVERY_WRITE,
};

Then the conversions look like this:

 -       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
 +       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1,
DAX_ACCESS, &kaddr, NULL);

...and there's less chance of confusion with the @nr_pages argument.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

