Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B9E6C4332F
	for <dm-devel@archiver.kernel.org>; Thu,  3 Nov 2022 16:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667492271;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xeOaeDgymt44BZjdmFjT1bjqQte2nEk18Teb26MuURI=;
	b=guk5gt3D3sVXbTeFWhogEvG2p84l48UdYqrdnU/wT5eVBzSPfCuLQvjIzyubeKEX0X753e
	qqcaQEXFUkxVWEh4EEUTh76iaiSFLHSPl4I0QuVZ+ziVP+BN5VMyaO3WNZZZAtF9FNrXtV
	gS0cf0FDZpmK6/qBoW22ofn9V25P7g8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-UusnLuRkPXev51c1eI05Kg-1; Thu, 03 Nov 2022 12:17:49 -0400
X-MC-Unique: UusnLuRkPXev51c1eI05Kg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5F583C0F221;
	Thu,  3 Nov 2022 16:17:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F283A1121325;
	Thu,  3 Nov 2022 16:17:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C15511946597;
	Thu,  3 Nov 2022 16:17:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 172051946594
 for <dm-devel@listman.corp.redhat.com>; Thu,  3 Nov 2022 16:17:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ED1C839D6A; Thu,  3 Nov 2022 16:17:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E650B7AE5
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 16:17:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5504811E75
 for <dm-devel@redhat.com>; Thu,  3 Nov 2022 16:17:42 +0000 (UTC)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
 [209.85.221.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-615-Wa_hUkzKO4GBiNXAcgF3aw-1; Thu, 03 Nov 2022 12:17:39 -0400
X-MC-Unique: Wa_hUkzKO4GBiNXAcgF3aw-1
Received: by mail-wr1-f53.google.com with SMTP id bk15so3480417wrb.13;
 Thu, 03 Nov 2022 09:17:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Dd/+wQA2XBz8muDM1I0P0w5QOuJDDR8AXeuZfkSV2JE=;
 b=cZicryeHCBbSb1AeTMwC4znAUQ2/DIq4YDlyKMAYCqBFJh8igXyeIjmArI7nUe8Thr
 xdOcOAx+JLi4LS0wMWfg1uT8uMoGfr42OW93cxkvpTX28JlxAvYALZdLgF6MplX8YywU
 02uc7uDS3sJpzy05CNhr8I1ytLBA/z3Q27qG3zTOwnVxo23YkNZfJMJxCqhMfkJI9N7k
 M/rZuhtMYey5tsyuvHl916rmCC/b2mHCfx2L70xWtnGIKQoGMm78L2yGWJifsWmCP1+m
 RebTSI7+nPnJx6dWpbNuWSh2+sn9nW13/FZKiF9X5V7hh61aoXU2f6Xh/lk5diSSiqpA
 EE9A==
X-Gm-Message-State: ACrzQf11WqTbmqqoLSZtHHi0lgB2NTBnpIHCbQhAak4q5882InCT5gGg
 Lu+eTWCvxPeBMrdZJatKcQ==
X-Google-Smtp-Source: AMsMyM6sxYCWHTCVCWni/NCfR5DcA/GsO6ACF4wU+8UOgaH9jnCFMILg8N1FRkNwvrondLNl3kEjAA==
X-Received: by 2002:a5d:4604:0:b0:236:cdd4:4cdd with SMTP id
 t4-20020a5d4604000000b00236cdd44cddmr13942449wrq.627.1667492257582; 
 Thu, 03 Nov 2022 09:17:37 -0700 (PDT)
Received: from localhost (230.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.230]) by smtp.gmail.com with ESMTPSA id
 b21-20020a05600c06d500b003b95ed78275sm308228wmn.20.2022.11.03.09.17.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 09:17:37 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu,  3 Nov 2022 17:17:27 +0100
Message-Id: <20221103161730.93378-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 0/3] update hwtable and multipath.conf man page
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
Cc: George Martin <Martin.George@netapp.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, DM-DEVEL ML <dm-devel@redhat.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Xose Vazquez Perez (3):
  multipath-tools: update hwtable text/info/comments
  multipath-tools: add PowerMax NVMe to hwtable
  multipath-tools: add more info for NetApp ontap prio

 README.md                  |  2 +-
 libmultipath/hwtable.c     | 27 ++++++++++++++++-----------
 multipath/multipath.conf.5 | 10 +++++-----
 3 files changed, 22 insertions(+), 17 deletions(-)

Cc: George Martin <Martin.George@netapp.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
-- 
2.38.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

