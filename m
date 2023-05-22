Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46283C7EE2D
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 06:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684824422;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pzSIaLwuEpKKqFrkPIIPlT0vyW64bF7+Awt0rxHLG9g=;
	b=b2N1Kexv6KQNBGRpod3xHOXmZ+RwjFyIkO5q84a5vsBUC0sLx3GiJGH9XBQnj3gMSc3COE
	6c5tWa9Shvxi54kqhpc0VI4en9UMAhd8/eAMR7KI+wCK0JCRy3vlhhU0xLlRFcQ4DeMR7+
	I+TZdWFhJE5SHb5wclKZlYdLQzgFmI4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-cFPrGwmtMIiQLDOCEeQw3g-1; Tue, 23 May 2023 02:47:00 -0400
X-MC-Unique: cFPrGwmtMIiQLDOCEeQw3g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF132800B2A;
	Tue, 23 May 2023 06:46:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BBF102166B25;
	Tue, 23 May 2023 06:46:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 85F1A19465A0;
	Tue, 23 May 2023 06:46:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F7581946595
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 May 2023 16:43:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4F39E40C6CD8; Mon, 22 May 2023 16:43:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4855D400E116
 for <dm-devel@redhat.com>; Mon, 22 May 2023 16:43:44 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CF2F800141
 for <dm-devel@redhat.com>; Mon, 22 May 2023 16:43:44 +0000 (UTC)
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
 by relay.mimecast.com with ESMTP id us-mta-304-yh-Rb3EQO1uTx9K4vhvUUA-1;
 Mon, 22 May 2023 12:43:40 -0400
X-MC-Unique: yh-Rb3EQO1uTx9K4vhvUUA-1
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
 by vmicros1.altlinux.org (Postfix) with ESMTP id 9609172C90B;
 Mon, 22 May 2023 19:43:38 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
 id 859C67CFDFA; Mon, 22 May 2023 19:43:38 +0300 (IDT)
Date: Mon, 22 May 2023 19:43:38 +0300
From: "Dmitry V. Levin" <ldv@strace.io>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20230522164338.GA7504@altlinux.org>
References: <20230519223356.GA32042@altlinux.org>
 <d5c31607bd92583c8a487e74bd43542b6d7f1a70.camel@suse.com>
 <20230522104947.GA2575@altlinux.org>
 <d0c9a2ca3ee3e66a151dd17ab9623d0701e2924e.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <d0c9a2ca3ee3e66a151dd17ab9623d0701e2924e.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 23 May 2023 06:46:55 +0000
Subject: Re: [dm-devel] [PATCH] 11-dm-mpath.rules: fix warnings reported by
 udevadm verify
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: strace.io
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 22, 2023 at 06:11:14PM +0200, Martin Wilck wrote:
[...]
> I see. I'll apply this patch then (and the other one with the missing
> comma, too), but unless you object, I'll add a note to the
> commit message explaining that this for improving readability 
> and coding style compliance. I want to avoid the impression that the
> existing code is technically wrong, which it isn't.

That's fine with me, thanks.


-- 
ldv

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

