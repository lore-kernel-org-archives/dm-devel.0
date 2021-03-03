Return-Path: <SRS0=/efG=IB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF30C433E0
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 10:42:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0A51064EE1
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 10:42:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A51064EE1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-InlH_0JhO4-skgbswDmDIQ-1; Wed, 03 Mar 2021 05:42:42 -0500
X-MC-Unique: InlH_0JhO4-skgbswDmDIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 808E610082F5;
	Wed,  3 Mar 2021 10:42:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2710619716;
	Wed,  3 Mar 2021 10:42:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 68F5B58074;
	Wed,  3 Mar 2021 10:42:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 123AgYlp026428 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 3 Mar 2021 05:42:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 96820200E275; Wed,  3 Mar 2021 10:42:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 814552026D3A
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 10:42:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50C0C86EB33
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 10:42:30 +0000 (UTC)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com
	[45.249.212.191]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-390-CItWoNKgOpGeMcdckVl4MQ-1; Wed, 03 Mar 2021 05:42:25 -0500
X-MC-Unique: CItWoNKgOpGeMcdckVl4MQ-1
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Dr9W073GqzMhQk;
	Wed,  3 Mar 2021 18:40:12 +0800 (CST)
Received: from [10.174.178.113] (10.174.178.113) by
	DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server
	id 14.3.498.0; Wed, 3 Mar 2021 18:42:13 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20210128210852.23207-1-mwilck@suse.com>
	<c1dddccecfe0e12a2fe2dca66faad740a30acd53.camel@suse.com>
	<99488b1b-2339-338d-e951-0b8f3e78449b@huawei.com>
	<dcc6fb2a344ce75972242e2c78e2e485b58140da.camel@suse.com>
	<655de0b3-9625-bf3c-85f8-d19832bd84d8@huawei.com>
	<79f18cdb19b41be24d082d5528ab2325e6552395.camel@suse.com>
	<05c23ce9-4859-b0c3-3acb-c74f2c4510d6@huawei.com>
	<41e79d67f568baf8de6b28e4924620240f0a2731.camel@suse.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <58a88880-8977-7439-86d6-898d8a2b4bed@huawei.com>
Date: Wed, 3 Mar 2021 18:42:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <41e79d67f568baf8de6b28e4924620240f0a2731.camel@suse.com>
X-Originating-IP: [10.174.178.113]
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 123AgYlp026428
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] multipathd: avoid crash in uevent_cleanup()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable


>> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: directio
>> checker refcount 6
>> Mar 02 11:40:35 localhost.localdomain multipathd[85474]: lxk free tur
>> checker=A0 //checker_put
>=20
>=20
> So we do not see "unloading tur checker". Like you said, that suggests
> that the crash occurs between libcheck_free() and the thread exiting.



"lxk free tur checker" is add in free_checker called by checker_put.
I don't change the level of "unloading tur checker", so we don't see it.

@@ -58,7 +58,7 @@ void free_checker (struct checker * c)
                return;
        c->refcount--;
        if (c->refcount) {
-               condlog(3, "%s checker refcount %d",
+               condlog(2, "%s checker refcount %d",
                        c->name, c->refcount);
                return;
        }
@@ -77,6 +77,7 @@ void free_checker (struct checker * c)
                        pthread_join(ct->thread, NULL);
                };
        }
+       condlog(2, "lxk free %s checker", c->name);
        FREE(c);
 }


> I suggest you put a message in tur.c:libcheck_free (), AFTER the call
> to cleanup_context(), printing the values of "running" and "holders"
> Anyway:
>=20
> =09holders =3D uatomic_sub_return(&ct->holders, 1);
> =09if (!holders)
> =09=09cleanup_context(ct);
>=20
> Whatever mistakes we have made, only one actor can have seen=A0
> holders =3D=3D 0, and have called cleanup_context().
>=20

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index 4ea63af..900f960 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -105,8 +105,11 @@ void libcheck_free (struct checker * c)
                        pthread_cancel(ct->thread);
                ct->thread =3D 0;
                holders =3D uatomic_sub_return(&ct->holders, 1);
-               if (!holders)
+               if (!holders) {
+                       running =3D uatomic_xchg(&ct->running, 0);
                        cleanup_context(ct);
+                       condlog(2, "lxk tur running is %d", running);
+               }
                c->context =3D NULL;
        }
        return;


Here I add running print but it is zero.

> The stacks you have shown indicate that the instruction pointers were
> broken. That would suggest something similar as dicussed in the ML
> thread leading to 38ffd89 ("libmultipath: prevent DSO unloading with
> astray checker threads"). Your logs show "tur checker refcount 1", so
> the next call to checker_put would have unloaded the DSO.=20

Here I test 0.8.5 master code with commit 38ffd89. There is no crash
in five hours (without patch, crash happen in running test script
for 30 to 40 minutes.)

Regards,
Lixiaokeng



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

