Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792675479;
	b=y4Z/YR59in4H4TARbQrf3Q0FO+SU+Cy9/S2L8UOPWx4DZx94OQyTyduDtygCSWgHU5sF
	 4GwnZsa9zrwmTXA8r9k+prcG6VkQsHo/tieXMeUUA6wk3lBrvD3ekUvqgGQ6paz3IPFhT
	 Arj4EgSMKehqwijHCx98/Cdx52ukJKE2h1OY3cIXgmeX6OX9firp8Qo6ASLvz0wWeuYe1
	 YeMGpFhwx2B6Sid2AOP7lgrURCmebLjiEkoQvXAFdePTMmDXHfO8C2ZdOxDoDbw5VLCfP
	 gNVjPtLXhvxvzl0Eih7m2rxeaT4M/goGll16Q6OBBWKYDg6A8+wPmkJ63q4jnRF1v0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792675479;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=h8PVwHmVxgj3EDuc7a9+2bgJCaWhNY770RjA2x6wCHc=;
	b=qzjyW4ucaepmQ4Zvnzlyzz7CLYo4fghJm/q5gziMEvDzGnDEFhgdBXa97Sac2ZX41Hwk
	 ouojPe0XUVIpzIGZuHk8fkLIhu/DSqW5p02abJYqR6QZCKmW/rlfzxnEwLfldo8GC/jHX
	 kTB+XH6QR9HvzY9E+VcpjKbYkyJiCZc3yooUZC1P4h0A8GvyUr5S8hYImjRNfop5Tyvwm
	 JbXAhNrTbmuCYcK1ruCHxCYjpnqExF/NPYUIalN3SVlz8ermKyHWkN3Dr5BceqeAVESRJ
	 Lkj07CopXHFOR67QrwczTopaB8JuNHSlEK9INdAeTzah0sEB1lJZdLVB93JWzm56JFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Zhr9fyDu;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A66C606A329
	for <dm-devel@lists.linux.dev>; Thu, 22 Oct 2026 13:24:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A66C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Zhr9fyDu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792675478;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h8PVwHmVxgj3EDuc7a9+2bgJCaWhNY770RjA2x6wCHc=;
	b=Zhr9fyDusYgnfRfki14l+/Y808RUytw+ARUTCEA5mG5rw1TuPBzlMYZDHDv+ZmTLiZ0C4p
	0gFOOBNGuK8ABp2Q8SBogVZatgNKs5bidLFlhyGcd69SeV/2q3gx5INY+2n5Ow2Fi1fDPg
	CJUh2PrEuktVSgvLsImvFp/leH4wb94=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-83-8zvWsLXrPvm5QkJJIiVDCg-1; Thu,
 22 Oct 2026 09:24:31 -0400
X-MC-Unique: 8zvWsLXrPvm5QkJJIiVDCg-1
X-Mimecast-MFC-AGG-ID: 8zvWsLXrPvm5QkJJIiVDCg_1792675468
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7AF918004A9;
	Thu, 22 Oct 2026 13:24:27 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F90D195608C;
	Thu, 22 Oct 2026 13:24:20 +0000 (UTC)
Date: Thu, 22 Oct 2026 15:24:18 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Frank.Li@oss.nxp.com
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>, 
    Yu Kuai <yukuai@fygo.io>, Li Nan <magiclinan@didiglobal.com>, 
    Xiao Ni <xiao@kernel.org>, Dan Williams <djbw@kernel.org>, 
    Herbert Xu <herbert@gondor.apana.org.au>, 
    "David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>, 
    Shuah Khan <skhan@linuxfoundation.org>, 
    Randy Dunlap <rdunlap@infradead.org>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
    linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org, 
    Anatolij Gustschin <agust@denx.de>, Saeed Bishara <saeed@marvell.com>, 
    Rameshwar Prasad Sahu <rsahu@apm.com>, 
    Thomas Petazzoni <thomas.petazzoni@free-electrons.com>, 
    Anup Patel <anup.patel@broadcom.com>, Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH RFC 1/4] md/dm-integrity: replace async_tx with synchronous
 xor for journal
In-Reply-To: <20261015-asycn_tx_remove-v1-1-056a7085e0a1@nxp.com>
Message-ID: <fb9c7c5c-e377-7926-c8f1-a7f9e93c2d46@redhat.com>
References: <20261015-asycn_tx_remove-v1-0-056a7085e0a1@nxp.com> <20261015-asycn_tx_remove-v1-1-056a7085e0a1@nxp.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 8KHOJaRFSE12k0TWKe-EMoK_JpVc7JlafHdagDup3qc_1792675468
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 15 Oct 2026, Frank.Li@oss.nxp.com wrote:

> From: Frank Li <Frank.Li@nxp.com>
> 
> Remove the dependency on the async_tx framework from dm-integrity's
> xor_journal() function.  The async_xor() + async_tx_issue_pending_all()
> pattern is replaced with direct kmap_local_page() + memcpy() +
> crypto_xor() + kunmap_local() per page, which is simpler and removes
> the need for #include <linux/async_tx.h>.
> 
> async_tx adds significant complexity and maintenance overhead while
> providing little practical benefit on modern systems, where RAID parity
> computation is typically performed more efficiently by CPU-based XOR/PQ
> implementations than by DMA engine offload.
> 
> Signed-off-by: Frank Li <Frank.Li@nxp.com>

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-integrity.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
> index 802b377613b06..6bd0623b6402a 100644
> --- a/drivers/md/dm-integrity.c
> +++ b/drivers/md/dm-integrity.c
> @@ -23,7 +23,6 @@
>  #include <crypto/hash.h>
>  #include <crypto/skcipher.h>
>  #include <crypto/utils.h>
> -#include <linux/async_tx.h>
>  #include <linux/dm-bufio.h>
>  
>  #include "dm-audit.h"
> @@ -896,7 +895,6 @@ static void complete_journal_op(void *context)
>  static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned int section,
>  			unsigned int n_sections, struct journal_completion *comp)
>  {
> -	struct async_submit_ctl submit;
>  	size_t n_bytes = (size_t)(n_sections * ic->journal_section_sectors) << SECTOR_SHIFT;
>  	unsigned int pl_index, pl_offset, section_index;
>  	struct page_list *source_pl, *target_pl;
> @@ -913,14 +911,11 @@ static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned int se
>  
>  	atomic_add(roundup(pl_offset + n_bytes, PAGE_SIZE) >> PAGE_SHIFT, &comp->in_flight);
>  
> -	init_async_submit(&submit, ASYNC_TX_XOR_ZERO_DST, NULL, complete_journal_op, comp, NULL);
> -
>  	section_index = pl_index;
>  
>  	do {
>  		size_t this_step;
> -		struct page *src_pages[2];
> -		struct page *dst_page;
> +		void *src0, *src1, *dst;
>  
>  		while (unlikely(pl_index == section_index)) {
>  			unsigned int dummy;
> @@ -935,11 +930,20 @@ static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned int se
>  		}
>  
>  		this_step = min(n_bytes, (size_t)PAGE_SIZE - pl_offset);
> -		dst_page = target_pl[pl_index].page;
> -		src_pages[0] = source_pl[pl_index].page;
> -		src_pages[1] = ic->journal_xor[pl_index].page;
>  
> -		async_xor(dst_page, src_pages, pl_offset, 2, this_step, &submit);
> +		src0 = kmap_local_page(source_pl[pl_index].page);
> +		src1 = kmap_local_page(ic->journal_xor[pl_index].page);
> +		dst  = kmap_local_page(target_pl[pl_index].page);
> +
> +		memcpy(dst + pl_offset, src0 + pl_offset, this_step);
> +		crypto_xor(dst + pl_offset, src1 + pl_offset, this_step);
> +
> +		kunmap_local(dst);
> +		kunmap_local(src1);
> +		kunmap_local(src0);
> +
> +		/* mirror async_tx per-page completion accounting */
> +		complete_journal_op(comp);
>  
>  		pl_index++;
>  		pl_offset = 0;
> @@ -947,8 +951,6 @@ static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned int se
>  	} while (n_bytes);
>  
>  	BUG_ON(n_sections);
> -
> -	async_tx_issue_pending_all();
>  }
>  
>  static void complete_journal_encrypt(void *data, int err)
> 
> -- 
> 2.43.0
> 

