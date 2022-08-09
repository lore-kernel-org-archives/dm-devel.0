Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC54C19F2D
	for <dm-devel@archiver.kernel.org>; Wed, 10 Aug 2022 03:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660102568;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4+7Eel1/RWEtSgQ0BDuh7dj1ZlIar6t5Ey0/k39e+i8=;
	b=Fq6We+XDiAKE2u+NuHcnWNepu8SIrIdk//0dUJqEv685NpMXtOAppD9ngbDXUiEqucs9jX
	qEGKLVUwrUHG71M0kduUvwr3YTCH15YiguNVNG+bFCmE7jpnn57RMhhN4Coj1EfK0hsHEh
	EEXdt0vizV47w2EC7Uj11TYNBp2mg7w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-NqQC5wUpMFGMXNEcowR0Fg-1; Tue, 09 Aug 2022 23:36:07 -0400
X-MC-Unique: NqQC5wUpMFGMXNEcowR0Fg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A22A1823F0F;
	Wed, 10 Aug 2022 03:36:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 917261121314;
	Wed, 10 Aug 2022 03:36:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7D39F1946A50;
	Wed, 10 Aug 2022 03:36:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 938891946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 14:59:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 78872400F36; Tue,  9 Aug 2022 14:59:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 74AF7403341
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 14:59:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DF428117B0
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 14:59:26 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-60apgCouOWKbLAcY3USdRw-1; Tue, 09 Aug 2022 10:59:25 -0400
X-MC-Unique: 60apgCouOWKbLAcY3USdRw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D84DAB8118F;
 Tue,  9 Aug 2022 14:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFA3C433D6;
 Tue,  9 Aug 2022 14:51:13 +0000 (UTC)
Date: Tue, 9 Aug 2022 08:51:10 -0600
From: Keith Busch <kbusch@kernel.org>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <YvJ0Xh61npH+M9HP@kbusch-mbp.dhcp.thefacebook.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-10-michael.christie@oracle.com>
 <12b99b10-8353-0f72-f314-c453a4fc5b6a@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <12b99b10-8353-0f72-f314-c453a4fc5b6a@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Wed, 10 Aug 2022 03:36:02 +0000
Subject: Re: [dm-devel] [PATCH v2 09/20] nvme: Add helper to execute
 Reservation Report
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
 "james.bottomley@hansenpartnership.com"
 <james.bottomley@hansenpartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "hch@lst.de" <hch@lst.de>, Mike Christie <michael.christie@oracle.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Aug 09, 2022 at 10:56:55AM +0000, Chaitanya Kulkarni wrote:
> On 8/8/22 17:04, Mike Christie wrote:
> > +
> > +	c.common.opcode = nvme_cmd_resv_report;
> > +	c.common.cdw10 = cpu_to_le32(nvme_bytes_to_numd(data_len));
> > +	c.common.cdw11 = 1;
> > +	*eds = true;
> > +
> > +retry:
> > +	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
> > +	    bdev->bd_disk->fops == &nvme_ns_head_ops)
> > +		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
> > +	else
> > +		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
> > +					      data, data_len);
> > +	if (ret == NVME_SC_HOST_ID_INCONSIST && c.common.cdw11) {
> > +		c.common.cdw11 = 0;
> > +		*eds = false;
> > +		goto retry;
> 
> Unconditional retries without any limit can create problems,
> perhaps consider adding some soft limits.

It's already conditioned on cdw11, which is cleared to 0 on the 2nd try. Not
that that's particularly clear. I'd suggest naming an enum value for it so the
code tells us what the signficance of cdw11 is in this context (it's the
Extended Data Structure control flag).

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

