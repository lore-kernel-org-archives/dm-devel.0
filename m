Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6884EC636D4
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 19:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676318329;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=n17XVYsipQjLlHXzLtBleXY/ed3hmMnjtxYAyqkLENI=;
	b=G1EPkkHJ3tqSBdZdovQE1fPIEa28SZkZfxgIgnTpAukAhKeyGBJNFi5UV2Ewk0CP+J5jKV
	ThGQPPwclbKeEn+aym2Mx8x1924CS4uF+fAFLs0yFfucTwuE+9dY9v3zN9D5xMEBRM7mOG
	yqvvzpXEFzN2TsVpFgNotpjcW5HaqVE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-YaVZODzpMjynge1Fv_lOYQ-1; Mon, 13 Feb 2023 14:58:47 -0500
X-MC-Unique: YaVZODzpMjynge1Fv_lOYQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 704AA1C426B0;
	Mon, 13 Feb 2023 19:58:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 20B112026D4B;
	Mon, 13 Feb 2023 19:58:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E35C31946588;
	Mon, 13 Feb 2023 19:58:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E87FA1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 19:58:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C9A2B2166B26; Mon, 13 Feb 2023 19:58:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C28B22166B2A
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 19:58:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96EDF18E0046
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 19:58:43 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-HQJKR8MVM1ignivqlSXhVQ-1; Mon, 13 Feb 2023 14:58:38 -0500
X-MC-Unique: HQJKR8MVM1ignivqlSXhVQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D54BCB81617;
 Mon, 13 Feb 2023 19:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901E8C433D2;
 Mon, 13 Feb 2023 19:50:48 +0000 (UTC)
Date: Mon, 13 Feb 2023 19:50:47 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Heinz Mauelshagen <heinzm@redhat.com>
Message-ID: <Y+qUl1sDqYwEPPo3@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] "dm: prefer kmap_local_page() instead of deprecated
 kmap_atomic()" is broken
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Mike and Heinz,

The following commit in linux-next is causing "BUG: scheduling while atomic"
bugs.  Probably because it is still using kunmap_atomic(), not kunmap_local().

	commit 621d8807771e430b44136e48dfe3c53540c9953d
	Author: Heinz Mauelshagen <heinzm@redhat.com>
	Date:   Tue Feb 7 20:22:58 2023 +0100

	    dm: prefer kmap_local_page() instead of deprecated kmap_atomic()

This patch does not appear to have been sent to the mailing list (why not?), so
I started a new thread.

- Eric

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

