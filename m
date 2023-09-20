Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A29CE79AD
	for <dm-devel@archiver.kernel.org>; Wed, 20 Sep 2023 09:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695202062;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OcurBfyVg5gaI74uqAEVSac3zL3ULIn8LAxd1WiQEVI=;
	b=WsuAmwdgKQos9g+50G/dJu0XK99AVMiiSehqlhk20K2RSnRMb5Lw2Ofse2/G0wwGhaQS9L
	NSLJvOxpPHQb8nLrfOws+Lq1z4VTDQIa0qJxjzZDJa8H0pbmA3MzkbsuKfXlIjuZBzP0rt
	ODSlW1v3domS7IAWX4zyuF1uH4O1eho=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-687-YvPrKUEeMYC3tqJzFI47cA-1; Wed, 20 Sep 2023 05:27:39 -0400
X-MC-Unique: YvPrKUEeMYC3tqJzFI47cA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 043F33C1ACE3;
	Wed, 20 Sep 2023 09:27:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3D29814027BA;
	Wed, 20 Sep 2023 09:27:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E9856194658F;
	Wed, 20 Sep 2023 09:27:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0596F194658D
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Sep 2023 08:58:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DAACA2156701; Wed, 20 Sep 2023 08:58:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D2B562156A27
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:32 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2907101A53B
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:32 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-XTF47sbZPp-GF-WV-D4D5w-1; Wed, 20 Sep 2023 04:58:30 -0400
X-MC-Unique: XTF47sbZPp-GF-WV-D4D5w-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230920085827epoutp01cf7866c7fde1f68fc6d6dbae010fe4ac~Gj7Ku1TAP2981529815epoutp01H
 for <dm-devel@redhat.com>; Wed, 20 Sep 2023 08:58:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230920085827epoutp01cf7866c7fde1f68fc6d6dbae010fe4ac~Gj7Ku1TAP2981529815epoutp01H
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230920085826epcas5p2b0dc5c55c1e5a53f96a84d0cc4b708cb~Gj7KQdNb62273322733epcas5p2u;
 Wed, 20 Sep 2023 08:58:26 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4RrC9s0lJDz4x9Pv; Wed, 20 Sep
 2023 08:58:25 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
 9D.D1.19094.034BA056; Wed, 20 Sep 2023 17:58:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20230920081508epcas5p4cf474394711300770d572af7d2fb621d~GjVW0BAaf3178931789epcas5p4f;
 Wed, 20 Sep 2023 08:15:08 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230920081508epsmtrp12a183029ecd76fe9e5abb1613c009e80~GjVWuJnay2250022500epsmtrp1Q;
 Wed, 20 Sep 2023 08:15:08 +0000 (GMT)
X-AuditID: b6c32a50-64fff70000004a96-a0-650ab4305868
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 9C.FE.08742.C0AAA056; Wed, 20 Sep 2023 17:15:08 +0900 (KST)
Received: from green245.sa.corp.samsungelectronics.net (unknown
 [107.99.41.245]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20230920081505epsmtip1e9d81a65c92149340cdf3edfdf69aed3~GjVTepM8F3236832368epsmtip1e;
 Wed, 20 Sep 2023 08:15:05 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair
 Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
Date: Wed, 20 Sep 2023 13:37:42 +0530
Message-Id: <20230920080756.11919-6-nj.shetty@samsung.com>
In-Reply-To: <20230920080756.11919-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1BUVRzHO/de7i7U0gVpPGDJtgUMb9YWPCBEJeSdZILGZrBmEFe4AbLc
 3XaXgBpHkFeuI4tkD1dbCNd4yfsxqzwiNIElBhsGEAwtZ5cIDBQHreEVy4Xyv8/5/X7f8/v+
 fmcOH3cs4bnwU1g1o2SlMhFpR7Rd8/T0FbfYMQEr3QDVm27g6OHiEoFOFK/gqGZSS6LZawsA
 mbsLAeqcO2+DxruvYKijvARDVTU/YaikZxQgy4gOQ50T3ui7AgOBOjr7CTR89QKJSr+38NCp
 MSOJKnpXMXSr2AKQ0ZwDUNtSKY7qZucJ1DexAw2t9Nq84Uxf0U3y6KE7jQQ9PJhON1WfJOlm
 w3G6fTybpC8WfWFDn86dI+mHlgmCnu8aIemilmpANw98Rj9q2kk3mf/CYuw/TA1NZqSJjFLI
 sAnyxBQ2KUy0/0D83vjAoACxrzgY7RYJWWkaEyaKiIrxfTtFtr4IkfATqSx9PRQjValE/q+H
 KuXpakaYLFepw0SMIlGmkCj8VNI0VTqb5Mcy6hBxQMCuwPXCw6nJazlTNoo5Qebcjd952eDm
 sxpgy4eUBN5eHcE0wI7vSHUA2HbyMWZNOFILAPZpnbnEYwCzp5uJLcU3SyYbLtEJ4ANNDskp
 8jH4dzVfA/h8kvKGA2t8a40TlY3DhvaLwHrAKT0Op9bKgFWwjXofDtzV2liZoNzg8MmbGyyg
 QmD/rTzSehGk/KH2roM1bEvtgY8MYzyuxAH2nzNvGMIpV5jbeh7nzNXbQl15CscR0Fg3Azje
 Bmd6W3gcu8A/tQWbnAGrzlaSVm+QygNQN6bbFITDfJMWt3rAKU9Yf9WfC78EvzTVYVxfe3h6
 yYxxcQE06rf4FXi5vozk2BmOPsnZZBo+KDcR3OKKAOwp7COKgVD31Dy6p+bR/d+6DODVwIVR
 qNKSmIRAhdiXZTL+e+UEeVoT2PgcXjFGUNOw4tcDMD7oAZCPi5wEae52jKMgUZr1KaOUxyvT
 ZYyqBwSuL/wM7vJCgnz9d7HqeLEkOEASFBQkCX4tSCzaLpjN/zbRkUqSqplUhlEwyi0dxrd1
 ycZ8CgXbL987kn/E4PGb29GyvtjSuUHJfh+dPRm+WLD8ZuaZX30y34oenWLF4d6iobWvE9VO
 ml6J4pf2KnPl8/pp38Mau4qjGvaOxftQbeTiTF6uW7PGOK2asL0/uye21q373Yq1puW9X01m
 DF7qOtGxfM5BwVtdfO62nn2R9RAecB4VRv+htMzufJIlcT1LGYzP/HhQv5B1sMt93LNOFBxZ
 a4i0j3KKOmTq2J1mapeFlO+Ihj9Mvbpwf/SfKB5fLx55Jy608eX39ItszbGEIrdL+hLl8YXr
 RO2u7irtfGNr3rDXiEwe94E9ecz1858jQuovXL9n8PjIrzTu40r3hn37RmNbRYQqWSr2wpUq
 6b9DTlutpQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHe885OzvOVmdT6tXEaFGhS82QeK0QI4tDCdW6Et1GHix0a2yt
 vAReJpYr81KWunBdRN2sxEu6pXaZ5Vx2EdYqJ3ahuYJqZWKS5qwlQd9+z//3f54vD4ULbUQw
 dVh+lFXKpakikke0dolCI2Yaeeyy6pplqOFRN46GRycIlFs8iaP6wSISfer6DpDr3kmAOj06
 Duq/Z8ZQx9VSDBnqH2Ko1PICoCFHJYY6nWJ0Jb+aQB2dNgLZb18ikb5miItOvzSRqNbqxdCr
 4iGATK4cgFon9Di6+ekrgXqc89CzSSsnPogxVw5ymWevGwnG/kTNNBkLSKa5Ootp788mmWtn
 z3GYQo2HZIaHnATz9Y6DZM62GAHT3JvJjDSFMk2uL9jmWbt5q5PY1MPHWGVU3AHeoakcN0fh
 4ad5ut9xs0Gfvxb4UZCOgeUTjzhawKOEdDuA4+fzwbQIgjWTD/BpDoAG7wfudEmDwev3dZgW
 UBRJi2HvFOXLA2ktDgvMHsI34PR1HD53VJC+7QBaAm1V/X8vEfQiaC/o4/iYT6+Etld5pO8Q
 pKNg0RuBL/ajV8GR6pdcHwv/VHr79NzpugDaKlyEj3F6PtTc0uHFgK78T1X+py4DzAiCWIVK
 lixTRSui5ezxSJVUplLLkyMPHpE1gb/fDg8zgTbjt0gLwChgAZDCRYF82WIeK+QnSdMzWOWR
 /Up1KquygHkUIZrLn/uxMElIJ0uPsiksq2CV/yxG+QVnY2Z9XFv5+5ZNzjH5xtwkt3edofSH
 WNPtSLS4vBLr7Yy37SWazlG1NtglTzHkloXGxOvSut3hwyFidcTOPQUJ/I4QLPbzeIk4f+Bc
 0EF3BDF7oDaBOL18fU9LbciCMwlXSgIVBh32q9Fr1dsv5G3qWvPLWWG92IrfaEOX59/F6t9J
 6p+atl/a0VF6IOZBWNTY07bwvC7CVNeQIfiorWvYcvJEIjnecmppoacu4X2hZGHY3bGfZfln
 NlydrH1cFbM1K2XFnG27GsvX+ic3CkoWSAfcsx6usBfZm8+fiD+WSMfu/hBXNUOaI4BrpzLF
 +3jmdIlXX5bpkAcM9MS9WCLfKyJUh6TR4bhSJf0NJJLZrFwDAAA=
X-CMS-MailID: 20230920081508epcas5p4cf474394711300770d572af7d2fb621d
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230920081508epcas5p4cf474394711300770d572af7d2fb621d
References: <20230920080756.11919-1-nj.shetty@samsung.com>
 <CGME20230920081508epcas5p4cf474394711300770d572af7d2fb621d@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH v16 05/12] fs/read_write: Enable copy_file_range
 for block device.
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
Cc: anuj1072538@gmail.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, gost.dev@samsung.com,
 nitheshshetty@gmail.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Nitesh Shetty <nj.shetty@samsung.com>,
 linux-block@vger.kernel.org, mcgrof@kernel.org, linux-fsdevel@vger.kernel.org,
 Anuj Gupta <anuj20.g@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Anuj Gupta <anuj20.g@samsung.com>

This is a prep patch. Allow copy_file_range to work for block devices.
Relaxing generic_copy_file_checks allows us to reuse the existing infra,
instead of adding a new user interface for block copy offload.
Change generic_copy_file_checks to use ->f_mapping->host for both inode_in
and inode_out. Allow block device in generic_file_rw_checks.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 fs/read_write.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 4771701c896b..f0f52bf48f57 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1405,8 +1405,8 @@ static int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
 				    struct file *file_out, loff_t pos_out,
 				    size_t *req_count, unsigned int flags)
 {
-	struct inode *inode_in = file_inode(file_in);
-	struct inode *inode_out = file_inode(file_out);
+	struct inode *inode_in = file_in->f_mapping->host;
+	struct inode *inode_out = file_out->f_mapping->host;
 	uint64_t count = *req_count;
 	loff_t size_in;
 	int ret;
@@ -1708,7 +1708,9 @@ int generic_file_rw_checks(struct file *file_in, struct file *file_out)
 	/* Don't copy dirs, pipes, sockets... */
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
-	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
+	if (!S_ISREG(inode_in->i_mode) && !S_ISBLK(inode_in->i_mode))
+		return -EINVAL;
+	if ((inode_in->i_mode & S_IFMT) != (inode_out->i_mode & S_IFMT))
 		return -EINVAL;
 
 	if (!(file_in->f_mode & FMODE_READ) ||
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

