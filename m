Return-Path: <SRS0=SQPv=L2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E9BC07E95
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:48:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 64F6261413
	for <dm-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:48:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64F6261413
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-d7GvHt_EM1K1GxHTrErGZg-1; Fri, 02 Jul 2021 16:48:23 -0400
X-MC-Unique: d7GvHt_EM1K1GxHTrErGZg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 315A4800C60;
	Fri,  2 Jul 2021 20:48:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1B9160657;
	Fri,  2 Jul 2021 20:48:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 663C84EA2A;
	Fri,  2 Jul 2021 20:48:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 162KmF5E003727 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 2 Jul 2021 16:48:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5DEEC113B75; Fri,  2 Jul 2021 20:48:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 546B711E1C4
	for <dm-devel@redhat.com>; Fri,  2 Jul 2021 20:48:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08E84185A7A4
	for <dm-devel@redhat.com>; Fri,  2 Jul 2021 20:48:11 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-380-AQ43oYIfNsSlzHYl8zMRoQ-1; Fri, 02 Jul 2021 16:48:06 -0400
X-MC-Unique: AQ43oYIfNsSlzHYl8zMRoQ-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 33769223CE;
	Fri,  2 Jul 2021 20:48:05 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id E731411C84;
	Fri,  2 Jul 2021 20:48:04 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id yz84NoR732AGBAAALh3uQQ
	(envelope-from <mwilck@suse.com>); Fri, 02 Jul 2021 20:48:04 +0000
Message-ID: <ac8e981f3bd73588d6fb72b21990f5e0fb09c3c5.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Fri, 02 Jul 2021 22:48:04 +0200
In-Reply-To: <20210404221258.18767-1-xose.vazquez@gmail.com>
References: <20210404221258.18767-1-xose.vazquez@gmail.com>
User-Agent: Evolution 3.40.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Zou Ming <zouming.zouming@huawei.com>,
	Zhouweigang <zhouweigang09@huawei.com>, DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: make HUAWEI/XSG1 config
 work with alua and multibus
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mo, 2021-04-05 at 00:12 +0200, Xose Vazquez Perez wrote:
> And add recommended no_path_retry and pgfailback values.
> 
> Info from:
> - RHEL
> https://download.huawei.com/edownload/e/download.do?actionFlag=download&nid=EDOC1100113070&partNo=6001&mid=SUPE_DOC&_t=1612885511000
> - SLES
> https://download.huawei.com/edownload/e/download.do?actionFlag=download&nid=EDOC1100117892&partNo=6001&mid=SUPE_DOC&_t=1612885538000
> 
> - without HyperMetro:
> vendor "HUAWEI"
> product "XSG1"
> path_grouping_policy multibus
> no_path_retry 15
> 
> - with HyperMetro:
> vendor "HUAWEI"
> product "XSG1"
> path_grouping_policy group_by_prio
> prio alua
> failback immediate
> no_path_retry 15
> 
> ALUA is only used with HyperMetro(cluster of two arrays).
> 
> Suggested-by: Martin Wilck <mwilck@suse.com>
> Cc: Zhouweigang (Jack) <zhouweigang09@huawei.com>
> Cc: Zou Ming <zouming.zouming@huawei.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

Sorry for the long delay.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

