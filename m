Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EC86C43334
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 19:41:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-xfTW8mOxPheK7tw77rhCwA-1; Wed, 08 Jun 2022 15:41:42 -0400
X-MC-Unique: xfTW8mOxPheK7tw77rhCwA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5136D1C18270;
	Wed,  8 Jun 2022 19:41:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B957918EA6;
	Wed,  8 Jun 2022 19:41:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5F69A194704E;
	Wed,  8 Jun 2022 19:41:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F035A194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 19:41:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BB14A1121319; Wed,  8 Jun 2022 19:41:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B689A1121315
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 19:41:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0F5C381078C
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 19:41:37 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-393-39jXFliLPe2iSXgSAVqMTQ-1; Wed,
 08 Jun 2022 15:41:26 -0400
X-MC-Unique: 39jXFliLPe2iSXgSAVqMTQ-1
Received: by linux.microsoft.com (Postfix, from userid 1033)
 id 2150E20BE665; Wed,  8 Jun 2022 12:41:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2150E20BE665
Date: Wed, 8 Jun 2022 12:41:25 -0700
From: Deven Bowers <deven.desai@linux.microsoft.com>
To: Matthew Wilcox <willy@infradead.org>
Message-ID: <20220608194125.GA32366@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
 <YqD0QjNb+wfH+Kjq@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <YqD0QjNb+wfH+Kjq@casper.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [RFC PATCH v8 00/17] Integrity Policy Enforcement
 LSM (IPE)
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
 roberto.sassu@huawei.com, linux-doc@vger.kernel.org, snitzer@kernel.org,
 jmorris@namei.org, zohar@linux.ibm.com, linux-kernel@vger.kernel.org,
 ebiggers@kernel.org, linux-security-module@vger.kernel.org,
 linux-audit@redhat.com, eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
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

On Wed, Jun 08, 2022 at 08:10:58PM +0100, Matthew Wilcox wrote:
> On Wed, Jun 08, 2022 at 12:01:12PM -0700, Deven Bowers wrote:
> > IPE is a Linux Security Module which takes a complimentary approach to
> 
> Hello, IPE.  You're looking exceptionally attractive today.  Have you
> been working out?

Not nearly as often as I'd like to :)

> 
> (maybe you meant "complementary"?  ;-)

Yes, thanks. Sorry for the misspelling.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

