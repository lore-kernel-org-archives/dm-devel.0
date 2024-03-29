Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9242146A7C
	for <dm-devel@lists.linux.dev>; Fri, 29 Mar 2024 14:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711720895; cv=none; b=m+qGTsi37N/U9QfOUiuQR1Ecy123pL+dWOa996ZGONKcsQbHnw2pyOAyed5T98wZgoarXNqzMKEO5XxSKK5wBHGUApf6lnRHQKYgTl7DkeIM46DT86tiZ9EaZgmMP0MiIuXVZci2vk14A8LWwQuJvBhEkzIDht0gEsq4O6Y87/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711720895; c=relaxed/simple;
	bh=i74F7NjaxnuQxdDtY85xiWNbuiNsx+NkmIsGdmHdShQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9ehwUISKz4g6WTo3dMP5as/IcvqRzzKCMpR8sa/lkLV1x0wKXAKjDy6mGVyQGZs8fej4oJ0ofIqjf4vbuJdcBl6RjYAadksKYmIyoy3YeV5IrFR0R3/1pCPuprA+6sZUcd5gjImZINwl/4kgKAj1B63BvFVuHZPM14s77gS8QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6e695470280so1036849a34.3
        for <dm-devel@lists.linux.dev>; Fri, 29 Mar 2024 07:01:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711720893; x=1712325693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lohjzyD8g/hGhEYvGq+VpCtpRHCNchr+EEmW0UGYQa4=;
        b=VMvNZxaqe5U6XbJoKLQjo78rSMaWj+kkxeJk5shtx08YNfvkoEXX7Y8w4IxtO7D8Ij
         TM+/0juXnmgI9y7bsxar3j/ofa7ap32ha+DCRBmPl18u0/JL+CCYA3B5uPJ5ZTAwOgrY
         E0rU7a6L2emykmz/cZdURENU276uvbd2grAojjfwdqD+KSfULxOMnIiaGG4XRB4l42kK
         5QqpowJj79k0cBzVmle8fbKmMmVgjBWWIFUWhVsKcglAnzgM8sDzeEBuOhLc1Ost4Ivz
         h2KRogarOao3wAAKbYMK4z17lMl5mE1U1A35mpcUQeRaXxT3HQUwMRbHxvqWiF8qiVjX
         OApg==
X-Forwarded-Encrypted: i=1; AJvYcCUcYPKYyb/LeHygm9zIo8ySM4F0jaOcPYPC8ZFFN9a+BHvbOfVUwQoQLMBOnG+di+EQpBExCnRASLRC9n43ZcUGlWs8D2Yoz0s=
X-Gm-Message-State: AOJu0Yw/bgXQCY5lGSrZD+m/0AaK/a5QJVuLNahTfDUoj5JgAqymrZhv
	UMD6jYj/PEk+QcIkLxIeCIUpIDBQrxhf6Q4W1np2c5Tq8JcGE0A/rwtU61U1kg==
X-Google-Smtp-Source: AGHT+IFsGhp10NMaL9dWqt1JzkamUY3E/XLNndhoccAqNlbVHfXe9eIcnVwx/GPeWcdOmWfGWY+mtQ==
X-Received: by 2002:a05:6830:1da:b0:6e5:1aca:aa26 with SMTP id r26-20020a05683001da00b006e51acaaa26mr2165579ota.7.1711720892924;
        Fri, 29 Mar 2024 07:01:32 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id nf5-20020a0562143b8500b0069044802760sm1663149qvb.120.2024.03.29.07.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Mar 2024 07:01:32 -0700 (PDT)
Date: Fri, 29 Mar 2024 10:01:31 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Matthew Sakai <msakai@redhat.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>, dm-devel@lists.linux.dev,
	cgroups@vger.kernel.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] dm: use bio_list_merge_init
Message-ID: <ZgbJu0Dx8uku5cTP@redhat.com>
References: <20240328084147.2954434-1-hch@lst.de>
 <20240328084147.2954434-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328084147.2954434-4-hch@lst.de>

On Thu, Mar 28 2024 at  4:41P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Use bio_list_merge_init instead of open coding bio_list_merge and
> bio_list_init.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
