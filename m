Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7986BC001B0
	for <dm-devel@archiver.kernel.org>; Mon, 17 Jul 2023 09:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689584951;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Lmuwccvmrrv5Ydr7J9QfAqXYWKGg1P6CdDsUqF8Z4xg=;
	b=J/wyxayt31FDx4Kv3QlhjTXVp2/NVUuttucIlbXLkoY04yAFmX/Qghz1S3/xFpm1zvKQrH
	2oWi750E8QZX8/+tRNGeMhvPQPnsExsc8iCZbp+iKmiw+9bjE3dH52iBhGyF0aMo3BpkUz
	0bLkgQjj85+Ghc3R0oMtkXtt7nfc4Gw=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-Mgy_1zBtPp-bcvofVHOoQg-1; Mon, 17 Jul 2023 05:09:10 -0400
X-MC-Unique: Mgy_1zBtPp-bcvofVHOoQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCDD03C0DDA1;
	Mon, 17 Jul 2023 09:09:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3B7891121315;
	Mon, 17 Jul 2023 09:09:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F8AD194658C;
	Mon, 17 Jul 2023 09:09:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C1E2C1946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 17 Jul 2023 09:09:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5E07D40C206F; Mon, 17 Jul 2023 09:09:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5694D40C2063
 for <dm-devel@redhat.com>; Mon, 17 Jul 2023 09:09:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 356BC88D196
 for <dm-devel@redhat.com>; Mon, 17 Jul 2023 09:09:04 +0000 (UTC)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com
 [209.85.128.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-qDe6a2-AMkmNzLKwz4MDcA-1; Mon, 17 Jul 2023 05:08:59 -0400
X-MC-Unique: qDe6a2-AMkmNzLKwz4MDcA-1
Received: by mail-yw1-f181.google.com with SMTP id
 00721157ae682-577412111f0so46080467b3.0
 for <dm-devel@redhat.com>; Mon, 17 Jul 2023 02:08:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1689584937; x=1692176937;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=VqUV389bcHJRJT6iwuWrxWbjzHQ6HHBmo47jvW7D/4Y=;
 b=iAoku93iGd97tWd2LVYL52UokxHEMZWz/X7k46vnCUhEoEmjexLShkfjLVQagmX+WG
 tNP/+f71ovGP78lSPha7KA3gWqIVHsYsOz1SmjiF3Px3WJGsrBwbc2zIQZFhjSjVIMM2
 y3xDkGo4v6oduf/ZMBiVOoNTvZ4xbW5heDE4y6lYQFEelfnDvdCVmiX9Z+k/w2qDyl93
 v898MrhZuS64Y8ksjAFsApD4SVQLNYj7w/8qWDb1ZMLUWYI0yOfn+oRPbOvynpQsWLY1
 WmONQInMOW6/rZZMagVBWZfKBK+Vwadj+NcGZ/KhA299e31iaaOKAkqUvLN5Gd1ysc3V
 D2EQ==
X-Gm-Message-State: ABy/qLY6AkDNBS86OljzIpVGgrPZ9ZT7PZy1VS44kK333qIvQPhszdNE
 tmprqc5Msj05a6G/dbJpQiLDbKw3wWTWHA==
X-Google-Smtp-Source: APBJJlFcuySQni8s6whNPx7toUMIGR4ne9axGGh/JLLMrY40KmPl8hkWDObOOlPEVL7OlyTUHq/ifw==
X-Received: by 2002:a0d:cb41:0:b0:56f:fffc:56ff with SMTP id
 n62-20020a0dcb41000000b0056ffffc56ffmr14549265ywd.42.1689584937470; 
 Mon, 17 Jul 2023 02:08:57 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com.
 [209.85.219.177]) by smtp.gmail.com with ESMTPSA id
 k125-20020a816f83000000b0055a07c7be39sm3756611ywc.31.2023.07.17.02.08.57
 for <dm-devel@redhat.com>
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 17 Jul 2023 02:08:57 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id
 3f1490d57ef6-bc379e4c1cbso4641739276.2
 for <dm-devel@redhat.com>; Mon, 17 Jul 2023 02:08:57 -0700 (PDT)
X-Received: by 2002:a25:ae51:0:b0:c63:7093:dd01 with SMTP id
 g17-20020a25ae51000000b00c637093dd01mr12173716ybe.27.1689584936882; Mon, 17
 Jul 2023 02:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230717075035.GA9549@tomerius.de>
In-Reply-To: <20230717075035.GA9549@tomerius.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 17 Jul 2023 11:08:45 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWA+2froa9Z=GHrd5Ub-dr=o-ErNsgjS7TJnXbHYggMdQ@mail.gmail.com>
Message-ID: <CAMuHMdWA+2froa9Z=GHrd5Ub-dr=o-ErNsgjS7TJnXbHYggMdQ@mail.gmail.com>
To: Kai Tomerius <kai@tomerius.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] File system robustness
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
Cc: dm-devel@redhat.com, Ext4 Developers List <linux-ext4@vger.kernel.org>,
 linux-embedded@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux-m68k.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

Q0MgbGludXgtZXh0NCwgZG0tZGV2ZWwKCk9uIE1vbiwgSnVsIDE3LCAyMDIzIGF0IDEwOjEz4oCv
QU0gS2FpIFRvbWVyaXVzIDxrYWlAdG9tZXJpdXMuZGU+IHdyb3RlOgo+Cj4gSGksCj4KPiBsZXQn
cyBzdXBwb3NlIGFuIGVtYmVkZGVkIHN5c3RlbSB3aXRoIGEgcmVhZC1vbmx5IHNxdWFzaGZzIHJv
b3QgZmlsZQo+IHN5c3RlbSwgYW5kIGEgd3JpdGFibGUgZXh0NCBkYXRhIHBhcnRpdGlvbiB3aXRo
IGRhdGE9am91cm5hbC4KPiBGdXJ0aGVybW9yZSwgdGhlIGRhdGEgcGFydGl0aW9uIHNoYWxsIGJl
IHByb3RlY3RlZCB3aXRoIGRtLWludGVncml0eS4KPgo+IE5vcm1hbGx5LCBJJ2QgdW1vdW50IHRo
ZSBkYXRhIHBhcnRpdGlvbiB3aGlsZSBzaHV0dGluZyBkb3duIHRoZQo+IHN5c3RlbS4gVGhlcmUg
bWlnaHQgYmUgY2FzZXMgdGhvdWdoIHdoZXJlIHBvd2VyIGlzIGN1dC4gSW4gc3VjaCBhCj4gY2Fz
ZSwgdGhlcmUnbGwgYmUgZXh0NCByZWNvdmVyaWVzLCB3aGljaCBpcyBvay4KPgo+IEhvdyByb2J1
c3Qgd291bGQgc3VjaCBhIHNldHVwIGJlPyBBcmUgdGhlcmUgY2hhbmNlcyB0aGF0IHRoZSBleHQ0
Cj4gcmVxdWlyZXMgYSBmc2NrPyBXaGF0IG1pZ2h0IGhhcHBlbiBpZiBmc2NrIGlzIG5vdCBydW4s
IGV2ZXI/IElzIHRoZXJlCj4gYSBjaGFuY2UgdGhhdCB0aGUgZGF0YSBwYXJ0aXRpb24gY2FuJ3Qg
YmUgbW91bnRlZCBhdCBhbGw/IEhvdyBvZnRlbgo+IG1pZ2h0IHRoYXQgaGFwcGVuPwo+Cj4gVGh4
Cj4gcmVnYXJkcwo+IEthaQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhh
dC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZl
bAo=

