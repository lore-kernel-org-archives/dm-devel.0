Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5E586644
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716563870; cv=none; b=n4guTkbftMpw4ArDPqkjAmlYYWP4Bh3E3yrxlRg0ybqgg9YEJ4Cpl/GeWM8jCnY0H2qZr7aN4FlUhrHdyF2bJ/Hrzio7WzFgux8RflmYWJmLg/oTPPkEN179QTI63Bue7lfuczhU1UkvTqZjh116imI6SyeaWu8dO8rKvgeRDPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716563870; c=relaxed/simple;
	bh=ogJeLBfVi/q8VKA2MghKvEN86VsXSqxJl6qNr17O5oY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zq95LDhzFnSe4q+ndOiRQKNIjDVZvqpUIG6Flp0JZCUqc97ocKOy2fdI3/pKlXIhiAWAALfFnzjbKYNRYqYBOv6KzvDGMLna2o8Xsb3aZCN1tOYTavbGeH5HvXKOXddFSl3qQq6pv2kJtlA0EKG8CCYP08fD3tjrjlN1zsn3Gjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-792ce7a1febso296418985a.1
        for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 08:17:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716563868; x=1717168668;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHRRH4xO/lD0B5A+mQnuddNrtjcDUg2GphrYjUWZwX4=;
        b=mHNg/WESLwQJCvEU5CKQ1Q81/vwSOso13c+t/Cyuu8eVaMfiswXRAMY72/ELp2ayGP
         WWDsUOeT4xbmVWI+P26ayJs/edjJdqrhz7Qx5vu+gNdbRv2VDmbgMDoFicPo52TnH0qO
         YRe26dWSeLKIfFuTFzsLI4oqfPIrScPMBNsTmeknqxBYMf4pHX9yRNatMUiTuyclOM3i
         iHMoCbWRMRk3FrW9a1xqLNLA5Vni1VsY7h2exk8Qt0wg+fdBDV+DWCmLXRYsHLuAidKe
         oUXHTCcbBGa/pM6dVtuY3is5Bi+DG4OSa++MeEQJMr4y8q0Yqzp+UhsssfEM6rPqbDlg
         Za9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgVc3NRf9rY4ngy3lxeWh71L9MdlWcfoM9Oso8lzFPJWORzQzQOkaJApAW4b3YnVQw7eiuL/sq0ztfRS67/IW5ypxxSH9JfP8=
X-Gm-Message-State: AOJu0YxQ/jJa3tt1fId2GSwywv3Fp33ukpt4XYMIotrRy31WGYNRK/Tq
	Z4pvma3EDr6+3tvoPm7w09hD0alSNrolNtIjTRC2lw6WkxQEQ9ER7rAyYC9Klx0=
X-Google-Smtp-Source: AGHT+IHnNl97lF0jmbaeQAvD6YhDS2EY5lsp+p/3ECpyfDxlVITlKcEEOW1iX8vh1QN4DYiM3aU12A==
X-Received: by 2002:a05:620a:25cb:b0:793:d25:7b1 with SMTP id af79cd13be357-794ab08429bmr272781485a.23.1716563868456;
        Fri, 24 May 2024 08:17:48 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-794abbfcd24sm72610185a.0.2024.05.24.08.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 May 2024 08:17:48 -0700 (PDT)
Date: Fri, 24 May 2024 11:17:47 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: convert newly added dm-zone code to the atomic queue commit API
Message-ID: <ZlCvm3_PpaNmPa0q@kernel.org>
References: <20240524142929.817565-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524142929.817565-1-hch@lst.de>

On Fri, May 24, 2024 at 04:29:08PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> the new dm-zone code added by Damien in 6.10-rc directly modifies the
> queue limits instead of using the commit-style API that dm has used
> forever and that the block layer adopted now, and thus can only run
> after all the other changes have been commited.  This is quite a land
> mine and can be easily fixed.
> 
> Note that if this doesn't go into 6.10-rc we'll need a way to get this
> in before more block work in this area for 6.11, i.e. probably through
> the block tree.
> 
> Diffstat:
>  dm-table.c |   19 +++++++---------
>  dm-zone.c  |   72 +++++++++++++++++++++++++++----------------------------------
>  dm.h       |    3 +-
>  3 files changed, 44 insertions(+), 50 deletions(-)

Found a couple issues/questions in patches 1 and 3.

But once all looks good: I'm fine with these changes going through
Jens for 6.10-rc (especially in that all DM's zoned changes for 6.10
were merged through block anyway).

Mike
