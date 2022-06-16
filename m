Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461B7C43334
	for <dm-devel@archiver.kernel.org>; Thu, 16 Jun 2022 10:09:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-zvh16FUaOi-t23uwyxLYdg-1; Thu, 16 Jun 2022 06:09:54 -0400
X-MC-Unique: zvh16FUaOi-t23uwyxLYdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B87F29AB3FD;
	Thu, 16 Jun 2022 10:09:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 44CF01415106;
	Thu, 16 Jun 2022 10:09:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 10E66194705C;
	Thu, 16 Jun 2022 10:09:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 021D7194705A
 for <dm-devel@listman.corp.redhat.com>; Thu, 16 Jun 2022 10:09:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A4F91492CA6; Thu, 16 Jun 2022 10:09:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FDD9492CA5
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 10:09:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8434329DD988
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 10:09:48 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-5-I-G29hqROYKZxlKXGX7w0w-1; Thu, 16 Jun 2022 06:09:46 -0400
X-MC-Unique: I-G29hqROYKZxlKXGX7w0w-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220616100945euoutp0290be24c8f8a935afd7cce0e2e081f4da~5Eg0oOwXg0162401624euoutp023
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 10:09:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220616100945euoutp0290be24c8f8a935afd7cce0e2e081f4da~5Eg0oOwXg0162401624euoutp023
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220616100945eucas1p16ff092593c3eb81dd46a4cf3be3997aa~5Eg0SG-ds0058100581eucas1p1j;
 Thu, 16 Jun 2022 10:09:45 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id B3.8D.09580.9610BA26; Thu, 16
 Jun 2022 11:09:45 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220616100944eucas1p15c06e5002e0f2cd08babcd1217fd63c6~5Egz281Dc0058100581eucas1p1i;
 Thu, 16 Jun 2022 10:09:44 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220616100944eusmtrp1c6ff48f087ed07ae172bf766a0ec7b31~5Egz2GWCJ0211102111eusmtrp1i;
 Thu, 16 Jun 2022 10:09:44 +0000 (GMT)
X-AuditID: cbfec7f5-9adff7000000256c-52-62ab0169c443
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id B6.16.09038.8610BA26; Thu, 16
 Jun 2022 11:09:44 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220616100944eusmtip12c538773222f85799ce3294eb6f54db1~5EgzpPmzg1755917559eusmtip16;
 Thu, 16 Jun 2022 10:09:44 +0000 (GMT)
Received: from [192.168.1.12] (106.210.248.244) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Thu, 16 Jun 2022 11:09:38 +0100
Message-ID: <e04db101-5628-2a1d-6b5c-997090484d7d@samsung.com>
Date: Thu, 16 Jun 2022 12:09:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Bart Van Assche <bvanassche@acm.org>, <hch@lst.de>,
 <snitzer@redhat.com>, <damien.lemoal@opensource.wdc.com>, <axboe@kernel.dk>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <857c444a-02b9-9cef-0c5b-2ecdb2fd46f6@acm.org>
X-Originating-IP: [106.210.248.244]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsWy7djP87qZjKuTDBa0CFisvtvPZjHtw09m
 i99nzzNb7H03m9Xiwo9GJouVq48yWTxZP4vZoufABxaLv133gGItD4FKbmlbXN41h81i/rKn
 7BY3JjxltFhz8ymLRdvGr4wOAh6Xr3h7/Duxhs1j56y77B6Xz5Z6bFrVyeaxsGEqs8fmJfUe
 u282AOVa77N6vN93lc1j/ZarLB6fN8l5tB/oZgrgjeKySUnNySxLLdK3S+DK2P/yO2PBPKGK
 J5vusTYwNvN3MXJySAiYSLQ8aWLrYuTiEBJYwSjx+N9uFgjnC6PEgh2HWCGcz4wSjY8eMsO0
 NKx8wAyRWM4o8eP+VXa4qrVv/0P172KUeDPpFytIC6+AncTuvv9ALRwcLAKqErt3FkCEBSVO
 znzCAmKLCkRIrGx9wwJSIiyQJTFnZjxImFlAXOLWk/lMICNFBFoZJY5O3A3mMAvcY5JoO3Od
 EaSBTUBLorGTHaSBU8BaYsmpO8wQzZoSrdt/s0PY8hLNW2eDnSAhoCzxbyfUM7USa4+dAbtf
 QuAbp8TEb21sEAkXiUM916BsYYlXx7ewQ9gyEqcn97BA2NUST2/8ZoZobmGU6N+5ng1igbVE
 35kciBpHiScXOqHCfBI33gpCnMMnMWnbdOYJjKqzkEJiFpKXZyH5YBaSDxYwsqxiFE8tLc5N
 Ty02zkst1ytOzC0uzUvXS87P3cQITJSn/x3/uoNxxauPeocYmTgYDzFKcDArifCaBa9MEuJN
 SaysSi3Kjy8qzUktPsQozcGiJM6bnLkhUUggPbEkNTs1tSC1CCbLxMEp1cBk+m6K/6UVngb8
 Aqxpu2ax7ryitXPexT/LZ2iFXJs+xfDokc1KRh612hqpG52SrQ0233jE2+h2ZXaC9axgixfV
 8xjsbrs7ZHBpeqX+r/omdD3punX+7KD8r07Xvs5nfbat5bVT7i63n5rT3h0tUvjwbq2zvJt0
 ib4rl/SJBCvBAwJi3Zmia8XYwyYJLG2rkDvUdssp3bjd6OG9c4ecLlZfra9rTVCL2xB/abpz
 +uLXT6IztvUnKtROjvoq8ii3ea98tqRMxKPG6kOfFR/v5Oo1zEtLvLVwf8tqPW4tTx8OD8bN
 j6w/GvIo3+mNDZ40uTxL8CFz6d2Qb9sSJucf/9gzZ/I/lrWzz9/Wja0ov6fEUpyRaKjFXFSc
 CABNZ45nAwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t/xu7oZjKuTDNauMLBYfbefzWLah5/M
 Fr/Pnme22PtuNqvFhR+NTBYrVx9lsniyfhazRc+BDywWf7vuAcVaHgKV3NK2uLxrDpvF/GVP
 2S1uTHjKaLHm5lMWi7aNXxkdBDwuX/H2+HdiDZvHzll32T0uny312LSqk81jYcNUZo/NS+o9
 dt9sAMq13mf1eL/vKpvH+i1XWTw+b5LzaD/QzRTAG6VnU5RfWpKqkJFfXGKrFG1oYaRnaGmh
 Z2RiqWdobB5rZWSqpG9nk5Kak1mWWqRvl6CXsf/ld8aCeUIVTzbdY21gbObvYuTkkBAwkWhY
 +YC5i5GLQ0hgKaPEvXV3WCASMhKfrnxkh7CFJf5c62KDKPrIKLHjwQWojl2MEvu2bwCr4hWw
 k9jd9x8owcHBIqAqsXtnAURYUOLkzCdgQ0UFIiQ+LZvAClIiLJAlMWdmPEiYWUBc4taT+Uwg
 I0UEWhklbq/8wgriMAvcY5J49ekbK8SyD4wS109cBVvAJqAl0dgJtpdTwFpiyak7zBCTNCVa
 t/9mh7DlJZq3zgYrlxBQlvi3kxnimVqJV/d3M05gFJ2F5LxZSO6YhWTSLCSTFjCyrGIUSS0t
 zk3PLTbSK07MLS7NS9dLzs/dxAhML9uO/dyyg3Hlq496hxiZOBgPMUpwMCuJ8JoFr0wS4k1J
 rKxKLcqPLyrNSS0+xGgKDKKJzFKiyfnABJdXEm9oZmBqaGJmaWBqaWasJM7rWdCRKCSQnliS
 mp2aWpBaBNPHxMEp1cDEcbjl5B8W68Jee/8/r69LMV4LKkrYuXZ29ceFv/5LMfR15ducvXjq
 d/66y4VLeStOla89tF1VlltKfk3htsKHXtXVCxSs+cUuf3x/6+iZix+kT16alGfgumOVCuu8
 r1NWiQZsOpD7qupVs07t1LLTXTdf38u6JK0W2rW57rHonYa9n5QF9y2ovmz/ZtHeEI6TP8y1
 iqyX2jutM5s0qcLRyHBZj3d2fKdkNf/klSqX9nNOPGZzfmJzcP1vu4uLPD8mBv7UfqKXrsgW
 YLWq7enr17Ompp64brDf6Wbss+ezdVi0a2cEek9fLtXsYSt0Qb1nkfi199VPf7567XiE871U
 y7eHx6cJ1XW+mmH9UyedT4mlOCPRUIu5qDgRABEoH/e4AwAA
X-CMS-MailID: 20220616100944eucas1p15c06e5002e0f2cd08babcd1217fd63c6
X-Msg-Generator: CA
X-RootMTR: 20220615101931eucas1p15ed09ae433a2c378b599e9086130d8eb
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220615101931eucas1p15ed09ae433a2c378b599e9086130d8eb
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615101931eucas1p15ed09ae433a2c378b599e9086130d8eb@eucas1p1.samsung.com>
 <20220615101920.329421-3-p.raghav@samsung.com>
 <857c444a-02b9-9cef-0c5b-2ecdb2fd46f6@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v7 02/13] block: allow blk-zoned devices to
 have non-power-of-2 zone size
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
Cc: pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Luis Chamberlain <mcgrof@kernel.org>, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gMjAyMi0wNi0xNSAyMjoyOCwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOgppc2tfbmFtZSwgem9u
ZS0+bGVuKTsKPj4gK8KgwqDCoMKgwqDCoMKgIGlmICh6b25lLT5sZW4gPT0gMCkgewo+PiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBwcl93YXJuKCIlczogSW52YWxpZCB6b25lIHNpemUiLCBkaXNr
LT5kaXNrX25hbWUpOwo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVOT0RFVjsK
Pj4gK8KgwqDCoMKgwqDCoMKgIH0KPj4gKwo+PiArwqDCoMKgwqDCoMKgwqAgLyoKPj4gK8KgwqDC
oMKgwqDCoMKgwqAgKiBEb24ndCBhbGxvdyB6b25lZCBkZXZpY2Ugd2l0aCBub24gcG93ZXJfb2Zf
MiB6b25lIHNpemUgd2l0aAo+PiArwqDCoMKgwqDCoMKgwqDCoCAqIHpvbmUgY2FwYWNpdHkgbGVz
cyB0aGFuIHpvbmUgc2l6ZS4KPj4gK8KgwqDCoMKgwqDCoMKgwqAgKi8KPiAKCj4gUGxlYXNlIGNo
YW5nZSAicG93ZXJfb2ZfMiIgaW50byAicG93ZXItb2YtMiIuCj4gCk9rLgo+PiArwqDCoMKgwqDC
oMKgwqAgaWYgKCFpc19wb3dlcl9vZl8yKHpvbmUtPmxlbikgJiYgem9uZS0+Y2FwYWNpdHkgPCB6
b25lLT5sZW4pIHsKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJfd2FybigiJXM6IEludmFs
aWQgem9uZSBjYXBhY2l0eSBmb3Igbm9uIHBvd2VyIG9mIDIKPj4gem9uZSBzaXplIiwKPj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkaXNrLT5kaXNrX25hbWUpOwo+PiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVOT0RFVjsKPj4gwqDCoMKgwqDCoMKgwqDCoMKg
IH0KPiAKPiBUaGUgYWJvdmUgY2hlY2sgc2VlbXMgd3JvbmcgdG8gbWUuIEkgZG9uJ3Qgc2VlIHdo
eSBkZXZpY2VzIHRoYXQgcmVwb3J0IGEKPiBjYXBhY2l0eSB0aGF0IGlzIGxlc3MgdGhhbiB0aGUg
em9uZSBzaXplIHNob3VsZCBiZSByZWplY3RlZC4KPiAKVGhpcyB3YXMgYnJvdWdodCB1cCBieSBE
YW1pZW4gZHVyaW5nIHByZXZpb3VzIHJldmlld3MuIFRoZSBhcmd1bWVudCB3YXMKdGhhdCB0aGUg
cmVhc29uIHRvIGFsbG93IG5vbiBwb3dlci1vZi0yIHpvbmVkIGRldmljZSBpcyB0byByZW1vdmUg
dGhlCmdhcHMgYmV0d2VlbiB6b25lIHNpemUgYW5kIHpvbmUgY2FwYWNpdHkuIEFsbG93aW5nIGEg
bnBvMiB6b25lIHNpemUgd2l0aAphIGRpZmZlcmVudCBjYXBhY2l0eSwgZXZlbiB0aG91Z2ggaXQg
aXMgdGVjaG5pY2FsbHkgcG9zc2libGUsIGl0IGRvZXMKbm90IG1ha2UgYW55IHByYWN0aWNhbCBz
ZW5zZS4gVGhhdCBpcyB3aHkgdGhpcyBjaGVjayB3YXMgaW50cm9kdWNlZC4KRG9lcyB0aGF0IGFu
c3dlciB5b3VyIHF1ZXN0aW9uPwo+PiArwqDCoMKgwqDCoMKgwqAgLyoKPj4gK8KgwqDCoMKgwqDC
oMKgwqAgKiBEaXZpc2lvbiBpcyB1c2VkIHRvIGNhbGN1bGF0ZSBucl96b25lcyBmb3IgYm90aCBw
b3dlcl9vZl8yCj4+ICvCoMKgwqDCoMKgwqDCoMKgICogYW5kIG5vbiBwb3dlcl9vZl8yIHpvbmUg
c2l6ZXMgYXMgaXQgaXMgbm90IGluIHRoZSBob3QgcGF0aC4KPj4gK8KgwqDCoMKgwqDCoMKgwqAg
Ki8KPiAKPiBTaG91bGRuJ3QgdGhlIGFib3ZlIGNvbW1lbnQgYmUgbW92ZWQgdG8gdGhlIHBhdGNo
IGRlc2NyaXB0aW9uPyBJJ20gbm90Cj4gc3VyZSB3aGV0aGVyIGhhdmluZyBzdWNoIGEgY29tbWVu
dCBpbiB0aGUgc291cmNlIGNvZGUgaXMgdmFsdWFibGUuCj4gClllYWgsIEkgd2lsbCByZW1vdmUg
aXQuIE1heWJlIGl0IGlzIHZlcnkgb2J2aW91cyBhdCB0aGlzIHBvaW50Lgo+PiArc3RhdGljIGlu
bGluZSBzZWN0b3JfdCBibGtfcXVldWVfb2Zmc2V0X2Zyb21fem9uZV9zdGFydChzdHJ1Y3QKPj4g
cmVxdWVzdF9xdWV1ZSAqcSwKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBzZWN0b3JfdCBzZWMpCj4+ICt7Cj4+ICvCoMKgwqAgc2VjdG9y
X3Qgem9uZV9zZWN0b3JzID0gYmxrX3F1ZXVlX3pvbmVfc2VjdG9ycyhxKTsKPj4gK8KgwqDCoCB1
NjQgcmVtYWluZGVyID0gMDsKPj4gKwo+PiArwqDCoMKgIGlmICghYmxrX3F1ZXVlX2lzX3pvbmVk
KHEpKQo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIGZhbHNlOwo+IAo+ICJyZXR1cm4gZmFsc2Ui
IHNob3VsZCBvbmx5IG9jY3VyIGluIGZ1bmN0aW9ucyByZXR1cm5pbmcgYSBib29sZWFuLiBUaGlz
Cj4gZnVuY3Rpb24gcmV0dXJucyB0eXBlIHNlY3Rvcl90Lgo+IApHb29kIGNhdGNoLiBJdCB3YXMg
YSBjb3B5IHBhc3RlIG1pc3Rha2UuIEZpeGVkIGl0Lgo+IFRoYW5rcywKPiAKPiBCYXJ0LgoKLS0K
ZG0tZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFu
LnJlZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

