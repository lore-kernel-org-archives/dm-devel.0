Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB4A5C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 08:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666253885;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PP0XI32uUIVs09AhAmrthQBDDF5ssjUiBf5MbWFOi/E=;
	b=RrknmPFixF0zEc0VVUsekr+mRHnXm8kW+AS8yzbgt+5VP+aVy7lQwQOOkrAHPjHNeqHZ5y
	kqVjQsd9b25b410WLH87ExPBBphDWAwi0iY6/cR/xZZMHfQUZMOKxQRIk8OM3nUFVPBAdK
	wtbrmx35hjFDyFiF2uWocn9CNeTF/Dw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-6Sgs1AleOhKJLBEi2YX1zQ-1; Thu, 20 Oct 2022 04:18:02 -0400
X-MC-Unique: 6Sgs1AleOhKJLBEi2YX1zQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE9C0811E67;
	Thu, 20 Oct 2022 08:17:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F19B12166B33;
	Thu, 20 Oct 2022 08:17:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8278F1946595;
	Thu, 20 Oct 2022 08:17:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 315861946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 08:17:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 05B0EC15BBC; Thu, 20 Oct 2022 08:17:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CA45AC15BA5
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 08:17:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5A8385A59D
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 08:17:55 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-217-n0Za6oQYNp6Zc0E88KsrAw-1; Thu, 20 Oct 2022 04:17:51 -0400
X-MC-Unique: n0Za6oQYNp6Zc0E88KsrAw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1olQkJ-00C85f-NC; Thu, 20 Oct 2022 08:17:43 +0000
Date: Thu, 20 Oct 2022 01:17:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <Y1EEJ6BEN2uOh8uj@infradead.org>
References: <Y07SYs98z5VNxdZq@redhat.com> <Y07twbDIVgEnPsFn@infradead.org>
 <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHk-=wg3cpPyoO8u+8Fu1uk86bgTUYanfKhmxMsZzvY_mV=Cxw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [git pull] device mapper changes for 6.1
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
Cc: linux-block@vger.kernel.org, Shaomin Deng <dengshaomin@cdjrlc.com>,
 Nikos Tsironis <ntsironis@arrikto.com>, Mike Snitzer <snitzer@kernel.org>,
 Nathan Huckleberry <nhuck@google.com>, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
 Genjian Zhang <zhanggenjian@kylinos.cn>, Jilin Yuan <yuanjilin@cdjrlc.com>,
 Milan Broz <gmazyland@gmail.com>, Alasdair G Kergon <agk@redhat.com>,
 Jiangshan Yi <yijiangshan@kylinos.cn>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Oct 18, 2022 at 11:54:49AM -0700, Linus Torvalds wrote:
> I wouldn't worry about maintainer sign-offs just for exporting a
> helper function, but I agree with the whole concept being a complete
> disaster and not a good idea at all.

It's not just a a "helper", it is internal magic for KASAN and low-level
code patching.  No driver has any business checking if something is a
module text/data address, and I'm fairly sure how they are using it is
actually wrong if DM is built in.

FYI, I also agree that the concept is a disaster as well.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

