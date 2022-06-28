Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A6BCC43334
	for <dm-devel@archiver.kernel.org>; Tue, 28 Jun 2022 06:38:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-VzsfBHJuPxi6SdN5SaHsHQ-1; Tue, 28 Jun 2022 02:38:05 -0400
X-MC-Unique: VzsfBHJuPxi6SdN5SaHsHQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C8181C068CE;
	Tue, 28 Jun 2022 06:38:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EDB1E40466A4;
	Tue, 28 Jun 2022 06:38:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C748194705C;
	Tue, 28 Jun 2022 06:38:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 01C5919466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 00:58:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D5CDC41637B; Tue, 28 Jun 2022 00:58:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D1510415F5E
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 00:58:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8D18811E80
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 00:58:33 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-dBM7baQtNI2uCaXbIsttTg-1; Mon, 27 Jun 2022 20:58:31 -0400
X-MC-Unique: dBM7baQtNI2uCaXbIsttTg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B6EC2616BE;
 Tue, 28 Jun 2022 00:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEABC341C8;
 Tue, 28 Jun 2022 00:58:27 +0000 (UTC)
Date: Tue, 28 Jun 2022 02:58:25 +0200
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Message-ID: <20220628005825.GA161566@embeddedor>
References: <20220627180432.GA136081@embeddedor>
 <6bc1e94c-ce1d-a074-7d0c-8dbe6ce22637@iogearbox.net>
 <20220628004052.GM23621@ziepe.ca>
MIME-Version: 1.0
In-Reply-To: <20220628004052.GM23621@ziepe.ca>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Tue, 28 Jun 2022 06:38:00 +0000
Subject: Re: [dm-devel] [PATCH][next] treewide: uapi: Replace zero-length
 arrays with flexible-array members
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
Cc: nvdimm@lists.linux.dev, alsa-devel@alsa-project.org, kvm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-mips@vger.kernel.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-hardening@vger.kernel.org,
 linux1394-devel@lists.sourceforge.net,
 linux-stm32@st-md-mailman.stormreply.com, linux-s390@vger.kernel.org,
 Daniel Borkmann <daniel@iogearbox.net>, linux-rdma@vger.kernel.org,
 x86@kernel.org, kasan-dev@googlegroups.com, lvs-devel@vger.kernel.org,
 coreteam@netfilter.org, v9fs-developer@lists.sourceforge.net,
 Kees Cook <keescook@chromium.org>, intel-gfx@lists.freedesktop.org,
 linux-can@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, virtualization@lists.linux-foundation.org,
 io-uring@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-scsi@vger.kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-sctp@vger.kernel.org,
 netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 bpf@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gTW9uLCBKdW4gMjcsIDIwMjIgYXQgMDk6NDA6NTJQTSAtMDMwMCwgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgo+IE9uIE1vbiwgSnVuIDI3LCAyMDIyIGF0IDA4OjI3OjM3UE0gKzAyMDAsIERhbmll
bCBCb3JrbWFubiB3cm90ZToKPiA+IE9uIDYvMjcvMjIgODowNCBQTSwgR3VzdGF2byBBLiBSLiBT
aWx2YSB3cm90ZToKPiA+ID4gVGhlcmUgaXMgYSByZWd1bGFyIG5lZWQgaW4gdGhlIGtlcm5lbCB0
byBwcm92aWRlIGEgd2F5IHRvIGRlY2xhcmUKPiA+ID4gaGF2aW5nIGEgZHluYW1pY2FsbHkgc2l6
ZWQgc2V0IG9mIHRyYWlsaW5nIGVsZW1lbnRzIGluIGEgc3RydWN0dXJlLgo+ID4gPiBLZXJuZWwg
Y29kZSBzaG91bGQgYWx3YXlzIHVzZSDigJxmbGV4aWJsZSBhcnJheSBtZW1iZXJz4oCdWzFdIGZv
ciB0aGVzZQo+ID4gPiBjYXNlcy4gVGhlIG9sZGVyIHN0eWxlIG9mIG9uZS1lbGVtZW50IG9yIHpl
cm8tbGVuZ3RoIGFycmF5cyBzaG91bGQKPiA+ID4gbm8gbG9uZ2VyIGJlIHVzZWRbMl0uCj4gPiA+
IAo+ID4gPiBUaGlzIGNvZGUgd2FzIHRyYW5zZm9ybWVkIHdpdGggdGhlIGhlbHAgb2YgQ29jY2lu
ZWxsZToKPiA+ID4gKGxpbnV4LTUuMTktcmMyJCBzcGF0Y2ggLS1qb2JzICQoZ2V0Y29uZiBfTlBS
T0NFU1NPUlNfT05MTikgLS1zcC1maWxlIHNjcmlwdC5jb2NjaSAtLWluY2x1ZGUtaGVhZGVycyAt
LWRpciAuID4gb3V0cHV0LnBhdGNoKQo+ID4gPiAKPiA+ID4gQEAKPiA+ID4gaWRlbnRpZmllciBT
LCBtZW1iZXIsIGFycmF5Owo+ID4gPiB0eXBlIFQxLCBUMjsKPiA+ID4gQEAKPiA+ID4gCj4gPiA+
IHN0cnVjdCBTIHsKPiA+ID4gICAgLi4uCj4gPiA+ICAgIFQxIG1lbWJlcjsKPiA+ID4gICAgVDIg
YXJyYXlbCj4gPiA+IC0gMAo+ID4gPiAgICBdOwo+ID4gPiB9Owo+ID4gPiAKPiA+ID4gLWZzdHJp
Y3QtZmxleC1hcnJheXM9MyBpcyBjb21pbmcgYW5kIHdlIG5lZWQgdG8gbGFuZCB0aGVzZSBjaGFu
Z2VzCj4gPiA+IHRvIHByZXZlbnQgaXNzdWVzIGxpa2UgdGhlc2UgaW4gdGhlIHNob3J0IGZ1dHVy
ZToKPiA+ID4gCj4gPiA+IC4uL2ZzL21pbml4L2Rpci5jOjMzNzozOiB3YXJuaW5nOiAnc3RyY3B5
JyB3aWxsIGFsd2F5cyBvdmVyZmxvdzsgZGVzdGluYXRpb24gYnVmZmVyIGhhcyBzaXplIDAsCj4g
PiA+IGJ1dCB0aGUgc291cmNlIHN0cmluZyBoYXMgbGVuZ3RoIDIgKGluY2x1ZGluZyBOVUwgYnl0
ZSkgWy1XZm9ydGlmeS1zb3VyY2VdCj4gPiA+IAkJc3RyY3B5KGRlMy0+bmFtZSwgIi4iKTsKPiA+
ID4gCQleCj4gPiA+IAo+ID4gPiBTaW5jZSB0aGVzZSBhcmUgYWxsIFswXSB0byBbXSBjaGFuZ2Vz
LCB0aGUgcmlzayB0byBVQVBJIGlzIG5lYXJseSB6ZXJvLiBJZgo+ID4gPiB0aGlzIGJyZWFrcyBh
bnl0aGluZywgd2UgY2FuIHVzZSBhIHVuaW9uIHdpdGggYSBuZXcgbWVtYmVyIG5hbWUuCj4gPiA+
IAo+ID4gPiBbMV0gaHR0cHM6Ly9lbi53aWtpcGVkaWEub3JnL3dpa2kvRmxleGlibGVfYXJyYXlf
bWVtYmVyCj4gPiA+IFsyXSBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL3Y1LjE2L3By
b2Nlc3MvZGVwcmVjYXRlZC5odG1sI3plcm8tbGVuZ3RoLWFuZC1vbmUtZWxlbWVudC1hcnJheXMK
PiA+ID4gCj4gPiA+IExpbms6IGh0dHBzOi8vZ2l0aHViLmNvbS9LU1BQL2xpbnV4L2lzc3Vlcy83
OAo+ID4gPiBCdWlsZC10ZXN0ZWQtYnk6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvNjJi
Njc1ZWMud0tYNkFPWjZjYkU3MXZ0RiUyNWxrcEBpbnRlbC5jb20vCj4gPiA+IFNpZ25lZC1vZmYt
Ynk6IEd1c3Rhdm8gQS4gUi4gU2lsdmEgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz4KPiA+ID4gLS0t
Cj4gPiA+IEhpIGFsbCEKPiA+ID4gCj4gPiA+IEpGWUk6IEknbSBhZGRpbmcgdGhpcyB0byBteSAt
bmV4dCB0cmVlLiA6KQo+ID4gCj4gPiBGeWksIHRoaXMgYnJlYWtzIEJQRiBDSToKPiA+IAo+ID4g
aHR0cHM6Ly9naXRodWIuY29tL2tlcm5lbC1wYXRjaGVzL2JwZi9ydW5zLzcwNzg3MTkzNzI/Y2hl
Y2tfc3VpdGVfZm9jdXM9dHJ1ZQo+ID4gCj4gPiAgIFsuLi5dCj4gPiAgIHByb2dzL21hcF9wdHJf
a2Vybi5jOjMxNDoyNjogZXJyb3I6IGZpZWxkICd0cmllX2tleScgd2l0aCB2YXJpYWJsZSBzaXpl
ZCB0eXBlICdzdHJ1Y3QgYnBmX2xwbV90cmllX2tleScgbm90IGF0IHRoZSBlbmQgb2YgYSBzdHJ1
Y3Qgb3IgY2xhc3MgaXMgYSBHTlUgZXh0ZW5zaW9uIFstV2Vycm9yLC1XZ251LXZhcmlhYmxlLXNp
emVkLXR5cGUtbm90LWF0LWVuZF0KPiA+ICAgICAgICAgICBzdHJ1Y3QgYnBmX2xwbV90cmllX2tl
eSB0cmllX2tleTsKPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBeCj4gCj4g
VGhpcyB3aWxsIGJyZWFrIHRoZSByZG1hLWNvcmUgdXNlcnNwYWNlIGFzIHdlbGwsIHdpdGggYSBz
aW1pbGFyCj4gZXJyb3I6Cj4gCj4gL3Vzci9iaW4vY2xhbmctMTMgLURWRVJCU19ERUJVRyAtRGli
dmVyYnNfRVhQT1JUUyAtSWluY2x1ZGUgLUkvdXNyL2luY2x1ZGUvbGlibmwzIC1JL3Vzci9pbmNs
dWRlL2RybSAtZyAtTzIgLWZkZWJ1Zy1wcmVmaXgtbWFwPS9fX3cvMS9zPS4gLWZzdGFjay1wcm90
ZWN0b3Itc3Ryb25nIC1XZm9ybWF0IC1XZXJyb3I9Zm9ybWF0LXNlY3VyaXR5IC1XZGF0ZS10aW1l
IC1EX0ZPUlRJRllfU09VUkNFPTIgLVdtaXNzaW5nLXByb3RvdHlwZXMgLVdtaXNzaW5nLWRlY2xh
cmF0aW9ucyAtV3dyaXRlLXN0cmluZ3MgLVdmb3JtYXQ9MiAtV2Nhc3QtZnVuY3Rpb24tdHlwZSAt
V2Zvcm1hdC1ub25saXRlcmFsIC1XZGF0ZS10aW1lIC1XbmVzdGVkLWV4dGVybnMgLVdzaGFkb3cg
LVdzdHJpY3QtcHJvdG90eXBlcyAtV29sZC1zdHlsZS1kZWZpbml0aW9uIC1XZXJyb3IgLVdyZWR1
bmRhbnQtZGVjbHMgLWcgLWZQSUMgICAtc3RkPWdudTExIC1NRCAtTVQgbGliaWJ2ZXJicy9DTWFr
ZUZpbGVzL2lidmVyYnMuZGlyL2NtZF9mbG93LmMubyAtTUYgbGliaWJ2ZXJicy9DTWFrZUZpbGVz
L2lidmVyYnMuZGlyL2NtZF9mbG93LmMuby5kIC1vIGxpYmlidmVyYnMvQ01ha2VGaWxlcy9pYnZl
cmJzLmRpci9jbWRfZmxvdy5jLm8gICAtYyAuLi9saWJpYnZlcmJzL2NtZF9mbG93LmMKPiBJbiBm
aWxlIGluY2x1ZGVkIGZyb20gLi4vbGliaWJ2ZXJicy9jbWRfZmxvdy5jOjMzOgo+IEluIGZpbGUg
aW5jbHVkZWQgZnJvbSBpbmNsdWRlL2luZmluaWJhbmQvY21kX3dyaXRlLmg6MzY6Cj4gSW4gZmls
ZSBpbmNsdWRlZCBmcm9tIGluY2x1ZGUvaW5maW5pYmFuZC9jbWRfaW9jdGwuaDo0MToKPiBJbiBm
aWxlIGluY2x1ZGVkIGZyb20gaW5jbHVkZS9pbmZpbmliYW5kL3ZlcmJzLmg6NDg6Cj4gSW4gZmls
ZSBpbmNsdWRlZCBmcm9tIGluY2x1ZGUvaW5maW5pYmFuZC92ZXJic19hcGkuaDo2NjoKPiBJbiBm
aWxlIGluY2x1ZGVkIGZyb20gaW5jbHVkZS9pbmZpbmliYW5kL2liX3VzZXJfaW9jdGxfdmVyYnMu
aDozODoKPiBpbmNsdWRlL3JkbWEvaWJfdXNlcl92ZXJicy5oOjQzNjozNDogZXJyb3I6IGZpZWxk
ICdiYXNlJyB3aXRoIHZhcmlhYmxlIHNpemVkIHR5cGUgJ3N0cnVjdCBpYl91dmVyYnNfY3JlYXRl
X2NxX3Jlc3AnIG5vdCBhdCB0aGUgZW5kIG9mIGEgc3RydWN0IG9yIGNsYXNzIGlzIGEgR05VIGV4
dGVuc2lvbiBbLVdlcnJvciwtV2dudS12YXJpYWJsZS1zaXplZC10eXBlLW5vdC1hdC1lbmRdCj4g
ICAgICAgICBzdHJ1Y3QgaWJfdXZlcmJzX2NyZWF0ZV9jcV9yZXNwIGJhc2U7Cj4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF4KPiBpbmNsdWRlL3JkbWEvaWJfdXNlcl92
ZXJicy5oOjY0NDozNDogZXJyb3I6IGZpZWxkICdiYXNlJyB3aXRoIHZhcmlhYmxlIHNpemVkIHR5
cGUgJ3N0cnVjdCBpYl91dmVyYnNfY3JlYXRlX3FwX3Jlc3AnIG5vdCBhdCB0aGUgZW5kIG9mIGEg
c3RydWN0IG9yIGNsYXNzIGlzIGEgR05VIGV4dGVuc2lvbiBbLVdlcnJvciwtV2dudS12YXJpYWJs
ZS1zaXplZC10eXBlLW5vdC1hdC1lbmRdCj4gICAgICAgICBzdHJ1Y3QgaWJfdXZlcmJzX2NyZWF0
ZV9xcF9yZXNwIGJhc2U7Cj4gCj4gV2hpY2ggaXMgd2h5IEkgZ2F2ZSB1cCB0cnlpbmcgdG8gY2hh
bmdlIHRoZXNlLi4KPiAKPiBUaG91Z2ggbWF5YmUgd2UgY291bGQganVzdCBzd2l0Y2ggb2ZmIC1X
Z251LXZhcmlhYmxlLXNpemVkLXR5cGUtbm90LWF0LWVuZCAgZHVyaW5nIGNvbmZpZ3VyYXRpb24g
PwoKTm8uIEkgdGhpbmsgbm93IHdlIGNhbiBlYXNpbHkgd29ya2Fyb3VuZCB0aGVzZSBzb3J0cyBv
ZiBwcm9ibGVtcyB3aXRoCnNvbWV0aGluZyBsaWtlIHRoaXM6CgoJc3RydWN0IGZsZXggewoJCWFu
eV90eXBlIGFueV9tZW1iZXI7CgkJdW5pb24gewoJCQl0eXBlIGFycmF5WzBdOwoJCQlfX0RFQ0xB
UkVfRkxFWF9BUlJBWSh0eXBlLCBhcnJheV9mbGV4KTsKCQl9OwoJfTsKCmFuZCB1c2UgYXJyYXlf
ZmxleCBpbiBrZXJuZWwtc3BhY2UuCgpUaGUgc2FtZSBmb3IgdGhlIG9uZS1lbG1lbnQgYXJyYXlz
IGluIFVBUEk6CgogICAgICAgIHN0cnVjdCBmbGV4IHsKICAgICAgICAgICAgICAgIGFueV90eXBl
IGFueV9tZW1iZXI7CiAgICAgICAgICAgICAgICB1bmlvbiB7CiAgICAgICAgICAgICAgICAgICAg
ICAgIHR5cGUgYXJyYXlbMV07CiAgICAgICAgICAgICAgICAgICAgICAgIF9fREVDTEFSRV9GTEVY
X0FSUkFZKHR5cGUsIGFycmF5X2ZsZXgpOwogICAgICAgICAgICAgICAgfTsKICAgICAgICB9OwoK
SSdsbCB1c2UgdGhlIGlkaW9tIGFib3ZlIHRvIHJlc29sdmUgYWxsIHRoZXNlIHdhcm5pbmdzIGlu
IGEgZm9sbG93LXVwCnBhdGNoLiA6KQoKVGhhbmtzCi0tCkd1c3Rhdm8KCi0tCmRtLWRldmVsIG1h
aWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

