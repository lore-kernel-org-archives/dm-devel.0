Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DF51E487;
	Fri,  2 May 2025 09:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746177424; cv=none; b=YbRUq9TolhW+wqAiAPKvZExMeHWQpwMaNCQP517ks6y00sHmM99eVFgRgfkBZqlxaI5K2zPYTuwgpzXoPD+dakmNXHPuaf2RKgHqJvhj27Iu4uKLffiryzl5JOazBfmP/k/3nWuyE4sYHcZMJoCH60wbba83MNwAF3+5E5Fu4x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746177424; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tDkjXstuT77a4lWUssZvqjf2w81fms7jmuX3odxf5kCx3+Uz70Ej1i62Msc2tDeb+jMKXF7uL1wXdeCy3HBIWBHyq6rlZJtoqJYPTUXUC3uUke+ePefZz13RoMQuozcA3o7Y9hD+AddpsjZBEx3xVLvEzrPVjrR9Ls5axu81f+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-39c0dfba946so1317453f8f.3;
        Fri, 02 May 2025 02:17:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746177422; x=1746782222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
        b=YFj+JNCtgSdyDfPRFOnCvoMMl/PH6f5VuVa0l7nqRTSilLvuUpHdRD0pN+fouxIMS/
         atftofqzgQi/8o1Os+tEWyhAr32pDF0vVYwXpCNHXi8FROqQ7lN8xRjNfovsr7DroVvP
         L2wMBkprGBrz6p51krXTqw49eWQsWP+8fUYqqGk2z8UlEL42b7SOGIg2k6j/0aKIGApG
         7j2JJySxktG8i2/SwQPtw9WI3+Rs/sc2M5xldoy96u3EIK45XU5zjq8aUu+tgO3ovYF9
         G5wUVYtviUNmYav6HzfSQCKqYc37iPKdXNmXbLXk2rtxucgZp8Iqy9C/BbOpb+luZGWJ
         pGvw==
X-Forwarded-Encrypted: i=1; AJvYcCUrfsqayErOZS7Awl0bfrKwZ24t9GvjpJuLUZV2TQYdDm0GZtCetIGbxAApspp+ag5sNtyCyw==@lists.linux.dev, AJvYcCXd+to1MxcZciWseXeiDmjKhpfVhAG4s78EgzkrJHlca+rS9gNEBMMOLStMBpUaKEUwrH+Fur25rw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+d6skDAd+uWts/+UmQxXY4ZgCaHWwjgNFFgucbL4MmVVOxTIW
	2fQIxnc0QQBrbDo9ZMUfBEtdpyQoya5cFsC545beH+Nk1y2/rxaK
X-Gm-Gg: ASbGncuoSclaqml5hIj2AGsGWMIbX3NowuDmE4lpj2CN6HS2EXxfh+gYHaZEtSWpXsn
	hHbwLrLSXq9OijsNb6/ZMWqiC8sMdZbY4T20HdWEM2wYE39LJskzXyew5SiDja3uwhFCtsI+Rc8
	BWtSNkSgyAaQCcNYlCR47qg9O0U9/tRNO13LxjLtD+5XuHGTE6SRJQqgMSMOiiucufSUSqXtx8x
	Xe4/BoM5yMN9YkYd47DtHwuoPI7BpACOTdnCPJWMfUdrkChP7cv4c+CX5JkuaVvncd44WUM+vFU
	qrZt149yYkPZp3ZGpPrpAafebhO0X9qm+RfZRSq0HZ5GprgrCvJuEaqqHjqkKxTAMuDE
X-Google-Smtp-Source: AGHT+IEHr91C4bNBb8k+B1Z8eJ4KnpjI8/kk3tpJZFK7ufLvYFKZ3M3NwP1v7B2vBEKWAwYg88p13w==
X-Received: by 2002:a5d:64a3:0:b0:3a0:8acc:4c5 with SMTP id ffacd0b85a97d-3a099ad27afmr1522259f8f.9.1746177421620;
        Fri, 02 May 2025 02:17:01 -0700 (PDT)
Received: from fedora (p54ad9a78.dip0.t-ipconnect.de. [84.173.154.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae3441sm1553880f8f.26.2025.05.02.02.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 02:17:01 -0700 (PDT)
Date: Fri, 2 May 2025 11:16:58 +0200
From: Johannes Thumshirn <jth@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, slava@dubeyko.com,
	glaubitz@physik.fu-berlin.de, frank.li@vivo.com,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 03/19] block: add a bio_add_max_vecs helper
Message-ID: <aBSNirClYlLrY-fN@fedora>
References: <20250430212159.2865803-1-hch@lst.de>
 <20250430212159.2865803-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430212159.2865803-4-hch@lst.de>

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
