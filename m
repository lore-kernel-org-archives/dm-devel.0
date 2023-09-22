Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31BBFCD4857
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 18:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695666970;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tjccJVIvP+8FsXa0kVMlCZPNvyUQ/2Hulu9xnCZWDCA=;
	b=YlFyH4At8u6p7f6NkDcKcyV85PWbCZSc4flb1YXpvFfKV76i1OYo8+TVVcJIKUs8NTRsZl
	cdiM7sSkNSAG67HepAS3xPovpSY01EiFlYHnASnuKtqQLsAUu/yaGSXqjsk3hiifYw9j9q
	Mu4zjg1fQIo0ZPZA/TRa3prX+VaHBxQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-oWUNtHwCMm6lo9R-EXIgfQ-1; Mon, 25 Sep 2023 14:36:07 -0400
X-MC-Unique: oWUNtHwCMm6lo9R-EXIgfQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D537858281;
	Mon, 25 Sep 2023 18:36:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5775221CAC7A;
	Mon, 25 Sep 2023 18:36:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 59D6419465B8;
	Mon, 25 Sep 2023 18:36:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 74BD11946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Sep 2023 13:08:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4002914171CA; Fri, 22 Sep 2023 13:08:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3835314171B6
 for <dm-devel@redhat.com>; Fri, 22 Sep 2023 13:08:24 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E816D800962
 for <dm-devel@redhat.com>; Fri, 22 Sep 2023 13:08:23 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16--xW8sb4rPrSHB-BPdPNpyg-1; Fri, 22 Sep 2023 09:08:21 -0400
X-MC-Unique: -xW8sb4rPrSHB-BPdPNpyg-1
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230922130818epoutp0355541006ea020ceb7a77192ddce87bde~HOn4ztzew1205812058epoutp03p
 for <dm-devel@redhat.com>; Fri, 22 Sep 2023 13:08:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230922130818epoutp0355541006ea020ceb7a77192ddce87bde~HOn4ztzew1205812058epoutp03p
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas2p3.samsung.com (KnoxPortal) with ESMTP id
 20230922130816epcas2p33d271a48d44365bb0a9300ff2edff03a~HOn3V3NrS2769427694epcas2p33;
 Fri, 22 Sep 2023 13:08:16 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.102]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4RsXdD20k3z4x9Pv; Fri, 22 Sep
 2023 13:08:16 +0000 (GMT)
X-AuditID: b6c32a45-84fff700000025dd-6f-650d91c036dc
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
 epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
 87.06.09693.0C19D056; Fri, 22 Sep 2023 22:08:16 +0900 (KST)
Mime-Version: 1.0
From: Jinyoung Choi <j-young.choi@samsung.com>
To: Nitesh Jagadeesh Shetty <nj.shetty@samsung.com>, Jens Axboe
 <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, "dm-devel@redhat.com"
 <dm-devel@redhat.com>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni
 <kch@nvidia.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20230920080756.11919-5-nj.shetty@samsung.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20230922130815epcms2p631fc5fc5ebe634cc948fef1992f83a38@epcms2p6>
Date: Fri, 22 Sep 2023 22:08:15 +0900
X-CMS-MailID: 20230922130815epcms2p631fc5fc5ebe634cc948fef1992f83a38
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Brightmail-Tracker: H4sIAAAAAAAAA22Tf1DTZRzHe/b9sg1q3NcJ+DTO4oYZPwI2gu2RoCOk+OaPg4o778hz7dg3
 4Bjb2nezMlwoCogHgZzlTQlHHMQwYfzcJDgaIJgSJUFBinlscDYRhEATsGCD7I/+ez3ve38+
 7+fzee5hY9x8Fo+dodBQaoVUzmd64K3dgeKQrlIOJbDMeaD67y9j6P7CEo6OlqxgqO7mZ0zk
 6J4DyNaVD9AdayDquHfWDY12WRiotq6XgU5ZRwCyD+sZqGMsGBnyqnD0bccVHA1dOsdEFdV2
 Fjr5i5mJavoeM9CvJXaAzLYjALUuVWDoomMGR/1jvmjiZAFAgyt9brE80qK/ySIHx004OTSg
 JRuNJ5hkU9WnZPtoDpP8qrjMjSzKvcck79vHcHKmc5hJFjcbATnf+BzZaJtmJHFSMqPTKamM
 UvtRilSlLEORFsPf/Y5kpyRSJBCGCHcgMd9PIc2iYvjxe5JC3siQry6C73dQKteuSklSmuaH
 vRqtVmo1lF+6ktbE8CmVTK4Sq0JpaRatVaSFKihNlFAgCI9cNb6XmV7eY2OpmkUf2a0NIAc8
 iCgE7mxIRMCf7prcCoEHm0uYAXQMzmOFgM3mEJvginnzmmczEQ2banvc1phL8OEPF/TApQvg
 sd/y8DVmEqHQPNXOWuvjRVzFoPnv22DtgBF9bnB4cYjhSuPAM/l23MW+sK2mxdnJnXgFnrPm
 rusB8GF1EeZibzhaN83a4JnLFcDFXvD4+MC6ZxP8/a/2df1ZaLUuMNcGgIQSNnS95ZKzYd6j
 mXV7GBwpMDmjOMReeKFc79Rx4gVY8WP/+hXiYW1xuTMWI4JhtcHh3AlGBML6S2Gu7v6wZwx3
 OTxhQfcKa2PAHNPS/7L5SxvDVbodVh4NLwH++id71v8nSv8k6jzAjMCHUtFZaRQdrhL++7Sp
 yqxG4PwRQa+bQdn0bKgVMNjACiAb43txUuc8KC5HJv34EKVWStRaOUVbQeTqkKUYzztVufql
 FBqJMGKHIEIkEorDIwVi/hbO+PFyGZdIk2qoTIpSUeqNOgbbnZfDGKjZL3zgOzsg+eDluMRR
 +/B3vTfaSggldq1Sx/MPSBYFjyQvBeg0p7bGGujOd5sPXDny/OyuFI/9px/deSYv8VbGiabg
 ea8Ex9lrukrjVSzp/aBJoHiJ3rLk2Ne7V5J9aGqiNda0LOuPuNjSGGj0DH1x67G66+Yzp+0Z
 1IER2i/5oOdCFGpfvLXt8+HdH4rL34yfsSXM9AVl1SjTE0UPHy+PGhKSUt11nO2W27zzdKf2
 6z99TAOTOoO38nBx8cTPi0+buK8Vtdzt5Rs+EW+Li6rKTYl8Kns5bjE86I+CXJ/rmgaeMtry
 dnSrJSZGXrlvak+boH7yxi6j7psyefbhUuMXOB+n06XCIExNS/8BGm04MpoEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230920081458epcas5p3a3e12d8b5661b5d6f4420316630b02e1
References: <20230920080756.11919-5-nj.shetty@samsung.com>
 <20230920080756.11919-1-nj.shetty@samsung.com>
 <CGME20230920081458epcas5p3a3e12d8b5661b5d6f4420316630b02e1@epcms2p6>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 25 Sep 2023 18:36:03 +0000
Subject: Re: [dm-devel] [PATCH v16 04/12] block: add emulation for copy
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
Reply-To: j-young.choi@samsung.com
Cc: Vincent Kang Fu <vincent.fu@samsung.com>,
 "anuj1072538@gmail.com" <anuj1072538@gmail.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 SSDR Gost Dev <gost.dev@samsung.com>,
 "nitheshshetty@gmail.com" <nitheshshetty@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Anuj Gupta <anuj20.g@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 1
X-Mimecast-Originator: samsung.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

PiArc3RhdGljIHZvaWQgYmxrZGV2X2NvcHlfZW11bGF0aW9uX3dvcmsoc3RydWN0IHdvcmtfc3Ry
dWN0ICp3b3JrKQo+ICt7Cj4gK8KgIMKgIMKgIMKgIHN0cnVjdCBibGtkZXZfY29weV9lbXVsYXRp
b25faW8gKmVtdWxhdGlvbl9pbyA9IGNvbnRhaW5lcl9vZih3b3JrLAo+ICvCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBzdHJ1Y3QgYmxrZGV2X2NvcHlfZW11bGF0aW9uX2lvLCBl
bXVsYXRpb25fd29yayk7Cj4gK8KgIMKgIMKgIMKgIHN0cnVjdCBibGtkZXZfY29weV9pbyAqY2lv
ID0gZW11bGF0aW9uX2lvLT5jaW87Cj4gK8KgIMKgIMKgIMKgIHN0cnVjdCBiaW8gKnJlYWRfYmlv
LCAqd3JpdGVfYmlvOwo+ICvCoCDCoCDCoCDCoCBsb2ZmX3QgcG9zX2luID0gZW11bGF0aW9uX2lv
LT5wb3NfaW4sIHBvc19vdXQgPSBlbXVsYXRpb25faW8tPnBvc19vdXQ7Cj4gK8KgIMKgIMKgIMKg
IHNzaXplX3QgcmVtLCBjaHVuazsKPiArwqAgwqAgwqAgwqAgaW50IHJldCA9IDA7Cj4gKwo+ICvC
oCDCoCDCoCDCoCBmb3IgKHJlbSA9IGVtdWxhdGlvbl9pby0+bGVuOyByZW0gPiAwOyByZW0gLT0g
Y2h1bmspIHsKPiArwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY2h1bmsgPSBtaW5fdChpbnQsIGVt
dWxhdGlvbl9pby0+YnVmX2xlbiwgcmVtKTsKPiArCj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IHJlYWRfYmlvID0gYmlvX21hcF9idWYoZW11bGF0aW9uX2lvLT5idWYsCj4gK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZW11bGF0aW9u
X2lvLT5idWZfbGVuLAo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoGVtdWxhdGlvbl9pby0+Z2ZwKTsKPiArwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgaWYgKElTX0VSUihyZWFkX2JpbykpIHsKPiArwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgcmV0ID0gUFRSX0VSUihyZWFkX2Jpbyk7Cj4gK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJyZWFrOwo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB9
Cj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJlYWRfYmlvLT5iaV9vcGYgPSBSRVFfT1BfUkVB
RCB8IFJFUV9TWU5DOwo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBiaW9fc2V0X2RldihyZWFk
X2JpbywgZW11bGF0aW9uX2lvLT5iZGV2X2luKTsKPiArwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
cmVhZF9iaW8tPmJpX2l0ZXIuYmlfc2VjdG9yID0gcG9zX2luID4+IFNFQ1RPUl9TSElGVDsKPiAr
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmVhZF9iaW8tPmJpX2l0ZXIuYmlfc2l6ZSA9IGNodW5r
Owo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByZXQgPSBzdWJtaXRfYmlvX3dhaXQocmVhZF9i
aW8pOwo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBrZnJlZShyZWFkX2Jpbyk7CgpIaSwgTml0
ZXNoLAoKYmxrX21xX21hcF9iaW9fcHV0KHJlYWRfYmlvKT8Kb3IgYmlvX3VuaW5pdChyZWFkX2Jp
byk7IGtmcmVlKHJlYWRfYmlvKT8KCj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGlmIChyZXQp
Cj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGJyZWFrOwo+ICsKPiArwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgd3JpdGVfYmlvID0gYmlvX21hcF9idWYoZW11bGF0aW9uX2lv
LT5idWYsCj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIGVtdWxhdGlvbl9pby0+YnVmX2xlbiwKPiArwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZW11bGF0aW9uX2lvLT5n
ZnApOwo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBpZiAoSVNfRVJSKHdyaXRlX2JpbykpIHsK
PiArwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmV0ID0gUFRSX0VSUih3cml0
ZV9iaW8pOwo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBicmVhazsKPiAr
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgfQo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB3cml0
ZV9iaW8tPmJpX29wZiA9IFJFUV9PUF9XUklURSB8IFJFUV9TWU5DOwo+ICvCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCBiaW9fc2V0X2Rldih3cml0ZV9iaW8sIGVtdWxhdGlvbl9pby0+YmRldl9vdXQp
Owo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCB3cml0ZV9iaW8tPmJpX2l0ZXIuYmlfc2VjdG9y
ID0gcG9zX291dCA+PiBTRUNUT1JfU0hJRlQ7Cj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHdy
aXRlX2Jpby0+YmlfaXRlci5iaV9zaXplID0gY2h1bms7Cj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIHJldCA9IHN1Ym1pdF9iaW9fd2FpdCh3cml0ZV9iaW8pOwo+ICvCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBrZnJlZSh3cml0ZV9iaW8pOwoKYmxrX21xX21hcF9iaW9fcHV0KHdyaXRlX2Jpbykg
PwpvciBiaW9fdW5pbml0KHdyaXRlX2Jpbyk7IGtmcmVlKHdyaXRlX2Jpbyk/CgpobW0uLi4gCkl0
IGNvbnRpbnVvdXNseSBhbGxvY2F0ZXMgYW5kIHJlbGVhc2VzIG1lbW9yeSBmb3IgYmlvLApXaHkg
ZG9uJ3QgeW91IGp1c3QgYWxsb2NhdGUgYW5kIHJldXNlIGJpbyBvdXRzaWRlIHRoZSBsb29wPwoK
PiArwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgaWYgKHJldCkKPiArwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgYnJlYWs7Cj4gKwo+ICvCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBw
b3NfaW4gKz0gY2h1bms7Cj4gK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHBvc19vdXQgKz0gY2h1
bms7Cj4gK8KgIMKgIMKgIMKgIH0KPiArwqAgwqAgwqAgwqAgY2lvLT5zdGF0dXMgPSByZXQ7Cj4g
K8KgIMKgIMKgIMKgIGt2ZnJlZShlbXVsYXRpb25faW8tPmJ1Zik7Cj4gK8KgIMKgIMKgIMKgIGtm
cmVlKGVtdWxhdGlvbl9pbyk7CgpJIGhhdmUgbm90IHVzdWFsbHkgc2VlbiBhbiBpbXBsZW1lbnRh
dGlvbiB0aGF0IHJlbGVhc2VzIG1lbW9yeSBmb3IKaXRzZWxmIHdoaWxlIHBlcmZvcm1pbmcgYSB3
b3JrZXIuICggSSBkb24ndCBrbm93IHdoYXQncyByaWdodC4gOikgKQoKU2luY2UgYmxrZGV2X2Nv
cHlfZW11bGF0aW9uKCkgYWxsb2NhdGVzIG1lbW9yeSBmb3IgdGhlIGVtdWxhdGlvbiAKYW5kIHdh
aXRzIGZvciBpdCB0byBiZSBjb21wbGV0ZWQsIHdvdWxkbid0IGl0IGJlIGJldHRlciB0byBwcm9j
ZWVkCndpdGggdGhlIG1lbW9yeSByZWxlYXNlIGZvciBpdCBpbiB0aGUgc2FtZSBjb250ZXh0PwoK
VGhhdCBpcywgSU1PLCB3b3VsZG4ndCBpdCBiZSBiZXR0ZXIgdG8gZnJlZSB0aGUgbWVtb3J5IHJl
bGF0ZWQgdG8KZW11bGF0aW9uIGluIGJsa2Rldl9jb3B5X3dhaXRfaW9fY29tcGxldGlvbigpPwoK
QmVzdCBSZWdhcmRzLApKaW55b3VuZy4KCgoKCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0t
ZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3Rp
bmZvL2RtLWRldmVsCg==

