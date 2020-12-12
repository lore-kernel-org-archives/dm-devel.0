Return-Path: <SRS0=vwJi=FQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0032C4361B
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 16:55:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6889D229C4
	for <dm-devel@archiver.kernel.org>; Sat, 12 Dec 2020 16:55:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6889D229C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1607792156;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hQAD5STjbopXje2kC+9Ax5Ri7ra9/sutqRWhGrVyR4c=;
	b=P874dda5NbiB8T09BeBSnibwY6QIecnSKQ/u4b8bX3w0dMIRlkg2vVDZEjncO+fX80j9eC
	j3pf7mdVcNg+v+NzSTlI2yGMMN70bcQYws5/2MBAXk5wFTOkLxm/pHKGm9UrLzPr3CMsYr
	A2NJLy4fdscUExVrtKcaYLSCTJ26LTU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-_QDpPJ4mN2SzR8kPjTuyDA-1; Sat, 12 Dec 2020 11:55:54 -0500
X-MC-Unique: _QDpPJ4mN2SzR8kPjTuyDA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F575E744;
	Sat, 12 Dec 2020 16:55:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4507660BFA;
	Sat, 12 Dec 2020 16:55:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B19B94A7C6;
	Sat, 12 Dec 2020 16:55:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BCGtmOv022075 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 12 Dec 2020 11:55:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 51FB92026D48; Sat, 12 Dec 2020 16:55:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4CFB02026D47
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 16:55:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0578800140
	for <dm-devel@redhat.com>; Sat, 12 Dec 2020 16:55:44 +0000 (UTC)
Received: from mail-qv1-f65.google.com (mail-qv1-f65.google.com
	[209.85.219.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-504-BBFbDgYHPGyeg_P0P_ssyQ-1; Sat, 12 Dec 2020 11:55:40 -0500
X-MC-Unique: BBFbDgYHPGyeg_P0P_ssyQ-1
Received: by mail-qv1-f65.google.com with SMTP id p12so5773881qvj.13;
	Sat, 12 Dec 2020 08:55:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition
	:content-transfer-encoding:in-reply-to;
	bh=C9dAR8KUaTQSVqBHY7IZtL3YZt1kyupy3xu4GVLhIsQ=;
	b=n81fdvW9mAL+WPNxztobR539CWRbbZiOp0CbMsZwe6GrVempYL6cql5F5ANVDTMik8
	5dEQQCMJt/N+uQWTcpSsW9nuhGmTEy5ktK0vZo1YyES3u2uIMxu/q31+/qZfgfUV6ZTz
	naSBVpB6n1dHhKWXGNuma6wsfXtKpuHz7uiPQypEmP/+Gszjyt6D1+yKyOj5ivodDFc7
	8mmTo/qOmZ1gUqpObth9kAp9RkKqjPp60EwzpN2YzL7l5/mG86BRSGotE+iLokczDnA1
	lBSYygh6QSDoH0nzGZxiG4kEbqNCRA7m+8T381sVVkYFCksx7wssYdmPwJnnGqPhMZbs
	e3dA==
X-Gm-Message-State: AOAM533RWKMFE6P7D8zCNHD3izC4wz7oEDWpW6Nmvu8Qt+VgMwZyoGlK
	mNO3kcSTh6CyIYbaszIK7E4=
X-Google-Smtp-Source: ABdhPJy5Tf31U0TmRDuFcmrY39Oaz9HNM6YTb8IpRm2RT7xOo5eHY/xIxf/1qp79bXmj79ssJ/gdXA==
X-Received: by 2002:ad4:580f:: with SMTP id dd15mr19779126qvb.40.1607792140121;
	Sat, 12 Dec 2020 08:55:40 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	u5sm10599317qka.106.2020.12.12.08.55.38
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sat, 12 Dec 2020 08:55:38 -0800 (PST)
Date: Sat, 12 Dec 2020 11:55:37 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Message-ID: <20201212165537.GA53870@lobo>
References: <D6749568-4ED2-49A7-B0D3-F0969B934BF6@fb.com>
	<20201212144229.GB21863@redhat.com>
	<2799b859-c451-c3f6-7753-fe08e35f4a7c@kernel.dk>
MIME-Version: 1.0
In-Reply-To: <2799b859-c451-c3f6-7753-fe08e35f4a7c@kernel.dk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Song Liu <songliubraving@fb.com>, Heinz Mauelshagen <heinzm@redhat.com>,
	Xiao Ni <xni@redhat.com>, Matthew Ruffell <matthew.ruffell@canonical.com>,
	linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com
Subject: [dm-devel] [PATCH] md: change mddev 'chunk_sectors' from int to
	unsigned
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Q29tbWl0IGUyNzgyZjU2MGMyOSAoIlJldmVydCAiZG0gcmFpZDogcmVtb3ZlIHVubmVjZXNzYXJ5
IGRpc2NhcmQKbGltaXRzIGZvciByYWlkMTAiIikgZXhwb3NlZCBjb21waWxlciB3YXJuaW5ncyBp
bnRyb2R1Y2VkIGJ5IGNvbW1pdAplMDkxMGM4ZTRmODcgKCJkbSByYWlkOiBmaXggZGlzY2FyZCBs
aW1pdHMgZm9yIHJhaWQxIGFuZCByYWlkMTAiKToKCkluIGZpbGUgaW5jbHVkZWQgZnJvbSAuL2lu
Y2x1ZGUvbGludXgva2VybmVsLmg6MTQsCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUv
YXNtLWdlbmVyaWMvYnVnLmg6MjAsCiAgICAgICAgICAgICAgICAgZnJvbSAuL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL2J1Zy5oOjkzLAogICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4
L2J1Zy5oOjUsCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvbW1kZWJ1Zy5o
OjUsCiAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvZ2ZwLmg6NSwKICAgICAg
ICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC9zbGFiLmg6MTUsCiAgICAgICAgICAgICAg
ICAgZnJvbSBkcml2ZXJzL21kL2RtLXJhaWQuYzo4Ogpkcml2ZXJzL21kL2RtLXJhaWQuYzogSW4g
ZnVuY3Rpb24g4oCYcmFpZF9pb19oaW50c+KAmToKLi9pbmNsdWRlL2xpbnV4L21pbm1heC5oOjE4
OjI4OiB3YXJuaW5nOiBjb21wYXJpc29uIG9mIGRpc3RpbmN0IHBvaW50ZXIgdHlwZXMgbGFja3Mg
YSBjYXN0CiAgKCEhKHNpemVvZigodHlwZW9mKHgpICopMSA9PSAodHlwZW9mKHkpICopMSkpKQog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgXn4KLi9pbmNsdWRlL2xpbnV4L21pbm1heC5oOjMy
OjQ6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDigJhfX3R5cGVjaGVja+KAmQogICAoX190
eXBlY2hlY2soeCwgeSkgJiYgX19ub19zaWRlX2VmZmVjdHMoeCwgeSkpCiAgICBefn5+fn5+fn5+
fgouL2luY2x1ZGUvbGludXgvbWlubWF4Lmg6NDI6MjQ6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBt
YWNybyDigJhfX3NhZmVfY21w4oCZCiAgX19idWlsdGluX2Nob29zZV9leHByKF9fc2FmZV9jbXAo
eCwgeSksIFwKICAgICAgICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fgouL2luY2x1ZGUvbGlu
dXgvbWlubWF4Lmg6NTE6MTk6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDigJhfX2NhcmVm
dWxfY21w4oCZCiAjZGVmaW5lIG1pbih4LCB5KSBfX2NhcmVmdWxfY21wKHgsIHksIDwpCiAgICAg
ICAgICAgICAgICAgICBefn5+fn5+fn5+fn5+Ci4vaW5jbHVkZS9saW51eC9taW5tYXguaDo4NDoz
OTogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmG1pbuKAmQogIF9feCA9PSAwID8gX195
IDogKChfX3kgPT0gMCkgPyBfX3ggOiBtaW4oX194LCBfX3kpKTsgfSkKICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgXn5+CmRyaXZlcnMvbWQvZG0tcmFpZC5jOjM3Mzk6MzM6
IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDigJhtaW5fbm90X3plcm/igJkKICAgbGltaXRz
LT5tYXhfZGlzY2FyZF9zZWN0b3JzID0gbWluX25vdF96ZXJvKHJzLT5tZC5jaHVua19zZWN0b3Jz
LAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fn4KCkZpeCB0aGlz
IGJ5IGNoYW5naW5nIHRoZSBjaHVua19zZWN0b3JzIG1lbWJlciBvZiAnc3RydWN0IG1kZGV2JyBm
cm9tCmludCB0byAndW5zaWduZWQgaW50JyB0byBtYXRjaCB0aGUgdHlwZSB1c2VkIGZvciB0aGUg
J2NodW5rX3NlY3RvcnMnCm1lbWJlciBvZiAnc3RydWN0IHF1ZXVlX2xpbWl0cycuICBWYXJpb3Vz
IE1EIGNvZGUgc3RpbGwgdXNlcyAnaW50JyBidXQKbm9uZSBvZiBpdCBhcHBlYXJzIHRvIGV2ZXIg
bWFrZSB1c2Ugb2Ygc2lnbmVkIGludDsgYW5kIHN0b3JpbmcKcG9zaXRpdmUgc2lnbmVkIGludCBp
biB1bnNpZ25lZCBpcyBwZXJmZWN0bHkgc2FmZS4KClJlcG9ydGVkLWJ5OiBTb25nIExpdSA8c29u
Z2xpdWJyYXZpbmdAZmIuY29tPgpGaXhlczogZTI3ODJmNTYwYzI5ICgiUmV2ZXJ0ICJkbSByYWlk
OiByZW1vdmUgdW5uZWNlc3NhcnkgZGlzY2FyZCBsaW1pdHMgZm9yIHJhaWQxMCIiKQpGaXhlczog
ZTA5MTBjOGU0Zjg3ICgiZG0gcmFpZDogZml4IGRpc2NhcmQgbGltaXRzIGZvciByYWlkMSBhbmQg
cmFpZDEwIikKQ2M6IHN0YWJsZUB2Z2VyLGtlcm5lbC5vcmcgIyBlMDkxMGM4ZTRmODcgd2FzIG1h
cmtlZCBmb3Igc3RhYmxlQApTaWduZWQtb2ZmLWJ5OiBNaWtlIFNuaXR6ZXIgPHNuaXR6ZXJAcmVk
aGF0LmNvbT4KLS0tCiBkcml2ZXJzL21kL21kLmggfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAy
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9t
ZC5oIGIvZHJpdmVycy9tZC9tZC5oCmluZGV4IDIxNzVhNWFjNGY3Yy4uYmI2NDViYzNiYTZkIDEw
MDY0NAotLS0gYS9kcml2ZXJzL21kL21kLmgKKysrIGIvZHJpdmVycy9tZC9tZC5oCkBAIC0zMTEs
NyArMzExLDcgQEAgc3RydWN0IG1kZGV2IHsKIAlpbnQJCQkJZXh0ZXJuYWw7CS8qIG1ldGFkYXRh
IGlzCiAJCQkJCQkJICogbWFuYWdlZCBleHRlcm5hbGx5ICovCiAJY2hhcgkJCQltZXRhZGF0YV90
eXBlWzE3XTsgLyogZXh0ZXJuYWxseSBzZXQqLwotCWludAkJCQljaHVua19zZWN0b3JzOworCXVu
c2lnbmVkIGludAkJCWNodW5rX3NlY3RvcnM7CiAJdGltZTY0X3QJCQljdGltZSwgdXRpbWU7CiAJ
aW50CQkJCWxldmVsLCBsYXlvdXQ7CiAJY2hhcgkJCQljbGV2ZWxbMTZdOwpAQCAtMzM5LDcgKzMz
OSw3IEBAIHN0cnVjdCBtZGRldiB7CiAJICovCiAJc2VjdG9yX3QJCQlyZXNoYXBlX3Bvc2l0aW9u
OwogCWludAkJCQlkZWx0YV9kaXNrcywgbmV3X2xldmVsLCBuZXdfbGF5b3V0OwotCWludAkJCQlu
ZXdfY2h1bmtfc2VjdG9yczsKKwl1bnNpZ25lZCBpbnQJCQluZXdfY2h1bmtfc2VjdG9yczsKIAlp
bnQJCQkJcmVzaGFwZV9iYWNrd2FyZHM7CiAKIAlzdHJ1Y3QgbWRfdGhyZWFkCQkqdGhyZWFkOwkv
KiBtYW5hZ2VtZW50IHRocmVhZCAqLwotLSAKMi4xNS4wCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlz
dGluZm8vZG0tZGV2ZWw=

