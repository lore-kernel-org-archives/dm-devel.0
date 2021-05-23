Return-Path: <SRS0=zCJ6=KS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E7EC4707A
	for <dm-devel@archiver.kernel.org>; Sun, 23 May 2021 07:59:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 02CC861205
	for <dm-devel@archiver.kernel.org>; Sun, 23 May 2021 07:59:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02CC861205
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-QelYNmWONEWPA9fn4A1fiw-1; Sun, 23 May 2021 03:59:03 -0400
X-MC-Unique: QelYNmWONEWPA9fn4A1fiw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3063180FD66;
	Sun, 23 May 2021 07:58:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C2D286E6F9;
	Sun, 23 May 2021 07:58:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 441A844A63;
	Sun, 23 May 2021 07:58:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14N7wuOb027909 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 23 May 2021 03:58:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CD6E9200BA94; Sun, 23 May 2021 07:58:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C91B5200D8C2
	for <dm-devel@redhat.com>; Sun, 23 May 2021 07:58:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EDA31857F1E
	for <dm-devel@redhat.com>; Sun, 23 May 2021 07:58:54 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-105-GG4tpJXDMBm-Spsw743s0w-1;
	Sun, 23 May 2021 03:58:51 -0400
X-MC-Unique: GG4tpJXDMBm-Spsw743s0w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id C6046AB6D;
	Sun, 23 May 2021 07:58:49 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>, Jim Paris <jim@jtan.com>,
	Joshua Morris <josh.h.morris@us.ibm.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>
References: <20210521055116.1053587-1-hch@lst.de>
	<20210521055116.1053587-7-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <83fc5cdc-53ed-0bd3-fbe8-93d0afd20771@suse.de>
Date: Sun, 23 May 2021 09:58:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-7-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14N7wuOb027909
X-loop: dm-devel@redhat.com
Cc: linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] [PATCH 06/26] brd: convert to
	blk_alloc_disk/blk_cleanup_disk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNS8yMS8yMSA3OjUwIEFNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiBDb252ZXJ0IHRo
ZSBicmQgZHJpdmVyIHRvIHVzZSB0aGUgYmxrX2FsbG9jX2Rpc2sgYW5kIGJsa19jbGVhbnVwX2Rp
c2sKPiBoZWxwZXJzIHRvIHNpbXBsaWZ5IGdlbmRpc2sgYW5kIHJlcXVlc3RfcXVldWUgYWxsb2Nh
dGlvbi4gIFRoaXMgYWxzbwo+IGFsbG93cyB0byByZW1vdmUgdGhlIHJlcXVlc3RfcXVldWUgcG9p
bnRlciBpbiBzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSwKPiBhbmQgdG8gc2ltcGxpZnkgdGhlIGluaXRp
YWxpemF0aW9uIGFzIGJsa19jbGVhbnVwX2Rpc2sgY2FuIGJlIGNhbGxlZAo+IG9uIGFueSBkaXNr
IHJldHVybmVkIGZyb20gYmxrX2FsbG9jX2Rpc2suCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0
b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gLS0tCj4gICBkcml2ZXJzL2Jsb2NrL2JyZC5jIHwg
OTQgKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCj4gICAxIGZp
bGUgY2hhbmdlZCwgMzMgaW5zZXJ0aW9ucygrKSwgNjEgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvYmxvY2svYnJkLmMgYi9kcml2ZXJzL2Jsb2NrL2JyZC5jCj4gaW5kZXgg
NzU2MmNmMzBiMTRlLi45NTY5NDExM2UzOGUgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVycy9ibG9jay9i
cmQuYwo+ICsrKyBiL2RyaXZlcnMvYmxvY2svYnJkLmMKPiBAQCAtMzgsOSArMzgsNyBAQAo+ICAg
ICogZGV2aWNlKS4KPiAgICAqLwo+ICAgc3RydWN0IGJyZF9kZXZpY2Ugewo+IC0JaW50CQlicmRf
bnVtYmVyOwo+IC0KPiAtCXN0cnVjdCByZXF1ZXN0X3F1ZXVlCSpicmRfcXVldWU7Cj4gKwlpbnQJ
CQlicmRfbnVtYmVyOwo+ICAgCXN0cnVjdCBnZW5kaXNrCQkqYnJkX2Rpc2s7Cj4gICAJc3RydWN0
IGxpc3RfaGVhZAlicmRfbGlzdDsKPiAgIAo+IEBAIC0zNzIsNyArMzcwLDcgQEAgc3RhdGljIExJ
U1RfSEVBRChicmRfZGV2aWNlcyk7Cj4gICBzdGF0aWMgREVGSU5FX01VVEVYKGJyZF9kZXZpY2Vz
X211dGV4KTsKPiAgIHN0YXRpYyBzdHJ1Y3QgZGVudHJ5ICpicmRfZGVidWdmc19kaXI7Cj4gICAK
PiAtc3RhdGljIHN0cnVjdCBicmRfZGV2aWNlICpicmRfYWxsb2MoaW50IGkpCj4gK3N0YXRpYyBp
bnQgYnJkX2FsbG9jKGludCBpKQo+ICAgewo+ICAgCXN0cnVjdCBicmRfZGV2aWNlICpicmQ7Cj4g
ICAJc3RydWN0IGdlbmRpc2sgKmRpc2s7Cj4gQEAgLTM4MCw2NCArMzc4LDU1IEBAIHN0YXRpYyBz
dHJ1Y3QgYnJkX2RldmljZSAqYnJkX2FsbG9jKGludCBpKQo+ICAgCj4gICAJYnJkID0ga3phbGxv
YyhzaXplb2YoKmJyZCksIEdGUF9LRVJORUwpOwo+ICAgCWlmICghYnJkKQo+IC0JCWdvdG8gb3V0
Owo+ICsJCXJldHVybiAtRU5PTUVNOwo+ICAgCWJyZC0+YnJkX251bWJlcgkJPSBpOwo+ICAgCXNw
aW5fbG9ja19pbml0KCZicmQtPmJyZF9sb2NrKTsKPiAgIAlJTklUX1JBRElYX1RSRUUoJmJyZC0+
YnJkX3BhZ2VzLCBHRlBfQVRPTUlDKTsKPiAgIAo+IC0JYnJkLT5icmRfcXVldWUgPSBibGtfYWxs
b2NfcXVldWUoTlVNQV9OT19OT0RFKTsKPiAtCWlmICghYnJkLT5icmRfcXVldWUpCj4gLQkJZ290
byBvdXRfZnJlZV9kZXY7Cj4gLQo+ICAgCXNucHJpbnRmKGJ1ZiwgRElTS19OQU1FX0xFTiwgInJh
bSVkIiwgaSk7Cj4gICAJaWYgKCFJU19FUlJfT1JfTlVMTChicmRfZGVidWdmc19kaXIpKQo+ICAg
CQlkZWJ1Z2ZzX2NyZWF0ZV91NjQoYnVmLCAwNDQ0LCBicmRfZGVidWdmc19kaXIsCj4gICAJCQkJ
JmJyZC0+YnJkX25yX3BhZ2VzKTsKPiAgIAo+IC0JLyogVGhpcyBpcyBzbyBmZGlzayB3aWxsIGFs
aWduIHBhcnRpdGlvbnMgb24gNGssIGJlY2F1c2Ugb2YKPiAtCSAqIGRpcmVjdF9hY2Nlc3MgQVBJ
IG5lZWRpbmcgNGsgYWxpZ25tZW50LCByZXR1cm5pbmcgYSBQRk4KPiAtCSAqIChUaGlzIGlzIG9u
bHkgYSBwcm9ibGVtIG9uIHZlcnkgc21hbGwgZGV2aWNlcyA8PSA0TSwKPiAtCSAqICBvdGhlcndp
c2UgZmRpc2sgd2lsbCBhbGlnbiBvbiAxTS4gUmVnYXJkbGVzcyB0aGlzIGNhbGwKPiAtCSAqICBp
cyBoYXJtbGVzcykKPiAtCSAqLwo+IC0JYmxrX3F1ZXVlX3BoeXNpY2FsX2Jsb2NrX3NpemUoYnJk
LT5icmRfcXVldWUsIFBBR0VfU0laRSk7Cj4gLQlkaXNrID0gYnJkLT5icmRfZGlzayA9IGFsbG9j
X2Rpc2sobWF4X3BhcnQpOwo+ICsJZGlzayA9IGJyZC0+YnJkX2Rpc2sgPSBibGtfYWxsb2NfZGlz
ayhOVU1BX05PX05PREUpOwo+ICAgCWlmICghZGlzaykKPiAtCQlnb3RvIG91dF9mcmVlX3F1ZXVl
Owo+ICsJCWdvdG8gb3V0X2ZyZWVfZGV2Owo+ICsKPiAgIAlkaXNrLT5tYWpvcgkJPSBSQU1ESVNL
X01BSk9SOwo+ICAgCWRpc2stPmZpcnN0X21pbm9yCT0gaSAqIG1heF9wYXJ0Owo+ICsJZGlzay0+
bWlub3JzCQk9IG1heF9wYXJ0Owo+ICAgCWRpc2stPmZvcHMJCT0gJmJyZF9mb3BzOwo+ICAgCWRp
c2stPnByaXZhdGVfZGF0YQk9IGJyZDsKPiAgIAlkaXNrLT5mbGFncwkJPSBHRU5IRF9GTF9FWFRf
REVWVDsKPiAgIAlzdHJsY3B5KGRpc2stPmRpc2tfbmFtZSwgYnVmLCBESVNLX05BTUVfTEVOKTsK
PiAgIAlzZXRfY2FwYWNpdHkoZGlzaywgcmRfc2l6ZSAqIDIpOwo+ICsJCj4gKwkvKgo+ICsJICog
VGhpcyBpcyBzbyBmZGlzayB3aWxsIGFsaWduIHBhcnRpdGlvbnMgb24gNGssIGJlY2F1c2Ugb2YK
PiArCSAqIGRpcmVjdF9hY2Nlc3MgQVBJIG5lZWRpbmcgNGsgYWxpZ25tZW50LCByZXR1cm5pbmcg
YSBQRk4KPiArCSAqIChUaGlzIGlzIG9ubHkgYSBwcm9ibGVtIG9uIHZlcnkgc21hbGwgZGV2aWNl
cyA8PSA0TSwKPiArCSAqICBvdGhlcndpc2UgZmRpc2sgd2lsbCBhbGlnbiBvbiAxTS4gUmVnYXJk
bGVzcyB0aGlzIGNhbGwKPiArCSAqICBpcyBoYXJtbGVzcykKPiArCSAqLwo+ICsJYmxrX3F1ZXVl
X3BoeXNpY2FsX2Jsb2NrX3NpemUoZGlzay0+cXVldWUsIFBBR0VfU0laRSk7Cj4gICAKCk1heWJl
IGNvbnZlcnRpbmcgdGhlIGNvbW1lbnQgdG8gcmVmZXIgdG8gJ1BBR0VfU0laRScgaW5zdGVhZCBv
ZiA0ayB3aGlsZSAKeW91J3JlIGF0IGl0IC4uLgoKPiAgIAkvKiBUZWxsIHRoZSBibG9jayBsYXll
ciB0aGF0IHRoaXMgaXMgbm90IGEgcm90YXRpb25hbCBkZXZpY2UgKi8KPiAtCWJsa19xdWV1ZV9m
bGFnX3NldChRVUVVRV9GTEFHX05PTlJPVCwgYnJkLT5icmRfcXVldWUpOwo+IC0JYmxrX3F1ZXVl
X2ZsYWdfY2xlYXIoUVVFVUVfRkxBR19BRERfUkFORE9NLCBicmQtPmJyZF9xdWV1ZSk7Cj4gKwli
bGtfcXVldWVfZmxhZ19zZXQoUVVFVUVfRkxBR19OT05ST1QsIGRpc2stPnF1ZXVlKTsKPiArCWJs
a19xdWV1ZV9mbGFnX2NsZWFyKFFVRVVFX0ZMQUdfQUREX1JBTkRPTSwgZGlzay0+cXVldWUpOwo+
ICsJYWRkX2Rpc2soZGlzayk7Cj4gKwlsaXN0X2FkZF90YWlsKCZicmQtPmJyZF9saXN0LCAmYnJk
X2RldmljZXMpOwo+ICAgCj4gLQlyZXR1cm4gYnJkOwo+ICsJcmV0dXJuIDA7Cj4gICAKPiAtb3V0
X2ZyZWVfcXVldWU6Cj4gLQlibGtfY2xlYW51cF9xdWV1ZShicmQtPmJyZF9xdWV1ZSk7Cj4gICBv
dXRfZnJlZV9kZXY6Cj4gICAJa2ZyZWUoYnJkKTsKPiAtb3V0Ogo+IC0JcmV0dXJuIE5VTEw7Cj4g
LX0KPiAtCj4gLXN0YXRpYyB2b2lkIGJyZF9mcmVlKHN0cnVjdCBicmRfZGV2aWNlICpicmQpCj4g
LXsKPiAtCXB1dF9kaXNrKGJyZC0+YnJkX2Rpc2spOwo+IC0JYmxrX2NsZWFudXBfcXVldWUoYnJk
LT5icmRfcXVldWUpOwo+IC0JYnJkX2ZyZWVfcGFnZXMoYnJkKTsKPiAtCWtmcmVlKGJyZCk7Cj4g
KwlyZXR1cm4gLUVOT01FTTsKPiAgIH0KPiAgIAo+ICAgc3RhdGljIHZvaWQgYnJkX3Byb2JlKGRl
dl90IGRldikKPiAgIHsKPiAtCXN0cnVjdCBicmRfZGV2aWNlICpicmQ7Cj4gICAJaW50IGkgPSBN
SU5PUihkZXYpIC8gbWF4X3BhcnQ7Cj4gKwlzdHJ1Y3QgYnJkX2RldmljZSAqYnJkOwo+ICAgCj4g
ICAJbXV0ZXhfbG9jaygmYnJkX2RldmljZXNfbXV0ZXgpOwo+ICAgCWxpc3RfZm9yX2VhY2hfZW50
cnkoYnJkLCAmYnJkX2RldmljZXMsIGJyZF9saXN0KSB7Cj4gQEAgLTQ0NSwxMyArNDM0LDcgQEAg
c3RhdGljIHZvaWQgYnJkX3Byb2JlKGRldl90IGRldikKPiAgIAkJCWdvdG8gb3V0X3VubG9jazsK
PiAgIAl9Cj4gICAKPiAtCWJyZCA9IGJyZF9hbGxvYyhpKTsKPiAtCWlmIChicmQpIHsKPiAtCQli
cmQtPmJyZF9kaXNrLT5xdWV1ZSA9IGJyZC0+YnJkX3F1ZXVlOwo+IC0JCWFkZF9kaXNrKGJyZC0+
YnJkX2Rpc2spOwo+IC0JCWxpc3RfYWRkX3RhaWwoJmJyZC0+YnJkX2xpc3QsICZicmRfZGV2aWNl
cyk7Cj4gLQl9Cj4gLQo+ICsJYnJkX2FsbG9jKGkpOwo+ICAgb3V0X3VubG9jazoKPiAgIAltdXRl
eF91bmxvY2soJmJyZF9kZXZpY2VzX211dGV4KTsKPiAgIH0KPiBAQCAtNDYwLDcgKzQ0Myw5IEBA
IHN0YXRpYyB2b2lkIGJyZF9kZWxfb25lKHN0cnVjdCBicmRfZGV2aWNlICpicmQpCj4gICB7Cj4g
ICAJbGlzdF9kZWwoJmJyZC0+YnJkX2xpc3QpOwo+ICAgCWRlbF9nZW5kaXNrKGJyZC0+YnJkX2Rp
c2spOwo+IC0JYnJkX2ZyZWUoYnJkKTsKPiArCWJsa19jbGVhbnVwX2Rpc2soYnJkLT5icmRfZGlz
ayk7Cj4gKwlicmRfZnJlZV9wYWdlcyhicmQpOwo+ICsJa2ZyZWUoYnJkKTsKPiAgIH0KPiAgIAo+
ICAgc3RhdGljIGlubGluZSB2b2lkIGJyZF9jaGVja19hbmRfcmVzZXRfcGFyKHZvaWQpCj4gQEAg
LTQ4NSw3ICs0NzAsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgYnJkX2NoZWNrX2FuZF9yZXNldF9w
YXIodm9pZCkKPiAgIHN0YXRpYyBpbnQgX19pbml0IGJyZF9pbml0KHZvaWQpCj4gICB7Cj4gICAJ
c3RydWN0IGJyZF9kZXZpY2UgKmJyZCwgKm5leHQ7Cj4gLQlpbnQgaTsKPiArCWludCBlcnIsIGk7
Cj4gICAKPiAgIAkvKgo+ICAgCSAqIGJyZCBtb2R1bGUgbm93IGhhcyBhIGZlYXR1cmUgdG8gaW5z
dGFudGlhdGUgdW5kZXJseWluZyBkZXZpY2UKPiBAQCAtNTExLDIyICs0OTYsMTEgQEAgc3RhdGlj
IGludCBfX2luaXQgYnJkX2luaXQodm9pZCkKPiAgIAo+ICAgCW11dGV4X2xvY2soJmJyZF9kZXZp
Y2VzX211dGV4KTsKPiAgIAlmb3IgKGkgPSAwOyBpIDwgcmRfbnI7IGkrKykgewo+IC0JCWJyZCA9
IGJyZF9hbGxvYyhpKTsKPiAtCQlpZiAoIWJyZCkKPiArCQllcnIgPSBicmRfYWxsb2MoaSk7Cj4g
KwkJaWYgKGVycikKPiAgIAkJCWdvdG8gb3V0X2ZyZWU7Cj4gLQkJbGlzdF9hZGRfdGFpbCgmYnJk
LT5icmRfbGlzdCwgJmJyZF9kZXZpY2VzKTsKPiAgIAl9Cj4gICAKPiAtCS8qIHBvaW50IG9mIG5v
IHJldHVybiAqLwo+IC0KPiAtCWxpc3RfZm9yX2VhY2hfZW50cnkoYnJkLCAmYnJkX2RldmljZXMs
IGJyZF9saXN0KSB7Cj4gLQkJLyoKPiAtCQkgKiBhc3NvY2lhdGUgd2l0aCBxdWV1ZSBqdXN0IGJl
Zm9yZSBhZGRpbmcgZGlzayBmb3IKPiAtCQkgKiBhdm9pZGluZyB0byBtZXNzIHVwIGZhaWx1cmUg
cGF0aAo+IC0JCSAqLwo+IC0JCWJyZC0+YnJkX2Rpc2stPnF1ZXVlID0gYnJkLT5icmRfcXVldWU7
Cj4gLQkJYWRkX2Rpc2soYnJkLT5icmRfZGlzayk7Cj4gLQl9Cj4gICAJbXV0ZXhfdW5sb2NrKCZi
cmRfZGV2aWNlc19tdXRleCk7Cj4gICAKPiAgIAlwcl9pbmZvKCJicmQ6IG1vZHVsZSBsb2FkZWRc
biIpOwo+IEBAIC01MzUsMTUgKzUwOSwxMyBAQCBzdGF0aWMgaW50IF9faW5pdCBicmRfaW5pdCh2
b2lkKQo+ICAgb3V0X2ZyZWU6Cj4gICAJZGVidWdmc19yZW1vdmVfcmVjdXJzaXZlKGJyZF9kZWJ1
Z2ZzX2Rpcik7Cj4gICAKPiAtCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShicmQsIG5leHQsICZi
cmRfZGV2aWNlcywgYnJkX2xpc3QpIHsKPiAtCQlsaXN0X2RlbCgmYnJkLT5icmRfbGlzdCk7Cj4g
LQkJYnJkX2ZyZWUoYnJkKTsKPiAtCX0KPiArCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShicmQs
IG5leHQsICZicmRfZGV2aWNlcywgYnJkX2xpc3QpCj4gKwkJYnJkX2RlbF9vbmUoYnJkKTsKPiAg
IAltdXRleF91bmxvY2soJmJyZF9kZXZpY2VzX211dGV4KTsKPiAgIAl1bnJlZ2lzdGVyX2Jsa2Rl
dihSQU1ESVNLX01BSk9SLCAicmFtZGlzayIpOwo+ICAgCj4gICAJcHJfaW5mbygiYnJkOiBtb2R1
bGUgTk9UIGxvYWRlZCAhISFcbiIpOwo+IC0JcmV0dXJuIC1FTk9NRU07Cj4gKwlyZXR1cm4gZXJy
Owo+ICAgfQo+ICAgCj4gICBzdGF0aWMgdm9pZCBfX2V4aXQgYnJkX2V4aXQodm9pZCkKPiAKT3Ro
ZXIgdGhhbiB0aGF0OgoKUmV2aWV3ZWQtYnk6IEhhbm5lcyBSZWluZWNrZSA8aGFyZUBzdXNlLmRl
PgoKQ2hlZXJzLAoKSGFubmVzCi0tIApEci4gSGFubmVzIFJlaW5lY2tlICAgICAgICAgICAgICAg
IEtlcm5lbCBTdG9yYWdlIEFyY2hpdGVjdApoYXJlQHN1c2UuZGUgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICArNDkgOTExIDc0MDUzIDY4OApTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHbWJI
LCBNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcKSFJCIDM2ODA5IChBRyBOw7xybmJlcmcp
LCBHZXNjaMOkZnRzZsO8aHJlcjogRmVsaXggSW1lbmTDtnJmZmVyCgoKLS0KZG0tZGV2ZWwgbWFp
bGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5jb20v
bWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbA==

