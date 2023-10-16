Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E8B1A59D
	for <dm-devel@lists.linux.dev>; Mon, 16 Oct 2023 08:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E/AKnDoz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697445282;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ut2K2E38rlt9GSxsxQ01EG761NscGYk1FQfACSrWV+4=;
	b=E/AKnDoz3MF90YFIMBP6IQCS+bwXue22OacwemRAjkHi1vi62T8wm3MF+DGL0IoAUC3DIB
	hRb6eacwQXM/ZB8RG/nf3xuuLMY42y2+lINqYVo0qKxMU3a+iWK9gIYTuZEmYeePEufuRQ
	7oIPsU3iNXZGW5DX9J9yx6Bf7n0h9mo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-_M5EsRtYOhyYswAbj4r5Ig-1; Mon, 16 Oct 2023 04:34:31 -0400
X-MC-Unique: _M5EsRtYOhyYswAbj4r5Ig-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FB3F946DC8
	for <dm-devel@lists.linux.dev>; Mon, 16 Oct 2023 08:34:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 17540492BFA
	for <dm-devel@lists.linux.dev>; Mon, 16 Oct 2023 08:34:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D9DE61946588
	for <dm-devel@lists.linux.dev>; Mon, 16 Oct 2023 08:34:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A13BB1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 Oct 2023 08:34:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 644292157F5A; Mon, 16 Oct 2023 08:34:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CAC52157F5B
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 08:34:29 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 363071C11709
 for <dm-devel@redhat.com>; Mon, 16 Oct 2023 08:34:29 +0000 (UTC)
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de
 [80.237.130.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-p21FAeN1NnyXpUXcpGlvIQ-1; Mon, 16 Oct 2023 04:34:02 -0400
X-MC-Unique: p21FAeN1NnyXpUXcpGlvIQ-1
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
 by wp530.webpack.hosteurope.de running ExIM with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
 id 1qsJ32-0006bZ-4j; Mon, 16 Oct 2023 10:34:00 +0200
Message-ID: <f937d16c-b4e6-4450-8744-9f4ccada5944@leemhuis.info>
Date: Mon, 16 Oct 2023 10:33:59 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (Bisected) Accessing opened Bitlocker partition leads to memory
 fault and kernel panic on Imac8,1
To: Linux Regressions <regressions@lists.linux.dev>
References: <f1b8d8f5-2079-537e-9d0f-d58da166fe50@gmail.com>
 <ZR9dEiXhQv-wBVA2@debian.me>
From: "Linux regression tracking #update (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
In-Reply-To: <ZR9dEiXhQv-wBVA2@debian.me>
X-bounce-key: webpack.hosteurope.de; regressions@leemhuis.info; 1697445242;
 9788a87c
X-HE-SMSGID: 1qsJ32-0006bZ-4j
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Cc: Linux Device Mapper <dm-devel@redhat.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: leemhuis.info
Content-Language: en-US, de-DE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 06.10.23 03:04, Bagas Sanjaya wrote:
> On Thu, Oct 05, 2023 at 08:15:43PM +0300, Tatu Heikkilä wrote:
>> Hello,
>> I think you and the lists are right recipients, forgive me if not, I've
>> never reported kernel bugs before. Naively this seems a crypto issue and
>> Herbert Xu from crypto maintainers made the buggy commit, but it edits
>> drivers/md/dm_crypt.c maintained by dm-devel people per MAINTAINERS, so I'm
>> going by that.
>> [...]

#regzbot fix: 152d0bcdf1efcb
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.

