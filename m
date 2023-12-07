Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FA53D0D4
	for <dm-devel@lists.linux.dev>; Thu,  7 Dec 2023 17:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="puHq3JkW"
Date: Thu, 7 Dec 2023 12:08:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701968920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eUd3xjH2HF2EejUSWZhUOf3yJDKcu6pMWysVFu8RiZs=;
	b=puHq3JkWtcBQNKbK5bAHnkin2RfTU367Wzc1OrpC+avd7p55JGJwuTXnTu5dsJFxD5ldDx
	K6V9iF4AyslZAbVyNff4Y9Nf/U8Xw1NCt8ZIJEwr0O1wLkJaGCgAZIMJd7Ef0iHSMKdh2l
	jxh5eUm5lg2fT0kvqSeerFEajefqv9k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-cachefs@redhat.com, dhowells@redhat.com, gfs2@lists.linux.dev,
	dm-devel@lists.linux.dev, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/11] vfs: inode cache scalability improvements
Message-ID: <20231207170835.yjpfpjy5or6bfkva@moria.home.lan>
References: <20231206060629.2827226-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206060629.2827226-1-david@fromorbit.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 06, 2023 at 05:05:29PM +1100, Dave Chinner wrote:
...o
> Git tree containing this series can be pulled from:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git vfs-scale

For the series:

Tested-by: Kent Overstreet <kent.overstreet@linux.dev>
