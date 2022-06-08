Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0652C43334
	for <dm-devel@archiver.kernel.org>; Wed,  8 Jun 2022 22:28:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-ewfGwvx-PruzCgs7viR0VQ-1; Wed, 08 Jun 2022 18:28:17 -0400
X-MC-Unique: ewfGwvx-PruzCgs7viR0VQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1F541C0513C;
	Wed,  8 Jun 2022 22:28:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 49CF640CF8F0;
	Wed,  8 Jun 2022 22:28:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E6FD41947051;
	Wed,  8 Jun 2022 22:28:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 35955194704E
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 22:28:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 29E3340CFD0B; Wed,  8 Jun 2022 22:28:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2627B40CF8F0
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 22:28:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C69D29AA3B7
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 22:28:11 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-324-CCJX4rdFPT-tV_N6FEit6Q-1; Wed,
 08 Jun 2022 18:28:09 -0400
X-MC-Unique: CCJX4rdFPT-tV_N6FEit6Q-1
Received: by linux.microsoft.com (Postfix, from userid 1033)
 id E908320BE66A; Wed,  8 Jun 2022 15:28:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E908320BE66A
Date: Wed, 8 Jun 2022 15:28:07 -0700
From: Deven Bowers <deven.desai@linux.microsoft.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <20220608222807.GA7650@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
 <1654714889-26728-11-git-send-email-deven.desai@linux.microsoft.com>
 <14754d16-75ae-cc92-cfc5-adce0628d9d9@schaufler-ca.com>
MIME-Version: 1.0
In-Reply-To: <14754d16-75ae-cc92-cfc5-adce0628d9d9@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [RFC PATCH v8 10/17] block|security: add LSM blob to
 block_device
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jun 08, 2022 at 01:07:39PM -0700, Casey Schaufler wrote:
> On 6/8/2022 12:01 PM, Deven Bowers wrote:
> >block_device structures can have valuable security properties,
> >based on how they are created, and what subsystem manages them.
> >
> >By adding LSM storage to this structure, this data can be accessed
> >at the LSM layer.
> >
> >Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> 
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> Not everyone is going to appreciate the infrastructure allocation
> of the block_device security blob, but I do.

Thanks Casey.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

