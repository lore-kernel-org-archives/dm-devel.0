Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E548C77B73
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480078;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=43QgVRdntwmZdXHqj+WsED1n2A4jcZrDItn4Xqv1nf8=;
	b=ghFMct3AtJ6LD2N9WRl0lAZMf2EV90EUVC5yoNxgeiKuzizmHf1bV047sZuvjcOqYBhvpC
	fUdY2u1bBrRNXN/AsbMS3KkOsA7aaBRHkSlTDKqEAle+PBuyJgBpZ54fDuxhHDGJCCvBPH
	zNI3MP+PFO8f/82pA+bSzF5Hm08uvU0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-_Hz6HvoWOoC7pAQW08ditQ-1; Tue, 30 May 2023 16:54:34 -0400
X-MC-Unique: _Hz6HvoWOoC7pAQW08ditQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DCD51C04188;
	Tue, 30 May 2023 20:54:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4324E2029F6D;
	Tue, 30 May 2023 20:54:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 697CD19465A0;
	Tue, 30 May 2023 20:54:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D8CEB1946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 16:23:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A0A21140EBD7; Tue, 30 May 2023 16:23:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9826D140EBB8
 for <dm-devel@redhat.com>; Tue, 30 May 2023 16:23:00 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D76D855702
 for <dm-devel@redhat.com>; Tue, 30 May 2023 16:22:58 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-udO7qj6JP5-VQUkR0HfcTA-1; Tue, 30 May 2023 12:22:52 -0400
X-MC-Unique: udO7qj6JP5-VQUkR0HfcTA-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230530162247epoutp0347103bed09690738a1c78d39facb7470~j_F3QFUZp0783707837epoutp03D
 for <dm-devel@redhat.com>; Tue, 30 May 2023 16:22:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230530162247epoutp0347103bed09690738a1c78d39facb7470~j_F3QFUZp0783707837epoutp03D
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230530162245epcas5p13dd525f833dbe394e5e0edaa652cdb0c~j_F1911Nb0345803458epcas5p1-;
 Tue, 30 May 2023 16:22:45 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4QVyNh1y9wz4x9Pp; Tue, 30 May
 2023 16:22:44 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 77.3F.04567.4D226746; Wed, 31 May 2023 01:22:44 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230530121351epcas5p2b18d46d6be650a7b830690b845ec22c8~j6sgq_Mda2862728627epcas5p2h;
 Tue, 30 May 2023 12:13:51 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230530121350epsmtrp2a219b3672da915ce319a0c25d4204123~j6sgpTLJG0347103471epsmtrp2-;
 Tue, 30 May 2023 12:13:50 +0000 (GMT)
X-AuditID: b6c32a49-943ff700000011d7-4a-647622d46e21
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 51.D5.28392.E78E5746; Tue, 30 May 2023 21:13:50 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230530121346epsmtip2a090cc3928ef845f7729023ca25e9244~j6sc4LK2o1829318293epsmtip2a;
 Tue, 30 May 2023 12:13:46 +0000 (GMT)
Date: Tue, 30 May 2023 17:40:43 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Maurizio Lombardi <mlombard@redhat.com>
Message-ID: <20230530121043.psdxyk7z3rk7sjtm@green245>
MIME-Version: 1.0
In-Reply-To: <CAFL455nMtKbDt1HeN6D2WPB2JjOYq2z1=RagmmuhmQ33eL2Bfw@mail.gmail.com>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbdRTHc+9tby+QYsdj/oBNoLoQmDy6lfpjAbfoipfgA0I0c8qwg2sh
 lLbpg83FOFYYOibykCErhIGylZc8t/EoMMJDXjIkPIfCGCmYQGQ8s2mF2nKL+t/nfM85v3N+
 5+QQmMMgy5VIkKoohVQk4eK2jPvd3l6+49zkuIC0vwlYO/gTBotqq3Goyd7BYNVsFg5XujcQ
 mL/2JwbnH5yE7auFTPioswWFbd/norCiqheF9VkE1Jeuo7DX9AcOc7smEbg4oUVh+8xR2NY+
 wIBjrUU4nKs2MeGtO4sseH2qGYe6vl0Udn2bisKh/EYMNhuuILBm5SkD9s+4wZGdPiY0Pi/C
 T71Ejo2Hk9rHwzjZop1lkSNz9QwyP3cQJxvLfcixYTXZUHkNJxs2cllkf4GRQTaWXSb1j1Jw
 MjN1FSfXF2cY5NOOCZz85m4lEuF4NjE4nhLFUQoPShori0uQikO44VExb8YECgJ4vrwg+BrX
 QypKokK4p9+O8A1NkJgnxfVIFknUZilCpFRy/V8PVsjUKsojXqZUhXApeZxEzpf7KUVJSrVU
 7CelVCd4AQHHAs2BnyTG/1A/i8oNDhcXbg6jKcg0OwOxIQCHD7Y1W0gGYks4cPQIuFo0YTU2
 EDD1y3cM2thEwEhBJ3M/ZTFn2OpoRUDHzxtM2lhCQF1NNWaJYnCOgL6tNfNbBIFzjoIhE2GR
 ncy4nlbGsDDGSWOBjQx7CztywoHhYR1qYTZHAMaH5q18AAzcNOzF23AiQX1T2Z7uzDkECm5v
 Y5a6gKOxBabSTYzu7jTQ/XoDp9kRLPfdZdHsCjZX2636BVCRV47TyWkI0E5pEdpxElwdzMIs
 TWOceFDVq6blw+DGYA1KN20PMo0GlNbZoLl4n18G1bUl1vddwOSzK1YmwVZ6G4seUBoKlgzr
 eDbirv3f57T/ldPulTgBrq1pmDS7g9R7hRgd4gZ0uwSN3qC21b8EwSsRF0quTBJTykA5T0pd
 +Hf5sbKkBmTvqHzCmpHZ+TW/LgQlkC4EEBjXiR0iUsY5sONEn12iFLIYhVpCKbuQQPPacjBX
 51iZ+SqlqhgePyiALxAI+EHHBTzui2yvkIFYB45YpKISKUpOKfbzUMLGNQXN9HkyJn7f7uF5
 k4tAevYDmHf/UiTOsMtV5f2O8/Idfc586fup5qMt/U66hrwcZWg6/mGXp8dbXxxiSZK1hg79
 6jusNx7f8fxK1iocp1ZqqstSEyblbZ/XhW8/UBl54gNzoV6FMcLxsKgefc+p4sbF5KFg/XtL
 57AfvXZ3FuQfCycSBzwuionb765HZ77yF+a1YM+OzM7v5mY3j/LugfqFEP/D10uHmMrypuU5
 d/clItlOfMzpt2jhmeet3s78Ql1SQYmb0HnxySgalnPwhVFdusvwrazpmSFjTyqrk1iaNp0L
 ZIUe+TrofOZytL9DcX+MseVV1x7dQf4zz3Gn0xVyIZehjBfxfDCFUvQPC7mUe90EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsWy7bCSvG7di9IUgzm7jC3WnzrGbDFn/Ro2
 i6YJf5ktVt/tZ7N4ffgTo8W0Dz+ZLR7st7fY+242q8XNAzuZLPYsmsRksXL1USaLjf0cFrsX
 fmSyOPr/LZvFpEPXGC2eXp3FZLH3lrbFnr0nWSwu75rDZnFvzX9Wi/nLnrJbdF/fwWax/Pg/
 JotDk5uZLE5P28xsseNJI6PFutfvWSxO3JK2OP/3OKvF7x9z2BzkPC5f8faYdf8sm8fOWXfZ
 Pc7f28jiMW3SKTaPzSu0PC6fLfXYtKqTzWPTp0nsHidm/Gbx2Lyk3mP3zQY2j97md2weH5/e
 YvF4v+8qm0ffllWMAcJRXDYpqTmZZalF+nYJXBkHXvawF3zlr+g7v5i1gbGNu4uRk0NCwETi
 6cSzLCC2kMAORokF11Ug4pISy/4eYYawhSVW/nvO3sXIBVTzhFHi1bJl7CAJFgFVieNfPjB2
 MXJwsAloS5z+zwESFgEyP7YsYQGpZxboYpeY9X4hG0hCWMBb4sm5DUwgNq+AmcSV0w+YIIa2
 MElMmPOEFSIhKHFy5hOwi5iBiuZtfsgMsoBZQFpi+T8OiLC8RPPW2WDHcQoESmzcvgRspqiA
 jMSMpV+ZJzAKzUIyaRaSSbMQJs1CMmkBI8sqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95Pzc
 TYzgxKOltYNxz6oPeocYmTgYDzFKcDArifDaJhanCPGmJFZWpRblxxeV5qQWH2KU5mBREue9
 0HUyXkggPbEkNTs1tSC1CCbLxMEp1cB00eRwQ+60icv0dNaHB2b/mqtT6ZofcXTB86ivtc0q
 +33nB/beCQ0xWOpTrB6oFy3xmXu2832rDfHXyj5fuTzRU45nYtyTAw2G++VOBbBN5vLcNGvp
 366/JX63a9pD3ybwZgh/V3m+uezBn3il+L/b+C7f81JVEtxyU6yWbeeiyISD72cna1R9TZE0
 nbvGXP7m3+T9hoqRBhyzZpQvUpmy3G6Wx5/FP/YcNPUqdfseq3Bp27TYMJnU3361dSkvNNdI
 sR++UqG782aTeLrWxEP57jvmnJ4oHJZ2ICPg04fpzhH3P0d3vTw8yf2kywoDnav5c457LrKe
 dOHe+22RH+o3ezW8rwlx/bFi7WMeVbWXSizFGYmGWsxFxYkAu5aSqKsDAAA=
X-CMS-MailID: 20230530121351epcas5p2b18d46d6be650a7b830690b845ec22c8
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230522104536epcas5p23dd8108dd267ec588e5c36e8f9eb9fe8
References: <CGME20230522104536epcas5p23dd8108dd267ec588e5c36e8f9eb9fe8@epcas5p2.samsung.com>
 <20230522104146.2856-1-nj.shetty@samsung.com>
 <20230522104146.2856-3-nj.shetty@samsung.com>
 <CAFL455nMtKbDt1HeN6D2WPB2JjOYq2z1=RagmmuhmQ33eL2Bfw@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: Re: [dm-devel] [PATCH v11 2/9] block: Add copy offload support
 infrastructure
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
Cc: linux-nvme@lists.infradead.org, James.Bottomley@hansenpartnership.com,
 linux-mm@kvack.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, nitheshshetty@gmail.com,
 James Smart <james.smart@broadcom.com>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Chaitanya Kulkarni <kch@nvidia.com>, anuj20.g@samsung.com,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Keith Busch <kbusch@kernel.org>, bvanassche@acm.org,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 joshi.k@samsung.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----dpMjS_Krfo.HeTa1.nqRY6lfIY-msh.FGO-xMH_14-IlSSmS=_319e1_"

------dpMjS_Krfo.HeTa1.nqRY6lfIY-msh.FGO-xMH_14-IlSSmS=_319e1_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23/05/30 01:29PM, Maurizio Lombardi wrote:
>po 22. 5. 2023 v 13:17 odes=C3=ADlatel Nitesh Shetty <nj.shetty@samsung.co=
m> napsal:
>>
>> +static int __blkdev_copy_offload(struct block_device *bdev_in, loff_t p=
os_in,
>> +               struct block_device *bdev_out, loff_t pos_out, size_t le=
n,
>> +               cio_iodone_t endio, void *private, gfp_t gfp_mask)
>> +{
>> +       struct cio *cio;
>> +       struct copy_ctx *ctx;
>> +       struct bio *read_bio, *write_bio;
>> +       struct page *token;
>> +       sector_t copy_len;
>> +       sector_t rem, max_copy_len;
>> +
>> +       cio =3D kzalloc(sizeof(struct cio), GFP_KERNEL);
>> +       if (!cio)
>> +               return -ENOMEM;
>> +       atomic_set(&cio->refcount, 0);
>> +       cio->waiter =3D current;
>> +       cio->endio =3D endio;
>> +       cio->private =3D private;
>> +
>> +       max_copy_len =3D min(bdev_max_copy_sectors(bdev_in),
>> +                       bdev_max_copy_sectors(bdev_out)) << SECTOR_SHIFT=
;
>> +
>> +       cio->pos_in =3D pos_in;
>> +       cio->pos_out =3D pos_out;
>> +       /* If there is a error, comp_len will be set to least successful=
ly
>> +        * completed copied length
>> +        */
>> +       cio->comp_len =3D len;
>> +       for (rem =3D len; rem > 0; rem -=3D copy_len) {
>> +               copy_len =3D min(rem, max_copy_len);
>> +
>> +               token =3D alloc_page(gfp_mask);
>> +               if (unlikely(!token))
>> +                       goto err_token;
>
>[...]
>
>> +err_token:
>> +       cio->comp_len =3D min_t(sector_t, cio->comp_len, (len - rem));
>> +       if (!atomic_read(&cio->refcount))
>> +               return -ENOMEM;
>> +       /* Wait for submitted IOs to complete */
>> +       return blkdev_copy_wait_completion(cio);
>> +}
>
>Suppose the first call to "token =3D alloc_page()" fails (and
>cio->refcount =3D=3D 0), isn't "cio" going to be leaked here?
>
>Maurizio
>

Agreed, will free it in "err_token", and will update next version.

Thank you,
Nitesh Shetty

------dpMjS_Krfo.HeTa1.nqRY6lfIY-msh.FGO-xMH_14-IlSSmS=_319e1_
Content-Type: text/plain; charset="utf-8"


------dpMjS_Krfo.HeTa1.nqRY6lfIY-msh.FGO-xMH_14-IlSSmS=_319e1_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------dpMjS_Krfo.HeTa1.nqRY6lfIY-msh.FGO-xMH_14-IlSSmS=_319e1_--

