Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C35C43334
	for <dm-devel@archiver.kernel.org>; Mon, 20 Jun 2022 07:18:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-021Ik0TwNeCmZJHkFC473w-1; Mon, 20 Jun 2022 03:18:19 -0400
X-MC-Unique: 021Ik0TwNeCmZJHkFC473w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFFB03800C21;
	Mon, 20 Jun 2022 07:18:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B65C492C3B;
	Mon, 20 Jun 2022 07:18:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 32F98194706D;
	Mon, 20 Jun 2022 07:18:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 09CA01947069
 for <dm-devel@listman.corp.redhat.com>; Mon, 20 Jun 2022 07:18:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE0EA404E4DB; Mon, 20 Jun 2022 07:18:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B9F4140C1289
 for <dm-devel@redhat.com>; Mon, 20 Jun 2022 07:18:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A05E3800C27
 for <dm-devel@redhat.com>; Mon, 20 Jun 2022 07:18:15 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-cH3HYyyoNKO_qfihHXG8Fg-1; Mon, 20 Jun 2022 03:18:09 -0400
X-MC-Unique: cH3HYyyoNKO_qfihHXG8Fg-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id A406968AFE; Mon, 20 Jun 2022 09:18:04 +0200 (CEST)
Date: Mon, 20 Jun 2022 09:18:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Christie <michael.christie@oracle.com>
Message-ID: <20220620071804.GH11418@lst.de>
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-9-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220603065536.5641-9-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 08/11] scsi: target: Add block PR support to
 iblock.
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
Cc: axboe@kernel.dk, james.bottomley@hansenpartnership.com,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com, snitzer@kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org,
 hch@lst.de
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

> +static sense_reason_t iblock_execute_pr_in(struct se_cmd *cmd, u8 sa,
> +					   unsigned char *param_data)
> +{
> +	sense_reason_t ret;
> +
> +	switch (sa) {
> +	case PRI_REPORT_CAPABILITIES:
> +		iblock_pr_report_caps(param_data);
> +		break;
> +	case PRI_READ_KEYS:
> +		ret = iblock_pr_read_keys(cmd, param_data);
> +		break;
> +	case PRI_READ_RESERVATION:
> +		ret = iblock_pr_read_reservation(cmd, param_data);
> +		break;
> +	case PRI_READ_FULL_STATUS:
> +	default:
> +		pr_err("Unknown PERSISTENT_RESERVE_IN SA: 0x%02x\n", sa);
> +		return TCM_UNSUPPORTED_SCSI_OPCODE;
> +	}
> +
> +	return ret;


ret is uninitialize in the iblock_pr_report_caps case.

> +	switch (cdb[0]) {
> +	case RESERVE:
> +	case RESERVE_10:
> +	case RELEASE:
> +	case RELEASE_10:
> +		/*
> +		 * The block layer pr_ops don't support the old RESERVE/RELEASE
> +		 * commands.
> +		 */
> +		if (dev->dev_attrib.emulate_pr &&
> +		    (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
> +			return TCM_UNSUPPORTED_SCSI_OPCODE;
> +	}

Can't this check go straight int sbc_parse_cdb?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

