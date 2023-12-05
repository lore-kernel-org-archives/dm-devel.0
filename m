Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BA02AD30
	for <dm-devel@lists.linux.dev>; Tue,  5 Dec 2023 21:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Zm3P2qOR"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a196f84d217so10726566b.3
        for <dm-devel@lists.linux.dev>; Tue, 05 Dec 2023 13:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1701810065; x=1702414865; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Vvk6G98iwDtRZNf78Z21bMAs1eP2eCE+1NjOFm2G6Zk=;
        b=Zm3P2qORcibXS7+S9lzXVFelp/NGLsCr1dv1QwSIvwpvFemIb32bB38uyrKRr1oZD/
         DRDoFsVMpKPyEXG4NFexWEIhu7M8eijKFYaWDmI8YatLC1Hxbgm8Afn85/WgwjYVCwHQ
         dvXn4SgsGmuN0ORqA6vt8utc5lO27qR6ES3CVEISOIxnOkelywx4mSJfjF4mNE/ozeKl
         /JX+f+HBSyTPBVXO7oUSRkUc6qGAzXKICIUIhFUORMl/whFaZ1dr2hhYSmXTjnaH2Ihx
         sKHS3Ki9hviHOMSGzp4eb+8VrcYTs0IZ7holImms8Abi1xhQoSB8fjWzXnLF9Uw4ckvb
         r4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701810065; x=1702414865;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vvk6G98iwDtRZNf78Z21bMAs1eP2eCE+1NjOFm2G6Zk=;
        b=kIShCByBgNgltn38z21JZw3MzXI5OVETFrQjDscN3IfIo4uM8LJadMYF6ak9flCPE8
         B69Swp1DvW/UpzaE+gXyo8TI3x9Il3l21/IxdwSeUPdP9U30UcsQhAahzQvXB42xXWqn
         qfrBHaG97UF6f3nne2wxyvMz3cQDi6aU5Gin/SB6eRX2IrXyPP0R+L6CYGunpUbLqBtU
         RnXSf960OY+Kw+PswUONcsIMnJNh/e2DAPc7x4DbSGFVAqj23Wy5sg/wpVDXiT0Du2LW
         SphYTJVrtLZpyebafa6rJzYvOh8cKVWW2v80yqiZcs06Bto3xbAaQGjEKecrndRpek8C
         wo8A==
X-Gm-Message-State: AOJu0Yxqlx1QrYKX7lrqjoKGegHgqFDhb/mg4YwDojKfdl31igb2yEHJ
	hD0OA/epoSQj5ik5T/whIOh2xQ==
X-Google-Smtp-Source: AGHT+IHJUy5jICkgDIwcs++mpCVe38aReKg3hFVXxCQG2ACby9NF0Pk8M0sWKSvEi3fjZGNoFWRUUA==
X-Received: by 2002:a17:906:f0d4:b0:a18:ab2f:467f with SMTP id dk20-20020a170906f0d400b00a18ab2f467fmr3706726ejb.37.1701810065495;
        Tue, 05 Dec 2023 13:01:05 -0800 (PST)
Received: from apollon.wilcks.net (dslb-090-186-000-097.090.186.pools.vodafone-ip.de. [90.186.0.97])
        by smtp.gmail.com with ESMTPSA id f23-20020a170906495700b00a19a40935a6sm6369594ejt.141.2023.12.05.13.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 13:01:05 -0800 (PST)
Message-ID: <0cc5ec31586a1832a6c08d9bf608a68fe804663f.camel@suse.com>
Subject: Re: [PATCH] multipathd: Make sure to disable queueing if recovery
 has failed.
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
	development <dm-devel@lists.linux.dev>
Date: Tue, 05 Dec 2023 22:01:04 +0100
In-Reply-To: <ZW951oB3ANEs16z0@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231127215418.271708-1-bmarzins@redhat.com>
	 <23fc863a947a0362e31e4cf685a4cb92f4e9178f.camel@suse.com>
	 <ZW4v8bZSDSypdv42@bmarzins-01.fast.rdu2.eng.redhat.com>
	 <094991ab4257ab76755d83a8738676f76327d1ec.camel@suse.com>
	 <ZW5aQ7T+znP/3N56@bmarzins-01.fast.rdu2.eng.redhat.com>
	 <00ea66aa2aa83176d6db9609f5173bbd5e294381.camel@suse.com>
	 <ZW951oB3ANEs16z0@bmarzins-01.fast.rdu2.eng.redhat.com>
Autocrypt: addr=martin.wilck@suse.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2023-12-05 at 14:28 -0500, Benjamin Marzinski wrote:
> On Tue, Dec 05, 2023 at 03:57:13PM +0100, Martin Wilck wrote:
> >=20
> > You are right, I see. It's actually an inconsistency that I would
> > like
> > to get rid of. I suggest that we ditch mpp->features entirely, and
> > just
> > keep track of the map's features using an abstract representation
> > using
> > booleans and ints. We should never apply kernel status changes that
> > are
> > inconsistent with our own representation of the map's features,
> > IMO.
>=20
> I don't agree with ditching it entirely. The existance of mpp-
> >features
> allows people to use a kernel feature with a version of the userspace
> tools that wasn't doesn't know about it. This means that if a new
> feature is added to the kernel, the existing multipath userspace
> tools
> can be used to test it.
>=20
> We need to provide users the option of setting features, and for
> backwards compatibility, we need to accept strings in the feature
> line
> that we also have other options to set. And we still need to build up
> a
> features line to pass into the kernel. So we will still need the code
> to
> reconcile the features line with other options.=A0 I'm not sure we
> would
> gain much by converting it to a set of variables and then back again.

Fair enough, but consistency is very important. Let's work towards
never setting anything in the kernel that doesn't match our notion of
the desired state of a map.

> The one case where we really need to track our current value separate
> from the features line is queue_if_no_path, and it does make sense to
> track that as a variable, so we can easily update it when we make
> changes to it. But even there, the current value is not necessarily
> the
> value we want to put in the features line we pass to the kernel. If
> we
> aren't queueing, and then add a working path, when we reload the
> device
> we want to use the configured no_path_retry value, and not our
> current
> queueing state.
>=20
> One thing that would be nice would be tweaking the queue_if_no_path
> value in the features string that we pass to the kernel based on the
> current queueing state and the current path states. If we are
> reloading
> a device, and we know that all the paths in that device are down, and
> we
> currently aren't queueing, we shouldn't pass in a features string
> that
> tells the kernel to enable queueing, which is what we currently do.

Agreed.

> The
> patch I posted which started this conversation exists because we
> don't
> do this, and we need to fix the queueing state afterwards.
> =A0
> > Along a similar line of reasoning, let me emphasize again why I
> > would
> > like to have the logic for enabling or disabling queueing in one
> > place.
> > Your previous post nicely distinguished the various cases and call
> > chains which change the queueing and recovery mode, but it would be
> > better if that kind of assessment wasn't necessary, and instead it
> > was
> > possible to inspect the code in just a block of (say) 50 code lines
> > that would decide whether or not a given map should be queueing and
> > /
> > or in recovery mode.
> >=20
> > It's an unfortunate property of the multipath-tools code base that
> > important logic is dispersed over multiple functions and source
> > files,
> > making a correct assessment of the code flow difficult and
> > cumbersome.
> > It can't be completely avoided given the complexity of the subject,
> > but
> > it would be nice to try.
> >=20
> > I'm looking forward to your new patch set ;-)
>=20
> Unfortunately, my new patchset doesn't change the first patch. It
> just
> builds on it to clean how the interactive client commands call
> things, to
> reduce the callers of some of our functions, and keep the client
> commands from doing more work than they should be. After the changes,
> the only things calling set_no_path_retry() are functions that are
> updating the multipath device due to external events, and the
> check_path
> code.=A0=20
>=20
> The update_queue_mode{add,del}_path() functions should be (and based
> on
> my code examination, are) able to assume a device in the correct
> queuing
> and recovery state, and just do the work of entering or leaving the
> recovery mode, based on a change in the number of active paths.=20

OK. Perhaps not what I was hoping for, but better than what we have
now. Maybe you can add a few comment lines to explain the various
cases, lest your analysis be forgotten.


> If we move the code that checks if the our queuing state is wrong out
> of
> set_no_path_retry() into the update_queue_mode{add,del}_path(), then
> we
> add a requirement that callers of those functions refresh the current
> queueing state. Otherwise we can't actually guarantee that they do
> the
> right thing. With the current callers, this doesn't really matter,
> because we don't need them to fix the queueing state. But why not
> keep
> the code that fixes the queueing state in a function that's called
> when
> it could be wrong, and also is (after my new patchset) only called
> after
> we have refreshed the state so it will do the right thing.
>=20
> So, I would prefer if we go with my first patch, as is.=A0 I'm open to
> the
> idea of moving this code into update_queue_mode{add,del}_path() as
> part
> of a future patchset where we switch to tracking the current queueing
> state outside of mpp->features, and updating it whenever we actually
> enable or disable queueing. I can work on this if you want.

I'm fine with leaving your first patch as is, perhaps with some
comments. Anyway please resubmit it as part of your new set.

Regards
Martin

