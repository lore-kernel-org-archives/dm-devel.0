Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA39CD6E77
	for <dm-devel@archiver.kernel.org>; Wed, 11 Oct 2023 15:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697036414;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QNLSvhMU9PGbOO1BIy11Ju8ON6F2RqOYZexbnIF6UEg=;
	b=FLSl1JxC+wK8ohnwrbBH4TX74gRey13cx8pheRhfaVe+dcIrKo+L24O++E3mR5ZIqUrY/f
	gz/gIlQVMfXNGac9of+9Wq8WKZfi8JVigA4IMlEOGG4nRDzTgZclprOF567nQJP+csYkkE
	16aOgoMQSj4XznhF8xbprI7p1D5zr5A=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-9UuVzS6aMficzRywQUaCqQ-1; Wed, 11 Oct 2023 11:00:12 -0400
X-MC-Unique: 9UuVzS6aMficzRywQUaCqQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E63371C068DC;
	Wed, 11 Oct 2023 15:00:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF147170E9;
	Wed, 11 Oct 2023 15:00:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A649A1946586;
	Wed, 11 Oct 2023 15:00:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CEB8D1946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 11 Oct 2023 15:00:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 93257C5796F; Wed, 11 Oct 2023 15:00:09 +0000 (UTC)
Received: from agk-cloud1.hosts.prod.upshift.rdu2.redhat.com
 (agk-cloud1.hosts.prod.upshift.rdu2.redhat.com [10.0.13.154])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 71D1DC5796D;
 Wed, 11 Oct 2023 15:00:09 +0000 (UTC)
Received: by agk-cloud1.hosts.prod.upshift.rdu2.redhat.com (Postfix,
 from userid 3883)
 id 28A99401F3A7; Wed, 11 Oct 2023 15:54:18 +0100 (BST)
Date: Wed, 11 Oct 2023 15:54:18 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: dm-devel@redhat.com
Subject: Mailing list move - update your address book!
Message-ID: <20231011145418.GE8783@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
Mail-Followup-To: dm-devel@redhat.com
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Although we are trying to get messages sent to the old address
forwarded, this isn't working yet and can't be guaranteed
to work 100% anyway, so please update your records to
use the new list address!

Alasdair (expecting this message to bounce)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

