Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73683C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  8 Mar 2022 20:48:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-reINBFG-OsiVX4mFA1XOnA-1; Tue, 08 Mar 2022 15:48:30 -0500
X-MC-Unique: reINBFG-OsiVX4mFA1XOnA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB9703801EC9;
	Tue,  8 Mar 2022 20:48:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 91CE62166B48;
	Tue,  8 Mar 2022 20:48:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5C493194F4B5;
	Tue,  8 Mar 2022 20:48:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E5512194F4AE
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Mar 2022 20:48:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D25CC145FBA5; Tue,  8 Mar 2022 20:48:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE3B4145FBA0
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 20:48:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5CA0185A79C
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 20:48:24 +0000 (UTC)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com
 [209.85.218.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-A5GRltaHMLSXBV0rroF0lw-1; Tue, 08 Mar 2022 15:48:22 -0500
X-MC-Unique: A5GRltaHMLSXBV0rroF0lw-1
Received: by mail-ej1-f53.google.com with SMTP id qt6so475408ejb.11
 for <dm-devel@redhat.com>; Tue, 08 Mar 2022 12:48:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=ZwTZJ+cU/YiESkdxq7NY4b6RLcbHEOvUMvJI9bbFH7M=;
 b=0ikkVemJ2mIOGtDvct2+XTJo0+GGD+uuy1PL5depCiY/1uG1hZ7T/AGiElOLN4sb0U
 fC+fR332tqVx4IPwl0JDTelGxumorwRqXpQJoolOvFEpS7V7iUVBYBCQH0r7eqb0bZi+
 /9s8sP04EEe8BnejzbpK3IV3xi0ij7S9n9BNNs9dt6UxPAzJSh9stii6xlN14UzwPvAd
 qPVuzFG8Aqb8kkTcsLgGNnugUnsyZdAZzTK+jBkW2SYd/6wQ/ZP6dh2xvSvoz4fIi5hz
 P2jIhtLpr28vk4maonEj0hlcop74P8wXQeICYgOuNWxHMb0yTIKzOF7AdVP3bB+xvPPg
 NY3g==
X-Gm-Message-State: AOAM532LKmkxXP6CgEtYFtvzpi1gsz2qvxsRD+OyNXowTrRlipGB+NHC
 vQVW5S6qmr8K4Huo11MmW4DHTQ==
X-Google-Smtp-Source: ABdhPJxoU+8TvtIedOHXaAEiIlveanpsqTd3At14GihTobnyXos5yBO4WToMuK5Nec5SIeR3YDUPEQ==
X-Received: by 2002:a17:907:168a:b0:6da:9167:47dc with SMTP id
 hc10-20020a170907168a00b006da916747dcmr14943856ejc.126.1646772501317; 
 Tue, 08 Mar 2022 12:48:21 -0800 (PST)
Received: from [172.16.10.50] (213.16.240.129.dsl.dyn.forthnet.gr.
 [213.16.240.129]) by smtp.gmail.com with ESMTPSA id
 r23-20020aa7da17000000b00415a1431488sm8172430eds.4.2022.03.08.12.48.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Mar 2022 12:48:20 -0800 (PST)
Message-ID: <23895da7-bcec-d092-373a-c3d961ab5c48@arrikto.com>
Date: Tue, 8 Mar 2022 22:48:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
 <012723a9-2e9c-c638-4944-fa560e1b0df0@arrikto.com>
 <c4124f39-1ee9-8f34-e731-42315fee15f9@nvidia.com>
From: Nikos Tsironis <ntsironis@arrikto.com>
In-Reply-To: <c4124f39-1ee9-8f34-e731-42315fee15f9@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
 Offload
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
Cc: "djwong@kernel.org" <djwong@kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "osandov@fb.com" <osandov@fb.com>,
 "msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
 Bart Van Assche <bvanassche@acm.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Christoph Hellwig <hch@lst.de>,
 "roland@purestorage.com" <roland@purestorage.com>,
 "zach.brown@ni.com" <zach.brown@ni.com>, "dsterba@suse.com" <dsterba@suse.com>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "mpatocka@redhat.com" <mpatocka@redhat.com>,
 "kbus >> Keith Busch" <kbusch@kernel.org>,
 "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
 Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
 "martin.petersen@oracle.com >> Martin K. Petersen"
 <martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMy8xLzIyIDIzOjMyLCBDaGFpdGFueWEgS3Vsa2Fybmkgd3JvdGU6Cj4gTmlrb3MsCj4gCj4+
PiBbOF0gaHR0cHM6Ly9rZXJuZWwuZGsvaW9fdXJpbmcucGRmCj4+Cj4+IEkgd291bGQgbGlrZSB0
byBwYXJ0aWNpcGF0ZSBpbiB0aGUgZGlzY3Vzc2lvbiB0b28uCj4+Cj4+IFRoZSBkbS1jbG9uZSB0
YXJnZXQgd291bGQgYWxzbyBiZW5lZml0IGZyb20gY29weSBvZmZsb2FkLCBhcyBpdCBoZWF2aWx5
Cj4+IGVtcGxveXMgZG0ta2NvcHlkLiBJIGhhdmUgYmVlbiBleHBsb3JpbmcgcmVkZXNpZ25pbmcg
a2NvcHlkIGluIG9yZGVyIHRvCj4+IGFjaGlldmUgaW5jcmVhc2VkIElPUFMgaW4gZG0tY2xvbmUg
YW5kIGRtLXNuYXBzaG90IGZvciBzbWFsbCBjb3BpZXMgb3Zlcgo+PiBOVk1lIGRldmljZXMsIGJ1
dCBjb3B5IG9mZmxvYWQgc291bmRzIGV2ZW4gbW9yZSBwcm9taXNpbmcsIGVzcGVjaWFsbHkKPj4g
Zm9yIGxhcmdlciBjb3BpZXMgaGFwcGVuaW5nIGluIHRoZSBiYWNrZ3JvdW5kIChhcyBpcyB0aGUg
Y2FzZSB3aXRoCj4+IGRtLWNsb25lJ3MgYmFja2dyb3VuZCBoeWRyYXRpb24pLgo+Pgo+PiBUaGFu
a3MsCj4+IE5pa29zCj4gCj4gSWYgeW91IGNhbiBkb2N1bWVudCB5b3VyIGZpbmRpbmdzIGhlcmUg
aXQgd2lsbCBiZSBncmVhdCBmb3IgbWUgdG8KPiBhZGQgaXQgdG8gdGhlIGFnZW5kYS4KPiAKCk15
IHdvcmsgZm9jdXNlcyBtYWlubHkgb24gaW1wcm92aW5nIHRoZSBJT1BzIGFuZCBsYXRlbmN5IG9m
IHRoZQpkbS1zbmFwc2hvdCB0YXJnZXQsIGluIG9yZGVyIHRvIGJyaW5nIHRoZSBwZXJmb3JtYW5j
ZSBvZiBzaG9ydC1saXZlZApzbmFwc2hvdHMgYXMgY2xvc2UgYXMgcG9zc2libGUgdG8gYmFyZS1t
ZXRhbCBwZXJmb3JtYW5jZS4KCk15IGluaXRpYWwgcGVyZm9ybWFuY2UgZXZhbHVhdGlvbiBvZiBk
bS1zbmFwc2hvdCBoYWQgcmV2ZWFsZWQgYSBiaWcKcGVyZm9ybWFuY2UgZHJvcCwgd2hpbGUgdGhl
IHNuYXBzaG90IGlzIGFjdGl2ZTsgYSBkcm9wIHdoaWNoIGlzIG5vdApqdXN0aWZpZWQgYnkgQ09X
IGFsb25lLgoKVXNpbmcgZmlvIHdpdGggYmxrdHJhY2UgSSBoYWQgbm90aWNlZCB0aGF0IHRoZSBw
ZXItQ1BVIEkvTyBkaXN0cmlidXRpb24Kd2FzIHVuZXZlbi4gQWx0aG91Z2ggbWFueSB0aHJlYWRz
IHdlcmUgZG9pbmcgSS9PLCBvbmx5IGEgY291cGxlIG9mIHRoZQpDUFVzIGVuZGVkIHVwIHN1Ym1p
dHRpbmcgSS9PIHJlcXVlc3RzIHRvIHRoZSB1bmRlcmx5aW5nIGRldmljZS4KClRoZSBzYW1lIGlz
c3VlIGFsc28gYWZmZWN0cyBkbS1jbG9uZSwgd2hlbiBkb2luZyBJL08gd2l0aCBzaXplcyBzbWFs
bGVyCnRoYW4gdGhlIHRhcmdldCdzIHJlZ2lvbiBzaXplLCB3aGVyZSBrY29weWQgaXMgdXNlZCBm
b3IgQ09XLgoKVGhlIGJvdHRsZW5lY2sgaGVyZSBpcyBrY29weWQgc2VyaWFsaXppbmcgYWxsIEkv
Ty4gVXNlcnMgb2Yga2NvcHlkLCBzdWNoCmFzIGRtLXNuYXBzaG90IGFuZCBkbS1jbG9uZSwgY2Fu
bm90IHRha2UgYWR2YW50YWdlIG9mIHRoZSBpbmNyZWFzZWQgSS9PCnBhcmFsbGVsaXNtIHRoYXQg
Y29tZXMgd2l0aCB1c2luZyBibGstbXEgaW4gbW9kZXJuIG11bHRpLWNvcmUgc3lzdGVtcywKYmVj
YXVzZSBJL09zIGFyZSBpc3N1ZWQgb25seSBieSBhIHNpbmdsZSBDUFUgYXQgYSB0aW1lLCB0aGUg
b25lIG9uIHdoaWNoCmtjb3B5ZOKAmXMgdGhyZWFkIGhhcHBlbnMgdG8gYmUgcnVubmluZy4KClNv
LCBJIGV4cGVyaW1lbnRlZCByZWRlc2lnbmluZyBrY29weWQgdG8gcHJldmVudCBJL08gc2VyaWFs
aXphdGlvbiBieQpyZXNwZWN0aW5nIHRocmVhZCBsb2NhbGl0eSBmb3IgSS9PcyBhbmQgdGhlaXIg
Y29tcGxldGlvbnMuIFRoaXMgbWFkZSB0aGUKZGlzdHJpYnV0aW9uIG9mIEkvTyBwcm9jZXNzaW5n
IHVuaWZvcm0gYWNyb3NzIENQVXMuCgpNeSBtZWFzdXJlbWVudHMgaGFkIHNob3duIHRoYXQgc2Nh
bGluZyBrY29weWQsIGluIGNvbWJpbmF0aW9uIHdpdGgKc2NhbGluZyBkbS1zbmFwc2hvdCBpdHNl
bGYgWzFdIFsyXSwgY2FuIGxlYWQgdG8gYW4gZXZlbnR1YWwgcGVyZm9ybWFuY2UKaW1wcm92ZW1l
bnQgb2YgfjMwMCUgaW5jcmVhc2UgaW4gc3VzdGFpbmVkIHRocm91Z2hwdXQgYW5kIH44MCUgZGVj
cmVhc2UKaW4gSS9PIGxhdGVuY3kgZm9yIHRyYW5zaWVudCBzbmFwc2hvdHMsIG92ZXIgdGhlIG51
bGxfYmxrIGRldmljZS4KClRoZSB3b3JrIGZvciBzY2FsaW5nIGRtLXNuYXBzaG90IGhhcyBiZWVu
IG1lcmdlZCBbMV0sIGJ1dCwKdW5mb3J0dW5hdGVseSwgSSBoYXZlbid0IGJlZW4gYWJsZSB0byBz
ZW5kIHVwc3RyZWFtIG15IHdvcmsgb24ga2NvcHlkCnlldCwgYmVjYXVzZSBJIGhhdmUgYmVlbiBy
ZWFsbHkgYnVzeSB3aXRoIG90aGVyIHRoaW5ncyB0aGUgbGFzdCBjb3VwbGUKb2YgeWVhcnMuCgpJ
IGhhdmVuJ3QgbG9va2VkIGludG8gdGhlIGRldGFpbHMgb2YgY29weSBvZmZsb2FkIHlldCwgYnV0
IGl0IHdvdWxkIGJlCnJlYWxseSBpbnRlcmVzdGluZyB0byBzZWUgaG93IGl0IGFmZmVjdHMgdGhl
IHBlcmZvcm1hbmNlIG9mIHJhbmRvbSBhbmQKc2VxdWVudGlhbCB3b3JrbG9hZHMsIGFuZCB0byBj
aGVjayBob3csIGFuZCBpZiwgc2NhbGluZyBrY29weWQgYWZmZWN0cwp0aGUgcGVyZm9ybWFuY2Us
IGluIGNvbWJpbmF0aW9uIHdpdGggY29weSBvZmZsb2FkLgoKTmlrb3MKClsxXSBodHRwczovL2xv
cmUua2VybmVsLm9yZy9kbS1kZXZlbC8yMDE5MDMxNzEyMjI1OC4yMTc2MC0xLW50c2lyb25pc0Bh
cnJpa3RvLmNvbS8KWzJdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2RtLWRldmVsLzQyNWQ3ZWZl
LWFiM2YtNjdiZS0yNjRlLTljM2I2ZGIyMjliY0BhcnJpa3RvLmNvbS8KCi0tCmRtLWRldmVsIG1h
aWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29t
L21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

