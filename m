Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C45B0C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:24:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-m589p04sMFWEwrMuZ3IgyQ-1; Fri, 29 Apr 2022 04:23:48 -0400
X-MC-Unique: m589p04sMFWEwrMuZ3IgyQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FECE2811832;
	Fri, 29 Apr 2022 08:23:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF73254B068;
	Fri, 29 Apr 2022 08:23:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2E8781947068;
	Fri, 29 Apr 2022 08:23:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 563A61947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 14:31:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 37B8D14682CD; Wed, 27 Apr 2022 14:31:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 336E214682DB
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 14:31:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13601801E80
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 14:31:16 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-lbXf5w6MMCSWRtoWOM0rtA-1; Wed, 27 Apr 2022 10:31:13 -0400
X-MC-Unique: lbXf5w6MMCSWRtoWOM0rtA-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20220427143110epoutp0386d5d5bdafd9ef0d71bd8c31c48a655d~px0y9clDF1047910479epoutp03G
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 14:31:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20220427143110epoutp0386d5d5bdafd9ef0d71bd8c31c48a655d~px0y9clDF1047910479epoutp03G
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20220427143110epcas5p40c88d0aed948bf707494648074071e87~px0yta3Zx2356823568epcas5p4v;
 Wed, 27 Apr 2022 14:31:10 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4KpLlZ5wJ5z4x9Pt; Wed, 27 Apr
 2022 14:31:06 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 05.DD.10063.9A359626; Wed, 27 Apr 2022 23:31:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20220427130824epcas5p38594effe1d648be050ff00284e115014~pwshxFhMl2087820878epcas5p35;
 Wed, 27 Apr 2022 13:08:24 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220427130824epsmtrp14e26381493d2df92a583d1f425e97e0c~pwshwRhe_3201832018epsmtrp1G;
 Wed, 27 Apr 2022 13:08:24 +0000 (GMT)
X-AuditID: b6c32a49-4b5ff7000000274f-c5-626953a9862a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 D8.A4.08853.84049626; Wed, 27 Apr 2022 22:08:24 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427130823epsmtip2faace445336901ad6bad32c4c8c06a3d~pwsghFvIJ1516015160epsmtip2s;
 Wed, 27 Apr 2022 13:08:23 +0000 (GMT)
Date: Wed, 27 Apr 2022 18:33:15 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20220427130315.GB9558@test-zns>
MIME-Version: 1.0
In-Reply-To: <513edc25-1c73-6c85-9a50-0e267a106ec0@opensource.wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmlu7K4Mwkg83dbBa/z55nttj7bjar
 xd5b2hZ79p5ksbi8aw6bxfxlT9ktuq/vYLPY8aSR0YHDY+esu+wem5fUe+xsvc/q8X7fVTaP
 z5vkAlijsm0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
 gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
 mQIVJmRnbOndwFrwUrBiw71fjA2MLXxdjJwcEgImEkv3zWDtYuTiEBLYzSjRvXYulPOJUeLs
 wd9sEM43RomWxYcYYVpWX5sKVbWXUaK1+zhU1TNGieM7vrGDVLEIqEr0LF8AlODgYBPQljj9
 nwMkLCJgKvG2p5UFpJ5Z4AyjRPv7XWD1wgLOEv0XbzOD2LwCOhJ7D2xlg7AFJU7OfMICYnMK
 uElMPbaRCcQWFVCWOLDtOBPIIAmBVg6J91P2sUOc5yKx/Np3NghbWOLV8S1QcSmJl/1tUHa5
 xPa2BVDNLYwSXadOsUAk7CUu7vkLtoFZIEPiZP8TqEGyElNPrYOK80n0/n7CBBHnldgxD8ZW
 llizfgFUvaTEte+NULaHxJ9fkLATEvjNKHFuecQERvlZSJ6bhWQdhK0jsWD3JyCbA8iWllj+
 jwPC1JRYv0t/ASPrKkbJ1ILi3PTUYtMCw7zUcniUJ+fnbmIEJ1Utzx2Mdx980DvEyMTBeIhR
 goNZSYT3y+6MJCHelMTKqtSi/Pii0pzU4kOMpsDImsgsJZqcD0zreSXxhiaWBiZmZmYmlsZm
 hkrivKfTNyQKCaQnlqRmp6YWpBbB9DFxcEo1MDHuZMtnCveS5dyplbLtQ6yT1cyrqp+jNV78
 td50UtihS2znQbNss6ct9y5WSj7h4r/YvvP4l4mq586arxDgNPK0nbt2++XpMSyzTzCcP7bl
 5Ga9AMnSCYdmflilkdHO6ZLZYi2mdeBXw/qNYccOMUeXMonf3vhNMHH187VXs/esU5gVdm+R
 QH7+vZSl3Et/rs9sdvogqivX0XT8L7/GDZcT0a5aIZtfbT5d3nVm9QtZWSuWxw7PjrLxsXB6
 ZAepV1oo5Jr3P3lwnr2ghq1ZxsBld7Y03/5b/IwP31969ER6+s043U+n6j5ylorx68Wd7luj
 tu5F4JUE58n38kyZ060niWXO15t/W6h4z12VDCWW4oxEQy3mouJEAIGbFNYzBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSvK6HQ2aSwaIl0ha/z55nttj7bjar
 xd5b2hZ79p5ksbi8aw6bxfxlT9ktuq/vYLPY8aSR0YHDY+esu+wem5fUe+xsvc/q8X7fVTaP
 z5vkAlijuGxSUnMyy1KL9O0SuDKaL3IXrOSv2LThL2MD413uLkZODgkBE4nV16aydjFycQgJ
 7GaUeHP7DSNEQlJi2d8jzBC2sMTKf8/ZIYqeMEo03poDlmARUJXoWb6ArYuRg4NNQFvi9H8O
 kLCIgKnE255WFpB6ZoEzjBLt73exgySEBZwl+i/eBuvlFdCR2HtgKxvE0N+MEkveTmaFSAhK
 nJz5hAXEZhbQkrjx7yUTyAJmAWmJ5f/AFnAKuElMPbaRCcQWFVCWOLDtONMERsFZSLpnIeme
 hdC9gJF5FaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcCRoae5g3L7qg94hRiYOxkOM
 EhzMSiK8X3ZnJAnxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TB
 KdXAdHDXNQfr76ea8g6xxHUXtj65+s76sFXCrNy02EbZflWt4s8m8WmWhQxPPdznWvr0qJo5
 Zdl8rf1zY1c1R/y1JZ82m/OuXpJrPi9hS23woU4/0/Lo1nXzLrLdWXPw+pSD+Rk7bu3XYXDP
 P6ZzU9qc1UTn5oMFWsuZp9vy5K7NW5w8V/286MKagv+9svKreO4v+lszVWWhb+8WvuP+G3Ym
 nG8q/h5b8l38wV/NvALj/cZTT3quXejR71hYe6g79UiOzdrSezVVklPsvNUmu2qEVNfYPZ/y
 ovWVfEzu76ojTfskD5v4KDZznLvU9rdpsWa19anSOSXHvrBI9QcbR2+MCWdc7zc5J/o8m5/l
 pjQlluKMREMt5qLiRACj4ob+8wIAAA==
X-CMS-MailID: 20220427130824epcas5p38594effe1d648be050ff00284e115014
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220426101938epcas5p291690dd1f0e931cd9f8139daaf3f9296
References: <20220426101241.30100-1-nj.shetty@samsung.com>
 <CGME20220426101938epcas5p291690dd1f0e931cd9f8139daaf3f9296@epcas5p2.samsung.com>
 <20220426101241.30100-4-nj.shetty@samsung.com>
 <513edc25-1c73-6c85-9a50-0e267a106ec0@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: Re: [dm-devel] [PATCH v4 03/10] block: Introduce a new ioctl for
 copy
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
Cc: linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="----s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_17950_"

------s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_17950_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

O Wed, Apr 27, 2022 at 11:48:57AM +0900, Damien Le Moal wrote:
> On 4/26/22 19:12, Nitesh Shetty wrote:
> > Add new BLKCOPY ioctl that offloads copying of one or more sources ranges
> > to one or more destination in a device. COPY ioctl accepts a 'copy_range'
> > structure that contains no of range, a reserved field , followed by an
> > array of ranges. Each source range is represented by 'range_entry' that
> > contains source start offset, destination start offset and length of
> > source ranges (in bytes)
> > 
> > MAX_COPY_NR_RANGE, limits the number of entries for the IOCTL and
> > MAX_COPY_TOTAL_LENGTH limits the total copy length, IOCTL can handle.
> > 
> > Example code, to issue BLKCOPY:
> > /* Sample example to copy three entries with [dest,src,len],
> > * [32768, 0, 4096] [36864, 4096, 4096] [40960,8192,4096] on same device */
> > 
> > int main(void)
> > {
> > 	int i, ret, fd;
> > 	unsigned long src = 0, dst = 32768, len = 4096;
> > 	struct copy_range *cr;
> > 	cr = (struct copy_range *)malloc(sizeof(*cr)+
> > 					(sizeof(struct range_entry)*3));
> > 	cr->nr_range = 3;
> > 	cr->reserved = 0;
> > 	for (i = 0; i< cr->nr_range; i++, src += len, dst += len) {
> > 		cr->range_list[i].dst = dst;
> > 		cr->range_list[i].src = src;
> > 		cr->range_list[i].len = len;
> > 		cr->range_list[i].comp_len = 0;
> > 	}
> > 	fd = open("/dev/nvme0n1", O_RDWR);
> > 	if (fd < 0) return 1;
> > 	ret = ioctl(fd, BLKCOPY, cr);
> > 	if (ret != 0)
> > 	       printf("copy failed, ret= %d\n", ret);
> > 	for (i=0; i< cr->nr_range; i++)
> > 		if (cr->range_list[i].len != cr->range_list[i].comp_len)
> > 			printf("Partial copy for entry %d: requested %llu, completed %llu\n",
> > 								i, cr->range_list[i].len,
> > 								cr->range_list[i].comp_len);
> > 	close(fd);
> > 	free(cr);
> > 	return ret;
> > }
> 
> Nice to have a code example. But please format it correctly.
>

acked

--
Nitesh Shetty

------s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_17950_
Content-Type: text/plain; charset="utf-8"


------s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_17950_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------s9reHD3dvq.Swzu4OgS99nNlXP7CLa0djtt04wdzZepsPVyA=_17950_--

