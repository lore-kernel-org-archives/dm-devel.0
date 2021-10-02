Return-Path: <SRS0=NCco=OW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D7CC433F5
	for <dm-devel@archiver.kernel.org>; Sat,  2 Oct 2021 13:44:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE83F61B06
	for <dm-devel@archiver.kernel.org>; Sat,  2 Oct 2021 13:44:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BE83F61B06
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-K2xmIcI1MNujqW9HY7KMIg-1; Sat, 02 Oct 2021 09:44:08 -0400
X-MC-Unique: K2xmIcI1MNujqW9HY7KMIg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C866C1084681;
	Sat,  2 Oct 2021 13:44:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E3DB25D9DE;
	Sat,  2 Oct 2021 13:44:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 40C211801241;
	Sat,  2 Oct 2021 13:44:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 192DhiJL027956 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 2 Oct 2021 09:43:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 87D99100CA51; Sat,  2 Oct 2021 13:43:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8328C100611F
	for <dm-devel@redhat.com>; Sat,  2 Oct 2021 13:43:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5005185A794
	for <dm-devel@redhat.com>; Sat,  2 Oct 2021 13:43:41 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-305-DF0cqez2NY-cSSymtyCbqQ-1; Sat, 02 Oct 2021 09:43:39 -0400
X-MC-Unique: DF0cqez2NY-cSSymtyCbqQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6DF6D22330;
	Sat,  2 Oct 2021 13:43:38 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3C8CC13B0F;
	Sat,  2 Oct 2021 13:43:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id GQS2DQpiWGH/IgAAMHmgww
	(envelope-from <hare@suse.de>); Sat, 02 Oct 2021 13:43:38 +0000
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <20211001181254.24056-1-xose.vazquez@gmail.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <c7566fb4-3407-7f44-4767-2742c7370a15@suse.de>
Date: Sat, 2 Oct 2021 15:43:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20211001181254.24056-1-xose.vazquez@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 192DhiJL027956
X-loop: dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>, DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH RFC] multipath-tools: remove Hannes as IBM
 arrays maintainer
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMTAvMS8yMSA4OjEyIFBNLCBYb3NlIFZhenF1ZXogUGVyZXogd3JvdGU6Cj4gQ2M6IEhhbm5l
cyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgo+IENjOiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNl
LmNvbT4KPiBDYzogQmVuamFtaW4gTWFyemluc2tpIDxibWFyemluc0ByZWRoYXQuY29tPgo+IENj
OiBDaHJpc3RvcGhlIFZhcm9xdWkgPGNocmlzdG9waGUudmFyb3F1aUBvcGVuc3ZjLmNvbT4KPiBD
YzogRE0tREVWRUwgTUwgPGRtLWRldmVsQHJlZGhhdC5jb20+Cj4gU2lnbmVkLW9mZi1ieTogWG9z
ZSBWYXpxdWV6IFBlcmV6IDx4b3NlLnZhenF1ZXpAZ21haWwuY29tPgo+IC0tLQo+ICAgbGlibXVs
dGlwYXRoL2h3dGFibGUuYyB8IDIgLS0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAyIGRlbGV0aW9ucygt
KQo+IAo+IGRpZmYgLS1naXQgYS9saWJtdWx0aXBhdGgvaHd0YWJsZS5jIGIvbGlibXVsdGlwYXRo
L2h3dGFibGUuYwo+IGluZGV4IDc2Mzk4MmNkLi4xMTI4MjY5OSAxMDA2NDQKPiAtLS0gYS9saWJt
dWx0aXBhdGgvaHd0YWJsZS5jCj4gKysrIGIvbGlibXVsdGlwYXRoL2h3dGFibGUuYwo+IEBAIC00
ODIsOCArNDgyLDYgQEAgc3RhdGljIHN0cnVjdCBod2VudHJ5IGRlZmF1bHRfaHdbXSA9IHsKPiAg
IAl9LAo+ICAgCS8qCj4gICAJICogSUJNCj4gLQkgKgo+IC0JICogTWFpbnRhaW5lcjogSGFubmVz
IFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+Cj4gICAJICovCj4gICAJewo+ICAgCQkvKiBQcm9GaWJy
ZSA0MDAwUiAqLwo+IApIbW0uIFlvdSBjb3VsZCd2ZSBhc2tlZCBtZSAuLi4KQW55d2F5LgoKUmV2
aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRlPgoKQ2hlZXJzLAoKSGFubmVz
Ci0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAgIEtlcm5lbCBTdG9yYWdlIEFy
Y2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICArNDkgOTEx
IDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJILCBNYXhmZWxkc3RyLiA1LCA5
MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcpLCBHZXNjaMOkZnRzZsO8aHJl
cjogRmVsaXggSW1lbmTDtnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVs
QHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9k
bS1kZXZlbA==

