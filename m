Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB28EC43334
	for <dm-devel@archiver.kernel.org>; Thu, 21 Jul 2022 14:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658414061;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6nM3/amWClz1jQnvozWSQWHJbZDBfzWUeH6FFca4fUs=;
	b=R0AaUy6gv4QFViF/G89LsTNJi3uPGdGSzCwjmb2FDzeA5Ct3zb14wzljPP4PQfM1sFBsd0
	AiavCJPB2+H9oKgh6h/aWxQzQorQM0Fb4Kn9nigunzzTfl7m4B0CyhQ1880Q9ANQn8C2vX
	JkSdJ3MZx7WSOSgAo5z5+gYE/qAm22Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-k8z8NjdcP3G4s6Uk2W0t5w-1; Thu, 21 Jul 2022 10:34:18 -0400
X-MC-Unique: k8z8NjdcP3G4s6Uk2W0t5w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC0402812C22;
	Thu, 21 Jul 2022 14:34:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9452C40D296B;
	Thu, 21 Jul 2022 14:34:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1223A194704F;
	Thu, 21 Jul 2022 14:34:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7703F1947040
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Jul 2022 14:34:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 44717492C3B; Thu, 21 Jul 2022 14:34:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 31AB8492CA5;
 Thu, 21 Jul 2022 14:34:13 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 26LEYBxv015333;
 Thu, 21 Jul 2022 09:34:12 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 26LEYBMP015332;
 Thu, 21 Jul 2022 09:34:11 -0500
Date: Thu, 21 Jul 2022 09:34:10 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Wu Guanghao <wuguanghao3@huawei.com>
Message-ID: <20220721143410.GZ10602@octiron.msp.redhat.com>
References: <4a5b490d-6361-a745-9e4c-0fe240c8b93f@huawei.com>
MIME-Version: 1.0
In-Reply-To: <4a5b490d-6361-a745-9e4c-0fe240c8b93f@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [Question] multipathd add/remove paths takes a long
 time
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
Cc: lixiaokeng@huawei.com, liuxing108@huawei.com, zhangying134@huawei.com,
 chenmao2@huawei.com, liuzhiqiang26@huawei.com, linfeilong@huawei.com,
 dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>,
 mwilck@suse.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Jul 19, 2022 at 08:13:39PM +0800, Wu Guanghao wrote:
> The system has 1K multipath devices, each device has 16 paths.
> Execute multipathd add/multipathd remove or uev_add_path/
> uev_remove_path to add/remove paths, which takes over 20s.
> What's more, the second checkloop may be execed immediately
> after finishing first checkloop. It's too long.
> 
> We found that time was mostly spent waiting for locks.
> 
> checkerloop(){
> 	...
> 	lock(&vecs->lock);
> 	vector_foreach_slot (vecs->pathvec, pp, i) {
> 		rc = check_path(...); // Too many paths, it takes a long time
> 		...
> 	}
> 	lock_cleanup_pop(vecs->lock);
> 	...
> }
> 
> Can the range of vecs->lock locks be adjusted to reduce the time consuming
> when adding/removing paths?

As long as we make sure not to skip any paths or double-check any paths,
we don't need to hold the vecs->lock between checking paths. There is
certainly some optimization that could get done here.

could you post the output of:

# multipath -l <sample_multipath_device>
# multipathd show config local

-Ben
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

