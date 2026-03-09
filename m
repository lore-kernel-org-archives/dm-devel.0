Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630AA3D648B
	for <dm-devel@lists.linux.dev>; Mon,  9 Mar 2026 16:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773072756; cv=none; b=VIdgGv64ACSXypuJWMfxutYspZsVaXSIn3R1C9r0yqbroVfqzioWsuC6lQ6TTawymeJGYngiEBEbZ4cjhAP6Nb/OmMCO2bFswe+fMLqlNeSzcSdII9s8lS/tsD+9/Ct0K2XZ+CCvgQWBbUI93rPcGWWG2i7N8Fdw89AE6J1cS8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773072756; c=relaxed/simple;
	bh=e1AKI+bCKQbWCoFU9e4RZd9y4sbLesngNc7PnzpU/KU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DoU3fpMBnOurfYldvcO7Ay+eN/FKoi0pmtWCMCKaOlHWkei2ZNBixa1KSmQF7r5gTwtfP+2CSTJSXCRjflEO8WxMW0xbZsG3GNEMOBhRm3gEcoHWQ6ON+VcldNs4rKzdKqyXPmLque38DQsF/zeVDQ75P3CjEH/RI4EEvBGWGtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JjSTfIhc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JjSTfIhc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773072751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8gnnyUL0n6EDT1Fhp8qXg6+M1hpcHUbUUrCiGO+2l/A=;
	b=JjSTfIhcTOdoFVAUqz2x6dQWawP9UU8kdH59p7nbVcZCj3HaUB/jnZgXbE/BcILjMGsWU0
	iDXwxguif0+okH1oy39KuPOL65ps1TE6CWdQ5BjPAdH5YAw20LEXL6w87hUKzQfi87txt+
	ldWlf6Yj0Sinxs60NiCVwaD/kFrvcTQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-322-yqA2XdDOM0aCU0b3yaFr-g-1; Mon,
 09 Mar 2026 12:12:27 -0400
X-MC-Unique: yqA2XdDOM0aCU0b3yaFr-g-1
X-Mimecast-MFC-AGG-ID: yqA2XdDOM0aCU0b3yaFr-g_1773072746
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E887180035D;
	Mon,  9 Mar 2026 16:12:25 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CED171956095;
	Mon,  9 Mar 2026 16:12:22 +0000 (UTC)
Date: Mon, 9 Mar 2026 17:12:19 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
cc: Linlin Zhang <linlin.zhang@oss.qualcomm.com>, linux-block@vger.kernel.org, 
    ebiggers@kernel.org, linux-kernel@vger.kernel.org, adrianvovk@gmail.com, 
    dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, gmazyland@gmail.com, 
    israelr@nvidia.com
Subject: Re: [PATCH v1 1/3] block: export blk-crypto symbols required by
 dm-inlinecrypt
In-Reply-To: <4d46676d-e738-497c-b848-4278ec15d868@kernel.dk>
Message-ID: <9ca23050-7ea6-e1d2-004a-807912379a21@redhat.com>
References: <20260304121729.1532469-1-linlin.zhang@oss.qualcomm.com> <20260304121729.1532469-2-linlin.zhang@oss.qualcomm.com> <4d46676d-e738-497c-b848-4278ec15d868@kernel.dk>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 1oCvP1wLO6CrJsK5kWRhC_g-djMeCOKlpR7_eqd_5p8_1773072746
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 9 Mar 2026, Jens Axboe wrote:

> On 3/4/26 5:17 AM, Linlin Zhang wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > bio_crypt_set_ctx(), blk_crypto_init_key(), and
> > blk_crypto_start_using_key() are needed to use inline encryption; see
> > Documentation/block/inline-encryption.rst.  Export them so that
> > dm-inlinecrypt can use them.  The only reason these weren't exported
> > before was that inline encryption was previously used only by fs/crypto/
> > which is built-in code.
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> 
> -- 
> Jens Axboe

Thanks.

Mikulas

