Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07957C7EE29
	for <dm-devel@archiver.kernel.org>; Thu,  8 Jun 2023 12:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686227312;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=Oq/jX7eovZ4Xfn4eqkd5enBggGIiRn+Jnj3lgYpWOlQ=;
	b=HR/S8od/6QhisoVFE32BTP0fu03TELhxCiFN32Eyk5psKzj3rXll+1yHUszbp9ldJmuOte
	KUR/oOPXCcoPQ73o0kLe6ltELccJepH7UT+9FS8cmvN9ccd+CrTL20ue3JTnTOn6rsDtCZ
	ZXzcFFMKMUeCUN0py/kv9kW98Bi5iOs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-WEBNJUb6NvySam0hd-6o1A-1; Thu, 08 Jun 2023 08:28:29 -0400
X-MC-Unique: WEBNJUb6NvySam0hd-6o1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64B8E85A5AA;
	Thu,  8 Jun 2023 12:28:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EB0F39E8B;
	Thu,  8 Jun 2023 12:28:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CC10019452D3;
	Thu,  8 Jun 2023 12:28:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D4112194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Jun 2023 12:28:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C36C940D1B68; Thu,  8 Jun 2023 12:28:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BBACA40D1B66
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 12:28:25 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A7FE28078CE
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 12:28:25 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-9uDQ4jrsMt2o-3CXByM4-A-1; Thu, 08 Jun 2023 08:28:21 -0400
X-MC-Unique: 9uDQ4jrsMt2o-3CXByM4-A-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230608122817epoutp0278a708662a196500d7c36dbff3cb3d38~mrssayctf0086900869epoutp02S
 for <dm-devel@redhat.com>; Thu,  8 Jun 2023 12:28:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230608122817epoutp0278a708662a196500d7c36dbff3cb3d38~mrssayctf0086900869epoutp02S
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230608122816epcas5p2b58dd7d8b7124a1c8760ab13fef80505~mrsrSQhHv0812208122epcas5p2X;
 Thu,  8 Jun 2023 12:28:16 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4QcNlz32Q5z4x9Pp; Thu,  8 Jun
 2023 12:28:15 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 35.C7.16380.F59C1846; Thu,  8 Jun 2023 21:28:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230608121123epcas5p3071e22355035496648768f4cd420dee1~mrd7ftIoY0769507695epcas5p3f;
 Thu,  8 Jun 2023 12:11:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230608121123epsmtrp1727243a3d59cf2e910bb0ea7b28766b9~mrd7eajJr2145721457epsmtrp1h;
 Thu,  8 Jun 2023 12:11:23 +0000 (GMT)
X-AuditID: b6c32a4b-56fff70000013ffc-51-6481c95f127e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 8C.0C.28392.B65C1846; Thu,  8 Jun 2023 21:11:23 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230608121118epsmtip15e30d20fec6e750fa9049485a81dc2e6~mrd3Q0W5H2318023180epsmtip1C;
 Thu,  8 Jun 2023 12:11:18 +0000 (GMT)
Date: Thu, 8 Jun 2023 17:38:17 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen"
 <martin.petersen@oracle.com>
Message-ID: <20230608120817.jg4xb4jhg77mlksw@green245>
MIME-Version: 1.0
In-Reply-To: <ZIAt7vL+/isPJEl5@infradead.org>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTH97ttb4uu7vJw+/GYkGqUR4p0lPqDWTGRyV2QDbe4zIFiQ68t
 jz7sQ3QaBZwwMAgCAqtuPCzvRSwoQ1SGZYqABLUgCipM6jZxoiKKjgFraV3875PveZ+Tw6I5
 tTHdWPFyDaWSi5I4+AJ6U7vPCm5sZ6o4oLjbEdV3XaahtNwZGqq7m4OjR+0TABU+fU1D5rYM
 gEzmRWjk11B0YfwYA91uO4uh8+V5GOrOLcdQTd0lDJ0re4ah0TvPmejS3GMc5RlvAvSgX4eh
 C4N+qCxdT0fnL3TSkanlOI5KKh8w0aGBZhxVdcxiyJh/AEPN5lSATj56QkdXBt1R70wHA02/
 Oo6v9SRNfRGkbrgHJ8/q7jLJ3nsGOtlY7UuaerRkQ20mTjbq95Pnbqfg5InD+Qwy+8A4Tj57
 MEgnn7T24+Th07WAbOzeQz5vWBLl+E3iaiklElMqL0oepxDHyyVCTsSXsetigwQBPC4vGK3i
 eMlFMkrICdsQxV0fn2RZFsdrpyhJa5GiRGo1Z+Wa1SqFVkN5SRVqjZBDKcVJSr7SXy2SqbVy
 ib+c0oTwAgI+CrI4bkuUDhp/AcoCYtffk9mMFFDNzgIOLEjwoWFsGs8CC1hOxDkAJ/XPmFaD
 EzEBoL7T32Z4DmBvjwl7E5FxeRzYDC0A/jhksIf/AeCtoSGa1YtOLINFumFLKhYLJ/xg9xzL
 KrsQW+G14sp5FxpRy4RtsxwrOxMfw5GBR/M6mxDA9CET08aOsPMHM92axoHgwhvlkVZ5MeEB
 iyte0KxlITHhAH/LOTpfChJhsHY8zNanMxzrOM20sRt8mJNu52RYU1CN22K/A1A3oAM2Qyg8
 2JVj700KWwtLaTb9Q3i06yRm0xfB7GmzfRFs2PzTG14Kf64vxW3sCm9OpdqZhIZr/9r3cwqD
 rQdL6LnAU/fWbLq36tk4BGY+TWPoLPPQCHdYNcuyoQ+sb1lZChi1wJVSqmUSSh2kDJRTyf/f
 O04hawDzr+Qb0Qzujzz1NwKMBYwAsmgcF3ZC6H6xE1ss2v0tpVLEqrRJlNoIgiynOkJzWxyn
 sPyiXBPL4wcH8AUCAT84UMDjfMBeIeyMcyIkIg2VSFFKSvUmDmM5uKVgp8r/ApPvlpzRV3pv
 fhKVnreuah370y7FjLAk8Mqcdlf467OZHfxI9xsGbuGuAV8pd8veu6nUwaGitMivZnL2eGxK
 j9lYPCaTLUyLupq/c9VLwSchrzJl0Z/vk23rem+heckLv9Fw1VR0zEPfmATy8pHEYY+twsdu
 nrfcLn4f0rd3/aYlZQXuvfuWzpjP5B2bldR4b0+5Kl9T73GM6hkUe0/24c7Rdy7G7Z4Ydi7y
 qmuKDGcaCpYzxctendhyv31zhcu+jTt+f+1a2P+nT0bImHBt44jfZ47J/3AE1Tu+eCGJZ89O
 LQ++HnT9XsCikney5qYFTRUb5Au/TvDX89PfT9nzckvy8dHtHLpaKuL50lRq0X/7hAE60wQA
 AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42LZdlhJTjf7aGOKQeMkdov1p44xWzRN+Mts
 sfpuP5vF68OfGC2mffjJbPHkQDujxeUnfBYP9ttb7H03m9Xi5oGdTBZ7Fk1isjg9YRGTxcrV
 R5ksdi/8yGTx+M5ndouj/9+yWUw6dI3R4unVWUwWe29pWyxsW8JisWfvSRaLy7vmsFnMX/aU
 3aL7+g42i+XH/zFZHJrczGSx40kjo8W61+9ZLE7ckrY4//c4q8XvH3PYHOQ9Ll/x9ph1/yyb
 x85Zd9k9zt/byOKxeYWWx+WzpR6bVnWyeWxeUu+x+2YDm8fivsmsHr3N79g8Pj69xeLxft9V
 No++LasYPTafrvb4vEkuQDCKyyYlNSezLLVI3y6BK+Puec2CY7wV82f9Zm9g/MLVxcjJISFg
 ItF+7B1jFyMXh5DADkaJ7submSESkhLL/h6BsoUlVv57zg5R9IRR4n3XRHaQBIuAisT0WfeB
 bA4ONgFtidP/OUDCIgJxEn0nl7CC1DMLrGOX+Lr1GtggYQFriQfXX4PZvAJmEm23L4PNERLY
 xCSxdaIHRFxQ4uTMJywgNjNQzbzND5lB5jMLSEss/8cBYnIK6EpcWuQLUiEqICMxY+lX5gmM
 grOQNM9C0jwLoXkBI/MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgVKKltYNxz6oP
 eocYmTgYDzFKcDArifBm2denCPGmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1
 tSC1CCbLxMEp1cC0Z/knhkyZ9r8vrY6G/u3XyoiLVXFded7avvNzMZsSt92BTVm3f5S9+L/j
 84YrLIuW+YTYt19/G+sq09h5L2TOh3Ymro695XcKY5ZUvlf61nN3tVR3flDMrFqLx+fLdspf
 sxVwOzCtZULjVaW8xqWrrDljfhw45sMZdFODhS9+09yva/5KbH6y/NK9a4qJmTyrDa8tYk+R
 nO5bpLDL5u0rA6eVblPXK54/tZA/i0H7/pH4T2V1gfqcUsK3WeNk5vdXMVqda4vuW/N5hsLE
 NRkvZziXxG3oLP7424zdPD90BmuCzsa8x7buqXH/s2+kXbU7Jme48sLZ8Nh6xW3PrY7HxWjs
 qXgtuM5Ty2Z7gocSS3FGoqEWc1FxIgCzmsAqlAMAAA==
X-CMS-MailID: 20230608121123epcas5p3071e22355035496648768f4cd420dee1
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230605122310epcas5p4aaebfc26fe5377613a36fe50423cf494
References: <20230605121732.28468-1-nj.shetty@samsung.com>
 <CGME20230605122310epcas5p4aaebfc26fe5377613a36fe50423cf494@epcas5p4.samsung.com>
 <20230605121732.28468-6-nj.shetty@samsung.com>
 <ZH3mjUb+yqI11XD8@infradead.org> <20230606113535.rjbhe6eqlyqk4pqq@green245>
 <ZIAt7vL+/isPJEl5@infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v12 5/9] nvme: add copy offload support
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
Cc: linux-doc@vger.kernel.org, djwong@kernel.org,
 linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
 willy@infradead.org, Chaitanya Kulkarni <kch@nvidia.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Mike Snitzer <snitzer@kernel.org>,
 ming.lei@redhat.com, linux-block@vger.kernel.org, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, Kanchan Joshi <joshi.k@samsung.com>,
 martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_57f1d_"

------RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_57f1d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

Hi Christoph and Martin,

On 23/06/07 12:12AM, Christoph Hellwig wrote:
>On Tue, Jun 06, 2023 at 05:05:35PM +0530, Nitesh Shetty wrote:
>> Downside will be duplicating checks which are present for read, write in
>> block layer, device-mapper and zoned devices.
>> But we can do this, shouldn't be an issue.
>
>Yes.  Please never overload operations, this is just causing problems
>everywhere, and that why I split the operations from the flag a few
>years ago.
>

Sure, we will add REQ_COPY_IN/OUT and send a new version.

>> The idea behind subsys is to prevent copy across different subsystem.
>> For example, copy across nvme subsystem and the scsi subsystem. [1]
>> At present, we don't support inter-namespace(copy across NVMe namespace),
>> but after community feedback for previous series we left scope for it.
>
>Never leave scope for something that isn't actually added.  That just
>creates a giant maintainance nightmare.  Cross-device copies are giant
>nightmare in general, and in the case of NVMe completely unusable
>as currently done in the working group.  Messing up something that
>is entirely reasonable (local copy) for something like that is a sure
>way to never get this series in.

Sure, we can do away with subsys and realign more on single namespace copy.
We are planning to use token to store source info, such as src sector,
len and namespace. Something like below,

struct nvme_copy_token {
	struct nvme_ns *ns; // to make sure we are copying within same namespace
/* store source info during *IN operation, will be used by *OUT operation */
	sector_t src_sector;
	sector_t sectors;
};
Do you have any better way to handle this in mind ?


Thank you,
Nitesh Shetty

------RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_57f1d_
Content-Type: text/plain; charset="utf-8"


------RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_57f1d_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------RbnLpepSOhDWt1JmDV6HMUWO9Dmn-C3OOrycHY1seGoKI43i=_57f1d_--

