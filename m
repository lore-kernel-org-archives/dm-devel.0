Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47B6C76196
	for <dm-devel@archiver.kernel.org>; Tue, 28 Mar 2023 06:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679984880;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wfhh8dfqxtCwEHEOjEnuEQ2oJ6jnuIitb1Vc3nv9amw=;
	b=Gmd9xeAytVvyyHkeYXC2DsgvF+gxK5L6B4pZpOFkLm/r6617kbPcxgNOLtQEKMCuF7BzP+
	P/oR0//yETDU64j8nC1xMCbcOKp/EpNlT/tFqxNwi5FckJVWPCSYfuGnPT5Ivj1Eg9HBrA
	aJXzKKQj9CdeUAr9scTGaBvR2/0xNL4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-MQ_XN_aKNJiCARUHPs4h3g-1; Tue, 28 Mar 2023 02:27:57 -0400
X-MC-Unique: MQ_XN_aKNJiCARUHPs4h3g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E640185A78F;
	Tue, 28 Mar 2023 06:27:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3CEF6492C3E;
	Tue, 28 Mar 2023 06:27:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DC82F194658C;
	Tue, 28 Mar 2023 06:27:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 78276194658F
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:24:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57F564020C83; Mon, 27 Mar 2023 20:24:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 50AA54020C82
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:24:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BC0A101A54F
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:24:32 +0000 (UTC)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com
 [209.85.219.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-B0FTa_d1NI-iVMlN35aYfw-1; Mon, 27 Mar 2023 16:24:30 -0400
X-MC-Unique: B0FTa_d1NI-iVMlN35aYfw-1
Received: by mail-yb1-f171.google.com with SMTP id b18so12358846ybp.1
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:24:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948669;
 h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=W2jfREF9qNzWz3+L5iyhz9HBp4RRyZ/NjEtDw2yRJBw=;
 b=w6t1XfXau6l/QsTt8wkT+5PIWev7EhuDfPpCZEQIK3E8qODYPhiYhHCWX/G0ib//0a
 6osxlOYIytZXzabj7vmGYNGSuyA/ka1WC5yqDCGcLLQGxNLmCjScOSCwqmlFm7MBevxU
 M6Yu8ONrZzFW42TtHcAibRb1tlKA0eDKYshrrdMskzXZkLapV+iHJja98wrad24K977Z
 oDxtcDskt31qphDspF6lVRr++Kc79kj35U1fec5bcmW/jPDV0KtRTBgiDf8TxsRvpay/
 k8Ibghj55/fXRvSZy3+0XC/E547P/3E4IXQJDhTrByrpCr6Y5DFRbOvgA0O2ySDu7daf
 8N6g==
X-Gm-Message-State: AAQBX9f6W+GSAEvDTBzK8QlOkkD4VyNsdpA8wIMPa2sisY8IEy/mKSLp
 pXQdQdrOgj1XWbtSusQzXul9OdWVE7w3qJwv417a5sOaHF0/uwBrkZlUqA==
X-Google-Smtp-Source: AKy350Z0clJbg8lM3qxdQgk0gxc3zUu/Wno2kScUMfWHalwZcybS7TKSmhLWkRSPjNuc7gbx+untru4cxllpeaZHG3g=
X-Received: by 2002:a25:b00b:0:b0:b68:27f8:e674 with SMTP id
 q11-20020a25b00b000000b00b6827f8e674mr11954180ybf.39.1679948669296; Mon, 27
 Mar 2023 13:24:29 -0700 (PDT)
MIME-Version: 1.0
From: Gwendal Grignou <gwendal@chromium.org>
Date: Mon, 27 Mar 2023 13:24:18 -0700
Message-ID: <CAMHSBOXxdtGxQ8MTv4Tz+fcngaOJS5r62Br6VEDJESg2g5jP4w@mail.gmail.com>
To: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 28 Mar 2023 06:27:49 +0000
Subject: [dm-devel] dm-clone: Request option to send discard to source
 device during hydration
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
Cc: Sarthak Kukreti <sarthakkukreti@google.com>,
 Daniil Lunev <dlunev@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On ChromeOS, we are working on migrating file backed loopback devices
to thinpool logical volumes using dm-clone on the Chromebook local
SSD.
Dm-clone hydration workflow is a great fit but the design of dm-clone
assumes a read-only source device. Data present in the backing file
will be copied to the new logical volume but can be safely deleted
only when the hydration process is complete. During migration, some
data will be duplicated and usage on the Chromebook SSD will
unnecessarily increase.
Would it be reasonable to add a discard option when enabling the
hydration process to discard data as we go on the source device?
2 implementations are possible:
a- add a state to the hydration state machine to ensure a region is
discarded before considering another region.
b- a simpler implementation where the discard is sent asynchronously
at the end of a region copy. It may not complete successfully (in case
the device crashes during the hydration for instance), but will vastly
reduce the amount of data left  in the source device at the end of the
hydration.

I prefer b) as it is easier to implement, but a) is cleaner from a
usage point of view.

Gwendal.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

