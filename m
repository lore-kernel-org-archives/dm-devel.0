Return-Path: <SRS0=zaPp=GX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A36DC433E0
	for <dm-devel@archiver.kernel.org>; Wed, 20 Jan 2021 14:13:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 011AD23340
	for <dm-devel@archiver.kernel.org>; Wed, 20 Jan 2021 14:13:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 011AD23340
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-H13uxgIAMEex2mfyEBj8fA-1; Wed, 20 Jan 2021 09:13:02 -0500
X-MC-Unique: H13uxgIAMEex2mfyEBj8fA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8D64100A644;
	Wed, 20 Jan 2021 14:12:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 10C672CFAF;
	Wed, 20 Jan 2021 14:12:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 270731809CA6;
	Wed, 20 Jan 2021 14:12:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10KE7IXC017040 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 20 Jan 2021 09:07:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 082CD2166B31; Wed, 20 Jan 2021 14:07:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 01B4C2166B2F
	for <dm-devel@redhat.com>; Wed, 20 Jan 2021 14:07:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE792811E99
	for <dm-devel@redhat.com>; Wed, 20 Jan 2021 14:07:15 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-422-BQDdT5jUPNiIlL5J8xrj5w-1;
	Wed, 20 Jan 2021 09:07:13 -0500
X-MC-Unique: BQDdT5jUPNiIlL5J8xrj5w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 1C0F5B699;
	Wed, 20 Jan 2021 14:07:12 +0000 (UTC)
Message-ID: <f1961d4104b14c80183b161a53262e1766e0df70.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Date: Wed, 20 Jan 2021 15:07:11 +0100
In-Reply-To: <d8ba8118-ce98-249a-cafd-021f0c1831a5@huawei.com>
References: <063bbeeb-15aa-f7c0-b881-7526c3a2720c@huawei.com>
	<f86753b17cc7e85e7e0f7e711adec349323a7c5a.camel@suse.com>
	<d8ba8118-ce98-249a-cafd-021f0c1831a5@huawei.com>
User-Agent: Evolution 3.38.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10KE7IXC017040
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>, lihaotian9@huawei.com
Subject: Re: [dm-devel] [QUESTION]: multipath device with wrong path lead to
 metadata err
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-01-20 at 10:30 +0800, lixiaokeng wrote:
> Hi Martin:
> =A0=A0=A0 Thanks for your reply.
>=20
>=20
> > verify_paths() would detect this. We do call verify_paths() in
> > coalesce_paths() before calling domap(), but not immediately
> > before.
> > Perhaps we should move the verify_paths() call down to immediately
> > before the domap() call.=A0That would at least minimize the time
> > window
> > for this race. It's hard to avoid it entirely. The way multipathd
> > is
> > written, the vecs lock is held all the time during
> > coalesce_paths(),=20
> > and thus no uevents can be processed. We could also consider
> > calling
> > verify_paths() before *and* after domap().
>=20
> Can calling verify_paths() before *and* after domap() deal this
> entirely?

Probably yes. If you look at update_map(), we do it there until domap()
succeeds. Could you try adding a verify_paths() call after domap() in
the failure case, before removing the map? I wouldn't go for a retry
loop like in update_map() at this point.

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

