Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16A31C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 25 Apr 2022 09:05:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-BneeIJJmOj66VpvQbAT_tQ-1; Mon, 25 Apr 2022 05:05:54 -0400
X-MC-Unique: BneeIJJmOj66VpvQbAT_tQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3BD080B71C;
	Mon, 25 Apr 2022 09:05:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6728E2166BA3;
	Mon, 25 Apr 2022 09:05:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1B7D51949762;
	Mon, 25 Apr 2022 09:05:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2921F1947BBE
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Apr 2022 09:05:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 04C164087D91; Mon, 25 Apr 2022 09:05:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F414640CF910
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 09:05:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC11E8038E3
 for <dm-devel@redhat.com>; Mon, 25 Apr 2022 09:05:50 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com
 (wout1-smtp.messagingengine.com [64.147.123.24]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-aigILFcsO0u0oyGa8fFVCQ-1; Mon, 25 Apr 2022 05:05:47 -0400
X-MC-Unique: aigILFcsO0u0oyGa8fFVCQ-1
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
 by mailout.west.internal (Postfix) with ESMTP id 396B13200E79;
 Mon, 25 Apr 2022 04:57:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute2.internal (MEProxy); Mon, 25 Apr 2022 04:57:04 -0400
X-ME-Sender: <xms:XmJmYlHeUZu3LGPPmk40s5RLcoZ7W7IajN0ohWLklNe6zIXKiajhuQ>
 <xme:XmJmYqWKOii65KNE4vg_yI-_3CjtB4g3_J7--r_WFrYo59ZbPcuXx4wZID2HHrp5O
 wOBB2SSeV0Luw>
X-ME-Received: <xmr:XmJmYnKe-ZaiLG54i4xxDlLQO0N3On5zvmv_1k-aLMCRwZn9vfPAj8flDDs_Ax_w8okhC5Azwtxvw1pIbo6N_ev_XrhtrF9S>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedruddugddtkecutefuodetggdotefrodftvf
 curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
 uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
 fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
 mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
 dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
 vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
 drtghomh
X-ME-Proxy: <xmx:XmJmYrFOnr64ORQ5FTauihsRBkrKmy-qQjRBbfu5g1U36wRSTXqCDA>
 <xmx:XmJmYrVLiqmAJzPm_ij1lQ3X8w4Ed702Ec-ZFiZSOP-ZKU4ke-PZaw>
 <xmx:XmJmYmN2qbG8WTpyai_Y4vKUCIlp5XuCUp5eBcGolMDdNCnzI_JBLA>
 <xmx:XmJmYvkmg_ZQbVQhY95LS2OzroLOwwlnxDDGn7ot_hXOxNK-J10xeA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 Apr 2022 04:57:01 -0400 (EDT)
Date: Mon, 25 Apr 2022 10:56:59 +0200
From: Greg KH <greg@kroah.com>
To: Akilesh Kailash <akailash@google.com>
Message-ID: <YmZiW0TUSjxrEGGZ@kroah.com>
References: <20220425082812.780445-1-akailash@google.com>
MIME-Version: 1.0
In-Reply-To: <20220425082812.780445-1-akailash@google.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH] dm: fix mempool NULL pointer race when
 completing IO
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, dm-devel@redhat.com, Jiazi Li <jqqlijiazi@gmail.com>,
 Jiazi Li <lijiazi@xiaomi.com>, kernel-team@android.com,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Apr 25, 2022 at 08:28:12AM +0000, Akilesh Kailash wrote:
> From: Jiazi Li <jqqlijiazi@gmail.com>
> 
> commit d208b89401e073de986dc891037c5a668f5d5d95 upstream.
> 
> This is a backport of the upstream patch to 5.10.y stable branch.

Now queued up, thanks.

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

