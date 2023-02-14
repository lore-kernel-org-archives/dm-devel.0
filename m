Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A612FC61DA4
	for <dm-devel@archiver.kernel.org>; Tue, 14 Feb 2023 19:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676401736;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tniq1DmpdhWHAwV8o773sb+LNCv65SHCk4k1HpzzAPY=;
	b=TE/rKQRsDCtH9n2f7VpAu7cpwV0wrVWl/shcUoFqaOCvsBgpd39eC31RlKdJgvsdPNxPuO
	Em3aDZoHjshDrrLUpL086F17438RyCqJ9k23KMACuL5o9pGC1fcZHubA6wgpxiVWMZX3an
	yvcPEGXKlIxjreJd9QHUINpt4QOtY98=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-Brb7RqIZNFSnmbqVJwjsDg-1; Tue, 14 Feb 2023 14:08:53 -0500
X-MC-Unique: Brb7RqIZNFSnmbqVJwjsDg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C9063C0F660;
	Tue, 14 Feb 2023 19:08:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A864B492B15;
	Tue, 14 Feb 2023 19:08:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7AA561946588;
	Tue, 14 Feb 2023 19:08:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2A11D1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Feb 2023 19:08:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BAD981121314; Tue, 14 Feb 2023 19:08:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B2D401121318
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 19:08:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 932AC87A9E1
 for <dm-devel@redhat.com>; Tue, 14 Feb 2023 19:08:43 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com
 [205.220.165.32]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-V1TwZxfSPE6HErIv_2JH8Q-1; Tue, 14 Feb 2023 14:08:42 -0500
X-MC-Unique: V1TwZxfSPE6HErIv_2JH8Q-1
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
 by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 31EGY9Pp005532; Tue, 14 Feb 2023 16:57:50 GMT
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
 by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xb5yx8-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 14 Feb 2023 16:57:49 +0000
Received: from pps.filterd
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5)
 with ESMTP id 31EGpwLS009585; Tue, 14 Feb 2023 16:57:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id
 3np1f5uukx-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Tue, 14 Feb 2023 16:57:48 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com
 (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31EGuHou039739;
 Tue, 14 Feb 2023 16:57:47 GMT
Received: from ca-mkp2.ca.oracle.com.com
 (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com
 [100.100.251.135])
 by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id
 3np1f5uuff-10; Tue, 14 Feb 2023 16:57:46 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Date: Tue, 14 Feb 2023 11:57:36 -0500
Message-Id: <167639371119.486235.3812806947516384921.b4-ty@oracle.com>
In-Reply-To: <20230129231053.20863-1-rdunlap@infradead.org>
References: <20230129231053.20863-1-rdunlap@infradead.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_11,2023-02-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302140144
X-Proofpoint-ORIG-GUID: qDgMHyaxiheYWVhdwVSVG77rlBQfOrXl
X-Proofpoint-GUID: qDgMHyaxiheYWVhdwVSVG77rlBQfOrXl
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] (subset) [PATCH 0/9] Documentation: correct lots of
 spelling errors (series 2)
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
Cc: nvdimm@lists.linux.dev, linux-doc@vger.kernel.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com, netdev@vger.kernel.org,
 Zefan Li <lizefan.x@bytedance.com>, sparclinux@vger.kernel.org,
 Neeraj Upadhyay <quic_neeraju@quicinc.com>, Alasdair Kergon <agk@redhat.com>,
 Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Guenter Roeck <linux@roeck-us.net>, linux-media@vger.kernel.org,
 Jean Delvare <jdelvare@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Mike Snitzer <snitzer@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, linux-raid@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
 cgroups@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>, linux-hwmon@vger.kernel.org,
 rcu@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-usb@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Vinod Koul <vkoul@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 dmaengine@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, 29 Jan 2023 15:10:44 -0800, Randy Dunlap wrote:

> Maintainers of specific kernel subsystems are only Cc-ed on their
> respective patches, not the entire series. [if all goes well]
> 
> These patches are based on linux-next-20230127.
> 
> 
>  [PATCH 1/9] Documentation: admin-guide: correct spelling
>  [PATCH 2/9] Documentation: driver-api: correct spelling
>  [PATCH 3/9] Documentation: hwmon: correct spelling
>  [PATCH 4/9] Documentation: networking: correct spelling
>  [PATCH 5/9] Documentation: RCU: correct spelling
>  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>  [PATCH 7/9] Documentation: scsi: correct spelling
>  [PATCH 8/9] Documentation: sparc: correct spelling
>  [PATCH 9/9] Documentation: userspace-api: correct spelling
> 
> [...]

Applied to 6.3/scsi-queue, thanks!

[6/9] Documentation: scsi/ChangeLog*: correct spelling
      https://git.kernel.org/mkp/scsi/c/685d5ef436a9
[7/9] Documentation: scsi: correct spelling
      https://git.kernel.org/mkp/scsi/c/cf065a7da517

-- 
Martin K. Petersen	Oracle Linux Engineering

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

