Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA7B3A26A
	for <dm-devel@lists.linux.dev>; Wed, 11 Oct 2023 18:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NB+jdiiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2DBC433C7;
	Wed, 11 Oct 2023 18:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697050370;
	bh=PbKSVQuoRrupMW+apdq+9X+8cgugMhjhXpKq0eAfpE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NB+jdiiENcmE56q+5R+l+R4U5RcO4OuLXZ8FgDwUypteleFObvRnMIL8w4Vfb5S2X
	 Z1kfob5rXsnqQOdFcEH72qll6Cy7APC6rbFjduprTGLn1Coeb0z+AqEfc9qm43X5bh
	 teiXBJKHHbTmOybOUk12IMLZb04/q2D1OBGPFPLY=
Date: Wed, 11 Oct 2023 14:52:46 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: Re: dm-devel has migrated to lists.linux.dev
Message-ID: <20231011-undoing-revision-89cb41@meerkat>
References: <ZSCYSO8wlg4keAmY@redhat.com>
 <ZSCbqvX0f9LOXByf@redhat.com>
 <ZSbsdlfRAoUj8Jzb@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZSbsdlfRAoUj8Jzb@redhat.com>

On Wed, Oct 11, 2023 at 02:41:58PM -0400, Mike Snitzer wrote:
> [this is also test, to see if new list allows old list to email it]

It does, but I don't recommend doing this, because the messages forwarded this
way will arrive with broken DKIM signatures (redhat.com signs the List-ID
header, which we must modify).

So, even though the message sent to the old address will make it to the new
list and to the archive, it will likely be rejected by many subscribers.

I recommend doing this just for a week or two and then just doing a hard
bounce without a forward.

-K
