Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98FE5C7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480079;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=ARNEXbWQkRliI3PpKkT1SoBCK3DbyjXxuoIFwySwe/g=;
	b=J2W9ll9xU+/kLbwsVOd7bAwS0ItqrBPYEz4I9Hpy7unRRHI9T1EnBArUoQ9A9k1bz/mO2n
	fS7qM22iEWYKKms7oBZNkYYAMwI7I0tH2OfqyNzle1iAQxdDPz6HYBfvt3HaAleXjUPuX/
	HfiuQwJR82YUgSZTYsF0qHNB9M0OPg8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-p9axPyg8MaigEHDBg8RNXA-1; Tue, 30 May 2023 16:54:37 -0400
X-MC-Unique: p9axPyg8MaigEHDBg8RNXA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F128280D5A5;
	Tue, 30 May 2023 20:54:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF396140E955;
	Tue, 30 May 2023 20:54:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 77F5419451CB;
	Tue, 30 May 2023 20:54:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 802531946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 10:41:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 64BF4492B0B; Tue, 30 May 2023 10:41:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D194492B0A
 for <dm-devel@redhat.com>; Tue, 30 May 2023 10:41:59 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D9B73802139
 for <dm-devel@redhat.com>; Tue, 30 May 2023 10:41:59 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-eFcdW2nrPP2JPUwvch48UA-1; Tue, 30 May 2023 06:41:57 -0400
X-MC-Unique: eFcdW2nrPP2JPUwvch48UA-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230530104154epoutp03ec95391a9912935e01d10ae8b186ad34~j5cOxRGDM2620026200epoutp03X
 for <dm-devel@redhat.com>; Tue, 30 May 2023 10:41:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230530104154epoutp03ec95391a9912935e01d10ae8b186ad34~j5cOxRGDM2620026200epoutp03X
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230530104153epcas5p2876a4c3f4e06f0e8e6c882b2fd33ffef~j5cN-Evjq0384103841epcas5p2h;
 Tue, 30 May 2023 10:41:53 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4QVpqM4sc2z4x9Pw; Tue, 30 May
 2023 10:41:51 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 3C.91.44881.FE2D5746; Tue, 30 May 2023 19:41:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230530102050epcas5p24882da82b49dc397d3ab694d51658705~j5J2J-5Pj2734627346epcas5p2e;
 Tue, 30 May 2023 10:20:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230530102050epsmtrp2dd099d94863ef09ba0c46326022e7ff0~j5J2IXIeD0209902099epsmtrp2H;
 Tue, 30 May 2023 10:20:50 +0000 (GMT)
X-AuditID: b6c32a4a-c47ff7000001af51-2c-6475d2ef7820
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 93.4D.28392.20EC5746; Tue, 30 May 2023 19:20:50 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230530102045epsmtip13a67ba165c229e2b47ea3d055ff9f54b~j5Jw0ZBr42118821188epsmtip1C;
 Tue, 30 May 2023 10:20:44 +0000 (GMT)
Date: Tue, 30 May 2023 15:47:40 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Matthew Wilcox <willy@infradead.org>
Message-ID: <20230530101740.lsb3mnt5zx6n7tzn@green245>
MIME-Version: 1.0
In-Reply-To: <ZHTm/v1jTZhcpDei@casper.infradead.org>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1BUVRzHO3eXuxcH7LIr0xEyaLMxQXAXlvWgrFBa3UAbm9SZdISu7B2W
 ZB/tZTWhAkFRNOIVhMtOPkJRQEB0cuWhsLwJ2pCQoHiYoJUpAgoKAe2ya+N/n9/3fL9zfr/f
 mUNw+EaeGxGtimW0KjpGiC/i/lC/cqXP6A2dXHSveDkqa2viIENZCY6SMmY5qLg/HUf36scB
 yn34lIOGrgejmgf5Dqi39iqGqk9nYeh8cSOGLqYTqOrUGIYa5+/jKMt0E6CRbj2Gavq8UXVN
 Kxd1VRpwNFAy74BOnB3hoWM9RhwVNs9hyJSdjCHj8AGASu+NclFLnzsyzzY7oJknBjxkGdX1
 SxilH+zAqav6fh5lHrjIpXKz2nDq0jkvqqtDR1UUpeJUxXgWj2rJm+FSlwoSqKreRJxKS36A
 U2MjfVxq9Fo3Tn19uQhsEezYE6RgaDmj9WRUkWp5tCpKJgz7MGJDRIBUJPYRB6I1Qk8VrWRk
 wo2btvi8Ex1jWZLQcy8do7NIW2iWFa5eH6RV62IZT4WajZUJGY08RiPR+LK0ktWponxVTOxa
 sUjkF2AxfrxH0Tx3iavp5X1WdOo3biJowI8CRwKSEpg8Nck5ChYRfLIKwN72Y/ZiHMCDx3OA
 1cUnJwA0l/s/SwzOmB1spkoAu+tPY7biDoBPzhZYCoLgkq/Dw22+VsRJb/jjPGHFJeQb8J/L
 flY3h+zE4bj59kIXAjIMDv9UvpB0JqVwao62ys6kC2w9Psy1sqPl2rmmPzEru5Ivw7wzjxf6
 hOQdR3hldNA+zUZ4JaXSzgL4d/Nlno3d4MSDGru+D57/5hxuCx8EUN+jB7aDYHioLZ1jZQ6p
 gHkp/fbAMpjTVorZ9MUwbWYYs+nO0PjdM34NlpSdtPuXwptTB+xMwUcp1Tzbfu4CWPCVmZsB
 PPTPTad/7j4br4WpD5Mc9JZlcEh3WDhH2HAlLKtcfRI4FIGljIZVRjFsgMZPxez7/70j1coK
 sPCFvEKN4NbQQ18TwAhgApDgCJc4y2hWzneW0/vjGK06QquLYVgTCLA8VSbHzTVSbfmDqtgI
 sSRQJJFKpZJAf6lY+JLzCllrJJ+MomOZPQyjYbTPchjh6JaIrQLp7VXbwgVh4k2dhxbTQ6Kf
 rz1e1WJapokeDvUp3+yxvuNCmsskXFe9jT/o7/iFMXxFocfOF/796K9gHZiX7RRsTWhKfTPk
 frdS0D59YjvrVFu7zTjJe/TBXGZlfnNpwqe7vLy3Nx7+drYz9Ogn63ridQFrZIZEXbggvSek
 qtMznr9Uv3uSei/kbY/fv/w1+62h/Y3v1/U47XYiiz1Kcgqk6EUD0zA9E1In3t94duvyd103
 jsSVu3xfHZCEsoMOP/08i4mPy9cCxfXbdTc2n2nIlLhn1N1qrR95NTdRubbPxTt+h2Z9k1m6
 dyzFsDX3QtL2uF2mgVfubmifyDSoj/S7Tvf+IeSyClrsxdGy9H8wQ8YVywQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWy7bCSnC7TudIUg6MLdCzWnzrGbDFn/Ro2
 i6YJf5ktVt/tZ7N4ffgTo8W0Dz+ZLR7st7fY+242q8XNAzuZLPYsmsRksXL1USaLjf0cFrsX
 fmSyOPr/LZvFpEPXGC2eXp3FZLH3lrbFnr0nWSwu75rDZnFvzX9Wi/nLnrJbdF/fwWax/Pg/
 JotDk5uZLHY8aWS0WPf6PYvFiVvSFuf/Hme1+P1jDpuDrMflK94es+6fZfPYOesuu8f5extZ
 PKZNOsXmsXmFlsfls6Uem1Z1snls+jSJ3ePEjN8sHpuX1HvsvtnA5tHb/I7N4+PTWywe7/dd
 ZfPo27KKMUA4issmJTUnsyy1SN8ugSvj6UzRgm7Wirubv7A0ME5g6WLk5JAQMJG4//s8K4gt
 JLCDUeLNv1SIuKTEsr9HmCFsYYmV/56zdzFyAdU8YZT4cOYAWxcjBweLgKpE+yk9EJNNQFvi
 9H8OEFNEQEPizRYjkGpmgetsEpOurQUbLyzgLfHk3AYmkBpeATOJ7/8SISY+Z5SYuOwaWA2v
 gKDEyZlPwE5jBqqZt/khM0g9s4C0xPJ/HCBhTqCL/x17wQRiiwrISMxY+pV5AqPgLCTds5B0
 z0LoXsDIvIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzhtaGntYNyz6oPeIUYmDsZD
 jBIczEoivLaJxSlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJx
 cEo1MHk/vpn7nu+FXZZp20KzgNvLi+xrKy/Z3WYK7SlPcvo5WVvxc4xka95jE3XuY+uPz2jy
 VcqYxF4+LyV9z6MA1vl7dgmmsXZy+mlf6vyuct4r+qOS9cWCawse3I9ifRmY+Ugz7vz+SzGh
 wnn397UJ3X0j735+qdPUGOHlLRuuf1qQNdPsRcnd9E33NdcnN1TL7RPamXfeRH27oGf7fLFL
 r8pZj+YWqzIYVLr2tHZmlLXWvOssf9JuukGVKfdeQ0BktLaRw/boohkrYxj2dlx78OOq7m0Z
 YzbplB9ydflTu2UXz/yn/zRit1Ds04btD/R1F34x+9feebzt/N6N4sLyZ2Icr91wNq9Xe7j7
 kk+nEktxRqKhFnNRcSIAIU/XjIoDAAA=
X-CMS-MailID: 20230530102050epcas5p24882da82b49dc397d3ab694d51658705
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230522104536epcas5p23dd8108dd267ec588e5c36e8f9eb9fe8
References: <20230522104146.2856-1-nj.shetty@samsung.com>
 <CGME20230522104536epcas5p23dd8108dd267ec588e5c36e8f9eb9fe8@epcas5p2.samsung.com>
 <20230522104146.2856-3-nj.shetty@samsung.com>
 <ZHTm/v1jTZhcpDei@casper.infradead.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
 James Smart <james.smart@broadcom.com>, Chaitanya Kulkarni <kch@nvidia.com>,
 anuj20.g@samsung.com, Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Keith Busch <kbusch@kernel.org>, bvanassche@acm.org,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 joshi.k@samsung.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----dpMjS_Krfo.HeTa1.nqRY6lfIY-msh.FGO-xMH_14-IlSSmS=_312ff_"

------dpMjS_Krfo.HeTa1.nqRY6lfIY-msh.FGO-xMH_14-IlSSmS=_312ff_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/05/29 06:55PM, Matthew Wilcox wrote:
>On Mon, May 22, 2023 at 04:11:33PM +0530, Nitesh Shetty wrote:
>> +		token = alloc_page(gfp_mask);
>
>Why is PAGE_SIZE the right size for 'token'?  That seems quite unlikely.
>I could understand it being SECTOR_SIZE or something that's dependent on
>the device, but I cannot fathom it being dependent on the host' page size.

This has nothing to do with block device at this point, merely a place
holder to store information about copy offload such as src sectors, len.
Token will be typecasted by driver to get copy info.
SECTOR_SIZE also should work in this case, will update in next version.

------dpMjS_Krfo.HeTa1.nqRY6lfIY-msh.FGO-xMH_14-IlSSmS=_312ff_
Content-Type: text/plain; charset="utf-8"


------dpMjS_Krfo.HeTa1.nqRY6lfIY-msh.FGO-xMH_14-IlSSmS=_312ff_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------dpMjS_Krfo.HeTa1.nqRY6lfIY-msh.FGO-xMH_14-IlSSmS=_312ff_--

