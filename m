Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 512F9C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:23:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-q6lBWPrrPFChxzLbEMgSjg-1; Fri, 29 Apr 2022 04:23:52 -0400
X-MC-Unique: q6lBWPrrPFChxzLbEMgSjg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5339C3C0F0A2;
	Fri, 29 Apr 2022 08:23:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3D330146894A;
	Fri, 29 Apr 2022 08:23:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B5423194704B;
	Fri, 29 Apr 2022 08:23:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 947271947043
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 18:09:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8754E407E1C1; Wed, 27 Apr 2022 18:09:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 82902407E1C0
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 18:09:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A73F811E7A
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 18:09:03 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-1P8uCtZ6M72rQ9bbabb35w-1; Wed, 27 Apr 2022 14:09:01 -0400
X-MC-Unique: 1P8uCtZ6M72rQ9bbabb35w-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20220427180858epoutp040be4b4e572120ad320e87c35741ab79e~p0y8-Q1q82298922989epoutp04M
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 18:08:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20220427180858epoutp040be4b4e572120ad320e87c35741ab79e~p0y8-Q1q82298922989epoutp04M
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20220427180857epcas5p49214c5b087f6a3abc404d9e61d699270~p0y7zEIdM3093730937epcas5p4-;
 Wed, 27 Apr 2022 18:08:57 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4KpRZs2w2mz4x9Pq; Wed, 27 Apr
 2022 18:08:53 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 CB.2C.10063.5B689626; Thu, 28 Apr 2022 03:08:53 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20220427154335epcas5p2decfa46fd054003fe354919a6ccc8bb5~py0BFdT5t1292212922epcas5p2s;
 Wed, 27 Apr 2022 15:43:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220427154335epsmtrp1836aaec6d9081312a54cf44cfab35bf7~py0BEoafL2542225422epsmtrp1t;
 Wed, 27 Apr 2022 15:43:35 +0000 (GMT)
X-AuditID: b6c32a49-4b5ff7000000274f-7e-626986b5bcd4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 B8.AA.08924.7A469626; Thu, 28 Apr 2022 00:43:35 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427154333epsmtip1c2203c795e44edd393049c9924cd6740~pyz-zoaVP2609826098epsmtip1D;
 Wed, 27 Apr 2022 15:43:33 +0000 (GMT)
Date: Wed, 27 Apr 2022 21:08:26 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20220427153826.GE9558@test-zns>
MIME-Version: 1.0
In-Reply-To: <c02f67e1-2f76-7e52-8478-78e28b96b6a1@opensource.wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmpu7Wtswkg77pgha/z55nttj7bjar
 xd5b2hZ79p5ksbi8aw6bxfxlT9ktuq/vYLPY8aSR0YHDY+esu+wem5fUe+xsvc/q8X7fVTaP
 z5vkAlijsm0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
 gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
 mQIVJmRn/LohVnBRoOL4pJPMDYzXebsYOTkkBEwkdvY9Yuli5OIQEtjNKPHm919GCOcTo8Sa
 bb2sEM5nRolFe6eywLS8Xj8LqmoXo8S7d1+gnGeMEtNP/gKrYhFQlZh4dCV7FyMHB5uAtsTp
 /xwgYREBU4m3Pa1g+5gFzjBKtL/fxQ6SEBYwk1jd2coGYvMK6Eg8n32TFcIWlDg58wkLyBxO
 ATeJXSuVQMKiAsoSB7YdZwKZIyEwlUPi76E/TBDXuUgseb2IGcIWlnh1fAs7hC0l8bK/Dcou
 l9jetgCquYVRouvUKajX7CUu7vkLNohZIEPizftlUA2yElNPrYOK80n0/n4CtYxXYsc8GFtZ
 Ys36BWwQtqTEte+NULaHxM6PK6HheIpR4tmkBtYJjPKzkDw3C8m+WUCPMgtoSqzfpQ8Rlpdo
 3jqbGSIsLbH8HweSigWMbKsYJVMLinPTU4tNCwzzUsvhkZ+cn7uJEZxotTx3MN598EHvECMT
 B+MhRgkOZiUR3i+7M5KEeFMSK6tSi/Lji0pzUosPMZoC420is5Rocj4w1eeVxBuaWBqYmJmZ
 mVgamxkqifOeTt+QKCSQnliSmp2aWpBaBNPHxMEp1cA07bdN1pr1rOJuT7VLfALK9OTWfT79
 2k7qzV7JTcov07ez1cwpjd/Zprt8Sdykh99eBecX7HR1PmOy9omaz7lYLsFdvAfuvKqdavCo
 77T2y1O3HAMM3t6atKFmfUyeZTYfR5Dq9M6CZQHJOpMs5iQw/AmTTXpnrfdn8dWV/0/2Ck/9
 zn/x2KsAs0fblQV7w+8JRPGnXFLi4fBf+NbXzGe63MoCg8VbnqXf+H/t0vG+5Jw5LN7BKrdc
 YmUXrb3KcOXp2hkTlk5WE3Cs/6TI++yOy66S1RuPGqY6LF25+nvDn8XJX6POqU7a7pvFLO2X
 P/uAXOr6bd4Mbnbz5wTk3Ymv4M4L/+nf/pbxR36mj2+pEktxRqKhFnNRcSIAhY8t5z0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWy7bCSnO7ylMwkg54+LovfZ88zW+x9N5vV
 Yu8tbYs9e0+yWFzeNYfNYv6yp+wW3dd3sFnseNLI6MDhsXPWXXaPzUvqPXa23mf1eL/vKpvH
 501yAaxRXDYpqTmZZalF+nYJXBnrr39gLPjMWzHvxASWBsap3F2MnBwSAiYSr9fPYuxi5OIQ
 EtjBKLFszhU2iISkxLK/R5ghbGGJlf+es0MUPWGUmHllNyNIgkVAVWLi0ZVACQ4ONgFtidP/
 OUDCIgKmEm97WllA6pkFzjBKtL/fxQ6SEBYwk1jd2Qq2gFdAR+L57JusEENPMUq8vDyZCSIh
 KHFy5hMWEJtZQF3iz7xLzCALmAWkJZb/44AIy0s0b50NFuYUcJPYtVIJJCwqoCxxYNtxpgmM
 QrOQDJqFZNAshEGzkAxawMiyilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOHK0tHYw
 7ln1Qe8QIxMH4yFGCQ5mJRHeL7szkoR4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5Y
 kpqdmlqQWgSTZeLglGpgsjqyIrdo7svg/Yd2r1/Vz3s9JMRNZlmiaxt/6tsXvfcmmR+85KSo
 8Cmub7Fk87R1E+ZdS86dUxIwbyfTztmSc94JtpRP6T5xaIPvvbMbb4oUFmftuZ3SwaC1n/kv
 W1rtJrsi++RZ6x0iFboPbiiz2PQ+9O3GN7+6pB5bzJf7080Uv6dhEdNVixczPm8VYCmYzv7t
 X0zu1fkf/vX1HV3dNaujOHdJL+v5JO7mkunK6oJnZ+Xt2m71eUXHV98ZZbvqdOq8FzgUuWZo
 ZZm6SoRpvTpsvFz/BDv/VKfXGUtEDi0Myw5lDvrdXMyoN+XK+na3XWtrpLbIZze6nqs5oRxy
 +NmFf8Zn1qv7Lf0k1O4cpcRSnJFoqMVcVJwIAL0nILoLAwAA
X-CMS-MailID: 20220427154335epcas5p2decfa46fd054003fe354919a6ccc8bb5
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
 <c02f67e1-2f76-7e52-8478-78e28b96b6a1@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: Re: [dm-devel] [PATCH v4 00/10] Add Copy offload support
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="----SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_17deb_"

------SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_17deb_
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 27, 2022 at 10:46:32AM +0900, Damien Le Moal wrote:
> On 4/26/22 19:12, Nitesh Shetty wrote:
> > The patch series covers the points discussed in November 2021 virtual c=
all
> > [LSF/MM/BFP TOPIC] Storage: Copy Offload[0].
> > We have covered the Initial agreed requirements in this patchset.
> > Patchset borrows Mikulas's token based approach for 2 bdev
> > implementation.
> >=20
> > Overall series supports =E2=80=93
> >=20
> > 1. Driver
> > - NVMe Copy command (single NS), including support in nvme-target (for
> >     block and file backend)
> >=20
> > 2. Block layer
> > - Block-generic copy (REQ_COPY flag), with interface accommodating
> >     two block-devs, and multi-source/destination interface
> > - Emulation, when offload is natively absent
> > - dm-linear support (for cases not requiring split)
> >=20
> > 3. User-interface
> > - new ioctl
> > - copy_file_range for zonefs
> >=20
> > 4. In-kernel user
> > - dm-kcopyd
> > - copy_file_range in zonefs
> >=20
> > For zonefs copy_file_range - Seems we cannot levearge fstest here. Limi=
ted
> > testing is done at this point using a custom application for unit testi=
ng.
>=20
> https://protect2.fireeye.com/v1/url?k=3Db14bf8e1-d0361099-b14a73ae-74fe48=
5fffb1-9bd9bbb269af18f9&q=3D1&e=3Db9714c29-ea22-4fa5-8a2a-eeb42ca4bdc1&u=3D=
https%3A%2F%2Fgithub.com%2Fwesterndigitalcorporation%2Fzonefs-tools
>=20
> ./configure --with-tests
> make
> sudo make install
>=20
> Then run tests/zonefs-tests.sh
>=20
> Adding test case is simple. Just add script files under tests/scripts
>=20
> I just realized that the README file of this project is not documenting
> this. I will update it.
>

Thank you. We will try to use this.
Any plans to integrate this testsuite with fstests(xfstest) ?

--
Nitesh Shetty

------SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_17deb_
Content-Type: text/plain; charset="utf-8"


------SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_17deb_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_17deb_--

