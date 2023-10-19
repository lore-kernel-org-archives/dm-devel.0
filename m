Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E081D8F64
	for <dm-devel@lists.linux.dev>; Thu, 19 Oct 2023 07:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y6KP2vuA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697699154;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HdcT5GIViRYvI20jTD7cOzmFTh9wTgWLlaepY8Zcj/s=;
	b=Y6KP2vuAxMz685sVALJ+AA9PRheCOQkW/2P3cxhhaIzZ7NOT+jJd2lzjstzlYJNGkxFvdu
	JL5QElRMF4Rzieqp/oVesEfP7mrmABk6jvh5sQEDyPgfDVtDc4o18wFxMsxWfW+MTDQbtL
	yDS3JVFRCGbqrMPFNgJ5KcJX9fGG8Zg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-693-YqSl5LnxNo6gjS4W_c4hOg-1; Thu, 19 Oct 2023 03:05:53 -0400
X-MC-Unique: YqSl5LnxNo6gjS4W_c4hOg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D524B28237C2
	for <dm-devel@lists.linux.dev>; Thu, 19 Oct 2023 07:05:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CDD131C060AE
	for <dm-devel@lists.linux.dev>; Thu, 19 Oct 2023 07:05:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 885FD1946A44
	for <dm-devel@lists.linux.dev>; Thu, 19 Oct 2023 07:05:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B220619466F6
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 Oct 2023 00:34:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 948BD2026D66; Thu, 19 Oct 2023 00:34:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D24A2026D4C
 for <dm-devel@redhat.com>; Thu, 19 Oct 2023 00:34:37 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BF8B185A7B5
 for <dm-devel@redhat.com>; Thu, 19 Oct 2023 00:34:37 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-299-jeKbi_MXPuGVrj_GlKHqgA-1; Wed,
 18 Oct 2023 20:34:35 -0400
X-MC-Unique: jeKbi_MXPuGVrj_GlKHqgA-1
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
 by sin.source.kernel.org (Postfix) with ESMTP id 929F0CE27AE;
 Thu, 19 Oct 2023 00:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBB4C433C7;
 Thu, 19 Oct 2023 00:27:47 +0000 (UTC)
Date: Wed, 18 Oct 2023 17:27:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH v2 11/13] ip_tunnel: convert __be16 tunnel flags to bitmaps
Message-ID: <20231018172747.305c65bd@kernel.org>
In-Reply-To: <20231016165247.14212-12-aleksander.lobakin@intel.com>
References: <20231016165247.14212-1-aleksander.lobakin@intel.com>
 <20231016165247.14212-12-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mailman-Approved-At: Thu, 19 Oct 2023 06:33:51 +0000
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
Cc: linux-s390@vger.kernel.org, ntfs3@lists.linux.dev,
 Yury Norov <yury.norov@gmail.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 David Ahern <dsahern@kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
 Alexander Potapenko <glider@google.com>,
 Simon Horman <simon.horman@corigine.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 16 Oct 2023 18:52:45 +0200 Alexander Lobakin wrote:
>  40 files changed, 715 insertions(+), 415 deletions(-)

This already has at least two conflicts with networking if I'm looking
right. Please let the pre-req's go in via Yury's tree and then send
this for net-next in the next release cycle.

