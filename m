Return-Path: <SRS0=VWZ+=IN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A98C433E0
	for <dm-devel@archiver.kernel.org>; Mon, 15 Mar 2021 08:55:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C2FAB64E3F
	for <dm-devel@archiver.kernel.org>; Mon, 15 Mar 2021 08:55:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2FAB64E3F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-jYGCKeJBNKGxu1EmM4StNg-1; Mon, 15 Mar 2021 04:55:37 -0400
X-MC-Unique: jYGCKeJBNKGxu1EmM4StNg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44F021940922;
	Mon, 15 Mar 2021 08:55:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED9635C5E1;
	Mon, 15 Mar 2021 08:55:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7F7DEC590;
	Mon, 15 Mar 2021 08:55:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BCPdSe028121 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 07:25:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 101442166BA9; Thu, 11 Mar 2021 12:25:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09A532166BA2
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 12:25:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B04BF801E8D
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 12:25:36 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-548-DrNn81u-Mza7QbukQvqO6A-1; Thu, 11 Mar 2021 07:25:34 -0500
X-MC-Unique: DrNn81u-Mza7QbukQvqO6A-1
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id
	20210311121841epoutp03bc3641205ab372651a4115724621c1b3~rSPf-4TxA2543825438epoutp03A
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 12:18:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
	20210311121841epoutp03bc3641205ab372651a4115724621c1b3~rSPf-4TxA2543825438epoutp03A
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTP id
	20210311121840epcas1p302b1ce7f837037d60384a21a31560cd4~rSPfRdfQK0692006920epcas1p3W;
	Thu, 11 Mar 2021 12:18:40 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.165]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Dx7Jv4hppz4x9Q0;
	Thu, 11 Mar 2021 12:18:39 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
	epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	4D.28.59147.F9A0A406; Thu, 11 Mar 2021 21:18:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20210311121838epcas1p295d765b3c89ddacac9cd9bbf918d6345~rSPd0xb_21757017570epcas1p2i;
	Thu, 11 Mar 2021 12:18:38 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20210311121838epsmtrp248085b90865a4f9819b6cbcede6a9970~rSPd0C94T0536705367epsmtrp2c;
	Thu, 11 Mar 2021 12:18:38 +0000 (GMT)
X-AuditID: b6c32a38-e3dff7000000e70b-49-604a0a9f4b53
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	3A.92.08745.E9A0A406; Thu, 11 Mar 2021 21:18:38 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.104]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20210311121838epsmtip16ef9075af635a905532e38e1e20b7620~rSPdkgv3Z1975719757epsmtip1Y;
	Thu, 11 Mar 2021 12:18:38 +0000 (GMT)
From: JeongHyeon Lee <jhs2.lee@samsung.com>
To: snitzer@redhat.com
Date: Thu, 11 Mar 2021 21:10:50 +0900
Message-Id: <1615464651-23675-1-git-send-email-jhs2.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsWy7bCmnu58Lq8Egxn7FC3WnzrGbLH33WxW
	i0v377BaXN41h82ibeNXRgdWj/f7rrJ59G1ZxejxeZNcAHNUjk1GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvp1NUX5pSapC
	Rn5xia1SakFKToGhQYFecWJucWleul5yfq6VoYGBkSlQZUJORsexT8wFbZwVC3dtY29gfMTe
	xcjBISFgIvHluWkXIxeHkMAORonTR0+zQzifGCXap0xlg3A+M0o8nHGfFaZjxgktiPguRomn
	jQugOr4wSkyZvZCxi5GTg01AW+J2yyZ2EFtEQEziSN8DVhCbWSBPYvGLdmYQW1jARmLVv6dg
	cRYBVYnnP96DxXkFXCRuz1jPBGJLCMhJ3DzXyQyyQEKgn13iy9SPrBAJF4l9lzvYIGxhiVfH
	t7BD2FISn9/tZYNo6GaUuH/+NVTRBEaJ3h4miBfsJd5fsgAxmQU0Jdbv0oeoUJTY+XsuI8Sd
	fBLvvvZAPcwr0dEmBFGiJLHi3zUWCFtCYsPhbqjhHhKrWw+BxYUEYiW+P53BOIFRdhbCggWM
	jKsYxVILinPTU4sNC0yQ42gTIzgVaVnsYJz79oPeIUYmDsZDjBIczEoivH7H3RKEeFMSK6tS
	i/Lji0pzUosPMZoCw2sis5Rocj4wGeaVxBuaGhkbG1uYmJmbmRorifMmGTyIFxJITyxJzU5N
	LUgtgulj4uCUamBaePaw+6kvfwvypWc9V3DXf5/1Xex1u7HeZltJ5eN2TQUdG5VDDDrjLk19
	tnpT50Jbk/h9Rp83MswofWVy2EZg7gv1aNknFtr3+uYnxB7dOGFT3q4vDTG2/zp5lQqn/Nt+
	cnt9pJ3T200m7ydFLNqUKW20e2nrdJ1JOX3P05vk2gK/1dzfZvBmsk+7tmLaKjGhFau+pWll
	+WytV7Wt7pC/4idW3LjCQ8r3dI1e/X3Lh3fPxB1hf/F6q7dRqtpDibsngsPOx8o3B/Cyn0kI
	bvH/dKlDSSi780qAVmpbCpvx9ZsGuwIkl2nqrkw3nHphmhe3nsek2XPkTaaaC6VG98e8irHY
	5+6UIdT2Ni7sphJLcUaioRZzUXEiAIUuoZfOAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJMWRmVeSWpSXmKPExsWy7bCSnO48Lq8Eg8OnjC3WnzrGbLH33WxW
	i0v377BaXN41h82ibeNXRgdWj/f7rrJ59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV0bHsU/M
	BW2cFQt3bWNvYHzE3sXIwSEhYCIx44RWFyMXh5DADkaJhs9bmboYOYHiEhIbNq2FqhGWOHy4
	GKLmE6PE23dfWEFq2AS0JW63bGIHsUUExCSO9D0AizMLFEk837eADcQWFrCRWPXvKVicRUBV
	4vmP98wgNq+Ai8TtGeuhdslJ3DzXyTyBkWcBI8MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS9
	5PzcTYzg0NDS2sG4Z9UHvUOMTByMhxglOJiVRHj9jrslCPGmJFZWpRblxxeV5qQWH2KU5mBR
	Eue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cB02Vpi8xJflSMyswJ+byzZwzvrgzFvn4v1HM8t
	JavVb/55/vyntMFbZglu4w0PGsuqJK5W8vrvK2+I/5QWeP9S8pIpLVOL57VbfUou4tzztKhC
	fcvimdeLg7/fltv0s3bmqzyTvUInD7wKfXugpTJFdcWS32mRK+5fOrnbcvUvzW9+IYfmPEww
	LHBbt41F4d7fWoY596d1vF3+4vUqfn8egefPM0Pe/CpU2c77R7j+YoVBYR9HJJffXHYt4ReZ
	H+Zv/7r6Usiilfrqy34kruTdfDVix3Hl+8p8p37enVB9582r4JMpCv+rpbP3dwUdrvl1hvVD
	+naHCfsu8ClJF+qX2ZxSPe5lZfokb6bNnjiTjUosxRmJhlrMRcWJADkiDeB8AgAA
X-CMS-MailID: 20210311121838epcas1p295d765b3c89ddacac9cd9bbf918d6345
X-Msg-Generator: CA
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210311121838epcas1p295d765b3c89ddacac9cd9bbf918d6345
References: <CGME20210311121838epcas1p295d765b3c89ddacac9cd9bbf918d6345@epcas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 15 Mar 2021 04:55:29 -0400
Cc: JeongHyeon Lee <jhs2.lee@samsung.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, agk@redhat.com
Subject: [dm-devel] [PATCH 1/2] dm verity: fix DM_VERITY_OPTS_MAX value
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Three optional parameters at once using dm verity table is not
supported, option can only be used exclusively.

e.g.)
  (verity_mode) (ignore_zero_block) (check_at_most_once)

verity table: '1  /dev/sdb /dev/sdb 4096 4096 1028807 1028807
<hash_alg> <root_hash> <salt> 11 use_fec_from_device /dev/sdb
fec_roots 2 fec_blocks 1036909 fec_start 1036909
restart_on_corruption ignore_zero_blocks check_at_most_once'

Signed-off-by: JeongHyeon Lee <jhs2.lee@samsung.com>
---
 drivers/md/dm-verity-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 6b8e5bdd8526..808a98ef624c 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -34,7 +34,7 @@
 #define DM_VERITY_OPT_IGN_ZEROES	"ignore_zero_blocks"
 #define DM_VERITY_OPT_AT_MOST_ONCE	"check_at_most_once"
 
-#define DM_VERITY_OPTS_MAX		(2 + DM_VERITY_OPTS_FEC + \
+#define DM_VERITY_OPTS_MAX		(3 + DM_VERITY_OPTS_FEC + \
 					 DM_VERITY_ROOT_HASH_VERIFICATION_OPTS)
 
 static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

