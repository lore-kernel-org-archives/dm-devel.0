Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1967238DC53;
	Sun, 18 Oct 2026 15:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792338602; cv=none; b=tItG+CZtlB55/lJHwFwxt5tCPJxCPLciJtqixS6jAEtq1IgbtPq3Drwu+Kol7ucwh0AKoLsIZfu5TlJxrdVJfDpYqQN60LJBWO5eSNOLtFNgl5zfUJ24vbrQlFJvIb/l0aS254H4csctFP8syOXWctPIWeFAVt9A4hFblPstIJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792338602; c=relaxed/simple;
	bh=nuWm5cdLlbh+eTVljmY2s0zpnWdBSnZbHIzuUMimW9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cb07jpP9xJ7JhEy7fJOPtkVdmzYBLuQYVPu7KRehgidOM7GOT43WvJ4ZQA6vOFENU922gduFfCqn0DJCF3NvPcCQQ4hlEhBww0NuYXS7TF8ojq/AGXOYoes6T8GhHUAfeYciyzsULthqjw4m9RJUkM1QSjGQZEIPi06oD/t3MgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5cqjmm0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5cqjmm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9FE1F000C4;
	Sun, 18 Oct 2026 15:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792338600;
	bh=6LphvJRgdMJSniREV29w572IWK1vBbe+xqjQ4ijfnWg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R5cqjmm0/pxO8eWkiE374zCrnaP6BYGUuQpanGQXmgKXv6qo9G0XALv+JAGPsZWBQ
	 82hnVRlC0cPE7YUB38NmsqyKeqrc16j3oJ19PIB17au1ZkjQyPXUGHHUZzNlARMPsv
	 0KcvhFPPxRiTgsG0EezciP9cGMpaHNwgsYzqn8lvZXtjxZ+oNUsGS7mqiF1Ov6t243
	 f4W5VXcv5VBZR8rpCQXrIvRUjVZCHlavSHklpYDj03gHAnBS8LpzOPNh1vgNqa7IIH
	 0XWlf3iNIi9ydffoEZCHNbPp9FWcUk9Q22rNrJE83iRR059mRwAvbwJW4HK1gc365z
	 0gP2Scs7OvnNQ==
Date: Sun, 18 Oct 2026 17:49:50 +0200
From: Christian Brauner <brauner@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, David Howells <dhowells@redhat.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Andrew Halaney <andrew@amutable.com>, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
	bpf@vger.kernel.org, fsverity@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 0/3] keys: Add well known IDs for
 fs-verity/dm-verity keys
Message-ID: <20261018-skrupel-ungefiltert-bauamt-99f4c40aa5f8@brauner>
References: <20261008-ajhalaney-dmverity-key-identifier-v2-0-008456d189cb@amutable.com>
 <20261012-broschen-inanspruchnahme-gebilde-d72cf2b99cda@brauner>
 <DM5UD20248FG.3BXPS76LK06F5@gmail.com>
 <20261016-ratlos-endkunde-eindimensional-1fe5eef08d13@brauner>
 <DM6CJUE4J2LX.2NR5QB5X3N0Y6@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DM6CJUE4J2LX.2NR5QB5X3N0Y6@gmail.com>

On Fri, Oct 16, 2026 at 02:53:23PM +0000, Alexei Starovoitov wrote:
> On Fri Oct 16, 2026 at 8:27 AM UTC, Christian Brauner wrote:
> > On Fri, Oct 16, 2026 at 12:38:11AM +0000, Alexei Starovoitov wrote:
> >> On Mon, Oct 12, 2026 at 12:38 PM Christian Brauner <brauner@kernel.org> wrote:
> >> > Applied to the vfs-7.4.keyring branch of the vfs/vfs.git tree.
> >> > Patches in the vfs-7.4.keyring branch should appear in linux-next soon.
> >> 
> >> What is this branch based on ?
> >> v2 was sent against bpf-next, because
> >> commit 264d8fd2794f ("bpf, keys: Add a bpf keyring for program signature validation")
> >> is only there.
> >> All hunks in keyctl.h, key.h and process_keys.c have its lines as
> >> context, so the patches don't apply to -rc as-is.
> >> And patch 3 documents KEY_SPEC_BPF_KEYRING.
> >
> > It's based on the portion of bpf-next that has Daniel's keyring patches.
> > Which means I just wait until bpf-next is merged and then send it as a
> > follow-up pr.
> 
> ohh. that should work. If it's simpler I can take this patch set into bpf-next,
> so you wouldn't need to monitor merge window that closely.

LLMs make that kinda trivial. I need to send late merge window PRs a lot
when we e.g., do tree-wide changes that would cause a lot of merge
conflicts if constantly carried in -next.
