Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0BEDE936ED
	for <dm-devel@archiver.kernel.org>; Thu,  5 Oct 2023 03:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696477351;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pImdE1PpDRFyMx7CEhIqn+//va8JC+VbCWr4oA1Uu+Y=;
	b=IbKGDPkb7uBCqowND53dZpA+o/rLsF3HbBNTNtSLnUyRrlasq/RR3GAwjGOzCHjU4N3sNE
	ugvlOZdOd5errWO4cP4CeR+mqL71ox9SP5+w8n5SCAnDgukOhXzKFpTmxO91/HSrfmta7+
	ndsJzTgjv52kRr5OS7EdbDUNBWAJ+j0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-vsjrBZ3bMQiNOR9LY-cqqg-1; Wed, 04 Oct 2023 23:42:28 -0400
X-MC-Unique: vsjrBZ3bMQiNOR9LY-cqqg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1458C858280;
	Thu,  5 Oct 2023 03:42:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C380C2026D4B;
	Thu,  5 Oct 2023 03:42:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 55E411946597;
	Thu,  5 Oct 2023 03:42:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B3127194658F
 for <dm-devel@listman.corp.redhat.com>; Thu,  5 Oct 2023 03:42:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6287F4026FC; Thu,  5 Oct 2023 03:42:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AAA0442CAD
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 03:42:24 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25E4938210A2
 for <dm-devel@redhat.com>; Thu,  5 Oct 2023 03:42:24 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-Jixir1X6OzmfZk6jOefBXw-1; Wed, 04 Oct 2023 23:42:19 -0400
X-MC-Unique: Jixir1X6OzmfZk6jOefBXw-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4S1HS06l7Dz4f3kj7;
 Thu,  5 Oct 2023 11:42:08 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
 by APP4 (Coremail) with SMTP id gCh0CgB3Dt6QMB5lq7emCA--.6724S3;
 Thu, 05 Oct 2023 11:42:10 +0800 (CST)
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
 <CAPhsuW5cUgqy9fqj+Z4nGPQrAok-eQ=NipNxb0TL_kuCFaPMcw@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f59cbb99-33dd-c427-2e43-5a07ab9fbf51@huaweicloud.com>
Date: Thu, 5 Oct 2023 11:42:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5cUgqy9fqj+Z4nGPQrAok-eQ=NipNxb0TL_kuCFaPMcw@mail.gmail.com>
X-CM-TRANSID: gCh0CgB3Dt6QMB5lq7emCA--.6724S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AF4xAr43Ww4UGFy8AryxKrg_yoW8AF17p3
 43Jr45Grs5JrnrGw1xG3yrZF1rAa93WFyDGr98Gry2k3y5uFy2ga48Kw4F9ryDW3Z3uw1I
 q3WjyF9rZ3Wjya7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
 6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
 c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
 AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
 17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
 IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3
 Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
 sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH -next v3 00/25] md: synchronize io with array
 reconfiguration
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 xni@redhat.com, "yukuai \(C\)" <yukuai3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

SGksCgrlnKggMjAyMy8wOS8yOSAzOjE1LCBTb25nIExpdSDlhpnpgZM6Cj4gSGkgS3VhaSwKPiAK
PiBUaGFua3MgZm9yIHRoZSBwYXRjaHNldCEKPiAKPiBBIGZldyBoaWdoIGxldmVsIHF1ZXN0aW9u
cy9zdWdnZXN0aW9uczoKClRoYW5rcyBhIGxvdCBmb3IgdGhlc2UhCj4gCj4gMS4gVGhpcyBpcyBh
IGJpZyBjaGFuZ2UgdGhhdCBuZWVkcyBhIGxvdCBvZiBleHBsYW5hdGlvbi4gV2hpbGUgeW91IG1h
bmFnZWQgdG8KPiBrZWVwIGVhY2ggcGF0Y2ggcmVsYXRpdmVseSBzbWFsbCAoZ3JlYXQgam9iIGJ0
dyksIGl0IGlzIG5vdCB2ZXJ5IGNsZWFyIHdoeSB3ZQo+IG5lZWQgdGhlc2UgY2hhbmdlcy4gU3Bl
Y2lmaWNhbGx5LCB3ZSBhcmUgYWRkaW5nIGEgbmV3IG11dGV4LCBpdCBpcyB3b3J0aAo+IG1lbnRp
b25pbmcgd2h5IHdlIGNhbm5vdCBhY2hpZXZlIHRoZSBzYW1lIGdvYWwgd2l0aG91dCBpdC4gUGxl
YXNlIGFkZAo+IG1vcmUgaW5mb3JtYXRpb24gaW4gdGhlIGNvdmVyIGxldHRlci4gV2Ugd2lsbCBw
dXQgcGFydCBvZiB0aGUgY292ZXIgbGV0dGVyIGluCj4gdGhlIG1lcmdlIGNvbW1pdC4KClllYWgs
IEkgcmVhbGl6ZSB0aGF0IEkgZXhwbGFpbiB0b28gbGl0dGxlLiBJIHdpbGwgYWRkIGJhY2tncm91
bmQgYW5kCmRlc2lnbi4KPiAKPiAyLiBJbiB0aGUgY292ZXIgbGV0dGVyLCBwbGVhc2UgYWxzbyBo
aWdobGlnaHQgdGhhdCB3ZSBhcmUgcmVtb3ZpbmcKPiAgIE1EX0FMTE9XX1NCX1VQREFURSBhbmQg
TURfVVBEQVRJTkdfU0IuIFRoaXMgaXMgYSBiaWcgaW1wcm92ZW1lbnQuCj4gCgpPa2F5Lgo+IDMu
IFBsZWFzZSByZWFycmFuZ2UgdGhlIHBhdGNoIHNldCBzbyB0aGF0IHRoZSB0d28gIlJFQURfT05D
RS9XUklURV9PTkNFIgo+IHBhdGNoZXMgYXJlIGF0IHRoZSBiZWdpbm5pbmcuCgpPa2F5Lgo+IAo+
IDQuIFBsZWFzZSBjb25zaWRlciBtZXJnaW5nIHNvbWUgcGF0Y2hlcy4gQ3VycmVudCAiYWRkLWFw
aSA9PiB1c2UtYXBpID0+Cj4gcmVtb3ZlLW9sZC1hcGkiIG1ha2VzIGl0IHRyaWNreSB0byBmb2xs
b3cgd2hhdCBpcyBiZWluZyBjaGFuZ2VkLiBGb3IgdGhpcyBzZXQsCj4gSSBmb3VuZCB0aGUgZGlm
ZiBvZiB0aGUgd2hvbGUgc2V0IGVhc2llciB0byBmb2xsb3cgdGhhbiBzb21lIG9mIHRoZSBiaWcg
cGF0Y2hlcy4KSSByZWZlciB0byBzb21lIG90aGVyIGJpZyBwYXRjaHNldCB0byByZXBsYWNlIGFu
IG9sZCBhcGksIGZvciBleGFtcGxlOgoKaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjMw
ODE4MTIzMjMyLjIyNjktMS1qYWNrQHN1c2UuY3ovCgpDdXJyZW50bHkgSSBwcmVmZXIgdG8gdXNl
IG9uZSBwYXRjaCBmb3IgZWFjaCBmdW5jdGlvbiBwb2ludC4gQW5kIEkgZG8KbWVyZ2VkIHNvbWUg
cGF0Y2hlcyBpbiB0aGlzIHZlcnNpb24sIGFuZCBmb3IgcmVtYWluaW5nIHBhdGNoZXMsIGRvIHlv
dQpwcmVmZXIgdG8gdXNlIG9uZSBwYXRjaCBmb3Igb25lIGZpbGUgaW5zdGVhZCBvZiBvbmUgZnVu
Y3Rpb24gcG9pbnQ/KEZvcgpleGFtcGxlLCBtZXJnZSBwYXRjaCAxMC0xMiBmb3IgbWQvcmFpZDUt
Y2FjaGUsIGFuZCAxMy0xNiBmb3IgbWQvcmFpZDUpLgoKVGhhbmtzLApLdWFpCgo+IAo+IFRoYW5r
cyBhZ2FpbiBmb3IgeW91ciBoYXJkIHdvcmsgaW50byB0aGlzIQo+IFNvbmcKPiAKPiBPbiBXZWQs
IFNlcCAyNywgMjAyMyBhdCAxMToyMuKAr1BNIFl1IEt1YWkgPHl1a3VhaTFAaHVhd2VpY2xvdWQu
Y29tPiB3cm90ZToKPj4KPj4gRnJvbTogWXUgS3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPgo+IFsu
Li5dCj4gLgo+IAoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20K
aHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

