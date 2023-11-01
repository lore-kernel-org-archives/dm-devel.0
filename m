Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED323134A3
	for <dm-devel@lists.linux.dev>; Wed,  1 Nov 2023 12:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q5/DpKzq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698842841;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=L18jqjZ/YFC+R7qqPrcdbK+tbLtkdiO++O5gj8jOKcw=;
	b=Q5/DpKzqUvAQSCgXT7Lm1yPpqEj5zgywOGdROAhCKy8VIlkZxa2VQcd048gU3Ux2fHJ1gk
	RGIWRgKLnORGGrXTGLf2+HLOfnY5+ilwGdx0PZur6UrPrMZixDBUX+3bMvApFsFhB/iX6/
	15GLXF3lEniwwOUFk8O1x1HTEQBC2cY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-OeHLlkGpPwmop2Ikh9KR2g-1; Wed, 01 Nov 2023 08:47:21 -0400
X-MC-Unique: OeHLlkGpPwmop2Ikh9KR2g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE6DA811001
	for <dm-devel@lists.linux.dev>; Wed,  1 Nov 2023 12:47:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C7543492BE0
	for <dm-devel@lists.linux.dev>; Wed,  1 Nov 2023 12:47:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 670E219465A0
	for <dm-devel@lists.linux.dev>; Wed,  1 Nov 2023 12:47:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE89A194658F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Nov 2023 12:47:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 731EFC12912; Wed,  1 Nov 2023 12:47:19 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D9A24C1290F;
 Wed,  1 Nov 2023 12:47:18 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id C096130C2A86; Wed,  1 Nov 2023 12:47:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 BDD333FB77; Wed,  1 Nov 2023 13:47:18 +0100 (CET)
Date: Wed, 1 Nov 2023 13:47:18 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [REGRESSION] dm_crypt essiv ciphers do not use async driver
 mv-aes-cbc anymore
In-Reply-To: <070dd167-9278-42fa-aef5-66621a602fd3@leemhuis.info>
Message-ID: <518e373e-673e-82a-24ff-b9e8b3927c85@redhat.com>
References: <53f57de2-ef58-4855-bb3c-f0d54472dc4d@yuka.dev>
 <20230929224327.GA11839@google.com>
 <070dd167-9278-42fa-aef5-66621a602fd3@leemhuis.info>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
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
Cc: Yureka <yuka@yuka.dev>, Herbert Xu <herbert@gondor.apana.org.au>,
 Boris Brezillon <bbrezillon@kernel.org>, Arnaud Ebalard <arno@natisbad.org>,
 Srujana Challa <schalla@marvell.com>, Eric Biggers <ebiggers@kernel.org>,
 dm-devel@redhat.com, linux-crypto@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 1 Nov 2023, Linux regression tracking (Thorsten Leemhuis) wrote:

> > #regzbot introduced: b8aa7dc5c753
> 
> BTW: Eric, thx for this.
> 
> Boris, Arnaud, Srujana, and Mikulas, could you maybe comment on this? I
> understand that this is not some everyday regression due to deadlock
> risk, but it nevertheless would be good to get this resolved somehow to
> stay in line with our "no regressions" rule.
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

Hi

The driver drivers/crypto/marvell/cesa/cipher.c uses GFP_ATOMIC 
allocations (see mv_cesa_skcipher_dma_req_init). So, it is not really safe 
to use it for dm-crypt.

GFP_ATOMIC allocations may fail anytime (for example, they fill fail if 
the machine receives too many network packets in a short timeframe and 
runs temporarily out of memory). And when the GFP_ATOMIC allocation fails, 
you get a write I/O error and data corruption.

It could be possible to change it to use GFP_NOIO allocations, then we 
would risk deadlock instead of data corruption. The best thing would be to 
convert the driver to use mempools.

Mikulas

