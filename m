Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABABFC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 17 May 2022 19:28:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-XsGFEELIN0WouSfmOhzWfA-1; Tue, 17 May 2022 15:28:18 -0400
X-MC-Unique: XsGFEELIN0WouSfmOhzWfA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E51C8117B0;
	Tue, 17 May 2022 19:28:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AAA3A1410DD5;
	Tue, 17 May 2022 19:28:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6F4CB19259EC;
	Tue, 17 May 2022 19:28:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 05BED19259E8
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 May 2022 19:28:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D24DA1410DDB; Tue, 17 May 2022 19:28:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CEB221410DD5
 for <dm-devel@redhat.com>; Tue, 17 May 2022 19:28:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B67B8101AA44
 for <dm-devel@redhat.com>; Tue, 17 May 2022 19:28:12 +0000 (UTC)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-ECq-RnsdOKuH5hP1P30d2Q-1; Tue, 17 May 2022 15:28:11 -0400
X-MC-Unique: ECq-RnsdOKuH5hP1P30d2Q-1
Received: by mail-pl1-f178.google.com with SMTP id s14so18225078plk.8
 for <dm-devel@redhat.com>; Tue, 17 May 2022 12:28:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=sRnxrATUFurY+xdKnn0z6Pv7TbtVcM0Bq4eah/DEREU=;
 b=kXQonqfix98eRdthn3sthzNMUJA6mWjB6KZzguEOvBKiZT776tljfEUV/ZuPMj1HI6
 mBExsklgcGlNybMqBAtTwF6i1RbGoLcNbA+vqElxsL70IZ11CybGNJWqKBVL5Qk8IRuS
 frgntLyXq1xCpQw+L6/V779mHzLtRd8SThzDaM37F5W5XW46ZdLMeCS/9LF/HEV8+lVI
 08+OYS+KxMrI7M7iC3hQzf/WIjubAoJJ/65FFV27BRhWeE6PC1VtFeRxSzhGwBxLNo7q
 /tS0q6UfWvCKemYzpx+axWukPm+YG2S5MNiwWRem9mUlH6ApOSxNXwx36kCX7lHeoP1a
 pK0g==
X-Gm-Message-State: AOAM533aqiPzQ4TLBOPgxk6xyeJyQh9hur3S60NrH25X+gCI3CRNGEWX
 n3amCQ+KRttw14yTT9n3VpiPNg==
X-Google-Smtp-Source: ABdhPJzb6NxCGOhL9QfuLNbvRAfqqVCHjnAogoMxMJEoG6YKx2Kx62sZPGUOs+pIjzwhzNyg+KiRSQ==
X-Received: by 2002:a17:90a:9914:b0:1db:d10f:1fcf with SMTP id
 b20-20020a17090a991400b001dbd10f1fcfmr37464999pjp.241.1652815689928; 
 Tue, 17 May 2022 12:28:09 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:641e:de1c:873b:321e])
 by smtp.gmail.com with UTF8SMTPSA id
 k1-20020a170902694100b0015e8d4eb2bcsm9412366plt.262.2022.05.17.12.28.09
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 17 May 2022 12:28:09 -0700 (PDT)
Date: Tue, 17 May 2022 12:28:08 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Kees Cook <keescook@chromium.org>
Message-ID: <YoP3SJ62uHI7nrXy@google.com>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
 <B7FB2BE6-DF1C-414A-B4C2-0C15FD1CBF75@chromium.org>
 <YoKVSEJyHvFg/V9+@google.com> <202205162038.B2D1BBAB3@keescook>
MIME-Version: 1.0
In-Reply-To: <202205162038.B2D1BBAB3@keescook>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v3 2/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 16, 2022 at 08:44:37PM -0700, Kees Cook wrote:
> On Mon, May 16, 2022 at 11:17:44AM -0700, Matthias Kaehlcke wrote:
> > On Fri, May 13, 2022 at 03:36:26PM -0700, Kees Cook wrote:
> > > 
> > > 
> > > On May 4, 2022 12:54:18 PM PDT, Matthias Kaehlcke <mka@chromium.org> wrote:
> > > >Extend LoadPin to allow loading of kernel files from trusted dm-verity [1]
> > > >devices.
> > > >
> > > >This change adds the concept of trusted verity devices to LoadPin. LoadPin
> > > >maintains a list of root digests of verity devices it considers trusted.
> > > >Userspace can populate this list through an ioctl on the new LoadPin
> > > >securityfs entry 'dm-verity'. The ioctl receives a file descriptor of
> > > >a file with verity digests as parameter. Verity reads the digests from
> > > >this file after confirming that the file is located on the pinned root.
> > > >The list of trusted digests can only be set up once, which is typically
> > > >done at boot time.
> > > >
> > > >When a kernel file is read LoadPin first checks (as usual) whether the file
> > > >is located on the pinned root, if so the file can be loaded. Otherwise, if
> > > >the verity extension is enabled, LoadPin determines whether the file is
> > > >located on a verity backed device and whether the root digest of that
> > > 
> > > I think this should be "... on an already trusted device ..."
> > 
> > It's not entirely clear which part you want me to substitute. 'an already
> > trusted device' makes me wonder whether you are thinking about reading the
> > list of digests, and not the general case of reading a kernel file, which
> > this paragraph intends to describe.
> 
> Sorry, I think I confused myself while reading what you'd written. I
> think it's fine as is. I think I had skipped around in my mind thinking
> about the trusted verity hashes file coming from the pinned root, but
> you basically already said that. :) Nevermind!
> 
> > > >+static int read_trusted_verity_root_digests(unsigned int fd)
> > > >+{
> > > >+	struct fd f;
> > > >+	void *data;
> > > 
> > > Probably easier if this is u8 *?
> > 
> > Maybe slightly, it would then require a cast when passing it to
> > kernel_read_file()
> 
> Oh, good point. That is a kinda weird API.
> 
> > 
> > > >+	int rc;
> > > >+	char *p, *d;
> > > >+
> > > >+	/* The list of trusted root digests can only be set up once */
> > > >+	if (!list_empty(&trusted_verity_root_digests))
> > > >+		return -EPERM;
> > > >+
> > > >+	f = fdget(fd);
> > > >+	if (!f.file)
> > > >+		return -EINVAL;
> > > >+
> > > >+	data = kzalloc(SZ_4K, GFP_KERNEL);
> > > >+	if (!data) {
> > > >+		rc = -ENOMEM;
> > > >+		goto err;
> > > >+	}
> > > >+
> > > >+	rc = kernel_read_file(f.file, 0, &data, SZ_4K - 1, NULL, READING_POLICY);
> > > >+	if (rc < 0)
> > > >+		goto err;
> 
> So maybe, here, you could do:
> 
> 	p = data;
> 	p[rc] '\0';
> 	p = strim(p);
> 
> etc... (the void * -> char * cast in the assignment should be accepted
> without warning?)

Yes, that would work, I'll change it accordingly, thanks!

> > > >+
> > > >+	((char *)data)[rc] = '\0';
> > > >+
> > > >+	p = strim(data);
> > > >+	while ((d = strsep(&p, ",")) != NULL) {
> > > 
> > > Maybe be flexible and add newline as a separator too?
> > 
> > Sure, I can add that. I'd also be fine with just allowing a newline as
> > separator, which seems a reasonable format for a sysfs file.
> 
> Yeah, that was my thinking too. And easier to parse for command line
> tools, etc. Not a requirement at all, but might make testing easier,
> etc.

Ok, I'll change it to use newline as the only separator.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

