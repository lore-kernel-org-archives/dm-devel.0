Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8239EBB
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 01:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706664556; cv=none; b=J6GQxY9yasHCU1HG3VRlFTEfYFegWegyiGIQAHriCScWzYTMpdfKDQ3IeyNIJQ65IAKuFAtXHoRDlOpSZi5dNS6NFzEhvaG1HuxvGbNL8UUF5iu+kqdIKWvomcWBqLIvDnqYK6K49dswv7TqEt+Ln8+ydkBNL8jGMWfsvON36I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706664556; c=relaxed/simple;
	bh=aJlhUnCAcl/yigpRuUE3FKFXJmobkfI0YtXFMKt6Ne4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kvvRqTVLqqNNKyXo9r5FSLu32mShNJ4K+IzzVNADv9yQvkWCGqu1Ey3kxDhsYnaKVreNK9TnBMqewtJTpstyltyPZG0069Xdwy5vb24FH32NcHPTC2eUmzMsbCL2JHeKjt3qYsOR6zaEir8vEaoJ8CCLAkqPuxrWz9b0Or/VXmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b+ShOc2V; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b+ShOc2V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706664553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JNqnrWYNhsbLxXIHidmeYKuJLzR8cqpFCLs5iG5NUIg=;
	b=b+ShOc2VM6S90hwqJVTQUVDw+akx0n3xxYQV/x4aCvn0t/aHRTD02HeoF+wZ8KDsZJVz28
	lcuR0J1xlXxEBe0+2xC6ggYfuGhr0gOZxwfV86YXe8jGUKeaCFZxQ2n4pOZ92SqidrsUsm
	BQr7PeqqmjxRcYJK6/NWJc6xFICMjYo=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-wTWJRYUjP7CSwB2tVPeZPg-1; Tue, 30 Jan 2024 20:29:11 -0500
X-MC-Unique: wTWJRYUjP7CSwB2tVPeZPg-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6dde04e1b6aso2661582b3a.2
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 17:29:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706664551; x=1707269351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JNqnrWYNhsbLxXIHidmeYKuJLzR8cqpFCLs5iG5NUIg=;
        b=fi6OTOMqoAazeOsRvhI1b+IifG6msauU4tCqjwScDZ/OaORXwpn96JVq3m8dTzXRFj
         ClbglolY+MIpNCSSPr/kRPnc4wIImIFuMuh0irXw0JPNj358/IE098KoZE2zRUH6Uoa6
         wmYXESrBtkvB/LDTqCCOwncRwW0zE0k68/8NsaBDCUsh4dOhGF3cT1j8hgGhyz24z10X
         LsU2zz9PLQNeMrmT2nrR4tbuhZevZ6SER91tmDIs6mFgWZiOxbVULjBDpqUjmm5UX847
         LCzOwYhcGyj/M25kyYzgYvl24cbElrJHvrS4h/xtedFQGAe2K7noIQ5G/h+a11B4DQXv
         Ou1A==
X-Gm-Message-State: AOJu0YzzKhWAqPm6z1T6rPhTJMfFASf1A1Upo1Ghu3zX5e3lwpQoaRol
	EebrBHEZfGGKREckhU8Z6pr4s1/T9hTPGDZD3+8xysahnfbJGlyq5TJbDTmXJ/uduUYbJCCgYcx
	WZfT9k2S3JcMLHDVmmmI9E+sDq3OF/7nEnQsEYyutYtohaI++Hnfsy9wtMVECtP8dYW0dFDJ9/Z
	yLFLWJWfT3s2njAxCFY7EX4HF2s6Wu0ME=
X-Received: by 2002:a05:6a00:c8b:b0:6db:d4f8:bb1d with SMTP id a11-20020a056a000c8b00b006dbd4f8bb1dmr431524pfv.2.1706664550904;
        Tue, 30 Jan 2024 17:29:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFr+2mKU7NfBaA1rJF29186UvNGqzXqI+b2lGNzCcEvEyxDyhvBbMJiH6oHf82morLlvpAekP+aQ15hJyqjlbo=
X-Received: by 2002:a05:6a00:c8b:b0:6db:d4f8:bb1d with SMTP id
 a11-20020a056a000c8b00b006dbd4f8bb1dmr431511pfv.2.1706664550628; Tue, 30 Jan
 2024 17:29:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130021843.3608859-1-yukuai1@huaweicloud.com>
 <CALTww29QO5kzmN6Vd+jT=-8W5F52tJjHKSgrfUc1Z1ZAeRKHHA@mail.gmail.com> <78016a94-737a-af4d-446b-c9fbef967895@huaweicloud.com>
In-Reply-To: <78016a94-737a-af4d-446b-c9fbef967895@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 31 Jan 2024 09:28:59 +0800
Message-ID: <CALTww29UKCJcvJB2BvGTbCcpvD4Y-J+Bg1WgE0nOijLNMv=RGg@mail.gmail.com>
Subject: Re: [PATCH v4 00/14] dm-raid: fix v6.7 regressions
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, heinzm@redhat.com, agk@redhat.com, snitzer@kernel.org, 
	dm-devel@lists.linux.dev, song@kernel.org, jbrassow@f14.redhat.com, 
	neilb@suse.de, shli@fb.com, akpm@osdl.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 9:25=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi, Xiao Ni!
>
> =E5=9C=A8 2024/01/31 8:29, Xiao Ni =E5=86=99=E9=81=93:
> > In my environment, the lvm2 regression test has passed. There are only
> > three failed cases which also fail in kernel 6.6.
> >
> > ###       failed: [ndev-vanilla] shell/lvresize-fs-crypt.sh
> > ###       failed: [ndev-vanilla] shell/pvck-dump.sh
> > ###       failed: [ndev-vanilla] shell/select-report.sh
> > ### 426 tests: 346 passed, 70 skipped, 0 timed out, 7 warned, 3 failed
> >    in 89:26.073
>
> Thanks for the test, this is greate news.
>
> Kuai
>

Hi Kuai

Have you run mdadm regression tests based on this patch set?

Regards
Xiao

