Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34BD7C38A2D
	for <dm-devel@archiver.kernel.org>; Mon, 24 Oct 2022 05:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666589486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=u1BY65xXZNIUiIYSg4USZ6KpAfKlhPF2RQClxYvQpYo=;
	b=d8SBSBw+W11Bi2E5iqTXcA3L4hykqOV8kaDWQ+ywu7NR10KFE9qpb1XkMJruKYsNxcqPFA
	3nQexqsjxpgr18oEbtGFK8Qaclyd4Xid/DgPfvSaAHAxKXC1Z1gzTYClZTGJNBtyZzHAcH
	rdZvX5Y3YMVbn8g84juFsqQFqn5S3MY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-2j8SuWhhN32xuzO_1v7ghw-1; Mon, 24 Oct 2022 01:31:23 -0400
X-MC-Unique: 2j8SuWhhN32xuzO_1v7ghw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD1DA85A5A6;
	Mon, 24 Oct 2022 05:31:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5CAE449BB60;
	Mon, 24 Oct 2022 05:31:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0516C1946589;
	Mon, 24 Oct 2022 05:31:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B22D1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 24 Oct 2022 05:31:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4EBA41415117; Mon, 24 Oct 2022 05:31:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 46CB5140EBF3
 for <dm-devel@redhat.com>; Mon, 24 Oct 2022 05:31:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24FE129AA385
 for <dm-devel@redhat.com>; Mon, 24 Oct 2022 05:31:16 +0000 (UTC)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com
 [209.85.215.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-437-Ax5tBurLM2Ksiz4dwkAWCA-1; Mon, 24 Oct 2022 01:31:14 -0400
X-MC-Unique: Ax5tBurLM2Ksiz4dwkAWCA-1
Received: by mail-pg1-f176.google.com with SMTP id b5so7833403pgb.6
 for <dm-devel@redhat.com>; Sun, 23 Oct 2022 22:31:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=FwxG912r7qQdhMvwHpOUVaZKCV3QA/HupUI/48WJuP8=;
 b=s7ehjkf5fvgNx/BN1A6qyS3n5ollQqmjOrs2+7+hVl33jNmvBFkv4yNrLUAStm4ukG
 eZbrqerRaiXsfpONB4/XOTKEMy2XJBHUzFSdvwCIWtI4FNFqV9L72TRRSNuUbxDpUh0c
 wdovbDbwMTQPT1bFBSY1teQ5W6Ae8X8h6UvkA1Ha+cxBrtabu2yU73Jq7I5zvP824pTH
 vvbeOMqFOefuq7qXUFgdK1DbYddYIa6izAfMcC18wi2C9XIT9Qe0mcA1/KXEc/4hQKsQ
 yuUByuHxd8EvsjZcnZlvb67lFsHqXefolKVf2l/gKzd//OH728d4QUtlBXYXS/NIyDe/
 avzg==
X-Gm-Message-State: ACrzQf3oYeIuFHTsd+TvkqBo6FmNohXoZPxie/PtBcaiFV2TJ+1Ne9i3
 AYeFBKlM3quB6SiZfVVsPEO5Thl3cLZipg==
X-Google-Smtp-Source: AMsMyM4qhjcVIs2TqmkRHCehYHsec5mzcEa4l4kRVjUQnd/NKoMzbiyGEQhn2aw2YDuvdTnCFJPVvA==
X-Received: by 2002:a63:1317:0:b0:42a:e7a5:ef5a with SMTP id
 i23-20020a631317000000b0042ae7a5ef5amr27152779pgl.392.1666589473004; 
 Sun, 23 Oct 2022 22:31:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au.
 [49.181.106.210]) by smtp.gmail.com with ESMTPSA id
 q10-20020a170902f78a00b0017a018221e2sm18680427pln.70.2022.10.23.22.31.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 23 Oct 2022 22:31:12 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
 (envelope-from <david@fromorbit.com>)
 id 1omq3J-005iEA-4a; Mon, 24 Oct 2022 16:31:09 +1100
Date: Mon, 24 Oct 2022 16:31:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Message-ID: <20221024053109.GY3600936@dread.disaster.area>
References: <e3d51a6b-12e9-2a19-1280-5fd9dd64117c@fujitsu.com>
 <deb54a77-90d3-df44-1880-61cce6e3f670@fujitsu.com>
 <1444b9b5-363a-163c-0513-55d1ea951799@fujitsu.com>
 <Yzt6eWLuX/RTjmjj@magnolia>
 <f196bcab-6aa2-6313-8a7c-f8ab409621b7@fujitsu.com>
 <Yzx64zGt2kTiDYaP@magnolia>
 <6a83a56e-addc-f3c4-2357-9589a49bf582@fujitsu.com>
 <Y1NRNtToQTjs0Dbd@magnolia>
 <20221023220018.GX3600936@dread.disaster.area>
 <OSBPR01MB2920CA997DDE891C06776279F42E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <OSBPR01MB2920CA997DDE891C06776279F42E9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH] xfs: fail dax mount if reflink is enabled on
 a partition
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
Cc: "hch@infradead.org" <hch@infradead.org>,
 "toshi.kani@hpe.com" <toshi.kani@hpe.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "Darrick J. Wong" <djwong@kernel.org>, Brian Foster <bfoster@redhat.com>,
 "yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yasunori Gotou \(Fujitsu\)" <y-goto@fujitsu.com>,
 Jeff Moyer <jmoyer@redhat.com>, "zwisler@kernel.org" <zwisler@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBPY3QgMjQsIDIwMjIgYXQgMDM6MTc6NTJBTSArMDAwMCwgcnVhbnN5LmZuc3RAZnVq
aXRzdS5jb20gd3JvdGU6Cj4g5ZyoIDIwMjIvMTAvMjQgNjowMCwgRGF2ZSBDaGlubmVyIOWGmemB
kzoKPiA+IE9uIEZyaSwgT2N0IDIxLCAyMDIyIGF0IDA3OjExOjAyUE0gLTA3MDAsIERhcnJpY2sg
Si4gV29uZyB3cm90ZToKPiA+PiBPbiBUaHUsIE9jdCAyMCwgMjAyMiBhdCAxMDoxNzo0NVBNICsw
ODAwLCBZYW5nLCBYaWFvL+adqCDmmZMgd3JvdGU6Cj4gPj4+IEluIGFkZGl0aW9uLCBJIGRvbid0
IGxpa2UgeW91ciBpZGVhIGFib3V0IHRoZSB0ZXN0IGNoYW5nZSBiZWNhdXNlIGl0IHdpbGwKPiA+
Pj4gbWFrZSBnZW5lcmljLzQ3MCBiZWNvbWUgdGhlIHNwZWNpYWwgdGVzdCBmb3IgWEZTLiBEbyB5
b3Uga25vdyBpZiB3ZSBjYW4gZml4Cj4gPj4+IHRoZSBpc3N1ZSBieSBjaGFuZ2luZyB0aGUgdGVz
dCBpbiBhbm90aGVyIHdheT8gYmxrZGlzY2FyZCAteiBjYW4gZml4IHRoZQo+ID4+PiBpc3N1ZSBi
ZWNhdXNlIGl0IGRvZXMgemVyby1maWxsIHJhdGhlciB0aGFuIGRpc2NhcmQgb24gdGhlIGJsb2Nr
IGRldmljZS4KPiA+Pj4gSG93ZXZlciwgYmxrZGlzY2FyZCAteiB3aWxsIHRha2UgYSBsb3Qgb2Yg
dGltZSB3aGVuIHRoZSBibG9jayBkZXZpY2UgaXMKPiA+Pj4gbGFyZ2UuCj4gPj4KPiA+PiBXZWxs
IHdlIC9jb3VsZC8ganVzdCBkbyB0aGF0IHRvbywgYnV0IHRoYXQgd2lsbCBzdWNrIGlmIHlvdSBo
YXZlIDJUQiBvZgo+ID4+IHBtZW0uIDspCj4gPj4KPiA+PiBNYXliZSBhcyBhbiBhbHRlcm5hdGl2
ZSBwYXRoIHdlIGNvdWxkIGp1c3QgY3JlYXRlIGEgdmVyeSBzbWFsbAo+ID4+IGZpbGVzeXN0ZW0g
b24gdGhlIHBtZW0gYW5kIHRoZW4gYmxrZGlzY2FyZCAteiBpdD8KPiA+Pgo+ID4+IFRoYXQgc2Fp
ZCAtLSBkb2VzIHBlcnNpc3RlbnQgbWVtb3J5IGFjdHVhbGx5IGhhdmUgYSBmdXR1cmU/ICBJbnRl
bAo+ID4+IHNjdXR0bGVkIHRoZSBlbnRpcmUgT3B0YW5lIHByb2R1Y3QsIGN4bC5tZW0gc291bmRz
IGxpa2UgZXhwYW5zaW9uCj4gPj4gY2hhc3NpcyBmdWxsIG9mIERSQU0sIGFuZCBmc2RheCBpcyBo
b3JyaWJseSBicm9rZW4gaW4gNi4wICh3ZWlyZCBrZXJuZWwKPiA+PiBhc3NlcnRzIGV2ZXJ5d2hl
cmUpIGFuZCA2LjEgKGV2ZXJ5IHRpbWUgSSBydW4gZnN0ZXN0cyBub3cgSSBzZWUgbWFzc2l2ZQo+
ID4+IGRhdGEgY29ycnVwdGlvbikuCj4gPgo+ID4gWXVwLCBJIHNlZSB0aGUgc2FtZSB0aGluZy4g
ZnNkYXggd2FzIGEgdHJhaW4gd3JlY2sgaW4gNi4wIC0gYnJva2VuCj4gPiBvbiBib3RoIGV4dDQg
YW5kIFhGUy4gTm93IHRoYXQgSSBydW4gYSBxdWljayBjaGVjayBvbiA2LjEtcmMxLCBJCj4gPiBk
b24ndCB0aGluayB0aGF0IGhhcyBjaGFuZ2VkIGF0IGFsbCAtIEkgc3RpbGwgc2VlIGxvdHMgb2Yg
a2VybmVsCj4gPiB3YXJuaW5ncywgZGF0YSBjb3JydXB0aW9uIGFuZCAiWEZTX0lPQ19DTE9ORV9S
QU5HRTogSW52YWxpZAo+ID4gYXJndW1lbnQiIGVycm9ycy4KPiAKPiBGaXJzdGx5LCBJIHRoaW5r
IHRoZSAiWEZTX0lPQ19DTE9ORV9SQU5HRTogSW52YWxpZCBhcmd1bWVudCIgZXJyb3IgaXMKPiBj
YXVzZWQgYnkgdGhlIHJlc3RyaWN0aW9ucyB3aGljaCBwcmV2ZW50IHJlZmxpbmsgd29yayB0b2dl
dGhlciB3aXRoIERBWDoKPiAKPiBhLiBmcy94ZnMveGZzX2lvY3RsLmM6MTE0MQo+IC8qIERvbid0
IGFsbG93IHVzIHRvIHNldCBEQVggbW9kZSBmb3IgYSByZWZsaW5rZWQgZmlsZSBmb3Igbm93LiAq
Lwo+IGlmICgoZmEtPmZzeF94ZmxhZ3MgJiBGU19YRkxBR19EQVgpICYmIHhmc19pc19yZWZsaW5r
X2lub2RlKGlwKSkKPiAgICAgICAgIHJldHVybiAtRUlOVkFMOwo+IAo+IGIuIGZzL3hmcy94ZnNf
aW9wcy5jOjExNzQKPiAvKiBPbmx5IHN1cHBvcnRlZCBvbiBub24tcmVmbGlua2VkIGZpbGVzLiAq
Lwo+IGlmICh4ZnNfaXNfcmVmbGlua19pbm9kZShpcCkpCj4gICAgICAgICByZXR1cm4gZmFsc2U7
Cj4gCj4gVGhlc2UgcmVzdHJpY3Rpb25zIHdlcmUgcmVtb3ZlZCBpbiAiZHJvcCBleHBlcmltZW50
YWwgd2FybmluZyIgcGF0Y2hbMV0uCj4gICBJIHRoaW5rIHRoZXkgc2hvdWxkIGJlIHNlcGFyYXRl
ZCBmcm9tIHRoYXQgcGF0Y2guCj4gCj4gWzFdCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGlu
dXgteGZzLzE2NjMyMzQwMDItMTctMS1naXQtc2VuZC1lbWFpbC1ydWFuc3kuZm5zdEBmdWppdHN1
LmNvbS8KPiAKPiAKPiBTZWNvbmRseSwgaG93IHRoZSBkYXRhIGNvcnJ1cHRpb24gaGFwcGVuZWQ/
CgpObyBpZGVhIC0gaSJtIGp1c3QgcmVwb3J0aW5nIHRoYXQgbG90cyBvZiBmc3ggdGVzdHMgZmFp
bGVkIHdpdGggZGF0YQpjb3JydXB0aW9ucy4gSSBoYXZlbid0IGhhZCB0aW1lIHRvIGxvb2sgYXQg
d2h5LCBJJ20gc3RpbGwgdHJ5aW5nIHRvCnNvcnQgb3V0IHRoZSBmaXggZm9yIGEgZGlmZmVyZW50
IGRhdGEgY29ycnVwdGlvbi4uLgoKPiBPciB3aGljaCBjYXNlIGZhaWxlZD8KCipsb3RzKiBvZiB0
aGVtIGZhaWxlZCB3aXRoIGtlcm5lbCB3YXJuaW5ncyB3aXRoIHJlZmxpbmsgdHVybmVkIG9mZjoK
ClNFQ1RJT04gICAgICAgLS0geGZzX2RheF9ub3JlZmxpbmsKPT09PT09PT09PT09PT09PT09PT09
PT09PQpGYWlsdXJlczogZ2VuZXJpYy8wNTEgZ2VuZXJpYy8wNjggZ2VuZXJpYy8wNzUgZ2VuZXJp
Yy8wODMKZ2VuZXJpYy8xMTIgZ2VuZXJpYy8xMjcgZ2VuZXJpYy8xOTggZ2VuZXJpYy8yMzEgZ2Vu
ZXJpYy8yNDcKZ2VuZXJpYy8yNjkgZ2VuZXJpYy8yNzAgZ2VuZXJpYy8zNDAgZ2VuZXJpYy8zNDQg
Z2VuZXJpYy8zODgKZ2VuZXJpYy80NjEgZ2VuZXJpYy80NzEgZ2VuZXJpYy80NzYgZ2VuZXJpYy81
MTkgZ2VuZXJpYy81NjEgeGZzLzAxMQp4ZnMvMDEzIHhmcy8wNzMgeGZzLzI5NyB4ZnMvMzA1IHhm
cy81MTcgeGZzLzUzOApGYWlsZWQgMjYgb2YgMTA3OSB0ZXN0cwoKQWxsIG9mIHRob3NlIGV4Y2Vw
dCB4ZnMvMDczIGFuZCBnZW5lcmljLzQ3MSBhcmUgZmFpbHVyZXMgZHVlIHRvCndhcm5pbmdzIGZv
dW5kIGluIGRtZXNnLgoKV2l0aCByZWZsaW5rIGVuYWJsZWQsIEkgdGVybWluYXRlZCB0aGUgcnVu
IGFmdGVyIGcvMDc1LCBnLzA5MSwgZy8xMTIKYW5kIGdlbmVyaWMvMTI3IHJlcG9ydGVkIGZzeCBk
YXRhIGNvcnJ1cHRpb25zIGFuZCBnLzA1MSwgZy8wNjgsCmcvMDc1IGFuZCBnLzA4MyBoYWQgcmVw
b3J0ZWQga2VybmVsIHdhcm5pbmdzIGluIGRtZXNnLgoKPiBDb3VsZAo+IHlvdSBnaXZlIG1lIG1v
cmUgaW5mbyAoc3VjaCBhcyBta2ZzIG9wdGlvbnMsIHhmc3Rlc3RzIGNvbmZpZ3MpPwoKVGhleSBh
cmUgZXhhY3RseSB0aGUgc2FtZSBhcyBsYXN0IHRpbWUgSSByZXBvcnRlZCB0aGVzZSBwcm9ibGVt
cy4KCkZvciB0aGUgIm5vIHJlZmxpbmsiIHRlc3QgaXNzdWVzOgoKbWtmcyBvcHRpb25zIGFyZSAi
LW0gcmVmbGluaz0wLHJtYXBidD0xIiwgbW91bnQgb3B0aW9ucyAiLW8KZGF4PWFsd2F5cyIgZm9y
IGJvdGggZmlsZXN5dGVtcy4gIENvbmZpZyBvdXRwdXQgYXQgc3RhcnQgb2YgdGVzdApydW46CgpT
RUNUSU9OICAgICAgIC0tIHhmc19kYXhfbm9yZWZsaW5rCkZTVFlQICAgICAgICAgLS0geGZzIChk
ZWJ1ZykKUExBVEZPUk0gICAgICAtLSBMaW51eC94ODZfNjQgdGVzdDMgNi4xLjAtcmMxLWRnYysg
IzE2MTUgU01QIFBSRUVNUFRfRFlOQU1JQyBXZWQgT2N0IDE5IDEyOjI0OjE2IEFFRFQgMjAyMgpN
S0ZTX09QVElPTlMgIC0tIC1mIC1tIHJlZmxpbms9MCxybWFwYnQ9MSAvZGV2L3BtZW0xCk1PVU5U
X09QVElPTlMgLS0gLW8gZGF4PWFsd2F5cyAtbyBjb250ZXh0PXN5c3RlbV91Om9iamVjdF9yOnJv
b3RfdDpzMCAvZGV2L3BtZW0xIC9tbnQvc2NyYXRjaAoKcG1lbSBkZXZpY2VzIGFyZSBhIHBhaXIg
b2YgZmFrZSA4R0IgcG1lbSByZWdpb25zIHNldCB1cCBieSBrZXJuZWwKQ0xJIHZpYSAibWVtbWFw
PThHITE1Ryw4RyEyNEciLiBJIGRvbid0IGhhdmUgYW55dGhpbmcgc3BlY2lhbCBzZXQgdXAKLSB0
aGUga2VybmVsIGNvbmZpZyBpcyBrZXB0IG1pbmltYWwgZm9yIHRoZXNlIFZNcyAtIGFuZCB0aGUg
b25seQprZXJuZWwgZGVidWcgb3B0aW9uIEkgaGF2ZSB0dXJuZWQgb24gZm9yIHRoZXNlIHNwZWNp
ZmljIHRlc3QgcnVucyBpcwpDT05GSUdfWEZTX0RFQlVHPXkuCgpUSGUgb25seSBkaWZmZXJlbmNl
IGJldHdlZW4gdGhlIG5vcmVmbGluayBhbmQgcmVmbGluayBydW5zIGlzIHRoYXQgSQpkcm9wIHRo
ZSAiLW0gcmVmbGluaz0wIiBta2ZzIHBhcmFtZXRlci4gT3RoZXJ3aXNlIHRoZXkgYXJlIGlkZW50
aWNhbAphbmQgdGhlIGVycm9ycyBJIHJlcG9ydGVkIGFyZSBmcm9tIGJhY2stdG8tYmFjayBmc3Rl
c3RzIHJ1bnMgd2l0aG91dApyZWJvb3RpbmcgdGhlIFZNLi4uLgoKLURhdmUuCi0tIApEYXZlIENo
aW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRl
dmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5m
by9kbS1kZXZlbAo=

