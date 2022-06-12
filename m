Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4030C43334
	for <dm-devel@archiver.kernel.org>; Sun, 12 Jun 2022 17:53:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-XqBxS3wdOYCKt4thdPp-Kg-1; Sun, 12 Jun 2022 13:53:36 -0400
X-MC-Unique: XqBxS3wdOYCKt4thdPp-Kg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66A0F3802B8A;
	Sun, 12 Jun 2022 17:53:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BDBB61400C2B;
	Sun, 12 Jun 2022 17:53:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4E049194705D;
	Sun, 12 Jun 2022 17:53:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 23A5B194705B
 for <dm-devel@listman.corp.redhat.com>; Sun, 12 Jun 2022 17:53:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 107292026D2D; Sun, 12 Jun 2022 17:53:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C8F02026D64
 for <dm-devel@redhat.com>; Sun, 12 Jun 2022 17:53:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6BCB101A54E
 for <dm-devel@redhat.com>; Sun, 12 Jun 2022 17:53:29 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-S5EFpTOnOJyw_1GahgLT3A-1; Sun, 12 Jun 2022 13:53:28 -0400
X-MC-Unique: S5EFpTOnOJyw_1GahgLT3A-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 36DF460FF7;
 Sun, 12 Jun 2022 17:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B57C34115;
 Sun, 12 Jun 2022 17:53:26 +0000 (UTC)
Date: Sun, 12 Jun 2022 13:53:25 -0400
From: Sasha Levin <sashal@kernel.org>
To: Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <YqYoFQ42N6YNlNnX@sashalap>
References: <20220607174846.477972-1-sashal@kernel.org>
 <20220607174846.477972-35-sashal@kernel.org>
 <f369ed06-d268-6fa9-f4aa-e9f5cd5ce53a@linux.dev>
MIME-Version: 1.0
In-Reply-To: <f369ed06-d268-6fa9-f4aa-e9f5cd5ce53a@linux.dev>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH AUTOSEL 5.18 35/68] md: don't unregister
 sync_thread with reconfig_mutex held
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
Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Donald Buczek <buczek@molgen.mpg.de>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On Wed, Jun 08, 2022 at 04:43:26PM +0800, Guoqing Jiang wrote:
>Hi,
>
>Pls drop this one from all stable kernel versions since it caused 
>regression.

Will do, thanks.

-- 
Thanks,
Sasha

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

