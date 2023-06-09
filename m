Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B407C7EE25
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 06:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686292801;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VIdMR7YmebOd30F41OY2gO0/GbUwA4DEVjbCtW0m2tQ=;
	b=hXgpdXlqjDyD5evifmR7hPyWQ/txq1aSLYnXsQSwgrPDP83VacMhC8D+rgOZES5pSnjG60
	wgzXItjLBQVDJt4HNL1XeMV1nfRE1I19y7d7dlOPjGtZR/Xi2jkzUrj/DygT1l+3WV5tUa
	u9Egb6XmSQE8O13CZ5zZHazVQg4CCSY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-389-3pU11r1wPuOFjDZr49BZFw-1; Fri, 09 Jun 2023 02:39:57 -0400
X-MC-Unique: 3pU11r1wPuOFjDZr49BZFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4358F8039C9;
	Fri,  9 Jun 2023 06:39:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A7D42166B25;
	Fri,  9 Jun 2023 06:39:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AD2B119451C0;
	Fri,  9 Jun 2023 06:39:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8B7EE194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 06:39:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7A21E515540; Fri,  9 Jun 2023 06:39:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7248F492B00
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 06:39:54 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 539BD3847087
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 06:39:54 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-426-UYZesx8kNzqpOvWugcneJQ-1; Fri,
 09 Jun 2023 02:39:46 -0400
X-MC-Unique: UYZesx8kNzqpOvWugcneJQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id EBA0E1FDF0
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 06:39:44 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DB4F3139C8
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 06:39:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id GNI7NDDJgmQQOAAAMHmgww
 (envelope-from <hare@suse.de>)
 for <dm-devel@redhat.com>; Fri, 09 Jun 2023 06:39:44 +0000
Message-ID: <b5068c7b-a2a9-3273-7e7e-867278caf1d0@suse.de>
Date: Fri, 9 Jun 2023 08:39:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: dm-devel@redhat.com
References: <20230608110258.189493-1-hch@lst.de>
 <20230608110258.189493-28-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230608110258.189493-28-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 27/30] block: replace fmode_t with a
 block-specific type for block open flags
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNi84LzIzIDEzOjAyLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBUaGUgb25seSBvdmVy
bGFwIGJldHdlZW4gdGhlIGJsb2NrIG9wZW4gZmxhZ3MgbWFwcGVkIGludG8gdGhlIGZtb2RlX3Qg
YW5kCj4gb3RoZXIgdXNlcyBvZiBmbW9kZV90IGFyZSBGTU9ERV9SRUFEIGFuZCBGTU9ERV9XUklU
RS4gIERlZmluZSBhIG5ldwo+IGJsa19tb2RlX3QgaW5zdGVhZCBmb3IgdXNlIGluIGJsa2Rldl9n
ZXRfYnlfe2RldixwYXRofSwgLT5vcGVuIGFuZAo+IC0+aW9jdGwgYW5kIHN0b3AgYWJ1c2luZyBm
bW9kZV90Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRl
Pgo+IEFja2VkLWJ5OiBKYWNrIFdhbmcgPGppbnB1LndhbmdAaW9ub3MuY29tPgkJW3JuYmRdCj4g
LS0tCj4gICBhcmNoL3VtL2RyaXZlcnMvdWJkX2tlcm4uYyAgICAgICAgICB8ICA4ICsrKy0tLQo+
ICAgYXJjaC94dGVuc2EvcGxhdGZvcm1zL2lzcy9zaW1kaXNrLmMgfCAgMiArLQo+ICAgYmxvY2sv
YmRldi5jICAgICAgICAgICAgICAgICAgICAgICAgfCAzMiArKysrKysrKysrKy0tLS0tLS0tLS0t
Cj4gICBibG9jay9ibGstem9uZWQuYyAgICAgICAgICAgICAgICAgICB8ICA4ICsrKy0tLQo+ICAg
YmxvY2svYmxrLmggICAgICAgICAgICAgICAgICAgICAgICAgfCAxMSArKysrLS0tLQo+ICAgYmxv
Y2svZm9wcy5jICAgICAgICAgICAgICAgICAgICAgICAgfCAzMiArKysrKysrKysrKysrKysrKy0t
LS0tCj4gICBibG9jay9nZW5oZC5jICAgICAgICAgICAgICAgICAgICAgICB8ICA4ICsrKy0tLQo+
ICAgYmxvY2svaW9jdGwuYyAgICAgICAgICAgICAgICAgICAgICAgfCA0MiArKysrKysrKystLS0t
LS0tLS0tLS0tLS0tLS0tLQo+ICAgZHJpdmVycy9ibG9jay9hbWlmbG9wLmMgICAgICAgICAgICAg
fCAxMiArKysrLS0tLS0KPiAgIGRyaXZlcnMvYmxvY2svYW9lL2FvZWJsay5jICAgICAgICAgIHwg
IDQgKy0tCj4gICBkcml2ZXJzL2Jsb2NrL2F0YWZsb3AuYyAgICAgICAgICAgICB8IDI1ICsrKysr
KysrKy0tLS0tLS0tCj4gICBkcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9tYWluLmMgICAgICB8ICA3
ICsrLS0tCj4gICBkcml2ZXJzL2Jsb2NrL2RyYmQvZHJiZF9ubC5jICAgICAgICB8ICAyICstCj4g
ICBkcml2ZXJzL2Jsb2NrL2Zsb3BweS5jICAgICAgICAgICAgICB8IDI4ICsrKysrKysrKy0tLS0t
LS0tLS0KPiAgIGRyaXZlcnMvYmxvY2svbG9vcC5jICAgICAgICAgICAgICAgIHwgMjIgKysrKysr
Ky0tLS0tLS0tCj4gICBkcml2ZXJzL2Jsb2NrL210aXAzMnh4L210aXAzMnh4LmMgICB8ICA0ICst
LQo+ICAgZHJpdmVycy9ibG9jay9uYmQuYyAgICAgICAgICAgICAgICAgfCAgNCArLS0KPiAgIGRy
aXZlcnMvYmxvY2svcGt0Y2R2ZC5jICAgICAgICAgICAgIHwgMTcgKysrKysrLS0tLS0tCj4gICBk
cml2ZXJzL2Jsb2NrL3JiZC5jICAgICAgICAgICAgICAgICB8ICAyICstCj4gICBkcml2ZXJzL2Js
b2NrL3JuYmQvcm5iZC1jbHQuYyAgICAgICB8ICA0ICstLQo+ICAgZHJpdmVycy9ibG9jay9ybmJk
L3JuYmQtc3J2LmMgICAgICAgfCAgNCArLS0KPiAgIGRyaXZlcnMvYmxvY2svc3VudmRjLmMgICAg
ICAgICAgICAgIHwgIDIgKy0KPiAgIGRyaXZlcnMvYmxvY2svc3dpbS5jICAgICAgICAgICAgICAg
IHwgMTYgKysrKystLS0tLS0KPiAgIGRyaXZlcnMvYmxvY2svc3dpbTMuYyAgICAgICAgICAgICAg
IHwgMjQgKysrKysrKystLS0tLS0tLS0KPiAgIGRyaXZlcnMvYmxvY2svdWJsa19kcnYuYyAgICAg
ICAgICAgIHwgIDIgKy0KPiAgIGRyaXZlcnMvYmxvY2sveGVuLWJsa2JhY2sveGVuYnVzLmMgIHwg
IDIgKy0KPiAgIGRyaXZlcnMvYmxvY2sveGVuLWJsa2Zyb250LmMgICAgICAgIHwgIDIgKy0KPiAg
IGRyaXZlcnMvYmxvY2svejJyYW0uYyAgICAgICAgICAgICAgIHwgIDIgKy0KPiAgIGRyaXZlcnMv
YmxvY2svenJhbS96cmFtX2Rydi5jICAgICAgIHwgIDYgKystLS0KPiAgIGRyaXZlcnMvY2Ryb20v
Y2Ryb20uYyAgICAgICAgICAgICAgIHwgIDYgKystLS0KPiAgIGRyaXZlcnMvY2Ryb20vZ2Ryb20u
YyAgICAgICAgICAgICAgIHwgIDQgKy0tCj4gICBkcml2ZXJzL21kL2JjYWNoZS9iY2FjaGUuaCAg
ICAgICAgICB8ICAyICstCj4gICBkcml2ZXJzL21kL2JjYWNoZS9yZXF1ZXN0LmMgICAgICAgICB8
ICA0ICstLQo+ICAgZHJpdmVycy9tZC9iY2FjaGUvc3VwZXIuYyAgICAgICAgICAgfCAgNiArKy0t
LQo+ICAgZHJpdmVycy9tZC9kbS1jYWNoZS10YXJnZXQuYyAgICAgICAgfCAxMiArKysrLS0tLS0K
PiAgIGRyaXZlcnMvbWQvZG0tY2xvbmUtdGFyZ2V0LmMgICAgICAgIHwgMTAgKysrLS0tLQo+ICAg
ZHJpdmVycy9tZC9kbS1jb3JlLmggICAgICAgICAgICAgICAgfCAgNyArKystLQo+ICAgZHJpdmVy
cy9tZC9kbS1lcmEtdGFyZ2V0LmMgICAgICAgICAgfCAgNiArKystLQo+ICAgZHJpdmVycy9tZC9k
bS1pb2N0bC5jICAgICAgICAgICAgICAgfCAxMCArKystLS0tCj4gICBkcml2ZXJzL21kL2RtLXNu
YXAuYyAgICAgICAgICAgICAgICB8ICA0ICstLQo+ICAgZHJpdmVycy9tZC9kbS10YWJsZS5jICAg
ICAgICAgICAgICAgfCAxMSArKysrLS0tLQo+ICAgZHJpdmVycy9tZC9kbS10aGluLmMgICAgICAg
ICAgICAgICAgfCAgOSArKysrLS0tCj4gICBkcml2ZXJzL21kL2RtLXZlcml0eS1mZWMuYyAgICAg
ICAgICB8ICAyICstCj4gICBkcml2ZXJzL21kL2RtLXZlcml0eS10YXJnZXQuYyAgICAgICB8ICA2
ICsrLS0tCj4gICBkcml2ZXJzL21kL2RtLmMgICAgICAgICAgICAgICAgICAgICB8IDEwICsrKy0t
LS0KPiAgIGRyaXZlcnMvbWQvZG0uaCAgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0KPiAgIGRy
aXZlcnMvbWQvbWQuYyAgICAgICAgICAgICAgICAgICAgIHwgIDggKysrLS0tCj4gICBkcml2ZXJz
L21tYy9jb3JlL2Jsb2NrLmMgICAgICAgICAgICB8ICA4ICsrKy0tLQo+ICAgZHJpdmVycy9tdGQv
ZGV2aWNlcy9ibG9jazJtdGQuYyAgICAgfCAgNCArLS0KPiAgIGRyaXZlcnMvbXRkL210ZF9ibGtk
ZXZzLmMgICAgICAgICAgIHwgIDQgKy0tCj4gICBkcml2ZXJzL210ZC91YmkvYmxvY2suYyAgICAg
ICAgICAgICB8ICA1ICsrLS0KPiAgIGRyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYyAgICAgICAgICAg
IHwgIDIgKy0KPiAgIGRyaXZlcnMvbnZtZS9ob3N0L2lvY3RsLmMgICAgICAgICAgIHwgIDggKysr
LS0tCj4gICBkcml2ZXJzL252bWUvaG9zdC9tdWx0aXBhdGguYyAgICAgICB8ICAyICstCj4gICBk
cml2ZXJzL252bWUvaG9zdC9udm1lLmggICAgICAgICAgICB8ICA0ICstLQo+ICAgZHJpdmVycy9u
dm1lL3RhcmdldC9pby1jbWQtYmRldi5jICAgfCAgMiArLQo+ICAgZHJpdmVycy9zMzkwL2Jsb2Nr
L2Rhc2QuYyAgICAgICAgICAgfCAgNiArKy0tLQo+ICAgZHJpdmVycy9zMzkwL2Jsb2NrL2Rhc2Rf
Z2VuaGQuYyAgICAgfCAgMyArKy0KPiAgIGRyaXZlcnMvczM5MC9ibG9jay9kYXNkX2ludC5oICAg
ICAgIHwgIDMgKystCj4gICBkcml2ZXJzL3MzOTAvYmxvY2svZGFzZF9pb2N0bC5jICAgICB8ICAy
ICstCj4gICBkcml2ZXJzL3MzOTAvYmxvY2svZGNzc2Jsay5jICAgICAgICB8ICA0ICstLQo+ICAg
ZHJpdmVycy9zY3NpL3NkLmMgICAgICAgICAgICAgICAgICAgfCAxOSArKysrKystLS0tLS0tCj4g
ICBkcml2ZXJzL3Njc2kvc3IuYyAgICAgICAgICAgICAgICAgICB8IDEwICsrKy0tLS0KPiAgIGRy
aXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX2libG9jay5jIHwgIDUgKystLQo+ICAgZHJpdmVycy90
YXJnZXQvdGFyZ2V0X2NvcmVfcHNjc2kuYyAgfCAgNCArLS0KPiAgIGZzL2J0cmZzL2Rldi1yZXBs
YWNlLmMgICAgICAgICAgICAgIHwgIDIgKy0KPiAgIGZzL2J0cmZzL3N1cGVyLmMgICAgICAgICAg
ICAgICAgICAgIHwgIDggKysrLS0tCj4gICBmcy9idHJmcy92b2x1bWVzLmMgICAgICAgICAgICAg
ICAgICB8IDE2ICsrKysrLS0tLS0tCj4gICBmcy9idHJmcy92b2x1bWVzLmggICAgICAgICAgICAg
ICAgICB8ICA0ICstLQo+ICAgZnMvZXJvZnMvc3VwZXIuYyAgICAgICAgICAgICAgICAgICAgfCAg
MiArLQo+ICAgZnMvZXh0NC9zdXBlci5jICAgICAgICAgICAgICAgICAgICAgfCAgMiArLQo+ICAg
ZnMvZjJmcy9zdXBlci5jICAgICAgICAgICAgICAgICAgICAgfCAgMiArLQo+ICAgZnMvamZzL2pm
c19sb2dtZ3IuYyAgICAgICAgICAgICAgICAgfCAgMiArLQo+ICAgZnMvbmZzL2Jsb2NrbGF5b3V0
L2Rldi5jICAgICAgICAgICAgfCAgNSArKy0tCj4gICBmcy9vY2ZzMi9jbHVzdGVyL2hlYXJ0YmVh
dC5jICAgICAgICB8ICAzICsrLQo+ICAgZnMvcmVpc2VyZnMvam91cm5hbC5jICAgICAgICAgICAg
ICAgfCAgNCArLS0KPiAgIGZzL3hmcy94ZnNfc3VwZXIuYyAgICAgICAgICAgICAgICAgIHwgIDIg
Ky0KPiAgIGluY2x1ZGUvbGludXgvYmxrZGV2LmggICAgICAgICAgICAgIHwgMzAgKysrKysrKysr
KysrKysrKy0tLS0tCj4gICBpbmNsdWRlL2xpbnV4L2Nkcm9tLmggICAgICAgICAgICAgICB8ICAz
ICsrLQo+ICAgaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmggICAgICAgfCAgOCArKystLS0K
PiAgIGtlcm5lbC9wb3dlci9zd2FwLmMgICAgICAgICAgICAgICAgIHwgIDYgKystLS0KPiAgIG1t
L3N3YXBmaWxlLmMgICAgICAgICAgICAgICAgICAgICAgIHwgIDIgKy0KPiAgIDgyIGZpbGVzIGNo
YW5nZWQsIDMzNCBpbnNlcnRpb25zKCspLCAzMTUgZGVsZXRpb25zKC0pCj4gClJldmlld2VkLWJ5
OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4KCkNoZWVycywKCkhhbm5lcwotLSAKRHIu
IEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJuZWwgU3RvcmFnZSBBcmNoaXRlY3QK
aGFyZUBzdXNlLmRlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2
ODgKU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8
cm5iZXJnCkhSQiAzNjgwOSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBU
b3RldiwgQW5kcmV3Ck15ZXJzLCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJt
YW4KCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8v
bGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

