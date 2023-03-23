Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED790C74A5B
	for <dm-devel@archiver.kernel.org>; Thu, 23 Mar 2023 20:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679601758;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OmDsVyPGneZF+tftlzPhMTM/YuJc3Dxul7V7ZrFWTxM=;
	b=T5y8Vt3whEMy/noLltB4pm9NGa3RJHAqf4PuyT2HGGElXuC6QDp5/ZbJMnRnAM/wBpmI7Q
	91JmkQGskiEK5zgZFYiLoOJ+MIkbVl9WTyV974REAbs+s2XUXR6W34N+F/HGQvk5In3b9+
	CL0x36Uk/yc3PFCLVphCabRgla4EEZY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-2UD8gVLGN3a0jRR0madk1Q-1; Thu, 23 Mar 2023 16:02:35 -0400
X-MC-Unique: 2UD8gVLGN3a0jRR0madk1Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2ACB1889063;
	Thu, 23 Mar 2023 20:02:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8CE01121314;
	Thu, 23 Mar 2023 20:02:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B7CC319465B7;
	Thu, 23 Mar 2023 20:02:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 23DFD1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Mar 2023 20:02:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 121382027040; Thu, 23 Mar 2023 20:02:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AD9A202701E
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 20:02:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD7CF85A5B1
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 20:02:24 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-PLy8Ew8gMJmJgQ1hzbsStQ-1; Thu,
 23 Mar 2023 16:01:39 -0400
X-MC-Unique: PLy8Ew8gMJmJgQ1hzbsStQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 894EC3389B;
 Thu, 23 Mar 2023 20:01:36 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4E79913596;
 Thu, 23 Mar 2023 20:01:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id ahGcECCwHGQuPAAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 23 Mar 2023 20:01:36 +0000
Message-ID: <f37eba2d7247a5ccb4bbb530e5ab1047fea5d534.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Sam James <sam@gentoo.org>, christophe.varoqui@opensvc.com, 
 dm-devel@redhat.com
Date: Thu, 23 Mar 2023 21:01:35 +0100
In-Reply-To: <20230323081256.904460-1-sam@gentoo.org>
References: <20230323081256.904460-1-sam@gentoo.org>
User-Agent: Evolution 3.46.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH] tests: fix quoting of CFLAGS in Makefile
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2023-03-23 at 08:12 +0000, Sam James wrote:
> Otherwise, when CFLAGS/CPPFLAGS have multiple entries (like "-O2 -
> pipe"), we
> get an error:
> ```
> make[1]: Entering directory '/var/tmp/portage/sys-fs/multipath-tools-
> 0.9.4/work/multipath-tools-0.9.4/tests'
> /bin/sh: line 1: -pipe: command not found
> make[1]: *** [Makefile:115: libmultipath.so.0] Error 127
> make[1]: *** Waiting for unfinished jobs....
> ```
> 
> Signed-off-by: Sam James <sam@gentoo.org>

Reviewed-by: Martin Wilck <mwilck@suse.com>

Thanks!

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

