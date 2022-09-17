Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EE2FECAAA1
	for <dm-devel@archiver.kernel.org>; Sat, 17 Sep 2022 03:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663384240;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WtACZzlmYCrhlVcXKR4IRntHXaRfJsF2Ihl+o9WSk88=;
	b=eaYLrLJ5XIoQSoBqFr/wFgR26MEXawg8L+SUVkbfSCI9lHhxvlKzvicMh8WZ3a2j7fLEW7
	Gkw4Yx+6EIJwGE46bOGzuWGNAm3+i29aPWv3tytEpL0/IV42nfPLfJcfxl3z068+7rH7Nd
	JgXDkhEpik3j0H9L3AMcG2ldWVoU9tc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-NH1xBZO2OyqgU_s0oGMJcQ-1; Fri, 16 Sep 2022 23:10:37 -0400
X-MC-Unique: NH1xBZO2OyqgU_s0oGMJcQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 532E6380664E;
	Sat, 17 Sep 2022 03:10:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 904DE1121314;
	Sat, 17 Sep 2022 03:10:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 401DB194658F;
	Sat, 17 Sep 2022 03:10:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CB1621946586
 for <dm-devel@listman.corp.redhat.com>; Sat, 17 Sep 2022 03:10:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BBC2340C6EC3; Sat, 17 Sep 2022 03:10:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B446F40C6EC2
 for <dm-devel@redhat.com>; Sat, 17 Sep 2022 03:10:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 973D13C0E218
 for <dm-devel@redhat.com>; Sat, 17 Sep 2022 03:10:30 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-bi5mXZ6KMty80kQ8-Qf3iQ-1; Fri, 16 Sep 2022 23:10:27 -0400
X-MC-Unique: bi5mXZ6KMty80kQ8-Qf3iQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 916C6B829E1;
 Sat, 17 Sep 2022 03:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272CEC433C1;
 Sat, 17 Sep 2022 03:03:40 +0000 (UTC)
Date: Fri, 16 Sep 2022 20:03:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <YyU5CyQfS+64xmnm@magnolia>
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
MIME-Version: 1.0
In-Reply-To: <20220915164826.1396245-1-sarthakkukreti@google.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH RFC 0/8] Introduce provisioning primitives
 for thinly provisioned storage
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
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Evan Green <evgreen@google.com>,
 Daniil Lunev <dlunev@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVGh1LCBTZXAgMTUsIDIwMjIgYXQgMDk6NDg6MThBTSAtMDcwMCwgU2FydGhhayBLdWtyZXRp
IHdyb3RlOgo+IEZyb206IFNhcnRoYWsgS3VrcmV0aSA8c2FydGhha2t1a3JldGlAY2hyb21pdW0u
b3JnPgo+IAo+IEhpLAo+IAo+IFRoaXMgcGF0Y2ggc2VyaWVzIGlzIGFuIFJGQyBvZiBhIG1lY2hh
bmlzbSB0byBwYXNzIHRocm91Z2ggcHJvdmlzaW9uCj4gcmVxdWVzdHMgb24gc3RhY2tlZCB0aGlu
bHkgcHJvdmlzaW9uZWQgc3RvcmFnZSBkZXZpY2VzL2ZpbGVzeXN0ZW1zLgoKW1JlZmxvd2VkIHRl
eHRdCgo+IFRoZSBsaW51eCBrZXJuZWwgcHJvdmlkZXMgc2V2ZXJhbCBtZWNoYW5pc21zIHRvIHNl
dCB1cCB0aGlubHkKPiBwcm92aXNpb25lZCBibG9jayBzdG9yYWdlIGFic3RyYWN0aW9ucyAoZWcu
IGRtLXRoaW4sIGxvb3AgZGV2aWNlcyBvdmVyCj4gc3BhcnNlIGZpbGVzKSwgZWl0aGVyIGRpcmVj
dGx5IGFzIGJsb2NrIGRldmljZXMgb3IgYmFja2luZyBzdG9yYWdlIGZvcgo+IGZpbGVzeXN0ZW1z
LiBDdXJyZW50bHksIHNob3J0IG9mIHdyaXRpbmcgZGF0YSB0byBlaXRoZXIgdGhlIGRldmljZSBv
cgo+IGZpbGVzeXN0ZW0sIHRoZXJlIGlzIG5vIHdheSBmb3IgdXNlcnMgdG8gcHJlLWFsbG9jYXRl
IHNwYWNlIGZvciB1c2UgaW4KPiBzdWNoIHN0b3JhZ2Ugc2V0dXBzLiBDb25zaWRlciB0aGUgZm9s
bG93aW5nIHVzZS1jYXNlczoKPiAKPiAxKSBTdXNwZW5kLXRvLWRpc2sgYW5kIHJlc3VtZSBmcm9t
IGEgZG0tdGhpbiBkZXZpY2U6IEluIG9yZGVyIHRvCj4gZW5zdXJlIHRoYXQgdGhlIHVuZGVybHlp
bmcgdGhpbnBvb2wgbWV0YWRhdGEgaXMgbm90IG1vZGlmaWVkIGR1cmluZwo+IHRoZSBzdXNwZW5k
IG1lY2hhbmlzbSwgdGhlIGRtLXRoaW4gZGV2aWNlIG5lZWRzIHRvIGJlIGZ1bGx5Cj4gcHJvdmlz
aW9uZWQuCj4gMikgSWYgYSBmaWxlc3lzdGVtIHVzZXMgYSBsb29wIGRldmljZSBvdmVyIGEgc3Bh
cnNlIGZpbGUsIGZhbGxvY2F0ZSgpCj4gb24gdGhlIGZpbGVzeXN0ZW0gd2lsbCBhbGxvY2F0ZSBi
bG9ja3MgZm9yIGZpbGVzIGJ1dCB0aGUgdW5kZXJseWluZwo+IHNwYXJzZSBmaWxlIHdpbGwgcmVt
YWluIGludGFjdC4KPiAzKSBBbm90aGVyIGV4YW1wbGUgaXMgdmlydHVhbCBtYWNoaW5lIHVzaW5n
IGEgc3BhcnNlIGZpbGUvZG0tdGhpbiBhcyBhCj4gc3RvcmFnZSBkZXZpY2U7IGJ5IGRlZmF1bHQs
IGFsbG9jYXRpb25zIHdpdGhpbiB0aGUgVk0gYm91bmRhcmllcyB3aWxsCj4gbm90IGFmZmVjdCB0
aGUgaG9zdC4KPiA0KSBTZXZlcmFsIHN0b3JhZ2Ugc3RhbmRhcmRzIHN1cHBvcnQgbWVjaGFuaXNt
cyBmb3IgdGhpbiBwcm92aXNpb25pbmcKPiBvbiByZWFsIGhhcmR3YXJlIGRldmljZXMuIEZvciBl
eGFtcGxlOgo+ICAgYS4gVGhlIE5WTWUgc3BlYyAxLjBiIHNlY3Rpb24gMi4xLjEgbG9vc2VseSB0
YWxrcyBhYm91dCB0aGluCj4gICBwcm92aXNpb25pbmc6ICJXaGVuIHRoZSBUSElOUCBiaXQgaW4g
dGhlIE5TRkVBVCBmaWVsZCBvZiB0aGUKPiAgIElkZW50aWZ5IE5hbWVzcGFjZSBkYXRhIHN0cnVj
dHVyZSBpcyBzZXQgdG8g4oCYMeKAmSwgdGhlIGNvbnRyb2xsZXIgLi4uCj4gICBzaGFsbCB0cmFj
ayB0aGUgbnVtYmVyIG9mIGFsbG9jYXRlZCBibG9ja3MgaW4gdGhlIE5hbWVzcGFjZQo+ICAgVXRp
bGl6YXRpb24gZmllbGQiCj4gICBiLiBUaGUgU0NTaSBCbG9jayBDb21tYW5kcyByZWZlcmVuY2Ug
LSA0IHNlY3Rpb24gcmVmZXJlbmNlcyAiVGhpbgo+ICAgcHJvdmlzaW9uZWQgbG9naWNhbCB1bml0
cyIsCj4gICBjLiBVRlMgMy4wIHNwZWMgc2VjdGlvbiAxMy4zLjMgcmVmZXJlbmNlcyAiVGhpbiBw
cm92aXNpb25pbmciLgo+IAo+IEluIGFsbCBvZiB0aGUgYWJvdmUgc2l0dWF0aW9ucywgY3VycmVu
dGx5IHRoZSBvbmx5IHdheSBmb3IKPiBwcmUtYWxsb2NhdGluZyBzcGFjZSBpcyB0byBpc3N1ZSB3
cml0ZXMgKG9yIHVzZQo+IFdSSVRFX1pFUk9FUy9XUklURV9TQU1FKS4gSG93ZXZlciwgdGhhdCBk
b2VzIG5vdCBzY2FsZSB3ZWxsIHdpdGgKPiBsYXJnZXIgcHJlLWFsbG9jYXRpb24gc2l6ZXMuIAo+
IAo+IFRoaXMgcGF0Y2hzZXQgaW50cm9kdWNlcyBwcmltaXRpdmVzIHRvIHN1cHBvcnQgYmxvY2st
bGV2ZWwKPiBwcm92aXNpb25pbmcgKG5vdGU6IHRoZSB0ZXJtICdwcm92aXNpb25pbmcnIGlzIHVz
ZWQgdG8gcHJldmVudAo+IG92ZXJsb2FkaW5nIHRoZSB0ZXJtICdhbGxvY2F0aW9ucy9wcmUtYWxs
b2NhdGlvbnMnKSByZXF1ZXN0cyBhY3Jvc3MKPiBmaWxlc3lzdGVtcyBhbmQgYmxvY2sgZGV2aWNl
cy4gVGhpcyBhbGxvd3MgZmFsbG9jYXRlKCkgYW5kIGZpbGUKPiBjcmVhdGlvbiByZXF1ZXN0cyB0
byByZXNlcnZlIHNwYWNlIGFjcm9zcyBzdGFja2VkIGxheWVycyBvZiBibG9jawo+IGRldmljZXMg
YW5kIGZpbGVzeXN0ZW1zLiBDdXJyZW50bHksIHRoZSBwYXRjaHNldCBjb3ZlcnMgYSBwcm90b3R5
cGUgb24KPiB0aGUgZGV2aWNlLW1hcHBlciB0YXJnZXRzLCBsb29wIGRldmljZSBhbmQgZXh0NCwg
YnV0IHRoZSBzYW1lCj4gbWVjaGFuaXNtIGNhbiBiZSBleHRlbmRlZCB0byBvdGhlciBmaWxlc3lz
dGVtcy9ibG9jayBkZXZpY2VzIGFzIHdlbGwKPiBhcyBleHRlbmRlZCBmb3IgdXNlIHdpdGggZGV2
aWNlcyBpbiA0IGEtYy4KCklmIHlvdSBjYWxsIFJFUV9PUF9QUk9WSVNJT04gb24gYW4gdW5tYXBw
ZWQgTEJBIHJhbmdlIG9mIGEgYmxvY2sgZGV2aWNlCmFuZCB0aGVuIHRyeSB0byByZWFkIHRoZSBw
cm92aXNpb25lZCBibG9ja3MsIHdoYXQgZG8geW91IGdldD8gIFplcm9lcz8KUmFuZG9tIHN0YWxl
IGRpc2sgY29udGVudHM/CgpJIHRoaW5rIEkgc2F3IGVsc2V3aGVyZSBpbiB0aGUgdGhyZWFkIHRo
YXQgYW55IG1hcHBlZCBMQkFzIHdpdGhpbiB0aGUKcHJvdmlzaW9uaW5nIHJhbmdlIGFyZSBsZWZ0
IGFsb25lIChpLmUuIG5vdCB6ZXJvZWQpIHNvIEknbGwgcHJvY2VlZCBvbgp0aGF0IGJhc2lzLgoK
PiBQYXRjaCAxIGludHJvZHVjZXMgUkVRX09QX1BST1ZJU0lPTiBhcyBhIG5ldyByZXF1ZXN0IHR5
cGUuIFRoZQo+IHByb3Zpc2lvbiByZXF1ZXN0IGFjdHMgbGlrZSB0aGUgaW52ZXJzZSBvZiBhIGRp
c2NhcmQgcmVxdWVzdDsgaW5zdGVhZAo+IG9mIG5vdGlmeWluZyBsb3dlciBsYXllcnMgdGhhdCB0
aGUgYmxvY2sgcmFuZ2Ugd2lsbCBubyBsb25nZXIgYmUgdXNlZCwKPiBwcm92aXNpb24gYWN0cyBh
cyBhIHJlcXVlc3QgdG8gbG93ZXIgbGF5ZXJzIHRvIHByb3Zpc2lvbiBkaXNrIHNwYWNlCj4gZm9y
IHRoZSBnaXZlbiBibG9jayByYW5nZS4gUmVhbCBoYXJkd2FyZSBzdG9yYWdlIGRldmljZXMgd2ls
bAo+IGN1cnJlbnRseSBkaXNhYmxlIHRoZSBwcm92aXNpb2luZyBjYXBhYmlsaXR5IGJ1dCBmb3Ig
dGhlIHN0YW5kYXJkcwo+IGxpc3RlZCBpbiA0YS4tYy4sIFJFUV9PUF9QUk9WSVNJT04gY2FuIGJl
IG92ZXJsb2FkZWQgZm9yIHVzZSBhcyB0aGUKPiBwcm92aXNpb2luZyBwcmltaXRpdmUgZm9yIGZ1
dHVyZSBkZXZpY2VzLgo+IAo+IFBhdGNoIDIgaW1wbGVtZW50cyBSRVFfT1BfUFJPVklTSU9OIGhh
bmRsaW5nIGZvciBzb21lIG9mIHRoZQo+IGRldmljZS1tYXBwZXIgdGFyZ2V0cy4gVGhpcyBhZGRp
dGlvbmFsbHkgYWRkcyBzdXBwb3J0IGZvcgo+IHByZS1hbGxvY2F0aW5nIHNwYWNlIGZvciB0aGlu
bHkgcHJvdmlzaW9uZWQgbG9naWNhbCB2b2x1bWVzIHZpYQo+IGZhbGxvY2F0ZSgpCj4gCj4gUGF0
Y2ggMyBpbXBsZW1lbnRzIHRoZSBoYW5kbGluZyBmb3IgdmlydGlvLWJsay4KPiAKPiBQYXRjaCA0
IGludHJvZHVjZXMgYW4gZmFsbG9jYXRlKCkgbW9kZSAoRkFMTE9DX0ZMX1BST1ZJU0lPTikgdGhh
dAo+IHNlbmRzIGEgcHJvdmlzaW9uIHJlcXVlc3QgdG8gdGhlIHVuZGVybHlpbmcgYmxvY2sgZGV2
aWNlIChhbmQgYmV5b25kKS4KPiBUaGlzIGFjdHMgYXMgdGhlIHByaW1hcnkgbWVjaGFuaXNtIGZv
ciBmaWxlLWxldmVsIHByb3Zpc2lvaW5nLgoKUGVyc29uYWxseSwgSSB0aGluayBpdCdzIHdlbGwg
d2l0aGluIHRoZSBkZWZpbml0aW9uIG9mIGZhbGxvY2F0ZSBtb2RlPT0wCihha2EgcHJlYWxsb2Nh
dGUpIGZvciBYRlMgdG8gY2FsbCBSRVFfT1BfUFJPVklTSU9OIG9uIHRoZSBibG9ja3MgdGhhdCBp
dApwcmVhbGxvY2F0ZXM/ICBYRlMgYWx3YXlzIHNldHMgdGhlIHVud3JpdHRlbiBmbGFnIG9uIHRo
ZSBmaWxlIG1hcHBpbmcsCnNvIGl0IGRvZXNuJ3QgbWF0dGVyIGlmIHRoZSBkZXZpY2UgcHJvdmlz
aW9ucyBzcGFjZSB3aXRob3V0IHplcm9pbmcgdGhlCmNvbnRlbnRzLgoKVGhhdCBzYWlkLCBpZiBk
ZXZpY2VzIGFyZSByZWFsbHkgYWxsb3dlZCB0byBleHBvc2Ugc3RhbGUgZGlzayBibG9ja3MKdGhl
biBmb3IgYmxrZGV2IGZhbGxvY2F0ZSBJIHRoaW5rIHlvdSBjb3VsZCBnZXQgYXdheSB3aXRoIHJl
dXNpbgpGQUxMT0NfRkxfTk9fSElERV9TVEFMRSBpbnN0ZWFkIG9mIGludHJvZHVjaW5nIGEgbmV3
IGZhbGxvY2F0ZSBmbGFnLgoKPiBQYXRjaCA1IHdpcmVzIHVwIHRoZSBsb29wIGRldmljZSBoYW5k
bGluZyBvZiBSRVFfT1BfUFJPVklTSU9OLgo+IAo+IFBhdGNoZXMgNi04IGNvdmVyIGEgcHJvdG90
eXBlIGltcGxlbWVudGF0aW9uIGZvciBleHQ0LCB3aGljaCBpbmNsdWRlcwo+IHdpcmluZyB1cCB0
aGUgZmFsbG9jYXRlKCkgaW1wbGVtZW50YXRpb24sIGludHJvZHVjaW5nIGEgZmlsZXN5c3RlbQo+
IGxldmVsIG9wdGlvbiAoY2FsbGVkICdwcm92aXNpb24nKSB0byBjb250cm9sIHRoZSBkZWZhdWx0
IGFsbG9jYXRpb24KPiBiZWhhdmlvdXIgYW5kIGZpbmFsbHkgYSBmaWxlIGxldmVsIG92ZXJyaWRl
IHRvIHJldGFpbiBjdXJyZW50Cj4gaGFuZGxpbmcsIGV2ZW4gb24gZmlsZXN5c3RlbXMgbW91bnRl
ZCB3aXRoICdwcm92aXNpb24nCgpIbW0sIEknbGwgaGF2ZSBhIGxvb2suCgo+IFRlc3Rpbmc6Cj4g
LS0tLS0tLS0KPiAtIEEgYmFja3BvcnQgb2YgdGhpcyBwYXRjaCBzZXJpZXMgd2FzIHRlc3RlZCBv
biBDaHJvbWl1bU9TIHVzaW5nIGEKPiA1LjEwIGtlcm5lbC4KPiAtIEZpbGUgb24gZXh0NCBvbiBh
IHRoaW4gbG9naWNhbCB2b2x1bWU6Cj4gZmFsbG9jYXRlKEZBTExPQ19GTF9QUk9WSVNJT04pIDog
NC42cywgZGQgaWY9L2Rldi96ZXJvIG9mPS4uLjogNiBtaW5zLgo+IAo+IFRPRE9zOgo+IC0tLS0t
LQo+IDEpIFRoZSBzdGFja2VkIGJsb2NrIGRldmljZXMgKGRtLSosIGxvb3AgZXRjLikgY3VycmVu
dGx5Cj4gdW5jb25kaXRpb25hbGx5IHBhc3MgdGhyb3VnaCBwcm92aXNpb24gcmVxdWVzdHMuIEFk
ZCBzdXBwb3J0IGZvcgo+IHByb3Zpc2lvbiwgc2ltaWxhciB0byBob3cgZGlzY2FyZCBoYW5kbGlu
ZyBpcyBzZXQgdXAgKHdpdGggb3B0aW9ucyB0bwo+IGRpc2FibGUsIHBhc3Nkb3duIG9yIHBhc3N0
aHJvdWdoIHJlcXVlc3RzKS4KPiAyKSBCbGt0ZXN0cyBhbmQgWGZzdGVzdHMgZm9yIHZhbGlkYXRp
bmcgcHJvdmlzaW9uaW5nLgoKWWVzLi4uLgoKLS1ECgo+IC0tCj4gZG0tZGV2ZWwgbWFpbGluZyBs
aXN0Cj4gZG0tZGV2ZWxAcmVkaGF0LmNvbQo+IGh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21h
aWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZl
bEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8v
ZG0tZGV2ZWwK

