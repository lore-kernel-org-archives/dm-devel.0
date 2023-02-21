Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A0AC636D7
	for <dm-devel@archiver.kernel.org>; Tue, 21 Feb 2023 20:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677013135;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3FKNHGvqEzk64/SACRMAyPjxsp4C+b9aY2g7LyVmJOY=;
	b=baFFXOLz7VqngfDGSdiuNXiNFAKKW74fgQ14f08BybKduyhI0C1KGr9PfXupCWgQ9iC1Z5
	1co9CU+TD1B0JV359yKFnkFs6mkQO92QARrh78RANK2yP7K+ceUBbLGUAW9zkrQGfrFOfG
	IbdG6Bo3qVjdM1w2adLtV4I29UK0qsQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628--dAXPlD7Nmqxsjdmw-XOLA-1; Tue, 21 Feb 2023 15:58:51 -0500
X-MC-Unique: -dAXPlD7Nmqxsjdmw-XOLA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4595987A9E2;
	Tue, 21 Feb 2023 20:58:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 31572C15BA0;
	Tue, 21 Feb 2023 20:58:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0A0F71946588;
	Tue, 21 Feb 2023 20:58:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 20F1E1946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 21 Feb 2023 20:58:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D5F15492B06; Tue, 21 Feb 2023 20:58:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE223492B04
 for <dm-devel@redhat.com>; Tue, 21 Feb 2023 20:58:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3D11100F907
 for <dm-devel@redhat.com>; Tue, 21 Feb 2023 20:58:48 +0000 (UTC)
Received: from bedivere.hansenpartnership.com
 (bedivere.hansenpartnership.com [96.44.175.130]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-542-gLvQ4yRlMJS1dHWglrPeZQ-1; Tue, 21 Feb 2023 15:58:45 -0500
X-MC-Unique: gLvQ4yRlMJS1dHWglrPeZQ-1
Received: from localhost (localhost [127.0.0.1])
 by bedivere.hansenpartnership.com (Postfix) with ESMTP id ADA661285D81;
 Tue, 21 Feb 2023 15:51:14 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new,
 port 10024)
 with ESMTP id FGjkMet321rv; Tue, 21 Feb 2023 15:51:14 -0500 (EST)
Received: from lingrow.int.hansenpartnership.com (unknown
 [IPv6:2601:5c4:4302:c21::c14])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits)
 server-digest SHA256) (Client did not present a certificate)
 by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 6110E1281F11;
 Tue, 21 Feb 2023 15:51:12 -0500 (EST)
Message-ID: <96463a32a97dc40bc30c47ddcdf19a5803de32d8.camel@HansenPartnership.com>
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Howells <dhowells@redhat.com>, lsf-pc@lists.linux-foundation.org, 
 linux-block@vger.kernel.org, dm-devel@redhat.com
Date: Tue, 21 Feb 2023 15:51:11 -0500
In-Reply-To: <2896937.1676998541@warthog.procyon.org.uk>
References: <2896937.1676998541@warthog.procyon.org.uk>
User-Agent: Evolution 3.42.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [LSF/MM/BPF TOPIC] Linux Security Summit cross-over?
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-fsdevel@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 2023-02-21 at 16:55 +0000, David Howells wrote:
> 
> Since the first day of the LSS is the same as the final day of LSF
> and in the same venue, are there any filesystem + security subjects
> that would merit a common session?


I've got one:  Cryptographic material handling.

Subtitle could be: making keyrings more usable.

The broad problem is that the use of encryption within the kernel is
growing (from the old dm-crypt to the newer fscrypt and beyond) yet
pretty much all of our cryptographic key material handling violates the
principle of least privilege.  The latest one (which I happened to
notice being interested in TPMs) is the systemd tpm2 cryptenroll.  The
specific violation is that key unwrapping should occur as close as
possible to use: when the kernel uses a key, it should be the kernel
unwrapping it not unwrapping in user space and handing the unwrapped
key down to the kernel because that gives a way.  We got here because
in most of the old uses, the key is derived from a passphrase and the
kernel can't prompt the user, so pieces of user space have to gather
the precursor cryptographic material anyway.  However, we're moving
towards using cryptographic devices (like the TPM, key fobs and the
like) to store keys we really should be passing the wrapped key into
the kernel and letting it do the unwrap to preserve least privilege. 
dm-crypt has some support for using kernel based TPM keys (the trusted
key subsystem), but this isn't propagated into systemd-cryptenroll and
pretty much none of the other encryption systems make any attempt to
use keyrings for unwrap handling, even if they use keyrings to store
cryptographic material.

Part of the reason seems to be that the keyrings subsystem itself is
hard to use as a generic "unwrapper" since the consumer of the keys has
to know exactly the key type to consume the protected payload.  We
could possibly fix this by adding a payload accessor function so the
keyring consumer could access a payload from any key type and thus
benefit from in-kernel unwrapping, but there are likely a host of other
issues that need to be solved.  So what I'd really like to discuss is:

Given the security need for a generic in-kernel unwrapper, should we
make keyrings do this and if so, how?

Regards,

James



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

