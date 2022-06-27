Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3220DC43334
	for <dm-devel@archiver.kernel.org>; Tue, 28 Jun 2022 06:39:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-275-XNOYcFWfO8qfPWaHxGeQJw-1; Tue, 28 Jun 2022 02:38:07 -0400
X-MC-Unique: XNOYcFWfO8qfPWaHxGeQJw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06EA129DD99D;
	Tue, 28 Jun 2022 06:38:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E9E79492C3B;
	Tue, 28 Jun 2022 06:38:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8EF13194705E;
	Tue, 28 Jun 2022 06:38:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AEB0919466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Jun 2022 18:51:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 74479415F5E; Mon, 27 Jun 2022 18:51:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FBB540F06D
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 18:51:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56C8E8032EA
 for <dm-devel@redhat.com>; Mon, 27 Jun 2022 18:51:33 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-IqwLqWbzOgylzHPR8OjwKA-1; Mon, 27 Jun 2022 14:51:31 -0400
X-MC-Unique: IqwLqWbzOgylzHPR8OjwKA-1
Received: from sslproxy03.your-server.de ([88.198.220.132])
 by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
 (Exim 4.92.3) (envelope-from <daniel@iogearbox.net>)
 id 1o5tSV-000G0X-5e; Mon, 27 Jun 2022 20:27:39 +0200
Received: from [85.1.206.226] (helo=linux.home)
 by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
 (Exim 4.92) (envelope-from <daniel@iogearbox.net>)
 id 1o5tSU-000TKD-AF; Mon, 27 Jun 2022 20:27:38 +0200
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
References: <20220627180432.GA136081@embeddedor>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6bc1e94c-ce1d-a074-7d0c-8dbe6ce22637@iogearbox.net>
Date: Mon, 27 Jun 2022 20:27:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220627180432.GA136081@embeddedor>
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26586/Mon Jun 27 10:06:41 2022)
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
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-hardening@vger.kernel.org,
 linux1394-devel@lists.sourceforge.net,
 linux-stm32@st-md-mailman.stormreply.com, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, x86@kernel.org,
 kasan-dev@googlegroups.com, lvs-devel@vger.kernel.org, coreteam@netfilter.org,
 v9fs-developer@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
 linux-can@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, io-uring@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-sctp@vger.kernel.org, netfilter-devel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gNi8yNy8yMiA4OjA0IFBNLCBHdXN0YXZvIEEuIFIuIFNpbHZhIHdyb3RlOgo+IFRoZXJlIGlz
IGEgcmVndWxhciBuZWVkIGluIHRoZSBrZXJuZWwgdG8gcHJvdmlkZSBhIHdheSB0byBkZWNsYXJl
Cj4gaGF2aW5nIGEgZHluYW1pY2FsbHkgc2l6ZWQgc2V0IG9mIHRyYWlsaW5nIGVsZW1lbnRzIGlu
IGEgc3RydWN0dXJlLgo+IEtlcm5lbCBjb2RlIHNob3VsZCBhbHdheXMgdXNlIOKAnGZsZXhpYmxl
IGFycmF5IG1lbWJlcnPigJ1bMV0gZm9yIHRoZXNlCj4gY2FzZXMuIFRoZSBvbGRlciBzdHlsZSBv
ZiBvbmUtZWxlbWVudCBvciB6ZXJvLWxlbmd0aCBhcnJheXMgc2hvdWxkCj4gbm8gbG9uZ2VyIGJl
IHVzZWRbMl0uCj4gCj4gVGhpcyBjb2RlIHdhcyB0cmFuc2Zvcm1lZCB3aXRoIHRoZSBoZWxwIG9m
IENvY2NpbmVsbGU6Cj4gKGxpbnV4LTUuMTktcmMyJCBzcGF0Y2ggLS1qb2JzICQoZ2V0Y29uZiBf
TlBST0NFU1NPUlNfT05MTikgLS1zcC1maWxlIHNjcmlwdC5jb2NjaSAtLWluY2x1ZGUtaGVhZGVy
cyAtLWRpciAuID4gb3V0cHV0LnBhdGNoKQo+IAo+IEBACj4gaWRlbnRpZmllciBTLCBtZW1iZXIs
IGFycmF5Owo+IHR5cGUgVDEsIFQyOwo+IEBACj4gCj4gc3RydWN0IFMgewo+ICAgIC4uLgo+ICAg
IFQxIG1lbWJlcjsKPiAgICBUMiBhcnJheVsKPiAtIDAKPiAgICBdOwo+IH07Cj4gCj4gLWZzdHJp
Y3QtZmxleC1hcnJheXM9MyBpcyBjb21pbmcgYW5kIHdlIG5lZWQgdG8gbGFuZCB0aGVzZSBjaGFu
Z2VzCj4gdG8gcHJldmVudCBpc3N1ZXMgbGlrZSB0aGVzZSBpbiB0aGUgc2hvcnQgZnV0dXJlOgo+
IAo+IC4uL2ZzL21pbml4L2Rpci5jOjMzNzozOiB3YXJuaW5nOiAnc3RyY3B5JyB3aWxsIGFsd2F5
cyBvdmVyZmxvdzsgZGVzdGluYXRpb24gYnVmZmVyIGhhcyBzaXplIDAsCj4gYnV0IHRoZSBzb3Vy
Y2Ugc3RyaW5nIGhhcyBsZW5ndGggMiAoaW5jbHVkaW5nIE5VTCBieXRlKSBbLVdmb3J0aWZ5LXNv
dXJjZV0KPiAJCXN0cmNweShkZTMtPm5hbWUsICIuIik7Cj4gCQleCj4gCj4gU2luY2UgdGhlc2Ug
YXJlIGFsbCBbMF0gdG8gW10gY2hhbmdlcywgdGhlIHJpc2sgdG8gVUFQSSBpcyBuZWFybHkgemVy
by4gSWYKPiB0aGlzIGJyZWFrcyBhbnl0aGluZywgd2UgY2FuIHVzZSBhIHVuaW9uIHdpdGggYSBu
ZXcgbWVtYmVyIG5hbWUuCj4gCj4gWzFdIGh0dHBzOi8vZW4ud2lraXBlZGlhLm9yZy93aWtpL0Zs
ZXhpYmxlX2FycmF5X21lbWJlcgo+IFsyXSBodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1s
L3Y1LjE2L3Byb2Nlc3MvZGVwcmVjYXRlZC5odG1sI3plcm8tbGVuZ3RoLWFuZC1vbmUtZWxlbWVu
dC1hcnJheXMKPiAKPiBMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vS1NQUC9saW51eC9pc3N1ZXMv
NzgKPiBCdWlsZC10ZXN0ZWQtYnk6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvNjJiNjc1
ZWMud0tYNkFPWjZjYkU3MXZ0RiUyNWxrcEBpbnRlbC5jb20vCj4gU2lnbmVkLW9mZi1ieTogR3Vz
dGF2byBBLiBSLiBTaWx2YSA8Z3VzdGF2b2Fyc0BrZXJuZWwub3JnPgo+IC0tLQo+IEhpIGFsbCEK
PiAKPiBKRllJOiBJJ20gYWRkaW5nIHRoaXMgdG8gbXkgLW5leHQgdHJlZS4gOikKCkZ5aSwgdGhp
cyBicmVha3MgQlBGIENJOgoKaHR0cHM6Ly9naXRodWIuY29tL2tlcm5lbC1wYXRjaGVzL2JwZi9y
dW5zLzcwNzg3MTkzNzI/Y2hlY2tfc3VpdGVfZm9jdXM9dHJ1ZQoKICAgWy4uLl0KICAgcHJvZ3Mv
bWFwX3B0cl9rZXJuLmM6MzE0OjI2OiBlcnJvcjogZmllbGQgJ3RyaWVfa2V5JyB3aXRoIHZhcmlh
YmxlIHNpemVkIHR5cGUgJ3N0cnVjdCBicGZfbHBtX3RyaWVfa2V5JyBub3QgYXQgdGhlIGVuZCBv
ZiBhIHN0cnVjdCBvciBjbGFzcyBpcyBhIEdOVSBleHRlbnNpb24gWy1XZXJyb3IsLVdnbnUtdmFy
aWFibGUtc2l6ZWQtdHlwZS1ub3QtYXQtZW5kXQogICAgICAgICAgIHN0cnVjdCBicGZfbHBtX3Ry
aWVfa2V5IHRyaWVfa2V5OwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF4KICAg
MSBlcnJvciBnZW5lcmF0ZWQuCiAgIG1ha2U6ICoqKiBbTWFrZWZpbGU6NTE5OiAvdG1wL3J1bm5l
ci93b3JrL2JwZi9icGYvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL21hcF9wdHJfa2Vybi5v
XSBFcnJvciAxCiAgIG1ha2U6ICoqKiBXYWl0aW5nIGZvciB1bmZpbmlzaGVkIGpvYnMuLi4uCiAg
IEVycm9yOiBQcm9jZXNzIGNvbXBsZXRlZCB3aXRoIGV4aXQgY29kZSAyLgoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

