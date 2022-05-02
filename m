Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B09C4332F
	for <dm-devel@archiver.kernel.org>; Mon,  2 May 2022 12:16:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-dmK1UuHsN62xuQkOdf557g-1; Mon, 02 May 2022 08:16:28 -0400
X-MC-Unique: dmK1UuHsN62xuQkOdf557g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6A2629AB40A;
	Mon,  2 May 2022 12:16:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E0DF14C3DB5;
	Mon,  2 May 2022 12:16:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 625A0194705E;
	Mon,  2 May 2022 12:16:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F1236194704A
 for <dm-devel@listman.corp.redhat.com>; Mon,  2 May 2022 12:16:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CEC1340D1B9F; Mon,  2 May 2022 12:16:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C90F2403D16A
 for <dm-devel@redhat.com>; Mon,  2 May 2022 12:16:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E20283396B
 for <dm-devel@redhat.com>; Mon,  2 May 2022 12:16:25 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-KRon8EVGPECnU7JDB_3hVA-1; Mon, 02 May 2022 08:16:23 -0400
X-MC-Unique: KRon8EVGPECnU7JDB_3hVA-1
X-IronPort-AV: E=Sophos;i="5.91,190,1647273600"; d="scan'208";a="200215691"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 02 May 2022 20:16:23 +0800
IronPort-SDR: PtRbOAtMXWlxZbCqFDLeUHKdyC6oQglnkf8HwtZNN0DkDhbyUJrULgYE4a3lnxCbCaNicwQOjA
 EvqRurJGkHp1w9sUqYJaP0QoFyLYq5mh6xN15FMMA2SIok7YF0efxQSAP4stNm/hwfY+oDym8k
 oV+3CGXkC4NWoOBujueJWzHFhr0eA0XK6bh0IKYZIcCmtML9c8CZ4la1pTL1iPpueNhfg9FxyO
 u9jQzgstEQ/uw+7e1+waYhC8OsqjxCUM9Yh2H2pq2oXLz5XGY2CpK/tGJO05Sgw6cT9IyWhplp
 AqvNcHJKfc8a0BY0/UweuzY0
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 02 May 2022 04:46:26 -0700
IronPort-SDR: fIISg64C3rMx90QPiTMR+cGkMeW/U8HSICL8c036zKBORQGq0RT5BtDk4WwqDPaATn+mgLc6EN
 4MeCDUBlH3FlqAC+V6tBg/v8/ek9wN+qec8/Rh3R3huWVBcmn85IxbvT7OqB2+CUKvXvSoDK3Z
 /4XQPUBp0PL9+V3d8ZuvqJ3nB/uZbK1w1yk7skAxO59Oc8vzTN0a9rxOwvyCy50OMD3aIg4Eno
 NMKJ8t+2IgEROYUibZhaM2X+DlREpzSyMjQkKgLqS6eycq/XlcFk7GpePcBnFNAghALtyv+nyt
 TNc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 02 May 2022 05:16:22 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KsMWp2jS3z1SHwl
 for <dm-devel@redhat.com>; Mon,  2 May 2022 05:16:22 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id ACeHW83F7Vxj for <dm-devel@redhat.com>;
 Mon,  2 May 2022 05:16:21 -0700 (PDT)
Received: from [10.225.81.200] (hq6rw33.ad.shared [10.225.81.200])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KsMWn2C5Wz1Rvlc;
 Mon,  2 May 2022 05:16:21 -0700 (PDT)
Message-ID: <84da2486-7a20-f3c7-43e9-60a29c7429fc@opensource.wdc.com>
Date: Mon, 2 May 2022 21:16:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
To: Nitesh Shetty <nj.shetty@samsung.com>
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
 <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
 <20220427124951.GA9558@test-zns>
 <260b95e8-74bf-9460-cf0d-7e3df1b1a3c7@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <260b95e8-74bf-9460-cf0d-7e3df1b1a3c7@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v4 00/10] Add Copy offload support
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
Cc: linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjAyMi8wNS8wMiAyMToxNCwgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj4gT24gMjAyMi8wNC8y
NyAyMTo0OSwgTml0ZXNoIFNoZXR0eSB3cm90ZToKPj4gTyBXZWQsIEFwciAyNywgMjAyMiBhdCAx
MToxOTo0OEFNICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPj4+IE9uIDQvMjYvMjIgMTk6
MTIsIE5pdGVzaCBTaGV0dHkgd3JvdGU6Cj4+Pj4gVGhlIHBhdGNoIHNlcmllcyBjb3ZlcnMgdGhl
IHBvaW50cyBkaXNjdXNzZWQgaW4gTm92ZW1iZXIgMjAyMSB2aXJ0dWFsIGNhbGwKPj4+PiBbTFNG
L01NL0JGUCBUT1BJQ10gU3RvcmFnZTogQ29weSBPZmZsb2FkWzBdLgo+Pj4+IFdlIGhhdmUgY292
ZXJlZCB0aGUgSW5pdGlhbCBhZ3JlZWQgcmVxdWlyZW1lbnRzIGluIHRoaXMgcGF0Y2hzZXQuCj4+
Pj4gUGF0Y2hzZXQgYm9ycm93cyBNaWt1bGFzJ3MgdG9rZW4gYmFzZWQgYXBwcm9hY2ggZm9yIDIg
YmRldgo+Pj4+IGltcGxlbWVudGF0aW9uLgo+Pj4+Cj4+Pj4gT3ZlcmFsbCBzZXJpZXMgc3VwcG9y
dHMg4oCTCj4+Pj4KPj4+PiAxLiBEcml2ZXIKPj4+PiAtIE5WTWUgQ29weSBjb21tYW5kIChzaW5n
bGUgTlMpLCBpbmNsdWRpbmcgc3VwcG9ydCBpbiBudm1lLXRhcmdldCAoZm9yCj4+Pj4gICAgIGJs
b2NrIGFuZCBmaWxlIGJhY2tlbmQpCj4+Pgo+Pj4gSXQgd291bGQgYWxzbyBiZSBuaWNlIHRvIGhh
dmUgY29weSBvZmZsb2FkIGVtdWxhdGlvbiBpbiBudWxsX2JsayBmb3IgdGVzdGluZy4KPj4+Cj4+
Cj4+IFdlIGNhbiBwbGFuIHRoaXMgaW4gbmV4dCBwaGFzZSBvZiBjb3B5IHN1cHBvcnQsIG9uY2Ug
dGhpcyBzZXJpZXMgc2V0dGxlcyBkb3duLgo+IAo+IFdoeSA/IEhvdyBkbyB5b3UgZXhwZWN0IHBl
b3BsZSB0byB0ZXN0IHNpbXBseSB3aXRob3V0IG51bGxfYmxrID8gU3V0cmUsIHlvdSBzYWlkCj4g
UUVNVSBjYW4gYmUgdXNlZC4gQnV0IGlmIGNvcHkgb2ZmbG9hZCBpcyBub3QgdXBzdHJlYW0gZm9y
IFFFTVUgZWl0aGVyLCB0aGVyZSBpcwo+IG5vIGVhc3kgd2F5IHRvIHRlc3QuCj4gCj4gQWRkaW5n
IHRoYXQgc3VwcG9ydCB0byBudWxsX2JsayB3b3VsZCBub3QgYmUgaGFyZCBhdCBhbGwuCgpTb3Jy
eS4gUmVwbGllZCBhZ2FpbiB0byBhbiBlbWFpbCBJIGFscmVhZHkgcmVwbGllZCB0by4gdmdlciBr
ZWVwIHNlbmRpbmcgbWUKbXVsdGlwbGUgY29waWVzIG9mIHRoZSBzYW1lIGVtYWlscy4uLgoKLS0g
CkRhbWllbiBMZSBNb2FsCldlc3Rlcm4gRGlnaXRhbCBSZXNlYXJjaAoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

