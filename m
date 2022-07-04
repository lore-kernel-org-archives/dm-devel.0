Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D677CCA479
	for <dm-devel@archiver.kernel.org>; Thu,  7 Jul 2022 07:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657178895;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oCZ5DjtGy85n+NjtrTIJdXD0yavXA6A9+DXYnKm3aac=;
	b=Ss4mrlpY7RwB9xnr8PMr8PSpoC5uDsePkrl5GqT7PfvPKtHBJsgFvlJS2P5i/83pGH79yS
	++6/2bEegPIo3IWJ9PmYyagA6MrGYwzTChkao7J5pTM6StJRqv2f4sNSbtoEhjTCvrj72a
	mGWrMEdc3JDfcArGKAmnkzZphW4nwog=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-456-9w82U3fUMuW9HEmtW8-ytQ-1; Thu, 07 Jul 2022 03:28:06 -0400
X-MC-Unique: 9w82U3fUMuW9HEmtW8-ytQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EFB083395C;
	Thu,  7 Jul 2022 07:28:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0ECFF492C3B;
	Thu,  7 Jul 2022 07:28:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D3B121947068;
	Thu,  7 Jul 2022 07:28:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A58A91947041
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 04:28:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9497340218D3; Mon,  4 Jul 2022 04:28:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 907E540474E4
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 04:28:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78C6C811E75
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 04:28:35 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-4ZA2aJfMNx-YSVpnD0XNAg-1; Mon, 04 Jul 2022 00:28:32 -0400
X-MC-Unique: 4ZA2aJfMNx-YSVpnD0XNAg-1
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2643jFjU012677;
 Mon, 4 Jul 2022 04:28:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3rk1gn7s-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 04 Jul 2022 04:28:30 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
 by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2644PL7f024924;
 Mon, 4 Jul 2022 04:28:30 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
 [169.51.49.99])
 by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h3rk1gn7d-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 04 Jul 2022 04:28:30 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
 by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2644LRBF003174;
 Mon, 4 Jul 2022 04:28:27 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com
 (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
 by ppma04ams.nl.ibm.com with ESMTP id 3h2dn924a8-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 04 Jul 2022 04:28:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com
 [9.149.105.232])
 by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 2644SOPL10092988
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Mon, 4 Jul 2022 04:28:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
 by IMSVA (Postfix) with ESMTP id 897875204F;
 Mon,  4 Jul 2022 04:28:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
 by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 7680C5204E;
 Mon,  4 Jul 2022 04:28:24 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55398)
 id 30422E022D; Mon,  4 Jul 2022 06:28:24 +0200 (CEST)
Date: Mon, 4 Jul 2022 06:28:24 +0200
From: Vineeth Vijayan <vneethv@linux.ibm.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <YsJsaLy5PDzMOvTo@tuxmaker.boeblingen.de.ibm.com>
References: <cover.1656785856.git.christophe.jaillet@wanadoo.fr>
 <3f2ad7fb91948525f6c52e0d36ec223cd3049c88.1656785856.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
In-Reply-To: <3f2ad7fb91948525f6c52e0d36ec223cd3049c88.1656785856.git.christophe.jaillet@wanadoo.fr>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eAg0oUXfuRnB6456bOXSml23Gr8U_wzs
X-Proofpoint-GUID: LeEqLeG_QOOFRNZ0bgbmbLGKSW2hjxra
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-04_03,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=774 suspectscore=0 malwarescore=0
 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501 clxscore=1011
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207040016
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Thu, 07 Jul 2022 07:28:03 +0000
Subject: Re: [dm-devel] [PATCH 1/4] s390/cio: Rename bitmap_size() as
 idset_bitmap_size()
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
Cc: linux-s390@vger.kernel.org, kernel-janitors@vger.kernel.org,
 ntfs3@lists.linux.dev, yury.norov@gmail.com, gor@linux.ibm.com,
 linux@rasmusvillemoes.dk, hca@linux.ibm.com, snitzer@kernel.org,
 oberpar@linux.ibm.com, linux-kernel@vger.kernel.org,
 almaz.alexandrovich@paragon-software.com, dm-devel@redhat.com,
 svens@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, Jul 02, 2022 at 08:29:09PM +0200, Christophe JAILLET wrote:
> In order to introduce a bitmap_size() function in the bitmap API, we have
> to rename functions with a similar name.
> 
> Add a "idset_" prefix and change bitmap_size() into idset_bitmap_size().
> 
> No functional change.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/s390/cio/idset.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/cio/idset.c b/drivers/s390/cio/idset.c
> index 45f9c0736be4..e1e77fe080bf 100644
> --- a/drivers/s390/cio/idset.c
> +++ b/drivers/s390/cio/idset.c
> @@ -16,7 +16,7 @@ struct idset {
>  	unsigned long bitmap[];
>  };
>  
> -static inline unsigned long bitmap_size(int num_ssid, int num_id)
> +static inline unsigned long idset_bitmap_size(int num_ssid, int num_id)
>  {
>  	return BITS_TO_LONGS(num_ssid * num_id) * sizeof(unsigned long);
>  }
> @@ -25,11 +25,11 @@ static struct idset *idset_new(int num_ssid, int num_id)
>  {
>  	struct idset *set;
>  
> -	set = vmalloc(sizeof(struct idset) + bitmap_size(num_ssid, num_id));
> +	set = vmalloc(sizeof(struct idset) + idset_bitmap_size(num_ssid, num_id));
>  	if (set) {
>  		set->num_ssid = num_ssid;
>  		set->num_id = num_id;
> -		memset(set->bitmap, 0, bitmap_size(num_ssid, num_id));
> +		memset(set->bitmap, 0, idset_bitmap_size(num_ssid, num_id));
>  	}
>  	return set;
>  }

Thank you CJ for this patchset.
As pointed out by others, it would be great to directly use tthe
bitmap-APIs instead of having an intermediate patch, which renames the
functions. As you mentioned, it is minimal, but the otherway would be
better for maintainability.

> @@ -41,7 +41,7 @@ void idset_free(struct idset *set)
>  
>  void idset_fill(struct idset *set)
>  {
> -	memset(set->bitmap, 0xff, bitmap_size(set->num_ssid, set->num_id));
> +	memset(set->bitmap, 0xff, idset_bitmap_size(set->num_ssid, set->num_id));
>  }
>  
>  static inline void idset_add(struct idset *set, int ssid, int id)
> -- 
> 2.34.1
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

