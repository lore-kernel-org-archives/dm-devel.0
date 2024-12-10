Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA8923DEAD;
	Tue, 10 Dec 2024 16:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733847934; cv=none; b=MRjMpYVhH7btvMRtT3V+YjFBRSdfakEraixVFyYMBttaswqyZ+CkcJTGi8WXTWWFnzGmG75XcG5uFJOb83DeXMQGWOqYs3hfkBXIG4JBO6IuRmCRzxnA/+RLgq7AhTihaMLUAbTZPcxAak8ih2Zbc7M3KPj3UBymr0oEgRv4PYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733847934; c=relaxed/simple;
	bh=bMY2y3X7jHv/QHiqsH1Rp1Wjo8/cKcuBZu7oYLVL7xE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jB1DnJlDwwE8bzelwxij87xkMoTv9ueLz+3N9LD8EczJtJiyga7n7pVcucYmUEznrWRKTc64JmV9regXhcdUWuTIFNjS/uFGSFONAYVD1PNimlGle0gSsnor6TNPmXuWfTnoeh6bg6IV3AJUyFmtSwbUyanpCPVBMCmaW/fYn9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iu/uhRg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iu/uhRg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D65FC4CED6;
	Tue, 10 Dec 2024 16:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733847933;
	bh=bMY2y3X7jHv/QHiqsH1Rp1Wjo8/cKcuBZu7oYLVL7xE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iu/uhRg40/zoiiay7C24fF9Jt1DBUQdKppAS8gM0enk9/iJsRL5+moWrIVfWsF+kx
	 3VdGi5kO/H47NoqCQXiBrv9UOLJgzlKDapW+v1ZAje3H6nj8SojUHxqw5R6zi8A8HD
	 hOQYBt1rOWvOmD+unCbJKpiYpbk8uc7p0wpn4eUaOdHxzryJfbXohtHqZN056awPAu
	 COEzFx8Jr9r/dljOppQCtQhRETEi/nZDxWRB4xGies2973R+4DwntvAJHkIYMAYJLJ
	 z5EcQgw9xKjgCBQaKo/MAWPNr6TEyzc6Lm+2mg71ufauJh1ljzP+H2KS9/hy66mCtG
	 b32MyyXnQ3RkQ==
Date: Tue, 10 Dec 2024 11:25:32 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>, zkabelac@redhat.com
Cc: Mohammed Anees <pvmohammedanees2003@gmail.com>,
	Alasdair Kergon <agk@redhat.com>, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: dm: Allow the use of escaped characters in str_field_delimit()
Message-ID: <Z1hrfMRedzEJb26O@kernel.org>
References: <20241112175758.114080-1-pvmohammedanees2003@gmail.com>
 <d62bac7e-432e-23bc-3d4c-d860e164dcaf@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d62bac7e-432e-23bc-3d4c-d860e164dcaf@redhat.com>

On Mon, Nov 18, 2024 at 11:38:05AM +0100, Mikulas Patocka wrote:
> 
> 
> On Tue, 12 Nov 2024, Mohammed Anees wrote:
> 
> > Escape characters were not handled before, which could lead to
> > unwanted issues. Some device-mapper names may contain backslashes (`\`)
> > as valid characters and should not be treated as escape characters. Only
> > escape characters followed directly by the separator are considered
> > valid and need to be processed. After handling, the escape characters
> > are removed to ensure the final string is correctly parsed without
> > unwanted escape sequences which were used only for escaping.
> > 
> > Signed-off-by: Mohammed Anees <pvmohammedanees2003@gmail.com>
> 
> Hi
> 
> Does anyone really need this? Is there some use case for using escape 
> characters in device mapper names?

It would seem Mohammed cared enough to write the patch, but not reply
to you with further clarification on why it needed...

BUT, in this instance it follows that: if lvm2 is allowing weird names
which require escacped characters _and_ dm-init is used then dm-init
needs to support handling them (dm-init is all about _not_ using
normal initramfs with lvm2 in all its glory).

Mike
