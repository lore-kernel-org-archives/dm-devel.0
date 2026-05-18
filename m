Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AA4413251
	for <dm-devel@lists.linux.dev>; Mon, 18 May 2026 12:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779107866; cv=none; b=rUItHskPVZ8Xi2i+2ZtBpJNU6S/XiyA/cLwDszNL5k8zP6M+XZwhIRes9nWG+qhkBDAPAiaOeRSzXPzgHvIlaW1n3jCX39F3ly5jfViG6upftkoYVuXIrvne0iBnRmVjRqLtDU+biGsLuNYSW24GvJ7D29jJ/d+er0nMUxTBcU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779107866; c=relaxed/simple;
	bh=z0DfcPltqLnpHldZMf2WlpA9EFIbAotYivQs+mnJqYQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Fa6qma2dE2asOcUAUBE53WETJZko3gf1SRDjKv16LAsWslM4MnVYF/vqmAvlJyfTPfXDPGdEySRbDVvbt0gLsRetDghuv5/2q59g3H5AW0GUY2l+ym0zJ95kMQBLpjIMNEjnfaD2d20ZFZQyV282T/hrpOeYYhUdmpn2KOCZfhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FJiEaTYG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FJiEaTYG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779107863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/ZzGJFX4jjYS4iKjx7e1l7yR/DZzHqdCwKWeunjPTOs=;
	b=FJiEaTYG0Nh1RGusdEuO4yoCA9GLyYkgtnvC7nsGEqlLVtuS1KuzrIqPb4zW7Mfti9gepI
	bFT3MUBCCAL4uEIlaUcZ7SDuYPViK/pf2siAh4acxxvpFi0LFvfVtrm/izXOI6K7g9kwZf
	BWGoMRueeC9bfazjtWE8NV4lKVkF9As=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-8-eYezmgPwMe654RW6r0mc8Q-1; Mon,
 18 May 2026 08:37:40 -0400
X-MC-Unique: eYezmgPwMe654RW6r0mc8Q-1
X-Mimecast-MFC-AGG-ID: eYezmgPwMe654RW6r0mc8Q_1779107859
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D7E8180034E;
	Mon, 18 May 2026 12:37:39 +0000 (UTC)
Received: from [10.44.50.181] (unknown [10.44.50.181])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D110B1800465;
	Mon, 18 May 2026 12:37:36 +0000 (UTC)
Date: Mon, 18 May 2026 14:37:31 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
cc: Milan Broz <gmazyland@gmail.com>, Eric Biggers <ebiggers@kernel.org>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Neeraj Soni <neeraj.soni@oss.qualcomm.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] dm-inlinecrypt: add support for hardware-wrapped
 keys
In-Reply-To: <2712f864-0f68-4428-9ba5-55fbf35de6e8@oss.qualcomm.com>
Message-ID: <f7de4505-859e-6838-b8b4-1e55c8c0331c@redhat.com>
References: <20260516115045.3958326-1-linlin.zhang@oss.qualcomm.com> <20260516115045.3958326-2-linlin.zhang@oss.qualcomm.com> <3b57685a-09b4-473a-8810-bbb46769ab42@gmail.com> <2712f864-0f68-4428-9ba5-55fbf35de6e8@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: MyT9vdxuifyRgLlZzQrhrZcgO5vh3NFWLGNnjdl07DE_1779107859
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="-1463811712-1136381637-1779107692=:1312089"
Content-ID: <e8d230a0-860e-a759-63b2-1a4be69d14a2@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-1136381637-1779107692=:1312089
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <dd546a3b-2403-d81c-5b9d-59e455edc73d@redhat.com>



On Mon, 18 May 2026, Linlin Zhang wrote:

> 
> 
> On 5/16/2026 8:17 PM, Milan Broz wrote:
> > On 5/16/26 1:50 PM, Linlin Zhang wrote:
> >> Add support for hardware-wrapped encryption keys to the
> >> dm-inlinecrypt target.
> >>
> >> Introduce a new parameter <is_wrappedkey> to indicate whether
> >> the provided key is a raw key or a hardware-wrapped key. Based
> >> on this flag, the appropriate blk-crypto key type is selected
> >> when initializing the key.
> >>
> >> This allows dm-inlinecrypt to work with hardware that requires
> >> keys to be wrapped and managed by the underlying inline
> >> encryption engine.
> >>
> >> Update the target argument parsing accordingly and pass the
> >> key type to blk_crypto_init_key(). Documentation is also
> >> updated to reflect the new parameter and usage.
> >>
> >> Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
> >> ---
> >>   .../device-mapper/dm-inlinecrypt.rst          | 10 ++-
> >>   drivers/md/dm-inlinecrypt.c                   | 71 +++++++++++--------
> >>   2 files changed, 50 insertions(+), 31 deletions(-)
> >>
> >> diff --git a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
> >> index c71e600efb76..3a4ce2c5f228 100644
> >> --- a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
> >> +++ b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
> >> @@ -10,7 +10,7 @@ https://docs.kernel.org/block/inline-encryption.html
> >>     Parameters::
> >>   -          <cipher> <key> <iv_offset> <device path> \
> >> +          <cipher> <key> <is_wrappedkey> <iv_offset> <device path> \
> >>             <offset> [<#opt_params> <opt_params>]
> > 
> > Please use optional parameter.
> > Adding mandatory field will introduce unnecessary incompatibility with dm-crypt mappings.
> > (The idea was that you can simply switch "crypt" to "inlinecrypt" for raw keys.)
> > 
> > I would probably just add "hw-wrapped" or "keytype=raw|hw-wrapped" optional argument
> > (with raw as default, so no need so specify it).
> > 
> > IOW the mapping will look like this (1 is number of optional parameters):
> > 
> >    <cipher> <key> <iv_offset> <device path> <offset> 1 hw-wrapped
> > or
> >    <cipher> <key> <iv_offset> <device path> <offset> 1 keytype=hw-wrapped
> 
> 
> Thanks for your suggestion!
> 
> I agree that keeping "hw-wrapped" or "keytype=raw|hw-wrapped" as an optional
> argument helps preserve compatibility when switching from "crypt" to
> "inlinecrypt"
> 
> My concern is that, in practice, this optional argument may effectively become
> mandatory for certain configurations. For instance, "hw-wrapped" or
> "keytype=raw|hw-wrapped" must be set for a wrapped key. This slightly blurs the
> original intent of "optional arguments", which are typically expected to be
> truly optional for correct operation.
> 
> Would this be acceptable? which one is more acceptable for upstream?
> incompatibility semantics mappings b/w dm-crypt and dm-inlinecrypt or blur
> the original intent of "optional arguments"?
> 
> Any additional thoughts or feedback from others would be much appreciated. Thanks!

Hi

I would prefer an optional argument "keytype:raw" or "keytype:hw-wrapped". 
Device mapper targets use colon to separate arguments from values, so I 
would use it here too.

I removed the patch that always sets BLK_CRYPTO_KEY_TYPE_HW_WRAPPED from 
the linux-dm repository and I will accept a patch that introduces 
"keytype:hw-wrapped" when you send it.

Mikulas

> > 
> > The second option will allow to add new key type much easier.
> 
> Regarding the second option ("keytype=..."), I agree it is more extensible.
> Could you please clarify what other key types you envision supporting in the
> future?
> 
> > 
> > Please check how other targets implement it, some dm-crypt examples
> > https://gitlab.com/cryptsetup/cryptsetup/-/wikis/DMCrypt
> > 
> > Thanks,
> > Milan
> > 
> 

---1463811712-1136381637-1779107692=:1312089--

