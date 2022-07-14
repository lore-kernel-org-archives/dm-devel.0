Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FFFC43334
	for <dm-devel@archiver.kernel.org>; Thu, 14 Jul 2022 18:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657824571;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lUYwRrjVA66N9NYAa5ekNuAXbFWDC1ynacBaBIyUq+g=;
	b=OKwlq48f644ucp3sMI9geXIHlAclgQVXEoFinDzb/0MXJZDOnhlguqx4ca+843ZWyrK0N4
	etfCoC0BhkWZuZDCoVBv8skd2a+FdACg+pmJHgZ6nl5KD7XdnCfJiBkiXrjtQfWKt4NrOU
	Q8+jgUjtOJpgP7lgTAqPrGO/c/XiQ/c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-Lv6UUBBJPran4KPlydny8w-1; Thu, 14 Jul 2022 14:49:28 -0400
X-MC-Unique: Lv6UUBBJPran4KPlydny8w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A4B61C05135;
	Thu, 14 Jul 2022 18:49:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 715068287E;
	Thu, 14 Jul 2022 18:49:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2DF7A194706C;
	Thu, 14 Jul 2022 18:49:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5147B1947042
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Jul 2022 18:49:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1F90740E80E1; Thu, 14 Jul 2022 18:49:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B10540E80E0
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 18:49:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00965804181
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 18:49:20 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-ky58toojNha5zeA_6vx72w-1; Thu, 14 Jul 2022 14:49:18 -0400
X-MC-Unique: ky58toojNha5zeA_6vx72w-1
Received: by mail-qk1-f198.google.com with SMTP id
 bp14-20020a05620a458e00b006b59195c391so1729221qkb.19
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 11:49:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=7kxj3LdYgbpNnStU9w3Sj9VXDhHdk9Jcchf++JL1N+Y=;
 b=RvjMDkZQfVyTynhb2/Ab4sJEiqhOpbG7wnhKCPKwXX+O7DZZe6KfahsLgz87/RekLi
 8FchihuWn4h0wZd90Wji4NBp8Czjj/V2c/bL4bS2n9KCS3l6iL6Ll1ZpKUyXCtMTGSE7
 GSpGuaNabGT2H9tnVXTav+XHwhgCX/xf9k6MMiQvGegcnw85+sWn0g4ySNYbiJV7h1/D
 GRt0EZiHwEkqABltGJ7WNNIK1NKstWakUh0MXEk+ONcjytTzx6qeqxx/1/Fl7+l6dgfj
 7D+Q3MpM5ewKYksfkmOXRNK3vaIz/cAnSsOJhTvQmrzTssJxssJyEMrGbai94QeRsD12
 0Jxg==
X-Gm-Message-State: AJIora92H41LRexwT3aW+6inYdAuirvDzj7pckGMlcFRWsMNgcTcnd29
 3RgZpMcqA4e9w8MwVLqvmvQtFCkbixvwvrbnGU7/qELNAaiZf8lNjzRJOdKxSMBvwGQIP27/zEo
 3XxcO3JhDUzez5g==
X-Received: by 2002:a05:620a:27cd:b0:6b5:cc9c:5656 with SMTP id
 i13-20020a05620a27cd00b006b5cc9c5656mr410474qkp.552.1657824558041; 
 Thu, 14 Jul 2022 11:49:18 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1up/sjBStld4GW4vXzjMBZxM8lmDyH6rq4IbnlFVHip8GGJh8ELoamRKFuXGwneRCOFrijM+Q==
X-Received: by 2002:a05:620a:27cd:b0:6b5:cc9c:5656 with SMTP id
 i13-20020a05620a27cd00b006b5cc9c5656mr410465qkp.552.1657824557830; 
 Thu, 14 Jul 2022 11:49:17 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 fp33-20020a05622a50a100b0031eaea83fc1sm1940851qtb.47.2022.07.14.11.49.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Jul 2022 11:49:17 -0700 (PDT)
Date: Thu, 14 Jul 2022 14:49:16 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <YtBlLDShzLdW8xDx@redhat.com>
References: <20220707202711.10836-1-michael.christie@oracle.com>
 <20220707202711.10836-3-michael.christie@oracle.com>
 <0c2c37c2-84f0-d6c7-b060-be7c5ba6dede@oracle.com>
MIME-Version: 1.0
In-Reply-To: <0c2c37c2-84f0-d6c7-b060-be7c5ba6dede@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 2/3] dm: Start pr_reserve from the same
 starting path
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
Cc: hch@infradead.org, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 09 2022 at 11:06P -0400,
Mike Christie <michael.christie@oracle.com> wrote:

> On 7/7/22 3:27 PM, Mike Christie wrote:
> > When an app does a pr_reserve it will go to whatever path we happen to
> > be using at the time. This can result in errors where the app does a
> > second pr_reserve call and expects success but gets a failure becuase
> > the reserve is not done on the holder's path. This patch has us always
> > start trying to do reserves from the first path in the first group.
> > 
> 
> Hi,
> 
> Giving myself a review comment. pr_preempt can also establish a reservation.
> I meant to send a patch for that as well. If the approach in this patchset is
> ok, I'll send a patch for that as well.
> 

It'd be nice to have Christoph weigh-in on these changes but I'm OK
with them in general.

But please give details on what you've tested them against.  I assume
the Windows cluster? How about pacemaker? And all looks good on other
systems that don't have the requirement to pin the PR to a device?

Once I have this context on testing I can then work through the
changes more closely and get them staged.  Please do feel free to send
a v2 that conveys what testing was done and you're welcome to sned the
patch for pr_preempt too.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

