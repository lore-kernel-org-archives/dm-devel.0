Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9066C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 12:18:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-EZo10NTwNk-lMqalf262aw-1; Wed, 27 Apr 2022 08:18:01 -0400
X-MC-Unique: EZo10NTwNk-lMqalf262aw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78477383974F;
	Wed, 27 Apr 2022 12:17:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 62AF4C50941;
	Wed, 27 Apr 2022 12:17:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 566221947046;
	Wed, 27 Apr 2022 12:17:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8E2C81947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Apr 2022 12:24:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 576A0145B989; Tue, 26 Apr 2022 12:24:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 515EF145B96B
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 12:24:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 302001E14BF3
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 12:24:36 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-u1UJiPsRMdaqrf3eHoPOcA-1; Tue, 26 Apr 2022 08:24:29 -0400
X-MC-Unique: u1UJiPsRMdaqrf3eHoPOcA-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20220426121439epoutp0401d40543c66c374dc583ec79daa1fc7c~pcUTtjBsm2403224032epoutp04h;
 Tue, 26 Apr 2022 12:14:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20220426121439epoutp0401d40543c66c374dc583ec79daa1fc7c~pcUTtjBsm2403224032epoutp04h
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20220426121438epcas5p10d323e4e6161275933c063e854a206a8~pcUTVHmsQ2178321783epcas5p1J;
 Tue, 26 Apr 2022 12:14:38 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4KngmV03q9z4x9Q0; Tue, 26 Apr
 2022 12:14:34 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 75.F0.09762.922E7626; Tue, 26 Apr 2022 21:14:33 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15~paug6xF5B1971219712epcas5p4f;
 Tue, 26 Apr 2022 10:18:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20220426101804epsmtrp279588e73b7154a836e04af3ef14dd860~paug5evnb1306613066epsmtrp2l;
 Tue, 26 Apr 2022 10:18:04 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-67-6267e229546a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 D0.39.08853.BD6C7626; Tue, 26 Apr 2022 19:18:03 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220426101757epsmtip1dbba971682fc11ea2415d9083f2b846b~pauasWk1T0320603206epsmtip1X;
 Tue, 26 Apr 2022 10:17:57 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: 
Date: Tue, 26 Apr 2022 15:42:28 +0530
Message-Id: <20220426101241.30100-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01TaVBbVRT2LXkJHcFXlumFDsKE6ShUlpSlF4Rildbn4AIuM1ot8IDXgECS
 ScCKVGURKhRKQcsSoGBhZFgkyJ6SIFCRkkJBKVDQAmVprVE2KUjDIukD7b/vfOd89zvn3Dk8
 zPgHrgUvXBTNSEV0JJ/YgzddtX3W3nZKGOxUUOoMFZqfMFh1O5OAOQtrGJzvmObA7Mw8LtT1
 9WNwcMYIqucKOHDgnwQUTtdtoXC0XYlC1eVsFFZUdaHwXnkpAlu/WUTh+h0BvLM8hsPszmEE
 zg7JUageOwhV6h4cDl4pJGDxt7NceG6khYBtWjUGy7s3UXhDvk7ArO56DmyZSUBgk64Yg1fH
 h3BYo53H4bWx/TA5fY0L+ze6OS/YUIM3fSn5RB9BZSXNcSml/DaX6h//HqcG+2KouspUgqov
 +5z66lY5QrWOxhNUYm8XRuUtLRNURtIcQSmTJzjU4uwYTs23DRF++05EeIYxdCgjtWZEIeLQ
 cJHQi+/7VuBLga5uTgJ7gTs8zLcW0VGMF9/nVT/74+GR2zvkW39ER8ZsU360TMZ3POIpFcdE
 M9ZhYlm0F5+RhEZKXCQOMjpKFiMSOoiYaA+Bk9Mh1+3CoIgwuTJK8qPFx5O3zhPxyJZxGmLA
 A6QLuDGZgKYhe3jGZCsCUn4ZIdhgCQH5RW0YG6wg4EJHKXdX0jqdhLAJNQIGBuI5bJCMgqz2
 8W0Jj0eQB8H1LZ5eYErioGJ1FdfXYGQPFyQpH6L6hAl5CFSMKQh9PU4eAEuV1nrakPQAv69m
 IHoakI4gc2IvS+8FPfkzuB5jpBVIaix41BwgHxoA7aVehG3OByi1nRiLTcAf3Q07TVuAv+fU
 BItPg+aUEpQVf4GANI0GZxPe4GfVBqo3xkhboLjiyNKW4KKmBmWNjUCGbgZleUPQcmkX24Bq
 RcnO++ZgeDVhB1NAuVjB0WNj8iRo6NBiFxAr+WPzyB+bR/6/cwmCVSLmjEQWJWRkrhJnEXP6
 v38NEUfVIY8uyc63BZmaXHDoRFAe0okAHsY3Nbx44FSwsWEoHfsJIxUHSmMiGVkn4rq94izM
 wixEvH2KouhAgYu7k4ubm5uLu7ObgL/PUCOspY1JIR3NRDCMhJHu6lCegUU8qvUu6lUd3nht
 rMenFj8W8GfTZgDH6eiH4vuvf/CX0VHH+lw81zk9N09VdeqBwr8o84GlMOd4aihT44BXv7Ls
 YXYXm3knvfjE5KdP+AesVDhYda3fv97jXzJanFa7FiAeyX66y3tVncWD880L6wEnl0v7dVUc
 TVz+2Zw3vp4K2q9qHhbcfbIi9hk7Ok1Q9qalJmGurfB8QrBVorN5y2rx87rIeY+zeT2N724M
 x+P+v8aZKoYilgOPlUNVtuI53Zlz1fzfaCUn8b0X45ovvyzzDto0sSm8KU7h3mt4e3DmjOOR
 2Kek3w2UVa1Utdt467SC4c9yG/1Sbcy+bH+f3vS2S7/W50nycVkYLbDDpDL6X4jE5znSBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA03SbUxTZxQH8Dz33t5eicVL0fBY3JydbApZWZlZzvAlRjd9DMMtS5zLcEo7
 7ypKobQwt2kirOPDKozRTaOVl1EXCKASi7ytQBQoHeNVawXqtCNAXNRRUbQStF0KWea3k///
 l5Pz4XC0NMjIuLSMbEGfoUqXs2FMY6f85TdudmvUb568mwh1f3TTUHuriIWTD2Zp8F0ZF4G5
 6JQY5voHaXBNhEPb1BkRDD3No2DcFqRg9HILBa1WMwXVtQ4K7lSdRWCvmKbg2ZgSxmY8DJg7
 biCYdFsoaPPEQWtbDwOu30pYKK+cFMPx4WYW2u+10VDlDFAwYHnGQrGzXgTNE3kIGufKaei8
 7Wbgwj0fA797oiG/YFYMg8+dos2vEtf1JGLx9rOk2DglJi2WW2IyePsiQ1z9OcRW8z1L6n89
 Rn4aqULEPprLkm/7HDQ59XCGJYXGKZa05HtFZHrSwxBfu5v9MOrTsA37hfS0LwV9/KbUsAOW
 Fq2uS/bVXyM/sLkoKDWhRRzm12H7uBGZUBgn5e0IewdKRAvFclz5vItemCNxdeCOeAEZKXzO
 2siaEMexfBzuDXIhs5RncLXfz4QMzU+LcWn70/lFkXwCrvbUzXuGj8EPa14JxRI+Ef/tL0Sh
 GPPxuMgbsRBH4J7TE0wopvnXcV3Z/Jk0vxIbG87QP6IllheU5X9leUH9gugatFzQGbQarUGp
 U2YIhxUGldaQk6FRfJ6ptaH5H4ld24yaah4oOhDFoQ6EOVq+VHIi5gu1VLJf9fU3gj5znz4n
 XTB0oGiOkUdJhkw9+6S8RpUtHBIEnaD/r6W4RbJcqu6fI9sv7ESyR6vFK4ZzolfJK84nLZPO
 eI/0yZNHHXueFG4NWBFeG+uKcynbe49/Eqlbs8kvsj72SqJiGhKElJUkGPBELt71wbLws7LP
 tP6xt3vGfEuSzaZAuQYau7fsCC8g7Ezr0cLod3aXRmUy+TslB2s3Fq1wzOpSFe9nDx9Wr5cf
 u5l4t2T04LtbDFaV+v62uFpb6ebHI+vuBy69dXFvU/KGufwrQ3lma6+m4NCq76xJV9/b6qwY
 yMrao2jte1QaTNuV+5o75ePMvohreSnOLO1pW+Vum/rPsm0/v1R2yZ5AmTtT6wem4n3Fs5zL
 0d21xp/WMNRZ5V5d8tH1JpIsZwwHVMpYWm9Q/QtVFxLzkgMAAA==
X-CMS-MailID: 20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Wed, 27 Apr 2022 12:14:17 +0000
Subject: [dm-devel] [PATCH v4 00/10] Add Copy offload support
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
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
 dm-devel@redhat.com, osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, msnitzer@redhat.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 James Smart <james.smart@broadcom.com>, hch@lst.de,
 Nitesh Shetty <nj.shetty@samsung.com>, chaitanyak@nvidia.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Mike Snitzer <snitzer@kernel.org>,
 josef@toxicpanda.com, linux-block@vger.kernel.org, dsterba@suse.com,
 kbusch@kernel.org, Frederick.Knight@netapp.com,
 Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk,
 Johannes Thumshirn <jth@kernel.org>, tytso@mit.edu, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, jack@suse.com, linux-fsdevel@vger.kernel.org,
 lsf-pc@lists.linux-foundation.org,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhlIHBhdGNoIHNlcmllcyBjb3ZlcnMgdGhlIHBvaW50cyBkaXNjdXNzZWQgaW4gTm92ZW1iZXIg
MjAyMSB2aXJ0dWFsIGNhbGwKW0xTRi9NTS9CRlAgVE9QSUNdIFN0b3JhZ2U6IENvcHkgT2ZmbG9h
ZFswXS4KV2UgaGF2ZSBjb3ZlcmVkIHRoZSBJbml0aWFsIGFncmVlZCByZXF1aXJlbWVudHMgaW4g
dGhpcyBwYXRjaHNldC4KUGF0Y2hzZXQgYm9ycm93cyBNaWt1bGFzJ3MgdG9rZW4gYmFzZWQgYXBw
cm9hY2ggZm9yIDIgYmRldgppbXBsZW1lbnRhdGlvbi4KCk92ZXJhbGwgc2VyaWVzIHN1cHBvcnRz
IOKAkwoKMS4gRHJpdmVyCi0gTlZNZSBDb3B5IGNvbW1hbmQgKHNpbmdsZSBOUyksIGluY2x1ZGlu
ZyBzdXBwb3J0IGluIG52bWUtdGFyZ2V0IChmb3IKICAgIGJsb2NrIGFuZCBmaWxlIGJhY2tlbmQp
CgoyLiBCbG9jayBsYXllcgotIEJsb2NrLWdlbmVyaWMgY29weSAoUkVRX0NPUFkgZmxhZyksIHdp
dGggaW50ZXJmYWNlIGFjY29tbW9kYXRpbmcKICAgIHR3byBibG9jay1kZXZzLCBhbmQgbXVsdGkt
c291cmNlL2Rlc3RpbmF0aW9uIGludGVyZmFjZQotIEVtdWxhdGlvbiwgd2hlbiBvZmZsb2FkIGlz
IG5hdGl2ZWx5IGFic2VudAotIGRtLWxpbmVhciBzdXBwb3J0IChmb3IgY2FzZXMgbm90IHJlcXVp
cmluZyBzcGxpdCkKCjMuIFVzZXItaW50ZXJmYWNlCi0gbmV3IGlvY3RsCi0gY29weV9maWxlX3Jh
bmdlIGZvciB6b25lZnMKCjQuIEluLWtlcm5lbCB1c2VyCi0gZG0ta2NvcHlkCi0gY29weV9maWxl
X3JhbmdlIGluIHpvbmVmcwoKRm9yIHpvbmVmcyBjb3B5X2ZpbGVfcmFuZ2UgLSBTZWVtcyB3ZSBj
YW5ub3QgbGV2ZWFyZ2UgZnN0ZXN0IGhlcmUuIExpbWl0ZWQKdGVzdGluZyBpcyBkb25lIGF0IHRo
aXMgcG9pbnQgdXNpbmcgYSBjdXN0b20gYXBwbGljYXRpb24gZm9yIHVuaXQgdGVzdGluZy4KCkFw
cHJlY2lhdGUgdGhlIGlucHV0cyBvbiBwbHVtYmluZyBhbmQgaG93IHRvIHRlc3QgdGhpcyBmdXJ0
aGVyPwpQZXJoYXBzIHNvbWUgb2YgaXQgY2FuIGJlIGRpc2N1c3NlZCBkdXJpbmcgTFNGL01NIHRv
by4KClswXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1udm1lL0NBKzFFM3JKN0JaN0xq
UVhYVGRYKy0wRWR6PXpUMTRtbVBHTWlWQ3pVZ0IzM0M2MHRiUUBtYWlsLmdtYWlsLmNvbS8KCkNo
YW5nZXMgaW4gdjQ6Ci0gYWRkZWQgY29weV9maWxlX3JhbmdlIHN1cHBvcnQgZm9yIHpvbmVmcwot
IGFkZGVkIGRvY3VtZW50YWlvbiBhYm91dCBuZXcgc3lzZnMgZW50cmllcwotIGluY29ycG9yYXRl
ZCByZXZpZXcgY29tbWVudHMgb24gdjMKLSBtaW5vciBmaXhlcwoKCkFybmF2IERhd24gKDIpOgog
IG52bWV0OiBhZGQgY29weSBjb21tYW5kIHN1cHBvcnQgZm9yIGJkZXYgYW5kIGZpbGUgbnMKICBm
czogYWRkIHN1cHBvcnQgZm9yIGNvcHkgZmlsZSByYW5nZSBpbiB6b25lZnMKCk5pdGVzaCBTaGV0
dHkgKDcpOgogIGJsb2NrOiBJbnRyb2R1Y2UgcXVldWUgbGltaXRzIGZvciBjb3B5LW9mZmxvYWQg
c3VwcG9ydAogIGJsb2NrOiBBZGQgY29weSBvZmZsb2FkIHN1cHBvcnQgaW5mcmFzdHJ1Y3R1cmUK
ICBibG9jazogSW50cm9kdWNlIGEgbmV3IGlvY3RsIGZvciBjb3B5CiAgYmxvY2s6IGFkZCBlbXVs
YXRpb24gZm9yIGNvcHkKICBudm1lOiBhZGQgY29weSBvZmZsb2FkIHN1cHBvcnQKICBkbTogQWRk
IHN1cHBvcnQgZm9yIGNvcHkgb2ZmbG9hZC4KICBkbTogRW5hYmxlIGNvcHkgb2ZmbG9hZCBmb3Ig
ZG0tbGluZWFyIHRhcmdldAoKU2VsdmFLdW1hciBTICgxKToKICBkbSBrY29weWQ6IHVzZSBjb3B5
IG9mZmxvYWQgc3VwcG9ydAoKIERvY3VtZW50YXRpb24vQUJJL3N0YWJsZS9zeXNmcy1ibG9jayB8
ICA4MyArKysrKysrCiBibG9jay9ibGstbGliLmMgICAgICAgICAgICAgICAgICAgICAgfCAzNTgg
KysrKysrKysrKysrKysrKysrKysrKysrKysrCiBibG9jay9ibGstbWFwLmMgICAgICAgICAgICAg
ICAgICAgICAgfCAgIDIgKy0KIGJsb2NrL2Jsay1zZXR0aW5ncy5jICAgICAgICAgICAgICAgICB8
ICA1OSArKysrKwogYmxvY2svYmxrLXN5c2ZzLmMgICAgICAgICAgICAgICAgICAgIHwgMTM4ICsr
KysrKysrKysrCiBibG9jay9ibGsuaCAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDIgKwog
YmxvY2svaW9jdGwuYyAgICAgICAgICAgICAgICAgICAgICAgIHwgIDMyICsrKwogZHJpdmVycy9t
ZC9kbS1rY29weWQuYyAgICAgICAgICAgICAgIHwgIDU1ICsrKy0KIGRyaXZlcnMvbWQvZG0tbGlu
ZWFyLmMgICAgICAgICAgICAgICB8ICAgMSArCiBkcml2ZXJzL21kL2RtLXRhYmxlLmMgICAgICAg
ICAgICAgICAgfCAgNDUgKysrKwogZHJpdmVycy9tZC9kbS5jICAgICAgICAgICAgICAgICAgICAg
IHwgICA2ICsKIGRyaXZlcnMvbnZtZS9ob3N0L2NvcmUuYyAgICAgICAgICAgICB8IDExNiArKysr
KysrKy0KIGRyaXZlcnMvbnZtZS9ob3N0L2ZjLmMgICAgICAgICAgICAgICB8ICAgNCArCiBkcml2
ZXJzL252bWUvaG9zdC9udm1lLmggICAgICAgICAgICAgfCAgIDcgKwogZHJpdmVycy9udm1lL2hv
c3QvcGNpLmMgICAgICAgICAgICAgIHwgIDI1ICsrCiBkcml2ZXJzL252bWUvaG9zdC9yZG1hLmMg
ICAgICAgICAgICAgfCAgIDYgKwogZHJpdmVycy9udm1lL2hvc3QvdGNwLmMgICAgICAgICAgICAg
IHwgIDE0ICsrCiBkcml2ZXJzL252bWUvaG9zdC90cmFjZS5jICAgICAgICAgICAgfCAgMTkgKysK
IGRyaXZlcnMvbnZtZS90YXJnZXQvYWRtaW4tY21kLmMgICAgICB8ICAgOCArLQogZHJpdmVycy9u
dm1lL3RhcmdldC9pby1jbWQtYmRldi5jICAgIHwgIDY1ICsrKysrCiBkcml2ZXJzL252bWUvdGFy
Z2V0L2lvLWNtZC1maWxlLmMgICAgfCAgNDkgKysrKwogZnMvem9uZWZzL3N1cGVyLmMgICAgICAg
ICAgICAgICAgICAgIHwgMTc4ICsrKysrKysrKysrKy0KIGZzL3pvbmVmcy96b25lZnMuaCAgICAg
ICAgICAgICAgICAgICB8ICAgMSArCiBpbmNsdWRlL2xpbnV4L2Jsa190eXBlcy5oICAgICAgICAg
ICAgfCAgMjEgKysKIGluY2x1ZGUvbGludXgvYmxrZGV2LmggICAgICAgICAgICAgICB8ICAxNyAr
KwogaW5jbHVkZS9saW51eC9kZXZpY2UtbWFwcGVyLmggICAgICAgIHwgICA1ICsKIGluY2x1ZGUv
bGludXgvbnZtZS5oICAgICAgICAgICAgICAgICB8ICA0MyArKystCiBpbmNsdWRlL3VhcGkvbGlu
dXgvZnMuaCAgICAgICAgICAgICAgfCAgMjMgKysKIDI4IGZpbGVzIGNoYW5nZWQsIDEzNjcgaW5z
ZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pCgoKYmFzZS1jb21taXQ6IGU3ZDY5ODdlMDlhMzI4
ZDRhOTQ5NzAxZGI0MGVmNjNmYmI5NzA2NzAKLS0gCjIuMzUuMS41MDAuZ2I4OTZmNzI5ZTIKCi0t
CmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29tCmh0dHBzOi8vbGlzdG1h
bi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

