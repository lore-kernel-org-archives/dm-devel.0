Return-Path: <SRS0=VWZ+=IN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2E21C433E6
	for <dm-devel@archiver.kernel.org>; Mon, 15 Mar 2021 08:55:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EE6F764E3F
	for <dm-devel@archiver.kernel.org>; Mon, 15 Mar 2021 08:55:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE6F764E3F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-L1PoFPP9Ow21Df7lgC_7tA-1; Mon, 15 Mar 2021 04:55:38 -0400
X-MC-Unique: L1PoFPP9Ow21Df7lgC_7tA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 644EE101F003;
	Mon, 15 Mar 2021 08:55:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A7EB610AF;
	Mon, 15 Mar 2021 08:55:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 940AC18155DE;
	Mon, 15 Mar 2021 08:55:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BCSRH7028333 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 07:28:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C41A52166BA2; Thu, 11 Mar 2021 12:28:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BC0B22166BA9
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 12:28:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72AC0800B23
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 12:28:25 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-241-oiuiFMHHNLeHs9hDcs9Ttg-1; Thu, 11 Mar 2021 07:28:23 -0500
X-MC-Unique: oiuiFMHHNLeHs9hDcs9Ttg-1
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id
	20210311121853epoutp028db997c5952ea0711071a1d02d3c29b8~rSPrBQlBy0951909519epoutp02y
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 12:18:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
	20210311121853epoutp028db997c5952ea0711071a1d02d3c29b8~rSPrBQlBy0951909519epoutp02y
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTP id
	20210311121852epcas1p2e50b6cd6197d7b42373e2f7a0e520ffe~rSPqPCpG41756917569epcas1p2u;
	Thu, 11 Mar 2021 12:18:52 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.166]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Dx7K72r1Kz4x9Pr;
	Thu, 11 Mar 2021 12:18:51 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
	epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
	97.6C.11962.BAA0A406; Thu, 11 Mar 2021 21:18:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
	20210311121850epcas1p493c255a586998916febfebaf994bc5dc~rSPouh7J00656806568epcas1p4x;
	Thu, 11 Mar 2021 12:18:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20210311121850epsmtrp25df50b0b79efbfc1e0abb395f714d4c6~rSPot6Rii0643206432epsmtrp2B;
	Thu, 11 Mar 2021 12:18:50 +0000 (GMT)
X-AuditID: b6c32a39-5cbff70000002eba-65-604a0aabcf0c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	CD.92.08745.AAA0A406; Thu, 11 Mar 2021 21:18:50 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.104]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20210311121850epsmtip1ef553eca1c36349522744ef72fab2681~rSPofhWCp2872828728epsmtip1G;
	Thu, 11 Mar 2021 12:18:50 +0000 (GMT)
From: JeongHyeon Lee <jhs2.lee@samsung.com>
To: snitzer@redhat.com
Date: Thu, 11 Mar 2021 21:10:51 +0900
Message-Id: <1615464651-23675-2-git-send-email-jhs2.lee@samsung.com>
In-Reply-To: <1615464651-23675-1-git-send-email-jhs2.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsWy7bCmvu5qLq8Eg65eXov1p44xW+x9N5vV
	4tL9O6wWl3fNYbNo2/iV0YHV4/2+q2wefVtWMXp83iQXwByVY5ORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb2dTlF9akqqQ
	kV9cYquUWpCSU2BoUKBXnJhbXJqXrpecn2tlaGBgZApUmZCTseHNL7aCNsGKi3NnsjUw9vN1
	MXJySAiYSMxumcEIYgsJ7GCU+PVbrouRC8j+xCgx8fYPZgjnM6PEtiOnmboYOcA6Hm3Uhojv
	YpToXvKGBcL5wihx79ocZpBRbALaErdbNrGD2CICYhJH+h6wgtjMAnkSi1+0g9UIC1hJ7Gq5
	BVbDIqAqsXHeY7AFvAIuEq+ns0BcJydx81wnWDmngKvEq/vbwXZJCKxil5j5+g0bRJGLxJuj
	a5ggbGGJV8e3sEPYUhKf3+1lg2joZpS4f/41VMMERoneHqhv7CXeX7IAMZkFNCXW79KHqFCU
	2Pl7LiPEyXwS7772sEJU80p0tAlBlChJrPh3DepMCYkNh7uhhntIrPp/jhESJDMYJZr3rmGa
	wCg3C2HDAkbGVYxiqQXFuempxYYFpsjxtYkRnKK0LHcwTn/7Qe8QIxMH4yFGCQ5mJRFev+Nu
	CUK8KYmVValF+fFFpTmpxYcYTYFhN5FZSjQ5H5gk80riDU2NjI2NLUzMzM1MjZXEeZMMHsQL
	CaQnlqRmp6YWpBbB9DFxcEo1MPknydy5ymOjmXs60OJtgPCS/cWZpRcvCqRy+j+VrZ58MOXv
	xdRNJ1Zli+/e1rru3TbVvd2lC0L3y/F85Ve6y7/0EntcuJZS59OgswI3/gnpJs5b43xm0oYT
	OlvWmD9tnnFw/cG3TiuPhNzdNuNP7702t+kaSU4XfzeG24YdFw6/IylXfDSFmaGH+4urVkfg
	r40JmiG2jupCspd/vXZ8qt9jOWlilaWsWspChSmTAsvqOBxFJtqtO/UgauIUO8sShqjtu2Y+
	Vnvf92a78fFdd0U65TSfLWJ/Mvs8++277RcdlmTJLbF9mbJo3ctHfGuUUhboeDxQ5/FVWm0S
	enJz79Tc48qbmr+cKZ/RvlN6mqUSS3FGoqEWc1FxIgDVvm5r2gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJTncVl1eCwdv1ChbrTx1jttj7bjar
	xaX7d1gtLu+aw2bRtvErowOrx/t9V9k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2PDm19s
	BW2CFRfnzmRrYOzn62Lk4JAQMJF4tFG7i5GLQ0hgB6PE301/GbsYOYHiEhIbNq1lh6gRljh8
	uBii5hOjxI7Tz1lBatgEtCVut2xiB7FFBMQkjvQ9AIszCxRJPN+3gA3EFhawktjVcgushkVA
	VWLjvMdMIDN5BVwkXk9ngVglJ3HzXCcziM0p4Crx6v52sLgQUEnDxpOMExj5FjAyrGKUTC0o
	zk3PLTYsMMpLLdcrTswtLs1L10vOz93ECA4kLa0djHtWfdA7xMjEwXiIUYKDWUmE1++4W4IQ
	b0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTGrK50Nabb9v
	WLbVtn/RtIATHDf7D3+f5CQcWv1Y7/iijWxqTBsqt62pcF6+v/fOV/G3Fsbrwj5Il2cqdO9I
	NXtw5FPtobAlztsP3vC7cFD8lruI+T/1fc8DGxbInIi99fZQYu3Eze1yqok6j11fNbMUFvJ7
	dJV/6LlyIXjz0RcXi3I9TN9c8/i54vQCnZ/i0pX79F7mBE7odQpYr+a3Vu76fT0rzpCWaUd0
	VT1+L3A9o97DbJa0x3tRuxCb3PwYjtP7zE87uFXt2c3wxifrpFvq0rmyF/Vy/TxXVr9yfX14
	8r0fqcw7dd6/EjjaeOAUm9qyDVG8Db6RnDXXfzc0H0l1OOSTMod/XfujA1ynOZRYijMSDbWY
	i4oTAT/hWhSTAgAA
X-CMS-MailID: 20210311121850epcas1p493c255a586998916febfebaf994bc5dc
X-Msg-Generator: CA
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210311121850epcas1p493c255a586998916febfebaf994bc5dc
References: <1615464651-23675-1-git-send-email-jhs2.lee@samsung.com>
	<CGME20210311121850epcas1p493c255a586998916febfebaf994bc5dc@epcas1p4.samsung.com>
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
Subject: [dm-devel] [PATCH 2/2] dm verity: allow only one verify mode
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If there are multiple verity mode when parsing the verity mode of dm
verity table, it will be set as the last one.
So set to 'allow only once' to prevent it.

Signed-off-by: JeongHyeon Lee <jhs2.lee@samsung.com>
---
 drivers/md/dm-verity-target.c | 38 ++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 808a98ef624c..b76431dc7721 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -893,6 +893,28 @@ static int verity_alloc_zero_digest(struct dm_verity *v)
 	return r;
 }
 
+static inline bool verity_is_verity_mode(const char *arg_name)
+{
+	return (!strcasecmp(arg_name, DM_VERITY_OPT_LOGGING) ||
+		!strcasecmp(arg_name, DM_VERITY_OPT_RESTART) ||
+		!strcasecmp(arg_name, DM_VERITY_OPT_PANIC));
+}
+
+static int verity_parse_verity_mode(struct dm_verity *v, const char *arg_name)
+{
+	if (v->mode)
+		return -EINVAL;
+
+	if (!strcasecmp(arg_name, DM_VERITY_OPT_LOGGING))
+		v->mode = DM_VERITY_MODE_LOGGING;
+	else if (!strcasecmp(arg_name, DM_VERITY_OPT_RESTART))
+		v->mode = DM_VERITY_MODE_RESTART;
+	else if (!strcasecmp(arg_name, DM_VERITY_OPT_PANIC))
+		v->mode = DM_VERITY_MODE_PANIC;
+
+	return 0;
+}
+
 static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 				 struct dm_verity_sig_opts *verify_args)
 {
@@ -916,16 +938,12 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 		arg_name = dm_shift_arg(as);
 		argc--;
 
-		if (!strcasecmp(arg_name, DM_VERITY_OPT_LOGGING)) {
-			v->mode = DM_VERITY_MODE_LOGGING;
-			continue;
-
-		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_RESTART)) {
-			v->mode = DM_VERITY_MODE_RESTART;
-			continue;
-
-		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_PANIC)) {
-			v->mode = DM_VERITY_MODE_PANIC;
+		if (verity_is_verity_mode(arg_name)) {
+			r = verity_parse_verity_mode(v, arg_name);
+			if (r) {
+				ti->error = "Already verity mode set";
+				return r;
+			}
 			continue;
 
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_IGN_ZEROES)) {
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

