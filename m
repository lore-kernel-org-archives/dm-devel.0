Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57258C352A1
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 08:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669795306;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=hRPABcHn088gam1L+I5f2n3cDLxdcPFIzx1t1T827bw=;
	b=LTuem/IUJJezCb5dQURkFws8OXnokjqqjhnQpnB7V09a+KHOMQMfTlufL4YJ5WhmfYRmli
	yD94WtipWa7Nft9Se2g5PWpoV947EO8vcZE6XAxID1UKfQDf10Jrr9zbaVqTA2qTEH4u5I
	85BbxiQOq7is81SvDjF9x08XQGzCRGM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-aYmbnyJ5N8-tSxARiS9aBQ-1; Wed, 30 Nov 2022 03:01:39 -0500
X-MC-Unique: aYmbnyJ5N8-tSxARiS9aBQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D174586F130;
	Wed, 30 Nov 2022 08:01:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DE121C15BB4;
	Wed, 30 Nov 2022 08:01:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1C9751946A47;
	Wed, 30 Nov 2022 08:01:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 046DB1946594
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Nov 2022 13:41:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DC0BF1121320; Tue, 29 Nov 2022 13:41:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D3BCF112131E
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 13:41:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0B493814941
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 13:41:23 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-UQf38Va0Nk-yIiIdiOPpBQ-1; Tue, 29 Nov 2022 08:41:16 -0500
X-MC-Unique: UQf38Va0Nk-yIiIdiOPpBQ-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20221129134113epoutp03a207a1fdc31fc1571efbe3bd86b946aa~sEe1x8BZ12395023950epoutp03D
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 13:41:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20221129134113epoutp03a207a1fdc31fc1571efbe3bd86b946aa~sEe1x8BZ12395023950epoutp03D
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20221129134112epcas5p3952d6737265a7cced70c5b9b42f44fb7~sEe1UCJyF1247612476epcas5p3C;
 Tue, 29 Nov 2022 13:41:12 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4NM3QH1RHTz4x9Pt; Tue, 29 Nov
 2022 13:41:11 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 F9.D7.39477.6FB06836; Tue, 29 Nov 2022 22:41:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
 20221129122758epcas5p4903125cb05fb36a5fdd4d89dd7c4a0a2~sDe5LYffZ1886718867epcas5p4I;
 Tue, 29 Nov 2022 12:27:58 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20221129122758epsmtrp213e89db4e58bd0a233dd3b860258c1bf~sDe5Iyxd20446004460epsmtrp2E;
 Tue, 29 Nov 2022 12:27:58 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-c9-63860bf62376
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 3D.0B.18644.ECAF5836; Tue, 29 Nov 2022 21:27:58 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20221129122755epsmtip1895a7d26f3d2b28585636e34b555dfa4~sDe2Jo09q2443424434epsmtip1U;
 Tue, 29 Nov 2022 12:27:55 +0000 (GMT)
Date: Tue, 29 Nov 2022 17:46:34 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20221129121634.GB16802@test-zns>
MIME-Version: 1.0
In-Reply-To: <cd772b6c-90ae-f2d1-b71c-5d43f10891bf@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ta0xTZxjH857TnrbccgSUVxTBOhNAi9SV7kWBYQQ5MmKIzixxWVhXjoVA
 L7RFkS9yVbkoQsRt3QRUwHGZhMK4CsOiq0AImQwGjIowZozMdlCWRhFYS8vit9/zz/N/Lu+T
 l427l7O82ckyNa2UiVK5hBOjrT/An2dxviQObjRiqGnwFxzlXF/FUYOhhECmh38y0crwCI56
 jN8x0WRfJ4bqGh5jqPv2IoYer78m0OzyFAOV6cYB6pnahx70DDDQaNf3BKqs/YuFSvUtTNQx
 nw2QuSaPhe4vmBioV3McPZnagUZW9cxIL0ozM0xQnRoDixp51sygRofTKW19AUG1VF+kuiez
 COpqrtGakD/DpEy9YwR1rbUeUGbtLupyXxFGaedfY/FuZ1LCkmhRIq30o2VieWKyTBLO/eRU
 wtGEEGEwn8cPRR9x/WQiKR3OjYqL5x1LTrWuz/U7J0pNt0rxIpWKeyAiTClPV9N+SXKVOpxL
 KxJTFQJFkEokVaXLJEEyWn2IHxx8MMSa+GVK0g3dBKawOGcsXWsnssAcpxBw2JAUQEvdBF4I
 nNjuZDeAlWv9LHuwBOCt4mpgD8wAro5ZWJuWCf20w9IFoH7hR0fWCwCXm7QMWxaD3Au1T5uJ
 QsBmE+Q+OLTOtsmeZBAcm5rYaIGTz9iwfOjpRlUPMgy2/PoTYWNXkgff5LQ7eAsc+HZ+oyaH
 jIB5hrdMG28l98C+Nj1mKwTJBg78Y+E2sI8XBSdmZx3sAV/pWx1je0OzsYew83lYd+MHwm7O
 A1Dzu8Zh+BjmD5bgNsbJJNi0lOPQfWD54H3MrrvBqyvzmF13hR0Vm7wHNjZVORpsh+OWbAdT
 8O9G08YG7qQOwPGfna8DX817y2nea2fn/bCqe4nQWB8PJ3fAe2tsOwbApq4DVYBZD7bTCpVU
 QqtCFAdl9Pn/Ty6WS7Vg438ExnaA2ef/BOkAxgbWrmyc6+m6eDJf7O6aKLqQSSvlCcr0VFql
 AyHWY5Xi3lvFcusHk6kT+ILQYIFQKBSEfijkc71c734TKHYnJSI1nULTClq56cPYHO8s7ALn
 zWc1BjQuPRVtqiUsKK1997YZXu7ipwXCw2tHmCdYt0yec4dc/Avno97FlNVkyn0D+nfHCI8n
 Fivq38kqlqsvR8Qad9ZlRIWHeky9vFOs/eIr4mgFZ/ql5wq/oSsje+9D4vOLZ58cDoiWCwXO
 206UnnFhFv2r/41qGepbKbsSV3C6k5qT17jEZnEnTTuxR70+016+BobEgE9/ra58EOk/G2vQ
 +YAXTrNb1i89z0uoTclb0kkCzZKz+1+NdZC72j849/bezbS2TOIu9DjZdqeyXFMijK5eTDMn
 ZUdKjVrekZioRstoeisjoPl0hFOmc1rcwFzglVyPjmMZRXy3R1yGKknED8SVKtF/MTinN6gE
 AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02RfUhTYRTGe++9u7sbrK5f+aplsIpi4cpa9v4hkUZ0g4ioiDBIl97UdCa7
 fqQhmWnRJLOIylVUpsVmaG5Z2tpalk1naiWGWW6lSzOZ32Bfc7VZ1H8P5/k9zzlwKNz3DRFM
 JadlsMo0eaqYFBL3n4pDw9q/F8WvcrvDUY31OY4KSl04quo9Q6LRJ/089KOtA0fGkcs89Nbc
 gCFNVROGDDfGMdTkdpLo41QPgc41vgHI2LMCPTK2EKjz4RUSXbv1iY/OWvQ8VO84BtBkZSEf
 VQ+PEsik3oKae0JQh8vC2xDIqO1tJNOg7uUzHbZagulsy2R02lMko684yhje5pPM6eMjv4Ei
 O48ZNXWRTMk9LWAmdaHMSXMxxugcTmz73BhhZAKbmpzFKleujxMm9VmukukPBIddpVd5+cDA
 VwEBBWkZ7La8x1VASPnS9QDWdo6AWSMI3nI9w2e1H9TMDPJnIQeA181TXoigl0Ld61pSBSiK
 pFfAVjflGfvTUtjV0+3lcfozBcsnBr1FfnQk1L+qIz1aRIfBbwUPyNnSRgCrvhX/MXxgS5mD
 8GiclsDumSHMswCnQ+DtGe8CAb0eFvZ+53l0AL0Ymu9bsFLgo/4vrf4vrf6Xvg5wLQhi0zlF
 ooILT1+dxmZLObmCy0xLlMYfUuiA9/USST14pB2TNgKMAr9Po3Cxv2h8R1G8ryhBnpPLKg/F
 KjNTWa4RhFCEOFD0UtUS60snyjPYFJZNZ5V/XYwSBOdjzQa9LXrx8MIjp6wG1dD5cyfmJ8F4
 WV5ZrFWaE5WUykXJ7ZVrYdc75zrZdPlQeYNTZGvXhOl2RGC7L9Zxoxnm22sW9OmnKkTtu5ML
 Qq0uTVa21v9CgtzHdqI5Yq0BtBp3KezrNI8L907XzJNIddoocc6ca2Fx+9iInZvGBhbQugGF
 aTAWE7ps1NZ+ILhkuXPTfmb/orqsEv6mn4vuEheDA4wHR4jhVdGKyurAFPcBmWwJuTFgvjNm
 Tu3mmqZtL9Z8KAjKOelnLcmN00wv25brH32vZbJyaKpto+lnRV6Gq3fuxzEHPs9UvOdLoOKL
 ZMmEmpjRLhd+xcokBy81iQkuSR4uwZWc/Be6kX6QaQMAAA==
X-CMS-MailID: 20221129122758epcas5p4903125cb05fb36a5fdd4d89dd7c4a0a2
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221123061010epcas5p21cef9d23e4362b01f2b19d1117e1cdf5
References: <CGME20221123061010epcas5p21cef9d23e4362b01f2b19d1117e1cdf5@epcas5p2.samsung.com>
 <20221123055827.26996-1-nj.shetty@samsung.com>
 <cd772b6c-90ae-f2d1-b71c-5d43f10891bf@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Wed, 30 Nov 2022 08:01:29 +0000
Subject: Re: [dm-devel] [PATCH v5 00/10] Implement copy offload support
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
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>,
 "naohiro.aota@wdc.com" <naohiro.aota@wdc.com>,
 "sagi@grimberg.me" <sagi@grimberg.me>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "nitheshshetty@gmail.com" <nitheshshetty@gmail.com>,
 "james.smart@broadcom.com" <james.smart@broadcom.com>,
 "shinichiro.kawasaki@wdc.com" <shinichiro.kawasaki@wdc.com>,
 "p.raghav@samsung.com" <p.raghav@samsung.com>,
 "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
 "kbusch@kernel.org" <kbusch@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "jth@kernel.org" <jth@kernel.org>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="----GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_7d164_"

------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_7d164_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Nov 23, 2022 at 10:56:23PM +0000, Chaitanya Kulkarni wrote:
> (+ Shinichiro)
> 
> On 11/22/22 21:58, Nitesh Shetty wrote:
> > The patch series covers the points discussed in November 2021 virtual
> > call [LSF/MM/BFP TOPIC] Storage: Copy Offload [0].
> > We have covered the initial agreed requirements in this patchset and
> > further additional features suggested by community.
> > Patchset borrows Mikulas's token based approach for 2 bdev
> > implementation.
> > 
> > This is on top of our previous patchset v4[1].
> 
> Now that series is converging, since patch-series touches
> drivers and key components in the block layer you need accompany
> the patch-series with the blktests to cover the corner cases in the
> drivers which supports this operations, as I mentioned this in the
> call last year....
> 
> If you need any help with that feel free to send an email to linux-block
> and CC me or Shinichiro (added in CC )...
> 
> -ck
>

Yes any help would be appreciated. I am not familiar with blktest 
development/testing cycle. Do we need add blktests along with patch 
series or do we need to add after patch series gets merged(to be merged)?

Thanks
Nitesh

------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_7d164_
Content-Type: text/plain; charset="utf-8"


------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_7d164_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_7d164_--

