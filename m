Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9414714A0BC
	for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 15:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752852092; cv=none; b=P0KVvd0ww6oGykZRdZpLst6FOeL8aB9oHkzh1coQPGkqCyZO3XnELeP7ufq0NTREfpKIeihI2fZ9oBYgYHfW6gYjs6T8snm2o8YwUUK2nY9vZ5J3FR+34awmc2KSXuGHv/u+/mBMs0ergI0g3BI8PpFSKKepXhAMcUprzFTERf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752852092; c=relaxed/simple;
	bh=GsYqjDDsfD6q6jigRpDbroMdmmD40smnNVyrjKACuh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hoiGmtSh301GOjYsNAbD8SBVD9beWx86lrVcjnuKYE5B3nJwmH9cVMqMdQyiHbq1NW0Mvxse7sKqnTRI1cCeJwwXWkFJvuX1vHrEHKPD+DoDikcE3mLN6QtXH4nOqjq5pFuW7zgewesVn6Pmjp4sT2f1vw6AE/TzHMD/8MYUBA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HaIWYgc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HaIWYgc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2227C4CEEB;
	Fri, 18 Jul 2025 15:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752852092;
	bh=GsYqjDDsfD6q6jigRpDbroMdmmD40smnNVyrjKACuh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HaIWYgc/Ygg+gcQmW0TiIHr+bP/iaCu2zEfWmGqM4DhjBvI3tdcwqt2wizIoto4m/
	 Blpu2DBy2Pi7/ZHHJBAP2KQlm5PjNkpLZrCDzaMPMfmHj9pRw7HeuWmLy+i+vNKFOu
	 Mjgymaa5VC8rz/94WvLppcPTuPOHZwI1n2FGZTU9R5fWuzJtSUkrONEDboPov5friu
	 Vnt4eAfZGKDsZDVGbt8b/+6mIg71GXqTPGAjpTM+fd7/zOODjCsvpsdcXdyA4jHrAh
	 CyS+6bzrGydnUi2SpzoRrvUN6XZiXOepC+vcsMG8kYsvvqSWOmAYyKJe/T6cb1M8r+
	 UkgtpNKpVjxEA==
Date: Fri, 18 Jul 2025 08:21:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eran Messeri <eranm@google.com>, Mike Snitzer <snitzer@kernel.org>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH] dm-verity: Rename bh-related fields
Message-ID: <20250718152130.GB1574@quark>
References: <20250717111750.1423232-1-eranm@google.com>
 <ce7553fe-320c-33e2-6e94-c597d0aa2205@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce7553fe-320c-33e2-6e94-c597d0aa2205@redhat.com>

On Thu, Jul 17, 2025 at 05:08:11PM +0200, Mikulas Patocka wrote:
> Hi
> 
> I wouldn't do this - these sorts of changes will cause problems when 
> backporting bugfixes to the stable kernel branches.
> 
> Mikulas

Sure, but doing the right thing in mainline takes priority over ease of
backports.

The naming here is challenging, and it is annoying that the UAPIs
"try_verify_in_tasklet" and "use_bh_bytes" are stuck with misleading
names that are tied to obsolete implementation details.  But for the
internal names I do think this patch is an improvement.  There are 4
cases for how data verification can happen now:

    1. In a kworker, via a regular workqueue.

    2. (When try_verify_in_tasklet=true)
       Inline in verity_end_io() in softirq context.  This happens when
       verity_end_io() is invoked in the BLOCK_SOFTIRQ.

    3. (When try_verify_in_tasklet=true)
       Inline in verity_end_io() in task context.  This happens when
       verity_end_io() is invoked by kworker, e.g. the loop device's.

    4. (When try_verify_in_tasklet=true)
       In a softirq following verity_end_io(), via the BH workqueue.
       This happens when verity_end_io() is invoked in hardirq context.

The name "in_bh" is wrong for case (3).  The name "use_bh_wq_enabled" is
wrong for cases (2) and (3).

But "in_bh" really just tracks whether sleeping code paths should be
executed or not.  "may_sleep" better reflects that.

For the rest, I think calling (2) through (4) "inline verification"
makes sense.  It clearly fits cases (2) and (3).  It's somewhat of a
stretch for (4); however, it's still "inline" in the sense that it tends
to happen in the same non-schedulable section as the hardirq itself.

Naming things is hard...

- Eric
