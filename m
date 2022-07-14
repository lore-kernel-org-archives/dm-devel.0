Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96FA1C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Jul 2022 23:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657840202;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GRUf6cUBMvFDIYAH+ObFx5nocJvCv8ofFr3CjqYWMi0=;
	b=cDVzK+VWtVLCNgdabFEJGTAzlztRybZ5pPLkfb9dWFYofGMySC6/jrIYoaipXHDDveFhK9
	cnLyKoF7Fw2lwkF4kiq9/DDAmRbdND0+hP6ayIcQ3pWSmtI2I28tWKv4XHy1OCVVS4bYgQ
	pDKIUWbfu1dq4qHw0U+CzJgmto80I6Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-cz9YNEAJNje7pK-DxTdg-w-1; Thu, 14 Jul 2022 19:09:58 -0400
X-MC-Unique: cz9YNEAJNje7pK-DxTdg-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58E19101A54E;
	Thu, 14 Jul 2022 23:09:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A8BB7140EBE3;
	Thu, 14 Jul 2022 23:09:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 81030194706F;
	Thu, 14 Jul 2022 23:09:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 71B7A194706D
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Jul 2022 23:09:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3DE2A2166B2A; Thu, 14 Jul 2022 23:09:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 39BC72166B26
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 23:09:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E94F85A584
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 23:09:54 +0000 (UTC)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-9yfguRWtNg2gh8wwUBisaw-1; Thu, 14 Jul 2022 19:09:44 -0400
X-MC-Unique: 9yfguRWtNg2gh8wwUBisaw-1
Received: by mail-wr1-f50.google.com with SMTP id bu1so4468463wrb.9;
 Thu, 14 Jul 2022 16:09:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=6GXtfrONS4xE+rx+306zWIoG2o7/GPdrSucnMoLW0cc=;
 b=mEQvuLdjzo7k+61zbNWdM9rhuUCCuEJ43RAoGrdyDD6W2JYbhXQODMueFzJA1swv5P
 H5+lKIwxdKNAJdV5xXKwcpqr77xy7wXULfeqi9SSIkz0JTu3pngXTD6ktKbsuUc5AO7P
 pJjfHqVebrlc5r5xShF2ijFuZnbvLpsdoyxaQjDfQC/IdGl/RceC8aqgFVlqfXBnkQyQ
 rMoNTmtUGmirG6IypJSwoNw7OmWR+ZbGOLrLzVS1S5y3l/orzbx8XaH5c+wJCKiF/7Nc
 FGEtO/6ps/qKHUwArEQwLfIt4iCjynK/x4YhEiyxVOkHrgRjUu8ZsINrHqNkrzzi+40E
 uuyw==
X-Gm-Message-State: AJIora/Wh5RR5EGlVH6D3y0B7oDFwgECKsOU1QeGKzxJdxFGLvC0KMh6
 9a+H5N4HP1wMVH/nrbvWWCyM1pnc3w==
X-Google-Smtp-Source: AGRyM1t15jQZlZgG2bj+Wz1IlKusvfrwWFjbr0ermPpIss1w+XixI1jaF879ZU0ka3WmM7InTaBvaQ==
X-Received: by 2002:a5d:4447:0:b0:21d:6b84:4678 with SMTP id
 x7-20020a5d4447000000b0021d6b844678mr9639146wrr.668.1657840182924; 
 Thu, 14 Jul 2022 16:09:42 -0700 (PDT)
Received: from localhost (127.red-81-44-149.dynamicip.rima-tde.net.
 [81.44.149.127]) by smtp.gmail.com with ESMTPSA id
 m185-20020a1c26c2000000b003a302fb9df7sm2928346wmm.21.2022.07.14.16.09.42
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 14 Jul 2022 16:09:42 -0700 (PDT)
Message-ID: <3ddb4a30-b478-7d34-9e55-45b0560da2cc@gmail.com>
Date: Fri, 15 Jul 2022 01:09:41 +0200
MIME-Version: 1.0
To: Martin Wilck <mwilck@suse.com>
References: <20220714190540.117283-1-xose.vazquez@gmail.com>
 <5a3b7d5920baa0d4a967f000b3b1ea61b16cbd69.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <5a3b7d5920baa0d4a967f000b3b1ea61b16cbd69.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 0/2] multipath-tools: update docs
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNy8xNC8yMiAyMTozOCwgTWFydGluIFdpbGNrIHdyb3RlOgoKPiBPbiBUaHUsIDIwMjItMDct
MTQgYXQgMjE6MDUgKzAyMDAsIFhvc2UgVmF6cXVleiBQZXJleiB3cm90ZToKPj4gWG9zZSBWYXpx
dWV6IFBlcmV6ICgyKToKPj4gIMKgIG11bHRpcGF0aC10b29sczogdXBkYXRlIGRldmVsIHJlcG8g
aW5mbyBpbiBSRUFETUUubWQKPj4gIMKgIG11bHRpcGF0aC10b29sczogZGVsZXRlIFJFQURNRS5h
bHVhCj4gCj4gV2h5IGNvbXBsZXRlIGRlbGV0ZSBpdD8KCkl0IHdhcyB3cml0dGVuIGZpdmUgeWVh
cnMgYWdvLCBhbmQgbm93IG1heWJlIGl0IGlzIG91dGRhdGVkL2lycmVsZXZhbnQuClRocmVlIG9w
dGlvbnMgd2VyZSBwcm92aWRlZDsgbGV0IGl0IGJlLCBkZWxldGUgaXQsIG9yIG1vdmUgdGhlIGlu
Zm8gdG8gUkVBRE1FLm1kClRyZWF0IGl0IGxpa2UgcmZjLgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBs
aXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1h
bi9saXN0aW5mby9kbS1kZXZlbAo=

