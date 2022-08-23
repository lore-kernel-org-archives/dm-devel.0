Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E757C32793
	for <dm-devel@archiver.kernel.org>; Tue, 23 Aug 2022 23:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661297651;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Tznr1jPYKLRPSrmEWzR2yB9rFYEWNHEo/3LMA/jo58k=;
	b=JRxevBni4mxUb8RzupIWJyIvoNv51KGScTRlYFtHj1fiSHF/lfJQSwAzSfPtM8dLhYNvv4
	cRZnq8oIRCI+tPw52eSmDB5La6Ofaj/zw5fbnprMswTIicXfZi/Imi5wnW3OJxUxlUYW+l
	gZg7B0vCAnSrlMdochCSfpeYIGLVdVU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-M_D_-uAHPs2sXZJDIgeihg-1; Tue, 23 Aug 2022 19:34:08 -0400
X-MC-Unique: M_D_-uAHPs2sXZJDIgeihg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0459B85A585;
	Tue, 23 Aug 2022 23:34:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12B9F2026D4C;
	Tue, 23 Aug 2022 23:34:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D307D1946A41;
	Tue, 23 Aug 2022 23:34:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2ACDC1946A40
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 Aug 2022 23:34:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F3CDB2166B29; Tue, 23 Aug 2022 23:34:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EFAE32166B26
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 23:34:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4E3A3C0D1A5
 for <dm-devel@redhat.com>; Tue, 23 Aug 2022 23:34:02 +0000 (UTC)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-224-zLHoKxXlMI2VxqmP-j-pkw-1; Tue, 23 Aug 2022 19:34:00 -0400
X-MC-Unique: zLHoKxXlMI2VxqmP-j-pkw-1
Received: by mail-wr1-f52.google.com with SMTP id a4so18781154wrq.1;
 Tue, 23 Aug 2022 16:33:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc;
 bh=yFd3uoPfext8CVFiAfPOjedq7QVGUjqln8leyjDTZdA=;
 b=OFSxoI2Vomy+GTmgX2J77ROY1gqO57ys+rMOzBo2bMZGMpbSSyqZ5gdgeB9yFS9ioc
 L9aynzggZfmnw0Qg25O9wyk2JRQaMlqUldYER2n6R90EOYKSO0A6rQbaXBLFsfW6N6hG
 BKgtfwh/b9bEOElQaQp2dnkokjxVWguy36+VF28sF/3qYBF3erGXZINv3nwNchKyfXdC
 sZdD3W7Kq797qR/XnSG9AiQwH4HEbiwALM10LkxEmtiPTO3gcTLBcx6JY5aEz8FqhroG
 52wpnjc6FwdDMDoAPibE8zzy0XPK3MrjxmwW4SHuf7kdcV9ze+IX4Uys/VFKD1ks6TTc
 xweg==
X-Gm-Message-State: ACgBeo24AhKmyPhg4U1VJVKaXsT+/t3aBt0Yw8ZAgj2nkYULa7YdyrRO
 u1kvFeum45QoRS35+ggFWZG4r+iIcA==
X-Google-Smtp-Source: AA6agR7EgkG8o6rrkINqAZPXRBI0Paz4xKIslyBcwZ5WE8HxWyN3ct8fekeMFitEWRzK2krw+VCE8A==
X-Received: by 2002:adf:f2cd:0:b0:225:33bb:87ee with SMTP id
 d13-20020adff2cd000000b0022533bb87eemr13603427wrp.696.1661297638856; 
 Tue, 23 Aug 2022 16:33:58 -0700 (PDT)
Received: from localhost (129.red-81-44-155.dynamicip.rima-tde.net.
 [81.44.155.129]) by smtp.gmail.com with ESMTPSA id
 l26-20020a05600c089a00b003a2cf1ba9e2sm18260107wmp.6.2022.08.23.16.33.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 23 Aug 2022 16:33:56 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed, 24 Aug 2022 01:33:52 +0200
Message-Id: <20220823233352.70881-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH] multipath-tools: add more info for NetApp RDAC
 arrays
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From:
https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-49E94674-947F-4921-A1D1-CE9B42DCBA39.html
https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-CA17AE34-F5B2-4FF4-8FD4-4A7AA4238976.html
https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-3DA657A9-FF4A-4237-90EC-BA8863B7431E.html

To use ALUA mode, "Automatic Load Balancing" should be enabled and
"Select operating system:" should be changed to "Linux DM-MP (Kernel 3.10 or later)".

To use RDAC mode, "Automatic Load Balancing" should be disabled and
"Select operating system:" should be changed to "Linux DM-MP (Kernel 3.9 or earlier)".


Add it to prio and hardware_handler, and to alua info.


Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.md                  | 5 +++--
 multipath/multipath.conf.5 | 8 +++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/README.md b/README.md
index b05b1332..4e34c591 100644
--- a/README.md
+++ b/README.md
@@ -165,8 +165,9 @@ To enable ALUA, the following options should be changed:
    "LUN Affinity" and "ALUA" should be changed to "Enable", "Redundancy Type"
    must be "Active-Active".
 
-- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series and OEM arrays:
-   "Select operating system:" should be changed to "Linux DM-MP (Kernel 3.10 or later)".
+- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series and rebranded arrays:
+  "Automatic Load Balancing" should be enabled and "Select operating system:"
+  should be changed to "Linux DM-MP (Kernel 3.10 or later)".
 
 - NetApp ONTAP:
    To check ALUA state: "igroup show -v <igroup_name>", and to enable ALUA:
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index acdd1ae6..58080990 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -6,7 +6,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2021-09-08 Linux
+.TH MULTIPATH.CONF 5 2022-08-14 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -320,7 +320,8 @@ Generate the path priority for NetApp ONTAP class, and rebranded arrays.
 .I rdac
 (Hardware-dependent)
 Generate the path priority for LSI/Engenio/NetApp RDAC class as NetApp SANtricity
-E/EF Series, and rebranded arrays.
+E/EF Series and rebranded arrays, with Automatic Load Balancing disabled and
+Select operating system: Linux DM-MP (Kernel 3.9 or earlier).
 .TP
 .I hp_sw
 (Hardware-dependent)
@@ -1568,7 +1569,8 @@ with Failover Mode 1 (Passive Not Ready(PNR)).
 .I 1 rdac
 (Hardware-dependent)
 Hardware handler for LSI/Engenio/NetApp RDAC class as NetApp SANtricity E/EF
-Series, and rebranded arrays.
+Series and rebranded arrays, with Automatic Load Balancing disabled and
+Select operating system: Linux DM-MP (Kernel 3.9 or earlier).
 .TP
 .I 1 hp_sw
 (Hardware-dependent)
-- 
2.37.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

