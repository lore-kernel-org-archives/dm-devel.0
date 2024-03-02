Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824FFEBE
	for <dm-devel@lists.linux.dev>; Sat,  2 Mar 2024 00:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709340127; cv=none; b=j/J9E4FWi8CsvUC/0wZnY/bNjDzE1aUrXpYTfOvX7ytGLL29cBTOvYX3WFg7LYlm4tFWv9Nal5bz3+lAwL11DOlojj0Y2Tv3fqEAB51Pb1oRJplEUvAzhkWRvuJ5GMkGAM4d4ijkH7UBEcH44J82Cy9Y6U4pAXlULxD7KRnXBZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709340127; c=relaxed/simple;
	bh=i729hCMFzqEbYAOmiK2FlB9Z2sI9k39TODZ4h7i1hfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i8Rv0uJOkvfGgJnRJ/mY41w3zSXxMs250f5oaHWGvBvzrSdkNzzqcImF5++BzqyMBmOwtER+b8wi2AcMmlvmeaKcgV7ng4xwYVlS9Bok2oc8WYuBVCpliu7FuQzytH0GaxsSqMjPYMqdOZO+sIboLae+mr3GnZoc4rQGop2vDEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eCZnFjMX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eCZnFjMX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709340124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i729hCMFzqEbYAOmiK2FlB9Z2sI9k39TODZ4h7i1hfI=;
	b=eCZnFjMXLMaBznlglKh0EscAg35wh6apCjkQJvt00tBDoOOIz+Zpmi+73Hhy0uX0K3TRkT
	QWl9asJcSqVCM6Qjno7N94oh506zRWPplnbpPIWvcyaJTtLUh0eIr0h7b6CmFpkhFecAfV
	hfe20QnsvxWTz5MZ7TYuPsXQPkBvdlQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-dr71JPdiMzCJA7P2q9w5uA-1; Fri, 01 Mar 2024 19:42:02 -0500
X-MC-Unique: dr71JPdiMzCJA7P2q9w5uA-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5cf555b2a53so2463577a12.1
        for <dm-devel@lists.linux.dev>; Fri, 01 Mar 2024 16:42:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709340121; x=1709944921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i729hCMFzqEbYAOmiK2FlB9Z2sI9k39TODZ4h7i1hfI=;
        b=Dz/kO7UFkHj4wCP8EMn7KqFe+7HZ5sCl7VFbhnUWtDRcOvT3Bo9744m0jKXvN2BguX
         U/2bu205M7/E7FHvj7YDJ0qmwRkdw3V2O1p7Su4E4HHo/InqkmNLE2VmQjUiMziICMqh
         j7ar5K9vO5JV27Eql4QzhCuHWQ7YGz1mM8WcIEwfPTG5fskhYb4ivUUYgTh2TACXVhCP
         g994n1zpFjgL1B1mtQzyb3e/TVTioq2rwS22HnxmGrGatk1ujT+RmhgdJ68He9zyCVi3
         eodjPW0UD5ycbCdCyxF0KzNqJcGulS7W2WJMELt34ub85VBhRF78+SzOIr91PXSWOhCk
         EvbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhLZYCchRyeRorNllY5mvcxwY6Z+wk4ZxxPB1oWgG+yyoVdWevE36YLiU0kytSsdRj9xlIOPTkQ/opFzvxw2x91KmcQ6xWdOw=
X-Gm-Message-State: AOJu0YyMIJOmyj6Rt3jXoWaEfO+y6bB1Lkmn370i/RkKH98dBtAfAjRL
	07j7fktp7ZxxMR33koJvHsb2jxj8WSXoTDclrQ6MyfVq+E4RaZgXK3R5njyx5g3N8wxRBrlc3PH
	j7TgI08FkgbL6uGr0pOIV36Ri415BxFwqQCO7mAaEDqypke3k51S7VvQdFa+179nxx9lOAKIfqi
	VF6XHcJ1RVZsTikM9eHyezs0UNwHPJ5ww=
X-Received: by 2002:a17:90b:514e:b0:29a:bdee:bc69 with SMTP id sd14-20020a17090b514e00b0029abdeebc69mr4954238pjb.8.1709340121692;
        Fri, 01 Mar 2024 16:42:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmQ5kRFjwCmVyags4kQc/4I/pGL7cgp2fA0CRlF1uj/1UejLX8I2lnBqaKZ+Iex0dKU0kd991J50MjJgaIO1Q=
X-Received: by 2002:a17:90b:514e:b0:29a:bdee:bc69 with SMTP id
 sd14-20020a17090b514e00b0029abdeebc69mr4954223pjb.8.1709340121393; Fri, 01
 Mar 2024 16:42:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240301152128.13465-1-xni@redhat.com> <CAPhsuW6ywzQ9oXUHt=2MN6kngWCvtGxOPffnzV=OHDs_01RGLg@mail.gmail.com>
In-Reply-To: <CAPhsuW6ywzQ9oXUHt=2MN6kngWCvtGxOPffnzV=OHDs_01RGLg@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Sat, 2 Mar 2024 08:41:50 +0800
Message-ID: <CALTww29CwWtP5_jBJANGZyAAQw05g=ak6Cu5m+V8p=cJb4MgkA@mail.gmail.com>
Subject: Re: [PATCH V2 0/4] Fix dmraid regression bugs
To: Song Liu <song@kernel.org>
Cc: yukuai1@huaweicloud.com, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 2, 2024 at 6:28=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Fri, Mar 1, 2024 at 7:21=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
> >
> > Hi all
> >
> > This patch set tries to fix dmraid regression problems we face
> > recently. This patch is based on song's md-6.8 branch.
> >
> > This patch set has four patches. The first two patches revert two patch=
es.
> > The third one and the fourth one resolve deadlock problems.
> >
> > I have run lvm2 regression test 5 times. There are 4 failed cases:
> > shell/dmsetup-integrity-keys.sh
> > shell/lvresize-fs-crypt.sh
> > shell/pvck-dump.sh
> > shell/select-report.sh
> >
> > And lvconvert-raid-reshape.sh can fail sometimes. But it fails in 6.6
> > kernel too. So it can return back to the same state with 6.6 kernel.
> >
> > V2:
> > It doesn't revert commit 82ec0ae59d02
> > ("md: Make sure md_do_sync() will set MD_RECOVERY_DONE")
> > It doesn't clear MD_RECOVERY_WAIT before stopping dmraid
> > Re-write patch01 comment
>
> Unfortunately, I am still seeing the same deadlock in the reboot tests
> with two arrays. OTOH, Yu Kuai's version doesn't have this issue.
> I think we will ship that patch set.
>
> Thanks for your kind work on this issue.
> Song
>

It's a process for me to study :)
I'll have a test based on Yu Kuai's patch set and give the result later.

Best Regards
Xiao

