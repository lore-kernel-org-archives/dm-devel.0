Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2CCCECAAA1
	for <dm-devel@archiver.kernel.org>; Sun, 30 Oct 2022 15:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667143465;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=F0FrVQGaJoRf5rRpTmJEcUMHES215YpJLKIaWLzX/iE=;
	b=OkLyRxUVjAVVjqi6VBbMBRA9KrAIcT/5/NvsZU5hwGq0YatEwPwq35fMD25Wwjb4LRjXUF
	gXX0oUkLyeA30vvtbJaaNNBVDmxKnPucm/VKS1JYNaYei4HJwvAhklF8UKAL9ydWpuhR5e
	JYNCxu8TW9R+AseuRZJNuRuzt5JfRVY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-S4vh8g9BM-qAxLoK_gHEGw-1; Sun, 30 Oct 2022 11:24:22 -0400
X-MC-Unique: S4vh8g9BM-qAxLoK_gHEGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A1B88027EA;
	Sun, 30 Oct 2022 15:24:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 66F652023A16;
	Sun, 30 Oct 2022 15:24:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 39836194658C;
	Sun, 30 Oct 2022 15:24:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7AACF1946589
 for <dm-devel@listman.corp.redhat.com>; Sun, 30 Oct 2022 15:24:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9C6A92166B2F; Sun, 30 Oct 2022 15:24:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 954942166B29
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 15:24:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C4DD1C0758C
 for <dm-devel@redhat.com>; Sun, 30 Oct 2022 15:24:12 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-WJJ-oAsrP6agyymFGOSyTQ-1; Sun, 30 Oct 2022 11:24:10 -0400
X-MC-Unique: WJJ-oAsrP6agyymFGOSyTQ-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 4812468AA6; Sun, 30 Oct 2022 16:24:06 +0100 (CET)
Date: Sun, 30 Oct 2022 16:24:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <20221030152405.GA9676@lst.de>
References: <20221020164605.1764830-1-hch@lst.de>
 <20221020164605.1764830-2-hch@lst.de>
 <cc7d4e79-a14d-1183-09a2-337052321e3e@huaweicloud.com>
 <868b6d4f-9306-0469-149a-47e5d282d141@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <868b6d4f-9306-0469-149a-47e5d282d141@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 1/6] block: clear the holder releated fields
 when deleting the kobjects
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 "yukuai \(C\)" <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Oct 21, 2022 at 11:22:05AM +0800, Yu Kuai wrote:
> I just verify that with this patchset applied, and together with the
> following patch to add some delay:

Yes, that's because we should only blow away the slave_dir and not
bd_holder_dir.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

