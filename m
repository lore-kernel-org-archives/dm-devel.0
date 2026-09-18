Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7133B3BB127
	for <dm-devel@lists.linux.dev>; Fri, 18 Sep 2026 08:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789718744; cv=none; b=E1Jr9VTXd/7tqD3pWsxCwgGJSgNImzrPS8Bv0CLVvKFenKeCb2DBLmo2zK7ceC1BxVAo1CDS2c3g1OBIrxZ9Z5Nh6hs/XiOicaLC9ag+FW3MLPDrkJaOWE4RihX+bzthvFwg+XJ4rkwsCIboF+xArJf22UPyvfsVLstOqqZMGyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789718744; c=relaxed/simple;
	bh=SSml5sWGhbr1aX5qXNp5m87HXKcpLyEzFeK1/Q/8sOE=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:Date:
	 Message-ID:Content-Type; b=fyujYyTEE6kPQWwUDe5vezonV5rcEXBrnVc9UJTUdLfdBG62gNWcW2RUrxmc2vHSc6sR3xhs07ccn8dAKU/vxSX5IAPDTL4wjCGj8us2nMXcw6p4y38RzOIpBN9Upn7OsbG4GJyvHPNd/LqOJ1wl4VxTYgYxo5jQk0LuSTbQ3Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PNReafD0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PNReafD0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789718742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ym7emDJFhy4PiOXGVpk05NT3ISXd1kAvgtskHF5RU0g=;
	b=PNReafD077lIjVU+tGlGZqSpttPqD4MOuRVkfVy4b2Yo2UmGInE8f4YaO6UZvDl6/5k5/p
	QNVA8oHGdnoHw8R/3IxVlR4Ro9FoQ6xwxagC6VhIf3QhNk3TDYxLOKhQVi9B8W7Ll0wkbh
	6Z42oQjinsehD5NOZCLVzaBzBmwkhZY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-546-RN0R4fb1NhK5JGQk9pctmg-1; Fri,
 18 Sep 2026 04:05:38 -0400
X-MC-Unique: RN0R4fb1NhK5JGQk9pctmg-1
X-Mimecast-MFC-AGG-ID: RN0R4fb1NhK5JGQk9pctmg_1789718736
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA7F818512C6;
	Fri, 18 Sep 2026 08:05:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1CADB1956047;
	Fri, 18 Sep 2026 08:05:27 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <aqyiCavj3xeNqyAo@kernel.org>
References: <aqyiCavj3xeNqyAo@kernel.org> <20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com> <20260914-ajhalaney-dmverity-key-identifier-v1-1-01922dc1366a@amutable.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: dhowells@redhat.com, Andrew Halaney <andrew@amutable.com>,
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
    Mikulas Patocka <mpatocka@redhat.com>,
    Benjamin Marzinski <bmarzins@redhat.com>,
    Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
    "Serge E. Hallyn" <serge@hallyn.com>,
    Eric Biggers <ebiggers@kernel.org>,
    "Theodore Y. Ts'o" <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>,
    Shuah Khan <skhan@linuxfoundation.org>,
    Randy Dunlap <rdunlap@infradead.org>, dm-devel@lists.linux.dev,
    linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
    linux-security-module@vger.kernel.org, bpf@vger.kernel.org,
    fsverity@lists.linux.dev, linux-doc@vger.kernel.org,
    "Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: Re: [PATCH 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Fri, 18 Sep 2026 09:05:26 +0100
Message-ID: <715249.1789718726@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: bgtfQvTcWkvqKwWn-89wa03ZWO-QsDHAnE7sBKb3f-A_1789718736
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <715248.1789718726.1@warthog.procyon.org.uk>

Jarkko Sakkinen <jarkko@kernel.org> wrote:

> This is great for discussion but what we want for the commit message
> is just motivation and resolution.

Actually, I think it's useful that Andrew wrote up the issues in the commit
message - and I think it shows part of the motivation.  The 'writing a fake
/proc/keys line in the description' is something I hadn't considered.

> I don't think we need all this just to say that /proc/keys in a racy
> query mechanism for production, which is an issue for dm-verity, given
> that nothing else is available.

I think at some point, we will need a system call to search all for all
accessible keys matching certain criteria by actually walking the key
database.  The problem there is that there may be multiple hits, so we may
need something like:

	int count = find_key(key_serial_t start_id,
			     const char *type, const char *desc_prefix,
			     key_serial_t *results, size_t results_size,
			     unsigned int flags);

Allowing you to do:

	key_serial_t dm_key;
	int n = find_key(0, "keyring", ".dm_verity", &dm_key, 1,
			 FIND_KEY_EXACT_DESC);

This wouldn't be as fast as a direct lookup since it would have to walk the
key tree, doing name comparisons and perm checks on each key of the type.

> And secondly special keys are meant for implicit keyrings so isn't
> that all there's to it?

I have no particular objection to setting aside a block of negative key IDs
for special keyrings that need to be accessed a lot - though I would make
common reg/unreg functions that take the ID to be registered and, say, set the
block at -257..-512.  Moving the BFP keyring to -257 and DM to -258.

David

