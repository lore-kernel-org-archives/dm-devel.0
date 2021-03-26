Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E49C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 17:26:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3839D6197C
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 17:26:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3839D6197C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-qeSZyypSP8iUDd3WvROr1w-1; Fri, 26 Mar 2021 13:26:02 -0400
X-MC-Unique: qeSZyypSP8iUDd3WvROr1w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCDE5180E470;
	Fri, 26 Mar 2021 17:25:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AEBE95D6DC;
	Fri, 26 Mar 2021 17:25:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 12CFC1809C83;
	Fri, 26 Mar 2021 17:25:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QHOmue008747 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 13:24:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B9697103404; Fri, 26 Mar 2021 17:24:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B254D1032BB
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 17:24:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67B6F8001A6
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 17:24:46 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-231-zu4VXSyDOOOcoFDtxMK6KA-1;
	Fri, 26 Mar 2021 13:24:42 -0400
X-MC-Unique: zu4VXSyDOOOcoFDtxMK6KA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 87A3AAF27;
	Fri, 26 Mar 2021 17:24:40 +0000 (UTC)
Message-ID: <c3ae65e46d13fcb4444a07fb3d57c7937a3c336e.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Fri, 26 Mar 2021 18:24:39 +0100
In-Reply-To: <20210326030839.15452-1-xose.vazquez@gmail.com>
References: <20210326030839.15452-1-xose.vazquez@gmail.com>
User-Agent: Evolution 3.38.4
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
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12QHOmue008747
X-loop: dm-devel@redhat.com
Cc: Zou Ming <zouming.zouming@huawei.com>,
	Zhouweigang <zhouweigang09@huawei.com>, DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: convert back HUAWEI/XSG1 to
	multibus
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2021-03-26 at 04:08 +0100, Xose Vazquez Perez wrote:
> This reverts commit ad206af1716437e84bbd81de6c4da7961d9a41d2
>=20
> Recommended configs are, info from:
> - RHEL=20
> https://download.huawei.com/edownload/e/download.do?actionFlag=3Ddownload=
&nid=3DEDOC1100113070&partNo=3D6001&mid=3DSUPE_DOC&_t=3D1612885511000
> - SLES=20
> https://download.huawei.com/edownload/e/download.do?actionFlag=3Ddownload=
&nid=3DEDOC1100117892&partNo=3D6001&mid=3DSUPE_DOC&_t=3D1612885538000
>=20
> - without HyperMetro:
> vendor "HUAWEI"
> product "XSG1"
> path_grouping_policy multibus
> no_path_retry 15
>=20
> - with HyperMetro:
> vendor "HUAWEI"
> product "XSG1"
> path_grouping_policy group_by_prio
> prio alua
> failback immediate
> no_path_retry 15
>=20
> ALUA is only used with HyperMetro(cluster of two arrays).
>=20
> Cc: Zhouweigang (Jack) <zhouweigang09@huawei.com>
> Cc: Zou Ming <zouming.zouming@huawei.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Forgive me if I'm missing something here, but what is this good for?
multipathd detects ALUA support by default.

 1 if the device doesn't support ALUA, it falls back to "const" anyway,
   in which case "group_by_prio" degenerates to "multibus" - which is
   exactly what this patch does;
 2 if the device supports ALUA, but returns the same ALUA state for
   all ports, again "group_by_prio" degenerates to "multibus";
 3 if the device supports ALUA and returns different states for=A0
   different ports, "group_by_prio" is the best bet anyway.

So why not just use "group_by_prio"?

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

