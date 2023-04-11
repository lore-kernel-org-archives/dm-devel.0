Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CC11C76196
	for <dm-devel@archiver.kernel.org>; Tue, 11 Apr 2023 07:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681198355;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=unWZniXDFegq3KUN1DaVQiv6Hbx21Fc5dEEEkYOv7UU=;
	b=VXErkFhLpwxjKbjQiAnsUolzVB0Wz3H2Aox4sfR1arQ7z39yVTYbbQMb/zsmnpd3yDWtDA
	0OF4Z1/gqRF86JMdDS5O5dgpja8KE4eleUB9XTd3nbyOl/hgFbpHFyUtb1s7uqiinkhdca
	RL4An6f931Xs6ioxGVapNRc+BDliaWQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-pCBlr5m8O_qEbcLdd4BFxA-1; Tue, 11 Apr 2023 03:32:32 -0400
X-MC-Unique: pCBlr5m8O_qEbcLdd4BFxA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5742885C6E2;
	Tue, 11 Apr 2023 07:32:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4639514171B7;
	Tue, 11 Apr 2023 07:32:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2D8991946588;
	Tue, 11 Apr 2023 07:32:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 297031946588
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Apr 2023 07:32:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 49CAAC15BBA; Tue, 11 Apr 2023 07:32:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 429C9C15BA0
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:32:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26E9788B7A0
 for <dm-devel@redhat.com>; Tue, 11 Apr 2023 07:32:26 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-235-6XyJRDgaNUeOZznKyvBhdg-1; Tue,
 11 Apr 2023 03:32:24 -0400
X-MC-Unique: 6XyJRDgaNUeOZznKyvBhdg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 7F68F21A4F;
 Tue, 11 Apr 2023 07:32:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1B66B13638;
 Tue, 11 Apr 2023 07:32:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id LU6VBQcNNWToZgAAMHmgww
 (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:32:23 +0000
Message-ID: <0b226464-e188-d4e9-dc71-4936c39020c6@suse.de>
Date: Tue, 11 Apr 2023 09:32:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To: Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
 hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
 dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 linux-nvme@lists.infradead.org, chaitanyak@nvidia.com, kbusch@kernel.org,
 target-devel@vger.kernel.org
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-18-michael.christie@oracle.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-18-michael.christie@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v6 17/18] scsi: target: Report and detect
 unsupported PR commands
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.de
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNC83LzIzIDIyOjA1LCBNaWtlIENocmlzdGllIHdyb3RlOgo+IFRoZSBiYWNrZW5kIG1vZHVs
ZXMgZG9uJ3Qga25vdyBhYm91dCBwb3J0cyBhbmQgSV9UIG5leHVzZXMgYW5kIHRoZSBwcl9vcHMK
PiBjYWxsb3V0cyB0aGUgbW9kdWxlcyB3aWxsIHVzZSBkb24ndCBzdXBwb3J0IHRoZSBvbGQgUkVT
RVJWRS9SRUxFQVNFCj4gY29tbWFuZHMuIFRoaXMgcGF0Y2ggaGFzIHVzIHJlcG9ydCB3ZSBkb24n
dCBzdXBwb3J0IHRob3NlIHR5cGVzIG9mCj4gY29tbWFuZHMgYW5kIGZhaWwgdGhlbS4KPiAKPiBT
aWduZWQtb2ZmLWJ5OiBNaWtlIENocmlzdGllIDxtaWNoYWVsLmNocmlzdGllQG9yYWNsZS5jb20+
Cj4gLS0tCj4gICBkcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV9wci5jICB8IDE3ICsrKysrKysr
Cj4gICBkcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV9zcGMuYyB8IDc1ICsrKysrKysrKysrKysr
KysrKysrKysrLS0tLS0tLS0tCj4gICAyIGZpbGVzIGNoYW5nZWQsIDcyIGluc2VydGlvbnMoKyks
IDIwIGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1
c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAg
ICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25z
IEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJu
YmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJldwpNeWVycywgQW5kcmV3
IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsCg==

