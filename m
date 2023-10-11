Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A292232C
	for <dm-devel@lists.linux.dev>; Wed, 11 Oct 2023 18:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vws0/dxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB349C433C8;
	Wed, 11 Oct 2023 18:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697048884;
	bh=K5id8BiaRqGjf54cA+qb93BhD1WLjiWCvqD7VvovQaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vws0/dxx0C3YVZWhz+P+BoF4dceL58rt1ta65LwsccLToqAp7mEFRFzsJLMcGCgay
	 kAuB2ODLkfoE9lvX284CNdLvWqcYqy/ecewKGd7MCTu5LhI3pQeiA27ddUkxUpRFhu
	 3EQ78tax9FAqZmxJw8NQ8o6QuV3w/o6qesmKUD80=
Date: Wed, 11 Oct 2023 14:28:01 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: Re: dm-devel has migrated to lists.linux.dev
Message-ID: <20231011-lure-dismay-cab04b@meerkat>
References: <ZSCYSO8wlg4keAmY@redhat.com>
 <ZSCbqvX0f9LOXByf@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZSCbqvX0f9LOXByf@redhat.com>

On Fri, Oct 06, 2023 at 07:43:38PM -0400, Mike Snitzer wrote:
> The dm-devel list archive is now here:
> https://lore.kernel.org/dm-devel/

FYI, the archive migration should now be completed and will be tracking the
new list. This message is partly a test to ensure that it worked.

-K
