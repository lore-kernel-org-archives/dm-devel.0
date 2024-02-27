Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A76B13DBBC
	for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 15:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709047004; cv=none; b=gPGx1t/KiG2jruHiw/eDAtu3gXJQyTjiKrQNX/2fOVKdtTDj5N9ie+F7w6rTrZxaGKV72NinoSewOJqpvrli1FTfZAquAgFF1UQnLAEK//2vj+CzssWc0+ur3XkyXrbkMKs20w4mCeYLB8SMkltbK5ZzkIN0LHsqfoLHGati4lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709047004; c=relaxed/simple;
	bh=1TjOgn7EZpOUEEsdqxGzzOJEHrIXNZsYpIJc8flVC+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BsBU/cokxt4dFcXcpErluqlIcHnTc3XS0zs/dHDDQvvJ2l7eYladVNPi6wZto1vAvn58D5Z5JY+Z/8+K0/LaWZaboCU7m+bx/mkMaFvmBRxBvZCHFD0UU6DIzYVjEiDxC71CGDav2iWDtL2SmMMTZWlhv31q5Gq7Z9pHPSC8uHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-42e323a2e39so26708901cf.1
        for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 07:16:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709047002; x=1709651802;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wkw57nIPcfh6PkDenfS4Isf5pAlTCASFCEKqDWK0EfE=;
        b=BJ+uV1PV2dM8dpM8PXW7t7YBmo96t/jUpRPcJyuRiu3W2jls4LXdBaWtWaIMIuybaJ
         9Nz31A3AkNP0m5B02RW7GS2Y21oP73J1rJxTX7Qx0SjySM4iBn1iQIi+pnFRMIFOC1tA
         PyjRg/5QntP6dsD7tFucmjPbWVdnatoJIhw0nrcZ+2C6osBFq2YQ4U99k81DJI5pRaYi
         J7cLep7Ha2SE9SdAH22fAKIMBOwTHipPdsKv6QnIe/jKUm42b5gNMh3lpTZ3RFx/A6iY
         wjhOLxkdHYcX2Gb/fu8eioOfz0/Xu8kJ9V3jk/1nHK5Th7zx+Z8kaR4yfkidA4LG0siv
         j4jQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsIiZe/miwKFHEMYWSmLu64Be5w0kzJ5rrQMYynCcoQ+HKj/ixpk+N6g7jzO0NS9DXr5YHH64HYe8sJ9gocVaq7Riij0Wz8L8=
X-Gm-Message-State: AOJu0YyAod4DTf8GsRys4QMdAhE4srXzCy/QgD/fFgaxDG6aZSt5pDtY
	8mCTAe19Tie5ac0c5rmSvaGtQ27bLWJ3EeSJDY01dZLO2QLfv+Osi7ZmLi8+Pw==
X-Google-Smtp-Source: AGHT+IF3OX3RYDmLw5Xwj18/cLQPLdUQKcDoUQ0MjVBxCwuhrwbbGKCfPKDKriEFGlBfhfC7wVJNEA==
X-Received: by 2002:a05:622a:293:b0:42e:8114:9469 with SMTP id z19-20020a05622a029300b0042e81149469mr9852481qtw.10.1709047002287;
        Tue, 27 Feb 2024 07:16:42 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id y19-20020ac87c93000000b0042e79e54811sm3071786qtv.64.2024.02.27.07.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 07:16:41 -0800 (PST)
Date: Tue, 27 Feb 2024 10:16:39 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: Re: atomic queue limit updates for stackable devices
Message-ID: <Zd38193LQCpF3-D0@redhat.com>
References: <20240223161247.3998821-1-hch@lst.de>
 <ZdjXsm9jwQlKpM87@redhat.com>
 <ZdjYJrKCLBF8Gw8D@redhat.com>
 <20240227151016.GC14335@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227151016.GC14335@lst.de>

On Tue, Feb 27 2024 at 10:10P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Feb 23, 2024 at 12:38:46PM -0500, Mike Snitzer wrote:
> > Also, you can use the lvm2 source code's testsuite to get really solid
> > DM test coverge (particularly for changes in this patchset which is
> > dealing with setting limits at device creation).
> 
> And that one runs fine, although even with Jens' tree as a baseline
> it hangs in the md code when dm tries to stop it.  Trying mainline
> now..

That's the mainline issue a bunch of MD (and dm-raid) oriented
engineers are working hard to fix, they've been discussing on
linux-raid (with many iterations of proposed patches).

It regressed due to 6.8 MD changes (maybe earlier).

Mike
