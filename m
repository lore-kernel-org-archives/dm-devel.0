Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0B122AE75;
	Fri,  2 May 2025 08:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746175953; cv=none; b=E0dxt/y3roWsRh0BR7yYh7QKBALwbgmN2MJJo1JWCNSxQ2HuMMdP8wAkPN+bj6J/rUlCsfqjjjaLJL7HMIHYZa9bOZfYS20BBsOoxe+GKZ7zrKjO1oDC/XtgFEE+1EMvxJVNFPYM0tdtzQC6xKCXPfYRuCvl3e0BxUm34JEzia0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746175953; c=relaxed/simple;
	bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e70hCsKxCT/6qv9KvZ15dH6lsCIGzp09j5JKu96ArG1RDP58QI6nMVJR+Bzju0fTgQN8odtKJii0mm/M1J1QK/luiW1OjQd+axPH2JgIGumTCDm5sa243STLkp0snapsIInlakQqYFqSYvkD/uNbJ660Fr3oso73S5grtrf59Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39ac56756f6so1776394f8f.2;
        Fri, 02 May 2025 01:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746175950; x=1746780750;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1UF7RGtB1Pbog0NUMV8tDJBLwjc+mTRVhKiphrplxs=;
        b=KX/8eNg1rb1YdCPaqlfmGRb8Nr14TMupp+QF4QesV4cxfA0ZbqYL4crJ7Uex5inzGQ
         mvRGTUN1sLLqlnsAlcOhq8xNykLuJLkkRsw5TcO6J9wYRunZMnFncWvLuCsZhDPFseiB
         7Y5EKCXnJLS85R/azrbM1c1URJd4xheDu1+f7htOlW4MDIJvlUUdO08NVVJlFhzFcMyo
         AKr3BIMbxygDVORLL02mwzBnh4ei2UrKbpWnBx17oIskEFvFbwKVAFVGsMSqYK17/Qk3
         6ObsjzXVic409FsJnBrrYwn/+cSiYuoG2s2sNjSrzhhupOESbEM/kxjRpB50x+I7Kx1y
         xPrA==
X-Forwarded-Encrypted: i=1; AJvYcCUY9n7FmvV5Rp2Az6P6408y9ERqxJnZh2pUKK/KShXKxlJVAGa5Bw76370aZDW9ZWumMMQiW3hpbA==@lists.linux.dev, AJvYcCViwHdbsya5peL/5lHHNvuqHTlxBt/mmQXIRt6l2TV50Q3N6uWi7VDExJVsIZrepnE4Irrf+g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwO5DPNd1gNrYJGfuhDuEjKJCLtWPP2YqRfNR6Zofz927UQVKf6
	R1xxOsdFhWKerLTzrIvDJPlMNQMd1XkBtDjfJU8DgxdTKf3SeEGF
X-Gm-Gg: ASbGncvJQpRCB3oGaFvqCzg4/XzM/6bpW65ICJ3v2sukMI8MAUze1TEKx+3z6yysM5V
	Gq7Xjn92wXeQ7xtvVckBIddNlNOvDkfo98V5JcyzjaP8S0wOwa3q4NwaXE2v4PwpBerPK4h19LN
	R2g0Z3BpStNga4/LF7znXULTEyCLF6mNcGfpDqkT1jEZPXj4llhTzvFcq7khZwHdauPZ0VTc6M1
	eaAfDEK+3AQ7+blyNqbWfgUGui6XvUGTuNUOkQJRbOpmbW8Iu3i2MJXnCjl9oJ8Edoy8f0YikaC
	eW6ev5C8G8Im3ZjvO0BD9poiD5sabSD7ox2ih/uZZan3jsk+TBJHL2jT4A==
X-Google-Smtp-Source: AGHT+IE9669DK67oKwLOAlAwcYfBBqCESjIKom6hvx2QNNfYlaOOfYtClSN42SPBuE8wsJXFDXbvEQ==
X-Received: by 2002:a05:6000:2209:b0:3a0:82f2:3094 with SMTP id ffacd0b85a97d-3a099af1a8dmr947113f8f.50.1746175949770;
        Fri, 02 May 2025 01:52:29 -0700 (PDT)
Received: from fedora (p54ad9a78.dip0.t-ipconnect.de. [84.173.154.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099b172b3sm1535001f8f.90.2025.05.02.01.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 01:52:29 -0700 (PDT)
Date: Fri, 2 May 2025 10:52:26 +0200
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
Subject: Re: [PATCH 07/19] block: simplify bio_map_kern
Message-ID: <aBSHykx-sNMJEenF@fedora>
References: <20250430212159.2865803-1-hch@lst.de>
 <20250430212159.2865803-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430212159.2865803-8-hch@lst.de>

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
