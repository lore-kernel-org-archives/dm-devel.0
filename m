Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 245A2C43334
	for <dm-devel@archiver.kernel.org>; Tue,  7 Jun 2022 09:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1654595879;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dksQScKP9V4cvI3D20ysZZpMyHIMw5u7XQVGVQs3YO0=;
	b=KCb5pxIEG1bBqI9XZxvwVMij3cR1j4EYDYT8D1LvjiPCAJZBoLSzWIqFtGb5VxVRJT2gm6
	0xk/guFjzfkoBqDDcLscDdcsyIRES3VxrpaGh8lLPWRgVZJzz3JlvUSffVZV1wMedvYjJR
	RdEhX9FocLn49IAyY1mC3P5kI5RNJHs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-dvp5wTQhOZCMkMpJDPP10w-1; Tue, 07 Jun 2022 05:57:56 -0400
X-MC-Unique: dvp5wTQhOZCMkMpJDPP10w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30BD31C161D8;
	Tue,  7 Jun 2022 09:57:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 45EE441047E8;
	Tue,  7 Jun 2022 09:57:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1CCC119451F1;
	Tue,  7 Jun 2022 09:57:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 71A2A19451F0
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Jun 2022 09:57:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5760E1121315; Tue,  7 Jun 2022 09:57:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DE0D1121314
 for <dm-devel@redhat.com>; Tue,  7 Jun 2022 09:57:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75C501D3388F
 for <dm-devel@redhat.com>; Tue,  7 Jun 2022 09:57:36 +0000 (UTC)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-f4NQMzKwOyywTtuZBwCU9g-1; Tue, 07 Jun 2022 05:57:32 -0400
X-MC-Unique: f4NQMzKwOyywTtuZBwCU9g-1
Received: by mail-wm1-f71.google.com with SMTP id
 k32-20020a05600c1ca000b0039c4cf75023so3568779wms.9
 for <dm-devel@redhat.com>; Tue, 07 Jun 2022 02:57:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=IHBszC15Ld8OVnvNMdu421xiC276w+hlRiTxIc/O7YY=;
 b=Yq1sv1MqJXfK1AXBpCm+7n3Rvhhjk5wB2v0aBysCUPrdL7Ru8JSAHinV1PTAk1yV5i
 fGlu37QKkzy1P5EvKIX58E5YTP5XSVuvCM89W8t5b2Cy/BXwWemrFSJmJy/CQI9I3v70
 b1tP1368UgnkjTBRmQOOrmpWtQSfACV1jxUJNplsQXtZLSz3AajoNeKX/m9WnyZYndGq
 gOP7nvUuLT4feCv7iaLUygiPEc+Eib1TKChgBRQP1UI+o5e5W7cqpXM/ypTM2/gN1E3P
 bTz8gXiypq746x1+sgagltzlQnaE2+Ho+tDVFXrAS5HkV7ZLQ9O1MXuZCMQpaiFQi6yd
 Av3w==
X-Gm-Message-State: AOAM530iYJZD9UcWyyh8QNI0080LQboQeyG5PCAY6Tvo19Cq/3pCXkAu
 b40/SpnObaOy7DOcaEnGu6/EpHutqTszKcZuFPYZ6wjgUsuOI/HDyjSZ1xHR81pBm9+8Vx50gT/
 yRdVPC5EP1yarRT4=
X-Received: by 2002:a05:6000:2a8:b0:213:ba0c:fef8 with SMTP id
 l8-20020a05600002a800b00213ba0cfef8mr22079059wry.485.1654595850463; 
 Tue, 07 Jun 2022 02:57:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzFDPtVoQMvowE46SaprV3ZVELYOY8maj61XTL2sJ4xtRialw/Ny0uzrJy4hdgckLmnPzOSg==
X-Received: by 2002:a05:6000:2a8:b0:213:ba0c:fef8 with SMTP id
 l8-20020a05600002a800b00213ba0cfef8mr22079048wry.485.1654595850244; 
 Tue, 07 Jun 2022 02:57:30 -0700 (PDT)
Received: from redhat.com (128.19.187.81.in-addr.arpa. [81.187.19.128])
 by smtp.gmail.com with ESMTPSA id
 h6-20020adfa4c6000000b0020fe61acd09sm18419893wrb.12.2022.06.07.02.57.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 07 Jun 2022 02:57:29 -0700 (PDT)
Date: Tue, 7 Jun 2022 10:57:27 +0100
From: "Bryn M. Reeves" <breeves@redhat.com>
To: Tony Camuso <tcamuso@redhat.com>
Message-ID: <Yp8hB/tJBVNxDXgy@redhat.com>
References: <b65d1bbb-7367-3a51-ba21-9de057a435fc@redhat.com>
MIME-Version: 1.0
In-Reply-To: <b65d1bbb-7367-3a51-ba21-9de057a435fc@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] Device Mapper being derailed in tboot launch
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBKdW4gMDYsIDIwMjIgYXQgMTE6NDM6NThBTSAtMDQwMCwgVG9ueSBDYW11c28gd3Jv
dGU6CiAKPiBTdWNjZXNzZnVsIGJvb3Rsb2cgc25pcHBldDoKPiAKPiBbICAgIDMuODQzOTExXSBz
ZCA1OjA6MDowOiBbc2RhXSBBdHRhY2hlZCBTQ1NJIGRpc2sKPiBbICAgIDMuODQ4MzcwXSBzZCA2
OjA6MDowOiBbc2RiXSBBdHRhY2hlZCBTQ1NJIGRpc2sKPiBbICAgIDMuOTI1NjM5XSBtZDEyNjog
ZGV0ZWN0ZWQgY2FwYWNpdHkgY2hhbmdlIGZyb20gMCB0byAxOTAwMzgyNTE5Mjk2Cj4gWyAgICAz
Ljk0NjMwN10gIG1kMTI2OiBwMSBwMiBwMwoKQXJlIHRoZSBNRCBhcnJheSBwYXJ0aXRpb25zIGJl
aW5nIHVzZWQgYXMgdGhlIFBWcyBmb3IgdGhlIHJoZWxfbGVub3ZvCnZvbHVtZSBncm91cD8gSXQn
cyB0aGUgbWFqb3IgZGlmZmVyZW5jZSBpbiB0aGUgdHdvIHNuaXBwZXRzIG90aGVyIHRoYW4KdGlt
aW5nLCBhbmQgd291bGQgYWNjb3VudCBmb3Igd2h5IHRoZSB2b2x1bWUgZ3JvdXAgY2Fubm90IGJl
IGRpc2NvdmVyZWQKaW4gdGhlIHRib290IGNhc2UuCgo+IFsgIE9LICBdIEZvdW5kIGRldmljZSAv
ZGV2L21hcHBlci9yaGVsX2xlbm92by0tc3QyNTB2Mi0tMDItcm9vdC4KPiBbICBPSyAgXSBSZWFj
aGVkIHRhcmdldCBJbml0cmQgUm9vdCBEZXZpY2UuCj4gWyAgT0sgIF0gRm91bmQgZGV2aWNlIC9k
ZXYvbWFwcGVyL3JoZWxfbGVub3ZvLS1zdDI1MHYyLS0wMi1zd2FwLgo+ICAgICAgICAgIFN0YXJ0
aW5nIFJlc3VtZSBmcm9tIGhpYmVybmF0aW9uIHVz4oCmci9yaGVsX2xlbm92by0tc3QyNTB2Mi0t
MDItc3dhcC4uLgo+IFsgIE9LICBdIFN0YXJ0ZWQgUmVzdW1lIGZyb20gaGliZXJuYXRpb24gdXNp
4oCmcGVyL3JoZWxfbGVub3ZvLS1zdDI1MHYyLS0wMi1zd2FwLgo+IFsgIE9LICBdIFJlYWNoZWQg
dGFyZ2V0IExvY2FsIEZpbGUgU3lzdGVtcyAoUHJlKS4KPiAKPiBGYWlsaW5nIGJvb3Rsb2cgc25p
cHBldDoKPiAKPiBbICAgIDQuNTc4MjA1XSBzZCA1OjA6MDowOiBbc2RhXSBBdHRhY2hlZCBTQ1NJ
IGRpc2sKPiBbICAgIDQuNTgxMDAwXSBzZCA2OjA6MDowOiBbc2RiXSBBdHRhY2hlZCBTQ1NJIGRp
c2sKPiBbIFRJTUUgXSBUaW1lZCBvdXQgd2FpdGluZyBmb3IgZGV2aWNlIGRldi1tYeKApmRzdDI1
MHYyXHgyZFx4MmQwMlx4MmRzd2FwLmRldmljZS4KPiBbREVQRU5EXSBEZXBlbmRlbmN5IGZhaWxl
ZCBmb3IgUmVzdW1lIGZyb20gaOKApnBlci9yaGVsX2xlbm92by0tc3QyNTB2Mi0tMDItc3dhcC4K
CkFueSBkaWZmZXJlbmNlcyBpbiBrZXJuZWwgY29tbWFuZCBsaW5lL2RyYWN1dCBhcmd1bWVudHMg
YmV0d2VlbiB0aGUgdHdvCmNhc2VzPyBFc3BlY2lhbGx5IHRoZSByZC5tZC4qIGJpdHM/CgpSZWdh
cmRzLApCcnluLgogCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

