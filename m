Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D713CCA479
	for <dm-devel@archiver.kernel.org>; Tue, 28 Jun 2022 06:38:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-jfwk1u8FPZyYslQ7i8lI9g-1; Tue, 28 Jun 2022 02:38:05 -0400
X-MC-Unique: jfwk1u8FPZyYslQ7i8lI9g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CBF52999B59;
	Tue, 28 Jun 2022 06:38:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B90A2492CA3;
	Tue, 28 Jun 2022 06:38:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4EA2A194706A;
	Tue, 28 Jun 2022 06:38:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5FC4E19466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 02:21:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3DBB6141510C; Tue, 28 Jun 2022 02:21:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 394701415108
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 02:21:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 206B93804500
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 02:21:38 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-Dnnj_rcaO6ui_5fcSlUeLA-1; Mon, 27 Jun 2022 22:21:35 -0400
X-MC-Unique: Dnnj_rcaO6ui_5fcSlUeLA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 11460617BC;
 Tue, 28 Jun 2022 02:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3298C341CB;
 Tue, 28 Jun 2022 02:21:31 +0000 (UTC)
Date: Tue, 28 Jun 2022 04:21:29 +0200
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Message-ID: <20220628022129.GA8452@embeddedor>
References: <20220627180432.GA136081@embeddedor>
 <6bc1e94c-ce1d-a074-7d0c-8dbe6ce22637@iogearbox.net>
 <20220628004052.GM23621@ziepe.ca>
 <20220628005825.GA161566@embeddedor>
MIME-Version: 1.0
In-Reply-To: <20220628005825.GA161566@embeddedor>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBKdW4gMjgsIDIwMjIgYXQgMDI6NTg6MjVBTSArMDIwMCwgR3VzdGF2byBBLiBSLiBT
aWx2YSB3cm90ZToKPiBPbiBNb24sIEp1biAyNywgMjAyMiBhdCAwOTo0MDo1MlBNIC0wMzAwLCBK
YXNvbiBHdW50aG9ycGUgd3JvdGU6Cj4gPiBPbiBNb24sIEp1biAyNywgMjAyMiBhdCAwODoyNzoz
N1BNICswMjAwLCBEYW5pZWwgQm9ya21hbm4gd3JvdGU6Cj4gPiA+IE9uIDYvMjcvMjIgODowNCBQ
TSwgR3VzdGF2byBBLiBSLiBTaWx2YSB3cm90ZToKPiA+ID4gPiBUaGVyZSBpcyBhIHJlZ3VsYXIg
bmVlZCBpbiB0aGUga2VybmVsIHRvIHByb3ZpZGUgYSB3YXkgdG8gZGVjbGFyZQo+ID4gPiA+IGhh
dmluZyBhIGR5bmFtaWNhbGx5IHNpemVkIHNldCBvZiB0cmFpbGluZyBlbGVtZW50cyBpbiBhIHN0
cnVjdHVyZS4KPiA+ID4gPiBLZXJuZWwgY29kZSBzaG91bGQgYWx3YXlzIHVzZSDigJxmbGV4aWJs
ZSBhcnJheSBtZW1iZXJz4oCdWzFdIGZvciB0aGVzZQo+ID4gPiA+IGNhc2VzLiBUaGUgb2xkZXIg
c3R5bGUgb2Ygb25lLWVsZW1lbnQgb3IgemVyby1sZW5ndGggYXJyYXlzIHNob3VsZAo+ID4gPiA+
IG5vIGxvbmdlciBiZSB1c2VkWzJdLgo+ID4gPiA+IAo+ID4gPiA+IFRoaXMgY29kZSB3YXMgdHJh
bnNmb3JtZWQgd2l0aCB0aGUgaGVscCBvZiBDb2NjaW5lbGxlOgo+ID4gPiA+IChsaW51eC01LjE5
LXJjMiQgc3BhdGNoIC0tam9icyAkKGdldGNvbmYgX05QUk9DRVNTT1JTX09OTE4pIC0tc3AtZmls
ZSBzY3JpcHQuY29jY2kgLS1pbmNsdWRlLWhlYWRlcnMgLS1kaXIgLiA+IG91dHB1dC5wYXRjaCkK
PiA+ID4gPiAKPiA+ID4gPiBAQAo+ID4gPiA+IGlkZW50aWZpZXIgUywgbWVtYmVyLCBhcnJheTsK
PiA+ID4gPiB0eXBlIFQxLCBUMjsKPiA+ID4gPiBAQAo+ID4gPiA+IAo+ID4gPiA+IHN0cnVjdCBT
IHsKPiA+ID4gPiAgICAuLi4KPiA+ID4gPiAgICBUMSBtZW1iZXI7Cj4gPiA+ID4gICAgVDIgYXJy
YXlbCj4gPiA+ID4gLSAwCj4gPiA+ID4gICAgXTsKPiA+ID4gPiB9Owo+ID4gPiA+IAo+ID4gPiA+
IC1mc3RyaWN0LWZsZXgtYXJyYXlzPTMgaXMgY29taW5nIGFuZCB3ZSBuZWVkIHRvIGxhbmQgdGhl
c2UgY2hhbmdlcwo+ID4gPiA+IHRvIHByZXZlbnQgaXNzdWVzIGxpa2UgdGhlc2UgaW4gdGhlIHNo
b3J0IGZ1dHVyZToKPiA+ID4gPiAKPiA+ID4gPiAuLi9mcy9taW5peC9kaXIuYzozMzc6Mzogd2Fy
bmluZzogJ3N0cmNweScgd2lsbCBhbHdheXMgb3ZlcmZsb3c7IGRlc3RpbmF0aW9uIGJ1ZmZlciBo
YXMgc2l6ZSAwLAo+ID4gPiA+IGJ1dCB0aGUgc291cmNlIHN0cmluZyBoYXMgbGVuZ3RoIDIgKGlu
Y2x1ZGluZyBOVUwgYnl0ZSkgWy1XZm9ydGlmeS1zb3VyY2VdCj4gPiA+ID4gCQlzdHJjcHkoZGUz
LT5uYW1lLCAiLiIpOwo+ID4gPiA+IAkJXgo+ID4gPiA+IAo+ID4gPiA+IFNpbmNlIHRoZXNlIGFy
ZSBhbGwgWzBdIHRvIFtdIGNoYW5nZXMsIHRoZSByaXNrIHRvIFVBUEkgaXMgbmVhcmx5IHplcm8u
IElmCj4gPiA+ID4gdGhpcyBicmVha3MgYW55dGhpbmcsIHdlIGNhbiB1c2UgYSB1bmlvbiB3aXRo
IGEgbmV3IG1lbWJlciBuYW1lLgo+ID4gPiA+IAo+ID4gPiA+IFsxXSBodHRwczovL2VuLndpa2lw
ZWRpYS5vcmcvd2lraS9GbGV4aWJsZV9hcnJheV9tZW1iZXIKPiA+ID4gPiBbMl0gaHR0cHM6Ly93
d3cua2VybmVsLm9yZy9kb2MvaHRtbC92NS4xNi9wcm9jZXNzL2RlcHJlY2F0ZWQuaHRtbCN6ZXJv
LWxlbmd0aC1hbmQtb25lLWVsZW1lbnQtYXJyYXlzCj4gPiA+ID4gCj4gPiA+ID4gTGluazogaHR0
cHM6Ly9naXRodWIuY29tL0tTUFAvbGludXgvaXNzdWVzLzc4Cj4gPiA+ID4gQnVpbGQtdGVzdGVk
LWJ5OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzYyYjY3NWVjLndLWDZBT1o2Y2JFNzF2
dEYlMjVsa3BAaW50ZWwuY29tLwo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEd1c3Rhdm8gQS4gUi4g
U2lsdmEgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz4KPiA+ID4gPiAtLS0KPiA+ID4gPiBIaSBhbGwh
Cj4gPiA+ID4gCj4gPiA+ID4gSkZZSTogSSdtIGFkZGluZyB0aGlzIHRvIG15IC1uZXh0IHRyZWUu
IDopCj4gPiA+IAo+ID4gPiBGeWksIHRoaXMgYnJlYWtzIEJQRiBDSToKPiA+ID4gCj4gPiA+IGh0
dHBzOi8vZ2l0aHViLmNvbS9rZXJuZWwtcGF0Y2hlcy9icGYvcnVucy83MDc4NzE5MzcyP2NoZWNr
X3N1aXRlX2ZvY3VzPXRydWUKPiA+ID4gCj4gPiA+ICAgWy4uLl0KPiA+ID4gICBwcm9ncy9tYXBf
cHRyX2tlcm4uYzozMTQ6MjY6IGVycm9yOiBmaWVsZCAndHJpZV9rZXknIHdpdGggdmFyaWFibGUg
c2l6ZWQgdHlwZSAnc3RydWN0IGJwZl9scG1fdHJpZV9rZXknIG5vdCBhdCB0aGUgZW5kIG9mIGEg
c3RydWN0IG9yIGNsYXNzIGlzIGEgR05VIGV4dGVuc2lvbiBbLVdlcnJvciwtV2dudS12YXJpYWJs
ZS1zaXplZC10eXBlLW5vdC1hdC1lbmRdCj4gPiA+ICAgICAgICAgICBzdHJ1Y3QgYnBmX2xwbV90
cmllX2tleSB0cmllX2tleTsKPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IF4KPiA+IAo+ID4gVGhpcyB3aWxsIGJyZWFrIHRoZSByZG1hLWNvcmUgdXNlcnNwYWNlIGFzIHdl
bGwsIHdpdGggYSBzaW1pbGFyCj4gPiBlcnJvcjoKPiA+IAo+ID4gL3Vzci9iaW4vY2xhbmctMTMg
LURWRVJCU19ERUJVRyAtRGlidmVyYnNfRVhQT1JUUyAtSWluY2x1ZGUgLUkvdXNyL2luY2x1ZGUv
bGlibmwzIC1JL3Vzci9pbmNsdWRlL2RybSAtZyAtTzIgLWZkZWJ1Zy1wcmVmaXgtbWFwPS9fX3cv
MS9zPS4gLWZzdGFjay1wcm90ZWN0b3Itc3Ryb25nIC1XZm9ybWF0IC1XZXJyb3I9Zm9ybWF0LXNl
Y3VyaXR5IC1XZGF0ZS10aW1lIC1EX0ZPUlRJRllfU09VUkNFPTIgLVdtaXNzaW5nLXByb3RvdHlw
ZXMgLVdtaXNzaW5nLWRlY2xhcmF0aW9ucyAtV3dyaXRlLXN0cmluZ3MgLVdmb3JtYXQ9MiAtV2Nh
c3QtZnVuY3Rpb24tdHlwZSAtV2Zvcm1hdC1ub25saXRlcmFsIC1XZGF0ZS10aW1lIC1XbmVzdGVk
LWV4dGVybnMgLVdzaGFkb3cgLVdzdHJpY3QtcHJvdG90eXBlcyAtV29sZC1zdHlsZS1kZWZpbml0
aW9uIC1XZXJyb3IgLVdyZWR1bmRhbnQtZGVjbHMgLWcgLWZQSUMgICAtc3RkPWdudTExIC1NRCAt
TVQgbGliaWJ2ZXJicy9DTWFrZUZpbGVzL2lidmVyYnMuZGlyL2NtZF9mbG93LmMubyAtTUYgbGli
aWJ2ZXJicy9DTWFrZUZpbGVzL2lidmVyYnMuZGlyL2NtZF9mbG93LmMuby5kIC1vIGxpYmlidmVy
YnMvQ01ha2VGaWxlcy9pYnZlcmJzLmRpci9jbWRfZmxvdy5jLm8gICAtYyAuLi9saWJpYnZlcmJz
L2NtZF9mbG93LmMKPiA+IEluIGZpbGUgaW5jbHVkZWQgZnJvbSAuLi9saWJpYnZlcmJzL2NtZF9m
bG93LmM6MzM6Cj4gPiBJbiBmaWxlIGluY2x1ZGVkIGZyb20gaW5jbHVkZS9pbmZpbmliYW5kL2Nt
ZF93cml0ZS5oOjM2Ogo+ID4gSW4gZmlsZSBpbmNsdWRlZCBmcm9tIGluY2x1ZGUvaW5maW5pYmFu
ZC9jbWRfaW9jdGwuaDo0MToKPiA+IEluIGZpbGUgaW5jbHVkZWQgZnJvbSBpbmNsdWRlL2luZmlu
aWJhbmQvdmVyYnMuaDo0ODoKPiA+IEluIGZpbGUgaW5jbHVkZWQgZnJvbSBpbmNsdWRlL2luZmlu
aWJhbmQvdmVyYnNfYXBpLmg6NjY6Cj4gPiBJbiBmaWxlIGluY2x1ZGVkIGZyb20gaW5jbHVkZS9p
bmZpbmliYW5kL2liX3VzZXJfaW9jdGxfdmVyYnMuaDozODoKPiA+IGluY2x1ZGUvcmRtYS9pYl91
c2VyX3ZlcmJzLmg6NDM2OjM0OiBlcnJvcjogZmllbGQgJ2Jhc2UnIHdpdGggdmFyaWFibGUgc2l6
ZWQgdHlwZSAnc3RydWN0IGliX3V2ZXJic19jcmVhdGVfY3FfcmVzcCcgbm90IGF0IHRoZSBlbmQg
b2YgYSBzdHJ1Y3Qgb3IgY2xhc3MgaXMgYSBHTlUgZXh0ZW5zaW9uIFstV2Vycm9yLC1XZ251LXZh
cmlhYmxlLXNpemVkLXR5cGUtbm90LWF0LWVuZF0KPiA+ICAgICAgICAgc3RydWN0IGliX3V2ZXJi
c19jcmVhdGVfY3FfcmVzcCBiYXNlOwo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIF4KPiA+IGluY2x1ZGUvcmRtYS9pYl91c2VyX3ZlcmJzLmg6NjQ0OjM0OiBlcnJv
cjogZmllbGQgJ2Jhc2UnIHdpdGggdmFyaWFibGUgc2l6ZWQgdHlwZSAnc3RydWN0IGliX3V2ZXJi
c19jcmVhdGVfcXBfcmVzcCcgbm90IGF0IHRoZSBlbmQgb2YgYSBzdHJ1Y3Qgb3IgY2xhc3MgaXMg
YSBHTlUgZXh0ZW5zaW9uIFstV2Vycm9yLC1XZ251LXZhcmlhYmxlLXNpemVkLXR5cGUtbm90LWF0
LWVuZF0KPiA+ICAgICAgICAgc3RydWN0IGliX3V2ZXJic19jcmVhdGVfcXBfcmVzcCBiYXNlOwo+
ID4gCj4gPiBXaGljaCBpcyB3aHkgSSBnYXZlIHVwIHRyeWluZyB0byBjaGFuZ2UgdGhlc2UuLgo+
ID4gCj4gPiBUaG91Z2ggbWF5YmUgd2UgY291bGQganVzdCBzd2l0Y2ggb2ZmIC1XZ251LXZhcmlh
YmxlLXNpemVkLXR5cGUtbm90LWF0LWVuZCAgZHVyaW5nIGNvbmZpZ3VyYXRpb24gPwo+IAo+IE5v
LiBJIHRoaW5rIG5vdyB3ZSBjYW4gZWFzaWx5IHdvcmthcm91bmQgdGhlc2Ugc29ydHMgb2YgcHJv
YmxlbXMgd2l0aAo+IHNvbWV0aGluZyBsaWtlIHRoaXM6Cj4gCj4gCXN0cnVjdCBmbGV4IHsKPiAJ
CWFueV90eXBlIGFueV9tZW1iZXI7Cj4gCQl1bmlvbiB7Cj4gCQkJdHlwZSBhcnJheVswXTsKPiAJ
CQlfX0RFQ0xBUkVfRkxFWF9BUlJBWSh0eXBlLCBhcnJheV9mbGV4KTsKPiAJCX07Cj4gCX07CgpN
bW1oLi4uIG5vcGU7IHRoaXMgZG9lc24ndCB3b3JrWzFdLgoKV2UgbmVlZCB0byB0aGluayBpbiBh
IGRpZmZlcmVudCBzdHJhdGVneS4KCi0tCkd1c3Rhdm8KClsxXSBodHRwczovL2dvZGJvbHQub3Jn
L3ovYXY3OVBxYmZ6CgotLQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNv
bQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

