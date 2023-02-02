Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECD21C05027
	for <dm-devel@archiver.kernel.org>; Thu,  2 Feb 2023 00:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675297174;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/H87haD1BzN7Y83fBjna4uiTInsoNZROSGGKKFvmoQU=;
	b=BKG/L3W7Ud7P6YSdBleg1qKEpaO/4gAQe9JKy2Rtgw/SiT2etrB4tLnZzAgzpcEc1FJxJ3
	D0/48Ed31RHrpfLJg3kfEjVI9yXUAYPERshybKnyp++ryyUc24WnFzx8M+H00RPMsGwSUD
	gKtiojoNtzPBkHIQ0ha1sYKzyrqtvv8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-wQ_0Mgs4Nky7CbS6UIgB1A-1; Wed, 01 Feb 2023 19:19:33 -0500
X-MC-Unique: wQ_0Mgs4Nky7CbS6UIgB1A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B27663C0DDA2;
	Thu,  2 Feb 2023 00:19:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5C929112132C;
	Thu,  2 Feb 2023 00:19:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 27D1019465A3;
	Thu,  2 Feb 2023 00:19:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DF1E8194658F
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 00:19:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BFCD753A0; Thu,  2 Feb 2023 00:19:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B7619422AE
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 00:19:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A9C129AA3B6
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 00:19:29 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-317-fmpXM9m9OJ2ARDAMNm7jmg-1; Wed,
 01 Feb 2023 19:19:26 -0500
X-MC-Unique: fmpXM9m9OJ2ARDAMNm7jmg-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 6706120B7102; Wed,  1 Feb 2023 16:19:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6706120B7102
Date: Wed, 1 Feb 2023 16:19:24 -0800
From: Fan Wu <wufan@linux.microsoft.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Message-ID: <20230202001924.GD9075@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-17-git-send-email-wufan@linux.microsoft.com>
 <Y9iSP+RxY+1/o7PQ@debian.me>
MIME-Version: 1.0
In-Reply-To: <Y9iSP+RxY+1/o7PQ@debian.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [RFC PATCH v9 16/16] documentation: add ipe
 documentation
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jan 31, 2023 at 10:59:59AM +0700, Bagas Sanjaya wrote:
> On Mon, Jan 30, 2023 at 02:57:31PM -0800, Fan Wu wrote:
> 
> What about wordings below instead?

Thanks for the review!
>  
> -IPE policy supports comments. The character '#' will function as a
> -comment, ignoring all characters to the right of '#' until the newline.
> +IPE policy supports comments. Any line which is prefixed with ``#`` will
> +be ignored.
This one is actually incorrect. The '#' can also appear at the end of a rule.
So it is not only prefixed to a line.

Other than this part, everything looks great, I will take them in the next
version.

-Fan

>  
>  -----------
> 
> Thanks.
> 
> -- 
> An old man doll... just what I always wanted! - Clara


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

