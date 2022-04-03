Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5212FC433FE
	for <dm-devel@archiver.kernel.org>; Mon,  4 Apr 2022 06:48:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-aT38HedsPkGVKfWC72f93A-1; Mon, 04 Apr 2022 02:48:40 -0400
X-MC-Unique: aT38HedsPkGVKfWC72f93A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E392833966;
	Mon,  4 Apr 2022 06:48:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C01E4081107;
	Mon,  4 Apr 2022 06:48:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 18BA01940375;
	Mon,  4 Apr 2022 06:48:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B1318194035F
 for <dm-devel@listman.corp.redhat.com>; Sun,  3 Apr 2022 03:56:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8F317553384; Sun,  3 Apr 2022 03:56:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B32D553381
 for <dm-devel@redhat.com>; Sun,  3 Apr 2022 03:56:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 729FA85A5A8
 for <dm-devel@redhat.com>; Sun,  3 Apr 2022 03:56:29 +0000 (UTC)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
 [209.85.216.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-luemGLOjNJqU6n7SLRBe1A-1; Sat, 02 Apr 2022 23:56:26 -0400
X-MC-Unique: luemGLOjNJqU6n7SLRBe1A-1
Received: by mail-pj1-f51.google.com with SMTP id
 l4-20020a17090a49c400b001c6840df4a3so6053864pjm.0; 
 Sat, 02 Apr 2022 20:56:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=aq3tVUArEckm4a747xQx+SdBWz59m2Jh3U4GOewQ4uE=;
 b=DkU+msF9FEAVdFdhCKAUZnMvK7FoyoMFb06qWpX/OOLlZ+BP/3pygMWeAXNsozw2OL
 q5LsV280mmxxnXnZpM4/lrw97+G0D9muNLAnidF3uTHAZhaDWV8YENLlFPDuhSaAF7gH
 NBTRqVtaJe9EGKGtSF3QtQJMVS22XNlfenfUGc/Vodb/g5oz+9UCA8pslxYJbHSYu/ag
 +RdxvkCejVY0OhQcSQkwSYjanmcPlHB1NaViVoa6mnfLvL71AinV1kLmFHoUTTTOmFZd
 SJduO5FgM9aXBRJf7eYAqZB+pWJNAO3C17DFDgjxfVLKqyG1HV4ae6Wvh0bXmA4Ka0hF
 Gjfg==
X-Gm-Message-State: AOAM532kmSerA0vydQZCc3gQQqcSSeTyFzahzgmHNLzx1Cg3bnobSyen
 fh7jNet3/H2RJDVFTJkKoZ0FKmkE1S72jNF2
X-Google-Smtp-Source: ABdhPJxUT5CbGHWP7XJ0MkUXkzUaa9hbM7mE7aEECrruz/Rjj3hGl2iTan9I1XVfje+10AmndVSIHA==
X-Received: by 2002:a17:90b:1bc6:b0:1c7:3229:652a with SMTP id
 oa6-20020a17090b1bc600b001c73229652amr19831973pjb.65.1648958184216; 
 Sat, 02 Apr 2022 20:56:24 -0700 (PDT)
Received: from localhost.localdomain ([183.156.181.188])
 by smtp.googlemail.com with ESMTPSA id
 i187-20020a62c1c4000000b004faafada2ffsm7785714pfg.204.2022.04.02.20.56.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 02 Apr 2022 20:56:23 -0700 (PDT)
From: Xiaomeng Tong <xiam0nd.tong@gmail.com>
To: snitzer@redhat.com
Date: Sun,  3 Apr 2022 11:56:03 +0800
Message-Id: <20220403035603.16169-1-xiam0nd.tong@gmail.com>
In-Reply-To: <YkcQdjE6uTfScyEy@redhat.com>
References: <YkcQdjE6uTfScyEy@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Mon, 04 Apr 2022 06:48:34 +0000
Subject: Re: [dm-devel] md: fix missing check on list iterator
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
Cc: stable@vger.kernel.org, dm-devel@redhat.com, xiam0nd.tong@gmail.com,
 linux-kernel@vger.kernel.org, agk@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 1 Apr 2022 10:47:18 -0400, Mike Snitzer wrote:
> Did you acually hit a bug (invalid memory access)?
> 
> I cannot see how given the checks prior to iterating m->priority_groups:
> 
>         if (!pgstr || (sscanf(pgstr, "%u%c", &pgnum, &dummy) != 1) || !pgnum ||
>             !m->nr_priority_groups || (pgnum > m->nr_priority_groups)) {
>                 DMWARN("invalid PG number supplied to bypass_pg");
>                 return -EINVAL;
>         }
> 
> So I have _not_ taken your "fix".

Yes, you are correct. It has been checked before, thus not a bug and
no need to fix. And I have sent a PATCH v2 to use list iterator only
inside the loop, please check it. Thank you very much.

--
Xiaomeng Tong

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

