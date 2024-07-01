Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C28416C697
	for <dm-devel@lists.linux.dev>; Mon,  1 Jul 2024 17:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719854732; cv=none; b=Cky3DD4EbJBMi7c6COfWvXnL1T4f7JgUwuGmeeLdsPErT7U2vFz5VP5rm4eJvuqnNNMOQ0T2FtRQVP7pOb+6piiE7GNmWmI5tGhToRYzHtmKFiqtYqQKU5ym8+tec7rNFWzphpbHveALnSe5HCKuplNxnKuFVZyyoARzWh2F2Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719854732; c=relaxed/simple;
	bh=aijWMinS3/Cl+sVa8RAsMtumkM0V2JKgXj2DJXZhUok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hWNkyKWCzuQCk2MNl/6Jwj5cWh1HfXypHBjOrvjTBZTqvQiHiAxhMrWxvORLLdkLQJO51qlsarxcV+TtXwHJnV6o/z3xz7MRfl/tH4TpR7nWAcOGGGFvagVypINrk3f8ABTApC6+EPuaRyyKR0ZNuNFtGq3MniOX9eoHFOuFyTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rgo8yR5w; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rgo8yR5w"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1faad2f1967so32364365ad.0
        for <dm-devel@lists.linux.dev>; Mon, 01 Jul 2024 10:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719854731; x=1720459531; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iYrXt/RrJXu2c0c790MOYBofpqZy6fGBFKHQFa14QyM=;
        b=Rgo8yR5wSRPLrp5KUkpb97MfJqeM4+RMNYgFC46z6ZPYBnW5UrPmXrWLuQl23BrVaf
         bQ2BPTtCdR+fA59WR1ly74ub9AJxNGqThH8aFrVeQTPVcC0KuxfhfW/pp04aEEjKj1xH
         yjI8acZRpXQX3/WIhUEv9S9kDGTlkMhE81qNJ/Z0dtacHcBzrVBpqwnmxfHk2gl8sI6i
         6AjnN4eU+oW884863YQC7qOtr+yKF91KPGIeh2KSKplO4rmLJohXyxCrCbRNY4wIqH16
         iLFZA6OKA0mHUnyNWWnNOITkhw3WJtmbl2P1L3QXNj2RfkylwDrV65bjxhBzZboBY5Ct
         C+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719854731; x=1720459531;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iYrXt/RrJXu2c0c790MOYBofpqZy6fGBFKHQFa14QyM=;
        b=dr1WgynF1RQblcWhiXNvX3aARlkOnNxYCH2qr9Pb1jaZ62qQ84wNYFrhFKdCiUMd7F
         gAWC5wZ+6BJsGq34CtmmbQpXMvag5FlHaXOr+hTQw6AbrWYkuY8IQJZhFMnvc2Epqj+l
         vgH2YR649bzKAiO9fQMpKBSZdwH9rWXtN/66o3vfCtB6Pixdl6JIaRd8QaeGpPeckWpV
         sEV72OE5TOwoKapC4jI3IprORoTsvCNN7jVRU0sk8X9e9PJVKHdxjczCQjnRG1k91/RF
         QAt1IAUaHWQbExcdTRszzwe8yCN32QosX+t3d+7JQJO+fTq0V3sgLogGhR8RCXW5ofbm
         QVmg==
X-Forwarded-Encrypted: i=1; AJvYcCX8vaBCK6JmKMYDYVjhAs0zaUnar9fLyWoLkTkJrnE95yBKFVLdTgbJOZOgYZU1TKjt3vee0ZcvM9EhT8POnM294kej2QTN06s=
X-Gm-Message-State: AOJu0Yyho8JW90Ri2aNctDWbfpsBQy3cQaV1Illy5Ubk8nrQvV/MdYLA
	82PQn3RZOYYkASM0bhxsyhyCHevITd624Hn8eeET2CSX41U2Mjr6PE48JQ==
X-Google-Smtp-Source: AGHT+IFngXRQ0EXxDqvNM5KNS4OFPMVY7KW0L47bGeBUZHL3yUUiYF4UV5ZzCgkhrJVOcrVVmWy1kQ==
X-Received: by 2002:a17:902:ea0e:b0:1f9:f3aa:fa86 with SMTP id d9443c01a7336-1fac7f1b664mr161379425ad.33.1719854730542;
        Mon, 01 Jul 2024 10:25:30 -0700 (PDT)
Received: from localhost (dhcp-141-239-149-160.hawaiiantel.net. [141.239.149.160])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac159686csm67502255ad.266.2024.07.01.10.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jul 2024 10:25:30 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Mon, 1 Jul 2024 07:25:27 -1000
From: Tejun Heo <tj@kernel.org>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Waiman Long <longman@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Laurence Oberman <loberman@redhat.com>,
	Jonathan Brassow <jbrassow@redhat.com>,
	Ming Lei <minlei@redhat.com>, Ondrej Kozina <okozina@redhat.com>,
	Milan Broz <gmazyland@gmail.com>, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, users@lists.libvirt.org
Subject: Re: dm-crypt performance regression due to workqueue changes
Message-ID: <ZoLmh5L7WrBqtn79@slm.duckdns.org>
References: <32fd8274-d5f-3eca-f5d2-1a9117fd8edb@redhat.com>
 <ZoGSJWMD9v1BxUDb@slm.duckdns.org>
 <e64c112-4fa9-74da-68ce-c1eec19460f2@redhat.com>
 <ZoKqYg7TKiozapmW@redhat.com>
 <e52c5a40-8ca9-38ae-1595-3785c6ac435@redhat.com>
 <ZoK0kwzis1iWVyLr@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZoK0kwzis1iWVyLr@redhat.com>

Hello,

On Mon, Jul 01, 2024 at 02:52:19PM +0100, Daniel P. Berrangé wrote:
...
> None the less, I'd suggest that virt-manager should be a explicitly
> asking for sockets=1,cores=N, as that has broader guest OS compatibility.

+1. Multiple sockets is pretty uncommon and often comes with significant
performance implications - e.g. if VM is also splitting memory into N nodes,
that can lead to significant higher overhead during reclaim due to node
imbalances and premature OOMs. If the reported topology is not real, it
makes a lot more sense to keep it basic.

Thanks.

-- 
tejun
