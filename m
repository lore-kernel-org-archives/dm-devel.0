Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFAB2EB64DA
	for <dm-devel@archiver.kernel.org>; Sat, 17 Jun 2023 19:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687030673;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=N2RYE3U82mdKPuDqOJqveUhrEZcj07K0zAYdWLgCxUA=;
	b=VoMhHCd2V39mn6obkzsOLdocHoQm/6pWCr1/7fmZ8mDwKMUM8KX23QP9bNVpfgcEr8wP9c
	SqVQimWIP/MB6iq9tATunpvfL9pLL2+uXBMUpBubQSWqlTf71sO4O1yMlUE7CrIxSWsP9E
	263Mmmmxy6vqIRcX7xzWiLobmcgImJQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-qPbUEDgpMJKcZ5zKzS93lw-1; Sat, 17 Jun 2023 15:37:50 -0400
X-MC-Unique: qPbUEDgpMJKcZ5zKzS93lw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60368800193;
	Sat, 17 Jun 2023 19:37:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A59FC2166B26;
	Sat, 17 Jun 2023 19:37:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6A6B51946594;
	Sat, 17 Jun 2023 19:37:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 940C41946589
 for <dm-devel@listman.corp.redhat.com>; Sat, 17 Jun 2023 19:37:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 35BD91121315; Sat, 17 Jun 2023 19:37:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E6451121314
 for <dm-devel@redhat.com>; Sat, 17 Jun 2023 19:37:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12C8180067D
 for <dm-devel@redhat.com>; Sat, 17 Jun 2023 19:37:41 +0000 (UTC)
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com
 [209.85.160.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-pA-pMjLaN5qHew7LD_U5jg-1; Sat, 17 Jun 2023 15:37:37 -0400
X-MC-Unique: pA-pMjLaN5qHew7LD_U5jg-1
Received: by mail-qt1-f179.google.com with SMTP id
 d75a77b69052e-3fddb0bd9e2so17137911cf.0; 
 Sat, 17 Jun 2023 12:37:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1687030656; x=1689622656;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=kl4HsAfWCKb8ynFnpo6ruxSlGxogBQy+qHi+pBH3hog=;
 b=XAuYOs+X/e1+2BaNZzblPiM5hZu4+OkxM2C3vRgsSXG0JL/G4Maqefmc3tAOkFv6Rf
 Htpo7zTGvIePoliTyZA1wjOVu7aSbyivasSbHuG6nYEJaOXZhsB+n4pr7aUv0dpzJQ4v
 4qOzDKf3rM0AcTWX21gv0pGzztU8ClzCrma/DEapSkWkwSJBDSbIGqsnniHYaFBD/e5J
 0NKmh/34+GrQgWONfJd6gCA6ctymhVyXyVJx2tOdu/pppi8jXvQYY5gPOGYQKgQKUymd
 H8byUwWDn+R74e0A2ta9JndOP2nAZvJsuu86YGOf6BQz0Zkisw/RNfqvveudU2EZoj4U
 6oGg==
X-Gm-Message-State: AC+VfDxeZdL9VeqFK7U1WzaGRkn/PldejW6gx0sKpQoO+8WTJ3p9vtQy
 6U06xQNKuSxh1Bhb0pQE55MH3StZ25iDFPH6nHXfczhvyb4=
X-Google-Smtp-Source: ACHHUZ5zKsw7XT8IyzJ4imq0bfVShGn6HETQgfcJDdPOSPTF/MH8EX00PBxCfURYMHyOJvOCmIk4aZK2UG7+UUNyPY0=
X-Received: by 2002:a05:622a:491:b0:3eb:1512:91c5 with SMTP id
 p17-20020a05622a049100b003eb151291c5mr7765845qtx.12.1687030656133; Sat, 17
 Jun 2023 12:37:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230605050853.6240-1-eatnumber1@gmail.com>
 <20230605050853.6240-5-eatnumber1@gmail.com>
In-Reply-To: <20230605050853.6240-5-eatnumber1@gmail.com>
From: Russell Harmon <eatnumber1@gmail.com>
Date: Sat, 17 Jun 2023 12:37:07 -0700
Message-ID: <CA+zrezSppKhAyNDofTpm2Rx+L1FmULdGadUi+svLzV-k8E0=LQ@mail.gmail.com>
To: bagasdotme@gmail.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v4 4/4] Documentation: dm-integrity: Document
 an example of how the tunables relate.
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com,
 linux-doc@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJpZW5kbHkgcGluZyBvbiB0aGlzIGxhc3QgcGF0Y2guIFdhcyB0aGVyZSBhZGRpdGlvbmFsIGNo
YW5nZXMgbmVlZGVkCmZvciB0aGlzIG9uZT8KCk9uIFN1biwgSnVuIDQsIDIwMjMgYXQgMTA6MDni
gK9QTSBSdXNzZWxsIEhhcm1vbiA8ZWF0bnVtYmVyMUBnbWFpbC5jb20+IHdyb3RlOgo+Cj4gU2ln
bmVkLW9mZi1ieTogUnVzc2VsbCBIYXJtb24gPGVhdG51bWJlcjFAZ21haWwuY29tPgo+IC0tLQo+
ICBEb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL2RldmljZS1tYXBwZXIvZG0taW50ZWdyaXR5LnJz
dCB8IDYgKysrKysrCj4gIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykKPgo+IGRpZmYg
LS1naXQgYS9Eb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL2RldmljZS1tYXBwZXIvZG0taW50ZWdy
aXR5LnJzdCBiL0RvY3VtZW50YXRpb24vYWRtaW4tZ3VpZGUvZGV2aWNlLW1hcHBlci9kbS1pbnRl
Z3JpdHkucnN0Cj4gaW5kZXggMDI0MTQ1N2MwMDI3Li5kOGE1ZjE0ZDBlM2MgMTAwNjQ0Cj4gLS0t
IGEvRG9jdW1lbnRhdGlvbi9hZG1pbi1ndWlkZS9kZXZpY2UtbWFwcGVyL2RtLWludGVncml0eS5y
c3QKPiArKysgYi9Eb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL2RldmljZS1tYXBwZXIvZG0taW50
ZWdyaXR5LnJzdAo+IEBAIC0yMTMsNiArMjEzLDEyIEBAIHRhYmxlIGFuZCBzd2FwIHRoZSB0YWJs
ZXMgd2l0aCBzdXNwZW5kIGFuZCByZXN1bWUpLiBUaGUgb3RoZXIgYXJndW1lbnRzCj4gIHNob3Vs
ZCBub3QgYmUgY2hhbmdlZCB3aGVuIHJlbG9hZGluZyB0aGUgdGFyZ2V0IGJlY2F1c2UgdGhlIGxh
eW91dCBvZiBkaXNrCj4gIGRhdGEgZGVwZW5kIG9uIHRoZW0gYW5kIHRoZSByZWxvYWRlZCB0YXJn
ZXQgd291bGQgYmUgbm9uLWZ1bmN0aW9uYWwuCj4KPiArRm9yIGV4YW1wbGUsIG9uIGEgZGV2aWNl
IHVzaW5nIHRoZSBkZWZhdWx0IGludGVybGVhdmVfc2VjdG9ycyBvZiAzMjc2OCwgYQo+ICtibG9j
a19zaXplIG9mIDUxMiwgYW5kIGFuIGludGVybmFsX2hhc2ggb2YgY3JjMzJjIHdpdGggYSB0YWcg
c2l6ZSBvZiA0Cj4gK2J5dGVzLCBpdCB3aWxsIHRha2UgMTI4IEtpQiBvZiB0YWdzIHRvIHRyYWNr
IGEgZnVsbCBkYXRhIGFyZWEsIHJlcXVpcmluZwo+ICsyNTYgc2VjdG9ycyBvZiBtZXRhZGF0YSBw
ZXIgZGF0YSBhcmVhLiBXaXRoIHRoZSBkZWZhdWx0IGJ1ZmZlcl9zZWN0b3JzIG9mCj4gKzEyOCwg
dGhhdCBtZWFucyB0aGVyZSB3aWxsIGJlIDIgYnVmZmVycyBwZXIgbWV0YWRhdGEgYXJlYSwgb3Ig
MiBidWZmZXJzCj4gK3BlciAxNiBNaUIgb2YgZGF0YS4KPgo+ICBTdGF0dXMgbGluZToKPgo+IC0t
Cj4gMi4zNC4xCj4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

