Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7494EC43334
	for <dm-devel@archiver.kernel.org>; Thu, 21 Jul 2022 11:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658404454;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0kHoGkaJvlxhUzcs/KQjQgoHDpOBJKYDDf1Q2UyXPuk=;
	b=gz6LXPyrdfzaFIF4V8cpjTfLMh9/pFkNL40B/lejlp8lauPlLit1NxZ8uLDFC4d+1ziuwh
	z93EoQRx4j00fsiqkNcOpPfM6MRhpPZqeQSeGZenXvu7iz24qWbxcHldqtuJdDRovzBxZ6
	K0sTdygm68l2bw79y/e1ZSnXmK+f8Dg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-1gAtmr82NOSx8mRb-0dp6w-1; Thu, 21 Jul 2022 07:54:05 -0400
X-MC-Unique: 1gAtmr82NOSx8mRb-0dp6w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7DE63826A47;
	Thu, 21 Jul 2022 11:54:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E1D522166B26;
	Thu, 21 Jul 2022 11:54:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 224BD1947047;
	Thu, 21 Jul 2022 11:54:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 87FEF1947040
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Jul 2022 11:53:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7AE6E40C128A; Thu, 21 Jul 2022 11:53:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 764C040C141D
 for <dm-devel@redhat.com>; Thu, 21 Jul 2022 11:53:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24F231C288DC
 for <dm-devel@redhat.com>; Thu, 21 Jul 2022 11:53:59 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-0z-bs74-MWiXjqmiN6Pu7A-1; Thu, 21 Jul 2022 07:53:56 -0400
X-MC-Unique: 0z-bs74-MWiXjqmiN6Pu7A-1
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.54])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LpWB92QkhzkX8w;
 Thu, 21 Jul 2022 19:51:29 +0800 (CST)
Received: from dggpemm500014.china.huawei.com (7.185.36.153) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Jul 2022 19:53:53 +0800
Received: from [10.174.177.211] (10.174.177.211) by
 dggpemm500014.china.huawei.com (7.185.36.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Jul 2022 19:53:52 +0800
Message-ID: <67bce412-18ff-931e-7165-6c4b669a9afb@huawei.com>
Date: Thu, 21 Jul 2022 19:53:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
To: Roger Heflin <rogerheflin@gmail.com>
References: <4a5b490d-6361-a745-9e4c-0fe240c8b93f@huawei.com>
 <CAAMCDefDsdjx1BVqgv6uPUTRR2fCH3WeZ87NX1_q7QP8sdAu+w@mail.gmail.com>
From: Wu Guanghao <wuguanghao3@huawei.com>
In-Reply-To: <CAAMCDefDsdjx1BVqgv6uPUTRR2fCH3WeZ87NX1_q7QP8sdAu+w@mail.gmail.com>
X-Originating-IP: [10.174.177.211]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500014.china.huawei.com (7.185.36.153)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [Question] multipathd add/remove paths takes a long
 time
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
Cc: lixiaokeng <lixiaokeng@huawei.com>, liuxing108@huawei.com,
 zhangying134@huawei.com, chenmao2@huawei.com,
 "liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>,
 linfeilong <linfeilong@huawei.com>, device-mapper
 development <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

CgrlnKggMjAyMi83LzIwIDA6NTUsIFJvZ2VyIEhlZmxpbiDlhpnpgZM6Cj4gV2hhdCBkb2VzIHRo
ZSBjcHUgdGltZSBsb29rIGxpa2Ugd2hlbiB5b3UgYXJlIHNlZWluZyB0aGlzIGlzc3VlPwo+IAo+
IEkgaGF2ZSBzZWVuIGxhcmdlIG51bWJlcnMgb2Ygc2NzaSBkZXZpY2VzIGNvbWluZyBpbiBhbmQg
bXVsdGlwYXRocwo+IGdldHRpbmcgYnVpbHQgY2F1c2UgdGhlIHN5c3RlbSB0byBzZWVtIHRvIHdh
c3RlIHRpbWUuICAgV2l0aCBhIGhpZ2gKPiBudW1iZXJzIG9mIHVkZXZfY2hpbGRyZW4gKEkgYmVs
aWV2ZSB0aGUgZGVmYXVsdCBpcyBwcmV0dHkgaGlnaCkgaXQgY2FuCj4gdXNlIGV4Y2Vzc2l2ZSBj
cHUgb24gYSBiaWcgbWFjaGluZSB3aXRoIGEgbG90IG9mIHBhdGhzIGFuZCBhcHBlYXJzIHRvCj4g
YmUgaW50ZXJmZXJpbmcgd2l0aCBpdHNlbGYuCj4gT3VyIHByb2JsZW0gbWF5IGJlIGEgbGl0dGxl
IGRpZmZlcmVudC4gQSBsYXJnZSBudW1iZXIgb2YgbXVsdGlwYXRoIGRldmljZXMgaGF2ZSBiZWVu
IGNyZWF0ZWQuCldlIG9ubHkgYWRkIGEgbXVsdGlwYXRoIGRldmljZSxzbyB0aGVyZSBzaG91bGRu
J3QgYmUgYSBsb3Qgb2YgdWRldiBldmVudHMuCgo+IEluIHRlc3RpbmcgSSB3YXMgaW52b2x2ZWQg
aW4gaXQgd2FzIGZvdW5kIHRoYXQgc2V0dGluZyB1ZGV2X2NoaWxkcmVuCj4gdG8gNCBwcm9kdWNl
ZCBjb25zaXN0ZW50IGZhc3QgYmVoYXZpb3IsIHdoZXJlYXMgaGF2aW5nIGl0IHNldCB0bwo+IGRl
ZmF1bHQgKGxvdHMgb2YgdGhyZWFkcyBvbiBsYXJnZSBtYWNoaW5lcywgZXhhY3QgbnVtYmVyIHZh
cmllcyBvbgo+IG1hY2hpbmUgc2l6ZS9kaXN0cmlidXRpb24vdWRldiB2ZXJzaW9uKSBzb21ldGlt
ZXMgcHJvZHVjaW5nIHN5c3RlbWQKPiB0aW1lb3V0cyB3aGVuIHBhdGhzIHdlcmUgYnJvdWdodCBp
bi4gKD45MHNlY29uZHMgZmluZCBQViBmb3IgcmVxdWlyZWQKPiBMVidzKS4KPiAKPiBUaGUgZ2l2
ZSBhd2F5IHdhcyB1ZGV2IGFjY3VtdWxhdGVkIDUwLTkwIG1pbnV0ZXMgb2YgY3B1IHRpbWUgaW4g
YQo+IGNvdXBsZSBvZiBtaW51dGVzIG9mIGJvb3QgdXAgd2l0aCBkZWZhdWx0IHVkZXZfY2hpbGRy
ZW4sIGJ1dCB3aXRoIGl0Cj4gc2V0IHRvIG9ubHkgNCB0aGUgcGF0aHMgcHJvY2Vzc2VkIGZhc3Rl
ciBhbmQgdGhlIG1hY2hpbmUgYm9vdGVkIHVwCj4gZmFzdGVyIGFuZCB1ZGV2IGRpZCB0aGUgc2Ft
ZSByZWFsIHdvcmsgZmFzdGVyIHdpdGggbXVjaCBsZXNzIGNwdXRpbWUKPiAyLTMgbWludXRlcyBv
ZiBjcHUgdGltZS4KPiAKPiB0aGlzIGlzIHRoZSBvcHRpb246Cj4gL3Vzci9saWIvc3lzdGVtZC9z
eXN0ZW1kLXVkZXZkIC0tY2hpbGRyZW4tbWF4PTQuCj5Nb2RpZmllZCBhcyB5b3Ugc3VnZ2VzdGVk
LCBidXQgaXQgZG9lc24ndCB3b3JrIHZlcnkgd2VsbC4KCj4gT24gVHVlLCBKdWwgMTksIDIwMjIg
YXQgNzozMyBBTSBXdSBHdWFuZ2hhbyA8d3VndWFuZ2hhbzNAaHVhd2VpLmNvbT4gd3JvdGU6Cj4+
Cj4+IFRoZSBzeXN0ZW0gaGFzIDFLIG11bHRpcGF0aCBkZXZpY2VzLCBlYWNoIGRldmljZSBoYXMg
MTYgcGF0aHMuCj4+IEV4ZWN1dGUgbXVsdGlwYXRoZCBhZGQvbXVsdGlwYXRoZCByZW1vdmUgb3Ig
dWV2X2FkZF9wYXRoLwo+PiB1ZXZfcmVtb3ZlX3BhdGggdG8gYWRkL3JlbW92ZSBwYXRocywgd2hp
Y2ggdGFrZXMgb3ZlciAyMHMuCj4+IFdoYXQncyBtb3JlLCB0aGUgc2Vjb25kIGNoZWNrbG9vcCBt
YXkgYmUgZXhlY2VkIGltbWVkaWF0ZWx5Cj4+IGFmdGVyIGZpbmlzaGluZyBmaXJzdCBjaGVja2xv
b3AuIEl0J3MgdG9vIGxvbmcuCj4+Cj4+IFdlIGZvdW5kIHRoYXQgdGltZSB3YXMgbW9zdGx5IHNw
ZW50IHdhaXRpbmcgZm9yIGxvY2tzLgo+Pgo+PiBjaGVja2VybG9vcCgpewo+PiAgICAgICAgIC4u
Lgo+PiAgICAgICAgIGxvY2soJnZlY3MtPmxvY2spOwo+PiAgICAgICAgIHZlY3Rvcl9mb3JlYWNo
X3Nsb3QgKHZlY3MtPnBhdGh2ZWMsIHBwLCBpKSB7Cj4+ICAgICAgICAgICAgICAgICByYyA9IGNo
ZWNrX3BhdGgoLi4uKTsgLy8gVG9vIG1hbnkgcGF0aHMsIGl0IHRha2VzIGEgbG9uZyB0aW1lCj4+
ICAgICAgICAgICAgICAgICAuLi4KPj4gICAgICAgICB9Cj4+ICAgICAgICAgbG9ja19jbGVhbnVw
X3BvcCh2ZWNzLT5sb2NrKTsKPj4gICAgICAgICAuLi4KPj4gfQo+Pgo+PiBDYW4gdGhlIHJhbmdl
IG9mIHZlY3MtPmxvY2sgbG9ja3MgYmUgYWRqdXN0ZWQgdG8gcmVkdWNlIHRoZSB0aW1lIGNvbnN1
bWluZwo+PiB3aGVuIGFkZGluZy9yZW1vdmluZyBwYXRocz8KPj4KPj4gLS0KPj4gZG0tZGV2ZWwg
bWFpbGluZyBsaXN0Cj4+IGRtLWRldmVsQHJlZGhhdC5jb20KPj4gaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo+Pgo+IC4KPiAKSW4gb3VyIHRlc3Qg
ZW52aXJvbm1lbnQsIGl0IHRha2VzIG92ZXIgNDBzIGZvciBjaGVja2VybG9vcCgpIHRvIGNoZWNr
IGFsbCBwYXRocywKdmVjcy0+bG9jayB3aWxsIG5vdCBiZSByZWxlYXNlZCBkdXJpbmcgdGhpcyB0
aW1lLlNvIGlmIHdlIGV4ZWN1dGUgY29tbWFuZHMgdG8KYWRkL3JlbW92ZSBwYXRocyBkdXJpbmcg
dGhpcyB0aW1lLCB3ZSBtYXkgaGF2ZSB0byB3YWl0IG1vcmUgdGhhbiA0MHMgYXQgbW9zdAp0byBn
ZXQgdmVjcy0+bG9jay4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQu
Y29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

