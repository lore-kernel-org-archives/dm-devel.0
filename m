Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DBB30D406;
	Mon, 12 Oct 2026 13:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810784; cv=none; b=YycgwS7yLFFdqp+x++6FziUVfH8BY4hi9p/jG2ilDR6vox0DV9g2sVperbhvzpKN02RrpgkRjA8usiO6OVwjlcsrLNmSowTZIhV4ADFnDMnHUOlLoK6egYfWX5dmqMit2XbjsyRTA5K79WpMQ1LWcN9zKBGCPVc5JWusuODwp2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810784; c=relaxed/simple;
	bh=P454wXS9DdByiiPHUTNVgjn5IjNWcOJRLu+jD4eg/Pc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SaZB67FFtnOccWeiE8SGdaYjGF927nWfvHEiEXHSUdjtQKIYJpINvWYlW1cQ7yXzS2qUCqSF9pX8MmUu/McZt92qpq07Ql+L7u1QhNM+mFLct0cQBC15CYek6XZeV7CpdfuU8JQW75PKHDXtkRUGW/h3jFnOnJH5/MXiA1YR1ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KDpfWVnL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KDpfWVnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66A21F0089C;
	Mon, 12 Oct 2026 13:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810782;
	bh=4I5B7wBeXWUXzc9QUIb5L0wjsowp8PcPTfJjf0v/5MY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KDpfWVnLq9UsVjiuPGdSN9B+cXar5q+l6DBPzhmkDs+Ueb+r/Z8+7AbiaQcbXCLc9
	 VNOnSmW8xS6bS/TAcyQ0f/pSevPXUEVgqfdbxP3WlBTOMB/gY12NSlqp3+whay9o8u
	 SfYjiqBSX2o4k3933OLtpyYsadTur2naFzobQrigUJwNpGTMCuSa4cotQ63NgKCJiU
	 Si3VBhD4g2S5Nx4OULNzEaPPu0qIdUIZ8JnRW+28Kb7x0GLpy8BBhN8su+PDY+YWum
	 JGXgi0p0A69k2YrSGKqWSjLUZW1fpovIgDPH9GwXKDR+IKcL1JCaw4IqS7rJkndVkz
	 3pDHjpNGHf+kA==
Date: Mon, 12 Oct 2026 15:12:53 +0200
From: Christian Brauner <brauner@kernel.org>
To: Manuel Huber <manuelh@nvidia.com>
Cc: Andrew Halaney <andrew@amutable.com>, 
	"bot+bpf-ci@kernel.org" <bot+bpf-ci@kernel.org>, "ast@kernel.org" <ast@kernel.org>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>, 
	"agk@redhat.com" <agk@redhat.com>, "snitzer@kernel.org" <snitzer@kernel.org>, 
	"mpatocka@redhat.com" <mpatocka@redhat.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>, 
	"dhowells@redhat.com" <dhowells@redhat.com>, "jarkko@kernel.org" <jarkko@kernel.org>, 
	"paul@paul-moore.com" <paul@paul-moore.com>, "jmorris@namei.org" <jmorris@namei.org>, 
	"serge@hallyn.com" <serge@hallyn.com>, "ebiggers@kernel.org" <ebiggers@kernel.org>, 
	"tytso@mit.edu" <tytso@mit.edu>, "corbet@lwn.net" <corbet@lwn.net>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "rdunlap@infradead.org" <rdunlap@infradead.org>, 
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"keyrings@vger.kernel.org" <keyrings@vger.kernel.org>, 
	"linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"fsverity@lists.linux.dev" <fsverity@lists.linux.dev>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"martin.lau@kernel.org" <martin.lau@kernel.org>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, "mason@kernel.org" <mason@kernel.org>, 
	"ihor.solodrai@linux.dev" <ihor.solodrai@linux.dev>, Fan Wu <wufan@kernel.org>
Subject: Re: [PATCH bpf-next v2 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
Message-ID: <20261012-wusste-werfen-loben-94aac9fd9cbe@brauner>
References: <20261008-ajhalaney-dmverity-key-identifier-v2-1-008456d189cb@amutable.com>
 <910460850fd4163dadb804fbdf6c17f6a9dfec060f4d865a17df87336ea3e165@mail.kernel.org>
 <asgQxTE-6YtEgvYZ@toolbx>
 <DM4PR12MB61364B4F81AE7A8D1FB71E1BDE902@DM4PR12MB6136.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DM4PR12MB61364B4F81AE7A8D1FB71E1BDE902@DM4PR12MB6136.namprd12.prod.outlook.com>

On Sun, Oct 11, 2026 at 09:35:43AM +0000, Manuel Huber wrote:
> On Thu, Oct 08, 2026 at 02:57:00PM -0700, Andrew Halaney wrote:
> > With the BPF keyring ID already being merged here in bpf-next, plus
> > Jarkko's feedback/RB, I continued following the current pattern instead
> > of walking back the BPF keyring ID, and dealing with the
> > builtin/module/rodata differences I alluded to that would make that
> > approach a little more annoying (at least with how I thought it thru).
> 
> Another data point for this design choice: after initial discussions
> with Fan Wu, I am about to propose a dedicated .ipe keyring for IPE
> policy-signature verification. The keyring would be exposed to
> userspace so that a trusted entity can provision keys, modeled after
> the .dm-verity keyring.
> 
> I do not want to introduce churn to this discussion. I am happy to
> establish the reserved ID range and generic registration interface
> upon proposing my changeset, to establish this separately, or to
> follow any other suggestions. Getting guidance for this subject ahead
> of time for the case where 'yet another keyring' is introduced would be
> highly appreciated.

I think another keyring for just .ipe is fine if they want that. I
wonder what you use ipe for. I've implemented ipe via a simple bpf lsm
in userspace (well, for dm-verity. We don't use IMA or fsverity.). It's
available in systemd itself. 
