Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B55EC636D3
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 22:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675291188;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oyvYmXZoc9ppoHsCwZR/IUuEC4vvg9AhTJzsaxQ9L7w=;
	b=g9SspzCIiXNuEDqYK9xBCUzofv+MZPm1erIgFNQ7KyjVFur6aWUT4lc2XU+1MRDncshEKm
	hXIxLzGCwBBeCxhCsZbZkhD0mdt0r34s78QUowYpyoEh7Li3xP9qJNKBOJKbSKHtVkMRDi
	a5f45Gtxy8E+zIQoFaSuiImGJ0IdnUw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-NUJjWdbLPNihqtUtdBlUvg-1; Wed, 01 Feb 2023 17:39:45 -0500
X-MC-Unique: NUJjWdbLPNihqtUtdBlUvg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C54AD1991C48;
	Wed,  1 Feb 2023 22:39:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CF1FD53A0;
	Wed,  1 Feb 2023 22:39:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BB7B219465A3;
	Wed,  1 Feb 2023 22:39:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E0EDA194658F
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 22:39:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F1671492B06; Wed,  1 Feb 2023 22:38:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E9AFC492B05
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 22:38:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D02823C025CD
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 22:38:59 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-365-C8SVPhuvPmG3VTBKj2YTNA-1; Wed,
 01 Feb 2023 17:38:55 -0500
X-MC-Unique: C8SVPhuvPmG3VTBKj2YTNA-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id CF5C720B7102; Wed,  1 Feb 2023 14:38:53 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CF5C720B7102
Date: Wed, 1 Feb 2023 14:38:53 -0800
From: Fan Wu <wufan@linux.microsoft.com>
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Message-ID: <20230201223853.GA9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-3-git-send-email-wufan@linux.microsoft.com>
 <dd7df8bc5b69a6745bdcf030a4e0690e3e067ff2.camel@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <dd7df8bc5b69a6745bdcf030a4e0690e3e067ff2.camel@huaweicloud.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [RFC PATCH v9 02/16] ipe: add policy parser
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu,
 paul@paul-moore.com, dm-devel@redhat.com, corbet@lwn.net,
 roberto.sassu@huawei.com, Deven Bowers <deven.desai@linux.microsoft.com>,
 linux-doc@vger.kernel.org, snitzer@kernel.org, jmorris@namei.org,
 zohar@linux.ibm.com, linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 linux-security-module@vger.kernel.org, linux-audit@redhat.com,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 31, 2023 at 11:53:27AM +0100, Roberto Sassu wrote:
> On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> 
> Uhm, memory leak? Also below. I suggest to use kmemleak.
> 
> Roberto
> 
Nice catch and thanks for the suggestion, I used kmemleak
and detected several incomplete cleanup. Will be fixed in
the next version.
-Fan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

