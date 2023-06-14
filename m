Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21DBEEB64DB
	for <dm-devel@archiver.kernel.org>; Wed, 14 Jun 2023 18:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686768622;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8ag4vSCpRG0zMjOhuZotRuRqxTANCO/x4J2wQG5BkDk=;
	b=A69LNxd1stLcklTnOEvACrdDkcfNOFJNwzMTS0EPdBnjwKDOIjEiP1Ejiv/4jhHNcBd2t+
	ugygQ1cmwLDMX4LV0sV0l06zKHWKTAxQaIIlUI33vzyXZ0NVhB6rcMUoRi2lBksK1d6M9v
	iXSeWI3mwa1zxs6eE1ewh3u/QmwgmZ8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-aPrx2MceP4qRkvp5WD371g-1; Wed, 14 Jun 2023 14:50:20 -0400
X-MC-Unique: aPrx2MceP4qRkvp5WD371g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B7C229ABA0B;
	Wed, 14 Jun 2023 18:50:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 854D72166B25;
	Wed, 14 Jun 2023 18:50:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 412A419451D9;
	Wed, 14 Jun 2023 18:50:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4E8FC19451D9
 for <dm-devel@listman.corp.redhat.com>; Wed, 14 Jun 2023 18:50:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 39C4F492B06; Wed, 14 Jun 2023 18:50:05 +0000 (UTC)
Received: from agk-cloud1.hosts.prod.upshift.rdu2.redhat.com
 (agk-cloud1.hosts.prod.upshift.rdu2.redhat.com [10.0.13.154])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 21299492C1B;
 Wed, 14 Jun 2023 18:50:04 +0000 (UTC)
Received: by agk-cloud1.hosts.prod.upshift.rdu2.redhat.com (Postfix,
 from userid 3883)
 id 885E74043A65; Wed, 14 Jun 2023 19:48:41 +0100 (BST)
Date: Wed, 14 Jun 2023 19:48:41 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: baomingtong001@208suo.com
Message-ID: <20230614184841.GB63706@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
Mail-Followup-To: baomingtong001@208suo.com,
 Alasdair G Kergon <agk@redhat.com>, snitzer <snitzer@kernel.org>,
 dm-devel <dm-devel@redhat.com>,
 linux-kernel <linux-kernel@vger.kernel.org>
References: <202306141008237478337@208suo.com>
 <20230614024228.GA63706@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
 <a78b787e3c45de04df95c80dfc2aa511@208suo.com>
MIME-Version: 1.0
In-Reply-To: <a78b787e3c45de04df95c80dfc2aa511@208suo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH] dm: remove unneeded variable
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
Cc: dm-devel <dm-devel@redhat.com>, snitzer <snitzer@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gV2VkLCBKdW4gMTQsIDIwMjMgYXQgMTE6MTI6MTlBTSArMDgwMCwgYmFvbWluZ3RvbmcwMDFA
MjA4c3VvLmNvbSB3cm90ZToKPiAgICDlnKggMjAyMy0wNi0xNCAxMDo0Mu+8jEFsYXNkYWlyIEcg
S2VyZ29uIOWGmemBk++8mgo+ID4gICAgICBEaWQgdGhlIHBhdGNoZWQgY29kZSBjb21waWxlIE9L
IGZvciB5b3U/Cgo+ICAgIFllcyEKIApTbyB3aGF0IGlzIHRoZSBkZWZpbml0aW9uIG9mIERNRU1J
VCB0aGF0IHlvdXIgY29tcGlsZXIgdXNlcyBhbmQgd2h5PwoKQWxhc2RhaXIKCi0tCmRtLWRldmVs
IG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQu
Y29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

