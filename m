Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 531CBCD98E0
	for <dm-devel@archiver.kernel.org>; Wed, 11 Oct 2023 00:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696982833;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ccfcsQYgZLRM0MxNm9pRdyNl/y510hoa8DxT0FtZ/lg=;
	b=dkvIZRdlSj61S4apK8cKCglC2vo0D8Gv1IfqOl3eFiPEkkyhzf7S8KD3L5Ram8b4EGWV/0
	s6mcIWasPBRv4VyOcy1Ral6uvfGJhiHT9aYxji3XviW+06jJOx/wSXTaUvQPndhi7FhZAS
	+VovZgDo1Ng97gstMigVIz6HaIsm1ck=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-mrw4_XKKOImNBSd9eOe4Pw-1; Tue, 10 Oct 2023 20:07:10 -0400
X-MC-Unique: mrw4_XKKOImNBSd9eOe4Pw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B22C101A590;
	Wed, 11 Oct 2023 00:07:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AAF1520807F4;
	Wed, 11 Oct 2023 00:07:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 614A619465B8;
	Wed, 11 Oct 2023 00:07:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7DA581946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 11 Oct 2023 00:07:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 58B041C06533; Wed, 11 Oct 2023 00:07:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 510471C060DF
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 00:07:05 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F047B1C09A48
 for <dm-devel@redhat.com>; Wed, 11 Oct 2023 00:07:04 +0000 (UTC)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-yRXt5Lk9MeSEhyuMxa1feQ-1; Tue, 10 Oct 2023 20:07:02 -0400
X-MC-Unique: yRXt5Lk9MeSEhyuMxa1feQ-1
Received: by mail-pg1-f178.google.com with SMTP id
 41be03b00d2f7-578b4997decso4729222a12.0
 for <dm-devel@redhat.com>; Tue, 10 Oct 2023 17:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1696982821; x=1697587621;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=pi+6fuCZ7nV+P3VswapuyLpGimJN9EBPXoRWDqou4vc=;
 b=vAjn4dXSOsaTguMTcYmUo/vGzsrJLw1QQnYAV8RF0MlAihEVwtesvpg7TK3RdOquOS
 g88KIJxx1RZBxYWRzAOVYaGceKi1wVcv0UURlSkk0DBAjF6NyhQ6Lbz1H/OBMllTIaF+
 uItY/keRFXr1Qy2q1SF4HZHWeNgPfpCQSOoWZxgQANeZBuAwwyEiEwE0WK6TPlXln5kq
 3KXUF5naw2UMtDmfq6Iy4JAS699Yum9OcBxmS5iot76VMZ9Tn7il6pWhzRdDWv0Jil52
 RvedM5zg5PVdaJbxVjj10puMGXYiBeZqGtZVbj1Oq7w0RGboOBGY9iFLHmEEf65mfxFv
 ez5Q==
X-Gm-Message-State: AOJu0YzLQ05DExmOlD+Jbdxhh0S+IRmTdJHyOeuj9l4tbnyr4EE7fpBD
 Rg2104wrMzd7KSy0EaykfyTBeg==
X-Google-Smtp-Source: AGHT+IFaQsl6J0oGbAmpi1RKpoyAS4x5TyIMLa9yejYUMWdd4HdS26Ku+N4gQppaQiaJj/ZVu9D0qw==
X-Received: by 2002:a05:6a21:6d9b:b0:14b:8023:33cb with SMTP id
 wl27-20020a056a216d9b00b0014b802333cbmr25670485pzb.11.1696982820871; 
 Tue, 10 Oct 2023 17:07:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au.
 [49.180.20.59]) by smtp.gmail.com with ESMTPSA id
 ji9-20020a170903324900b001c5900c9e8fsm12483875plb.81.2023.10.10.17.07.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 10 Oct 2023 17:07:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
 (envelope-from <david@fromorbit.com>) id 1qqMkb-00CB10-3B;
 Wed, 11 Oct 2023 11:06:58 +1100
Date: Wed, 11 Oct 2023 11:06:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZSXnIYejKVo74doY@dread.disaster.area>
References: <20231007012817.3052558-1-sarthakkukreti@chromium.org>
 <20231007012817.3052558-6-sarthakkukreti@chromium.org>
 <ZSM64EOTVyKNkc/X@dread.disaster.area>
 <CAG9=OMP_YbfCyjJGGwoZfgwxO-FmR55F5zv3DO8c2-=YzY8iwA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAG9=OMP_YbfCyjJGGwoZfgwxO-FmR55F5zv3DO8c2-=YzY8iwA@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v8 5/5] block: Pass unshare intent via
 REQ_OP_PROVISION
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <djwong@kernel.org>,
 Brian Foster <bfoster@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: fromorbit.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBPY3QgMTAsIDIwMjMgYXQgMDM6NDI6MzlQTSAtMDcwMCwgU2FydGhhayBLdWtyZXRp
IHdyb3RlOgo+IE9uIFN1biwgT2N0IDgsIDIwMjMgYXQgNDoyN+KAr1BNIERhdmUgQ2hpbm5lciA8
ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6Cj4gPgo+ID4gT24gRnJpLCBPY3QgMDYsIDIwMjMg
YXQgMDY6Mjg6MTdQTSAtMDcwMCwgU2FydGhhayBLdWtyZXRpIHdyb3RlOgo+ID4gPiBBbGxvdyBS
RVFfT1BfUFJPVklTSU9OIHRvIHBhc3MgaW4gYW4gZXh0cmEgUkVRX1VOU0hBUkUgYml0IHRvCj4g
PiA+IGFubm90YXRlIHVuc2hhcmUgcmVxdWVzdHMgdG8gdW5kZXJseWluZyBsYXllcnMuIExheWVy
cyB0aGF0IHN1cHBvcnQKPiA+ID4gRkFMTE9DX0ZMX1VOU0hBUkUgd2lsbCBiZSBhYmxlIHRvIHVz
ZSB0aGlzIGFzIGFuIGluZGljYXRvciBvZiB3aGljaAo+ID4gPiBmYWxsb2NhdGUoKSBtb2RlIHRv
IHVzZS4KPiA+ID4KPiA+ID4gU3VnZ2VzdGVkLWJ5OiBEYXJyaWNrIEouIFdvbmcgPGRqd29uZ0Br
ZXJuZWwub3JnPgo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBTYXJ0aGFrIEt1a3JldGkgPHNhcnRoYWtr
dWtyZXRpQGNocm9taXVtLm9yZz4KPiA+ID4gLS0tCj4gPiA+ICBibG9jay9ibGstbGliLmMgICAg
ICAgICAgIHwgIDYgKysrKystCj4gPiA+ICBibG9jay9mb3BzLmMgICAgICAgICAgICAgIHwgIDYg
KysrKy0tCj4gPiA+ICBkcml2ZXJzL2Jsb2NrL2xvb3AuYyAgICAgIHwgMzUgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKystLS0tLS0KPiA+ID4gIGluY2x1ZGUvbGludXgvYmxrX3R5cGVzLmgg
fCAgMyArKysKPiA+ID4gIGluY2x1ZGUvbGludXgvYmxrZGV2LmggICAgfCAgMyArKy0KPiA+ID4g
IDUgZmlsZXMgY2hhbmdlZCwgNDMgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCj4gPgo+
ID4gSSBoYXZlIG5vIGlkZWEgaG93IGZpbGVzeXN0ZW1zIChvciBldmVuIHVzZXJzcGFjZSBhcHBs
aWNhdGlvbnMsIGZvcgo+ID4gdGhhdCBtYXR0ZXIpIGFyZSBzdXBwb3NlZCB0byB1c2UgdGhpcyAt
IHRoZXkgaGF2ZSBubyBpZGVhIGlmIHRoZQo+ID4gdW5kZXJseWluZyBibG9jayBkZXZpY2UgaGFz
IHNoYXJlZCBibG9ja3MgZm9yIExCQSByYW5nZXMgaXQgYWxyZWFkeQo+ID4gaGFzIGFsbG9jYXRl
ZCBhbmQgcHJvdmlzaW9uZWQuIElPV3MsIEkgZG9uJ3Qga25vdyB3YWh0IHRoZSBzZW1hbnRpY3MK
PiA+IG9mIHRoaXMgZnVuY3Rpb24gaXMsIGl0IGlzIG5vdCBkb2N1bWVudGVkIGFueXdoZXJlLCBh
bmQgdGhlcmUgaXMgbm8KPiA+IHVzZSBjYXNlIHByZXNlbnQgdGhhdCB0ZWxscyBtZSBob3cgaXQg
bWlnaHQgZ2V0IHVzZWQuCj4gPgo+ID4gWWVzLCB1bnNoYXJlIGF0IHRoZSBmaWxlIGxldmVsIG1l
YW5zIHRoZSBmaWxlc3lzdGVtIHRyaWVzIHRvIGJyZWFrCj4gPiBpbnRlcm5hbCBkYXRhIGV4dGVu
dCBzaGFyaW5nLCBidXQgaWYgdGhlIGJsb2NrIGxheWVycyBvciBiYWNraW5nCj4gPiBkZXZpY2Vz
IGFyZSBkb2luZyBkZWR1cGxpY2F0aW9uIGFuZCBzaGFyaW5nIHVua25vd24gdG8gdGhlCj4gPiBh
cHBsaWNhdGlvbiBvciBmaWxlc3lzdGVtLCBob3cgZG8gdGhleSBldmVyIGtub3cgdGhhdCB0aGlz
IG9wZXJhdGlvbgo+ID4gbWlnaHQgbmVlZCB0byBiZSBwZXJmb3JtZWQ/IEluIHdoYXQgY2FzZXMg
ZG8gd2UgbmVlZCB0byBiZSBhYmxlIHRvCj4gPiB1bnNoYXJlIGJsb2NrIGRldmljZSByYW5nZXMs
IGFuZCBob3cgaXMgdGhhdCBkaWZmZXJlbnQgdG8gdGhlCj4gPiBndWFyYW50ZWVzIHRoYXQgUkVR
X1BST1ZJU0lPTiBpcyBhbHJlYWR5IHN1cHBvc2VkIHRvIGdpdmUgZm9yCj4gPiBwcm92aXNpb25l
ZCByYW5nZXMgdGhhdCBhcmUgdGhlbiBzdWJzZXF1ZW50bHkgc2hhcmVkIGJ5IHRoZSBibG9jawo+
ID4gZGV2aWNlIChlLmcuIGJ5IHNuYXBzaG90cyk/Cj4gPgo+ID4gQWxzbywgZnJvbSBhbiBBUEkg
cGVyc3BlY3RpdmUsIHRoaXMgaXMgYW4gInVuc2hhcmUiIGRhdGEgb3BlcmF0aW9uLAo+ID4gbm90
IGEgInByb3Zpc2lvbiIgb3BlcmF0aW9uLiBIZW5jZSBJJ2Qgc3VnZ2VzdCB0aGF0IHRoZSBBUEkg
c2hvdWxkCj4gPiBiZSBibGtkZXZfaXNzdWVfdW5zaGFyZSgpIHJhdGhlciB0aGFuIG9wdGlvbmFs
IGJlaGF2aW91ciB0bwo+ID4gX3Byb3Zpc2lvbigpIHdoaWNoIC0gYmVmb3JlIHRoaXMgcGF0Y2gg
LSBoYWQgY2xlYXIgYW5kIHdlbGwgZGVmaW5lZAo+ID4gbWVhbmluZy4uLi4KPiA+Cj4gRmFpciBw
b2ludHMsIHRoZSBpbnRlbnQgZnJvbSB0aGUgY29udmVyc2F0aW9uIHdpdGggRGFycmljayB3YXMg
dGhlCj4gYWRkaXRpb24gb2Ygc3VwcG9ydCBmb3IgRkFMTE9DX0ZMX1VOU0hBUkVfUkFOR0UgaW4g
cGF0Y2ggMiBvZiB2NAo+IChvcmlnaW5hbGx5IHN1Z2dlc3RlZCBieSBCcmlhbiBGb3JzdGVyIGlu
IFsxXSk6IGlmIHdlIGFsbG93Cj4gZmFsbG9jYXRlKFVOU0hBUkVfUkFOR0UpIG9uIGEgbG9vcCBk
ZXZpY2UgKGV4LiBmb3IgY3JlYXRpbmcgYQo+IHNuYXBzaG90LCBzaW1pbGFyIGluIG5hdHVyZSB0
byB0aGUgRklDTE9ORSBleGFtcGxlIHlvdSBtZW50aW9uZWQgb24KPiB0aGUgbG9vcCBwYXRjaCks
IHdlJ2QgKGlkZWFsbHkpIHdhbnQgdG8gcGFzcyBpdCB0aHJvdWdoIHRvIHRoZQo+IHVuZGVybHlp
bmcgbGF5ZXJzIGFuZCBsZXQgdGhlbSBmaWd1cmUgb3V0IHdoYXQgdG8gZG8gd2l0aCBpdC4gQnV0
IGl0Cj4gaXMgb25seSBmb3Igc2l0dWF0aW9ucyB3aGVyZSB3ZSBhcmUgZXhwbGljaXRseSBrbm93
IHdoYXQgdGhlCj4gdW5kZXJseWluZyBsYXllcnMgYXJlIGFuZCB3aGF0J3MgdGhlIG1lY2hhCj4g
Cj4gSSBhZ3JlZSB0aG91Z2ggdGhhdCBpdCBjbG91ZHMgdGhlIEFQSSBhIGJpdCBhbmQgSSBkb24n
dCB0aGluayBpdAo+IG5lY2Vzc2FyaWx5IG5lZWRzIHRvIGJlIGEgcGFydCBvZiB0aGUgaW5pdGlh
bCBwYXRjaCBzZXJpZXM6IGZvciBub3csIEkKPiBwcm9wb3NlIGtlZXBpbmcganVzdCBtb2RlIHpl
cm8gKGFuZCBGQUxMT0NfRkxfS0VFUF9TSVpFKSBoYW5kbGluZyBpbgo+IHRoZSBibG9jayBzZXJp
ZXMgcGF0Y2ggYW5kIGRyb3AgdGhpcyBwYXRjaCBmb3Igbm93LiBXRFlUPwoKVW50aWwgd2UgaGF2
ZSBhbiBhY3R1YWwgdXNlIGNhc2UgZm9yIHVuc2hhcmluZyAod2hpY2ggZXhwbGljaXRseQpicmVh
a3MgZXh0ZW50IHNoYXJpbmcpIGFzIG9wcG9zZWQgdG8gcHJvdmlzaW9uaW5nICh3aGljaCBlbnN1
cmVzCm92ZXJ3cml0ZXMgYWx3YXlzIHN1Y2NlZWQgcmVnYXJkbGVzcyBvZiBleHRlbnQgc3RhdGUp
IHRoZW4gbGV0J3MKbGVhdmUgaXQgb3V0IG9mIHRoaXMgLXByb3Zpc2lvbmluZy0gc2VyaWVzLgoK
LURhdmUuCi0tIApEYXZlIENoaW5uZXIKZGF2aWRAZnJvbW9yYml0LmNvbQoKLS0KZG0tZGV2ZWwg
bWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

