Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE409C6FD1C
	for <dm-devel@archiver.kernel.org>; Wed, 22 Mar 2023 07:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679471457;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uR2Yxy6JTeO963Cf/lRrVsAp6h0xL7tM7ookYzIDn6Q=;
	b=EuUluW/rTBWsgdbSAxhXRL81ZBGUJTFpxS8YhVCmjUGPzQm8HVzjYl9rlhYVLBPsJlSR2W
	dWR39IFljN/93OJY4wKstaI2/SCBSy+3dZv+ik3/AvsioN49JUL+1SUbKdTnIlRq28FCNf
	Pv5HLgQmQ0lk5Awh2qVMl+6IULkViEU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-qJejrBOfOsWErPzMWETgbQ-1; Wed, 22 Mar 2023 03:50:56 -0400
X-MC-Unique: qJejrBOfOsWErPzMWETgbQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CAC5858F09;
	Wed, 22 Mar 2023 07:50:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CCF73492C13;
	Wed, 22 Mar 2023 07:50:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9948219465B9;
	Wed, 22 Mar 2023 07:50:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7C0B1946594
 for <dm-devel@listman.corp.redhat.com>; Tue, 21 Mar 2023 13:53:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 99BD62027062; Tue, 21 Mar 2023 13:53:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 913802027061
 for <dm-devel@redhat.com>; Tue, 21 Mar 2023 13:53:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 705392999B2D
 for <dm-devel@redhat.com>; Tue, 21 Mar 2023 13:53:19 +0000 (UTC)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com
 [209.85.208.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-TT_RB8cgN6ymnKenGBVALQ-1; Tue, 21 Mar 2023 09:53:17 -0400
X-MC-Unique: TT_RB8cgN6ymnKenGBVALQ-1
Received: by mail-ed1-f45.google.com with SMTP id cn12so14325091edb.4
 for <dm-devel@redhat.com>; Tue, 21 Mar 2023 06:53:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679406796;
 h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=8W6ejF7gmj1PXpTdZI2xA9f/8wOpeSmMndaGTr9oNFw=;
 b=ud6BH4pasHIgmPLMdVtooha3VQt2/OS7zJJM4Mw0+gktC/CNHF/8eIRs6VcrVe5mzx
 hKbH4JLwZJ8xUJS6F70u1rp5imnALyagefbD5Jz4l1Os2bTg14lkzziEQpxrUTwSjwE9
 uKsA8F5T2OGduu3GFvgZwSuPJm+Y5tl1TLrXC7oz9VpII6prB+cBblklGF0UmmcMTu4/
 P7NNPd2qzmIZRCshzYsqaSrXf6bK1V3ArKkrY6DfpnRS3BR18t+Y1vsQt0BeGM81nSOm
 lCzrC9dbGnoJtFt0kEsevbAF+YLsTdEHSZvLN7grPrdYqFdjVmgvutzw1F74IBkzGJTk
 qZYg==
X-Gm-Message-State: AO0yUKVGc3eeJTa3jmae73l0eGNkSbeLRDAEQzsgX+/CBhtu+xnuvdRB
 +zUmoJn+UC6Fja/apEcimDFp50Xf5q4njTbQM4o=
X-Google-Smtp-Source: AK7set/s5RxMFyLJ3g71CZ2H3wSgUc+1I0vaYBez5Vxx/7wCI9wP3s5ElkFf/xSD0ekVeCy826N1b1k+nOXGwbH0HWE=
X-Received: by 2002:a50:ce45:0:b0:4fb:80cf:898b with SMTP id
 k5-20020a50ce45000000b004fb80cf898bmr1595691edj.7.1679406796401; Tue, 21 Mar
 2023 06:53:16 -0700 (PDT)
MIME-Version: 1.0
From: lacsaP Patatetom <patatetom@gmail.com>
Date: Tue, 21 Mar 2023 14:52:54 +0100
Message-ID: <CAGhAadc4tfjpB1UJ2WkUVLSkvbsShi+Ek6XUGL=0NbTU9tsGAQ@mail.gmail.com>
To: linux-block@vger.kernel.org
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Wed, 22 Mar 2023 07:50:48 +0000
Subject: [dm-devel] RO device/partition "tampered" by LVM
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
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

hello developers,

until recently, I used to modify the `bio_check_ro` function of the
`block/blk-core.c` file to prevent LVM from altering read-only
partitions.

is it possible to get this behavior back after the many changes
applied to the `block/blk-core.c` file and especially to the
`bio_check_ro` function ?
if yes, can you tell me how to do it ?
otherwise, would retrograde only the `block/blk-core.c` file in a
previous version work ?

here is a GitHub page that details what I said :
https://github.com/patatetom/lvm-on-readonly-block-device .

on this subject, do you know of any other technologies such as LVM
that would alter a disk or partition marked as read-only, which would
ignore the administrator's wish ?

regards, lacsaP.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

