Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C7A8C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 23 Nov 2022 08:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669191965;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=sP+eVXn1aY8hmyfuwuptNfAsNXYXMmw1Uy1CH+R14Ww=;
	b=KtGx8xdHMDq8XS6IcAtJwaOnfQX5sDJobMe9RcwWI6nVNx2ueB/0EvZ6c3jOFuvqrGQg27
	M2AgBtGe9rZRjp+z7sU82y2jMRmbdnpQDywr8rpAagSev2pNe7OvIgLOn+veDCgf2eBpf0
	c5r/kWA/WhA6HIy90Ac3RBPhp/havzQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-KP4GsJDkMX-AxHegMW5zMw-1; Wed, 23 Nov 2022 03:26:01 -0500
X-MC-Unique: KP4GsJDkMX-AxHegMW5zMw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6748C1C0CE65;
	Wed, 23 Nov 2022 08:25:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 54D3C1401C20;
	Wed, 23 Nov 2022 08:25:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3C75F194658D;
	Wed, 23 Nov 2022 08:25:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0A7071946589
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Nov 2022 06:21:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F043D4EA4A; Wed, 23 Nov 2022 06:21:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E8C2C39D7C
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:21:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C56CF1C05ADB
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:21:06 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-360-pyb3QrzXO1OKUUlsWfrSFA-1; Wed, 23 Nov 2022 01:21:04 -0500
X-MC-Unique: pyb3QrzXO1OKUUlsWfrSFA-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20221123061352epoutp01987a1e5c33e3c9d1a2c610994b486aac~qIgiV1lOk1789617896epoutp01l
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 06:13:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20221123061352epoutp01987a1e5c33e3c9d1a2c610994b486aac~qIgiV1lOk1789617896epoutp01l
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20221123061350epcas5p471359445e51afd8cd2387ddbf6faa737~qIggyQ-f61580315803epcas5p4-;
 Wed, 23 Nov 2022 06:13:50 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4NH9mq4fGdz4x9QH; Wed, 23 Nov
 2022 06:13:47 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 19.37.56352.B1ABD736; Wed, 23 Nov 2022 15:13:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20221123061010epcas5p21cef9d23e4362b01f2b19d1117e1cdf5~qIdUMOmSP0377003770epcas5p2k;
 Wed, 23 Nov 2022 06:10:10 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20221123061010epsmtrp240c1b1d323a61346f7e8928f9190ee34~qIdULATEz0451404514epsmtrp2a;
 Wed, 23 Nov 2022 06:10:10 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-35-637dba1bece3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 D7.FA.14392.249BD736; Wed, 23 Nov 2022 15:10:10 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
 [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20221123061007epsmtip1e493ba5af1c6e49ea490269a2dcb0bab~qIdRPeIeF1429014290epsmtip1d;
 Wed, 23 Nov 2022 06:10:07 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
 james.smart@broadcom.com, kch@nvidia.com, damien.lemoal@opensource.wdc.com,
 naohiro.aota@wdc.com, jth@kernel.org, viro@zeniv.linux.org.uk
Date: Wed, 23 Nov 2022 11:28:17 +0530
Message-Id: <20221123055827.26996-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Tf1CTdRi/7/tu7wYJvQLJV7iAm2ch3mCLMb94UnaRvaQV1gXi1dEab4Ng
 P9y7iZodKFKKyY8MsmFAAbs2aOAkmFsrDg4IhPAiMEgiA0z5KeIZhosGL5T/fZ7P83k+z/N8
 v/fwcR8XEcBPU+lorUqWISA8OY2tW0KFgfb35aLipmBU19WOo+OFLhzVDBcQaLGnF0fOmVIu
 Gmy+hCFTTRuGHF/MYahtaZpA1+8OcdDHLQMAjfcbMOQc2oq+dXZyUJ/9PIHKjeM8VNRxkYts
 Y8cAalwsx9F89QkeskzOctAPQ4Go19XB3elPGUZ6COqSYZhH9f52gUP19egpq/kUQV2syqIc
 g9kEdSZnxi3IHeFSs9/1E1R+gxlQ89Yg6sPm0xhlHZvG4r33p+9IpWUptDaEVsnVKWkqRYxg
 92vJzyVHSUVioTgabROEqGRKOkYQuydeuCstw72/IOSgLEPvpuJlDCOIeHqHVq3X0SGpakYX
 I6A1KRkaiSackSkZvUoRrqJ128Ui0VNRbuFb6am35iwczVnpIaO9l8gGN0PzgAcfkhI46yoh
 8oAn34d0ADhcbMLZ4A6A90bPcdngHoDVp7u4ayXmG3mrCSeAldndgA1yMbhQ1YblAT6fILfC
 y0v8Zd6PzMfgSUfzii9OlmJw2viAtyzyJRGsdSmXXTnkZth+YwksYy9yOzz1QR++LIFkBCwY
 Wc/S62HnZ2OcZYyTwTDnm9IVS0h+6gHNJcOr08XCKVMrh8W+cKKjgcfiADg/4yRYnAlNn3xF
 sMUnADRcNQA28QzM7SpYaYyTW2CdPYKlH4fFXRaMbewNzyyOYSzvBW1la3gTrK2rWPXfCAf+
 OraKKThVO7syjw/5JnSUjBKFINjw0D6Gh/Yx/N+5AuBmsJHWMEoFzURpIlV05n8/K1crrWDl
 DsJ228Afv98ObwEYH7QAyMcFfl5ZcUflPl4pssNHaK06WavPoJkWEOV+4yI84DG52n1IKl2y
 WBItkkilUkl0pFQs8PeqPBcm9yEVMh2dTtMaWrtWh/E9ArKxV4V7F9qVl1/389cnRUuS4vL3
 JpQ3/bghWvHskUbbe4og735rgmHf17ZYv52HTK+8KDXNz8qEo/G/aPh3qn+1dTTkJ2wmg3vM
 I/cnB8hr82XJuQk9alhqvh3wZH3mleKy/ePMwsGr3LP1jC1tQsQTHy4M4ybl5j9Sv8/PFf95
 5d+1B7r7Q6cs9v63/7GYEm/665pqWjrStOeFExeemPy+veJPT+Pg8Qksbh3HaXmesJbl3L/1
 Uh0avtJZHiQ5WlT/qPnlqsR3D3gGVl0z/9Q+lLhnk71V+ELkR0xXUzHte5LSlV/fcDcrMizI
 +M62n3uV3caKdeYlpWOwaGju1BsPlr5scwk4TKpMHIZrGdm/XLQGHpAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02RbUhTYRiGec97dnZcrU4z6NW+aFiWpmZWvFSUSD9OP6KMKMlqjXXSaF9s
 miVl2mzhpMyEoGlpoUunGU1nuWmIqVPDrLREw+zD+TFRGwVac1lLov7d93VfPH8eGorqyUD6
 lDKJ0yilcjElIGueiVeExdRekG1wOEPww/YWiC9d90Jc3p9DYU9HJ8T1E/k83NtQS+Cy8mYC
 2++6Cdw8O07hj9/6SHyj8S3AzjdGAtf3heK6+jYSd9kKKFxocvJxrqOKh58MZgBc4ymE+GtJ
 Jh9Xjk2SuLVvKe70OnjRS1jjQAfF1hr7+Wzn+0ck29WRzFrMWRRbVXyRtfemU+xV3cRv4fIA
 j518+oZir1WbAfvVsoK90pBNsJbBcWLfgsOC7Sc4+akznCZix3FB4qi7klTnbTlrsnVS6WBk
 rQH40YjZhMxDBp4BCGgRYwfIav9Mzg0ByORtgnPZH5X9HObPSToCeRzTwABommJC0fNZ2scX
 M0UE6nrvgr4CmRIC5Xf3Uz7Jn8GowqvwHSKZ1ahlaBb4spDZirL0XdCnICYC5QwsmsOLUNut
 QdKHIROMHt4R+TBkViKdNR9eBwuN/1nGf5bxP6sIQDMI4NRaRYJCG6mOVHIp4VqpQpusTAiX
 qRQW8OfDIeuegMfmL+GNgKBBI0A0FC8WXtx9XiYSnpCeS+U0KokmWc5pG8FSmhQvEb40tElE
 TII0iTvNcWpO83claL/AdGJ5bJrytTUtKapWlCUqfyVxf785n++/rVLc6rbqEgX0SOQtVWnc
 7qrqnqwYuKHF5Z7yHCvIHX6aZ9o+I961wG+/9lO2TebQl6iO6+7Pb2/esnPEIN04kOM6eCgq
 eLCwGIc1pVpwT+l+3iSbuOdzLO1cr1He0JcuBF7VdETsPOu05NLVJJfJaawLSQkSPh//Njam
 H4qD8jPx/PHRjOw7qa7eo9Hd2bagk9FrH+T3lO8dvtequFzmmnmw90DKu7z7o/MCfygagkMj
 RupWTRxZJv9Q0JIZo5fctsQXxwv9PK+Uw3Su+lBuja3ixafuqOo17cVhTec32wOmipoyZbrN
 YlKbKI0MgRqt9BedYdszUAMAAA==
X-CMS-MailID: 20221123061010epcas5p21cef9d23e4362b01f2b19d1117e1cdf5
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221123061010epcas5p21cef9d23e4362b01f2b19d1117e1cdf5
References: <CGME20221123061010epcas5p21cef9d23e4362b01f2b19d1117e1cdf5@epcas5p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Wed, 23 Nov 2022 08:25:56 +0000
Subject: [dm-devel] [PATCH v5 00/10] Implement copy offload support
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
Cc: p.raghav@samsung.com, joshi.k@samsung.com, gost.dev@samsung.com,
 anuj20.g@samsung.com, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Nitesh Shetty <nj.shetty@samsung.com>,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The patch series covers the points discussed in November 2021 virtual
call [LSF/MM/BFP TOPIC] Storage: Copy Offload [0].
We have covered the initial agreed requirements in this patchset and
further additional features suggested by community.
Patchset borrows Mikulas's token based approach for 2 bdev
implementation.

This is on top of our previous patchset v4[1].

Overall series supports:
========================
	1. Driver
		- NVMe Copy command (single NS, TP 4065), including support
		in nvme-target (for block and file backend).

	2. Block layer
		- Block-generic copy (REQ_COPY flag), with interface
		accommodating two block-devs, and multi-source/destination
		interface
		- Emulation, when offload is natively absent
		- dm-linear support (for cases not requiring split)

	3. User-interface
		- new ioctl
		- copy_file_range for zonefs

	4. In-kernel user
		- dm-kcopyd
		- copy_file_range in zonefs

Testing
=======
	Copy offload can be tested on:
	a. QEMU: NVME simple copy (TP 4065). By setting nvme-ns
		parameters mssrl,mcl, msrc. For more info [2].
	b. Fabrics loopback.
	c. zonefs copy_file_range

	Emuation can be tested on any device.

	Sample application to use IOCTL is present in patch desciption.
	fio[3].

Performance
===========
	With the async design of copy-emulation/offload using fio[3],
	we were  able to see the following improvements as
	compared to userspace read and write on a NVMeOF TCP setup:
	Setup1: Network Speed: 1000Mb/s
		Host PC: Intel(R) Core(TM) i7-8700 CPU @ 3.20GHz
		Target PC: AMD Ryzen 9 5900X 12-Core Processor
		block size 8k, range 1:
			635% improvement in IO BW (107 MiB/s to 787 MiB/s).
			Network utilisation drops from  97% to 14%.
		block-size 2M, range 16:
			2555% improvement in IO BW (100 MiB/s to 2655 MiB/s).
			Network utilisation drops from 89% to 0.62%.
	Setup2: Network Speed: 100Gb/s
		Server: Intel(R) Xeon(R) Gold 6240 CPU @ 2.60GHz, 72 cores
			(host and target have the same configuration)
		block-size 8k, range 1:
			6.5% improvement in IO BW (791 MiB/s to 843 MiB/s).
			Network utilisation drops from  6.75% to 0.14%.
		block-size 2M, range 16:
			15% improvement in IO BW (1027 MiB/s to 1183 MiB/s).
			Network utilisation drops from 8.42% to ~0%.
		block-size 8k, 8 ranges:
			18% drop in IO BW (from 798 MiB/s to 647 MiB/s)
			Network utilisation drops from 6.66% to 0.13%.

		At present we see drop in performance for bs 8k,16k and
		higher ranges (8, 16), so something more to check there.
	Overall, in these tests, kernel copy emulation performs better than
	userspace read+write. 

Zonefs copy_file_range
======================
	Sample tests for zonefs-tools[4]. Test 0118 and 0119 will test
	basic CFR. Will raise a PR, once this series is finalized.

Future Work
===========
	- nullblk: copy-offload emulation
	- generic copy file range (CFR):
		I did go through this, but couldn't find straight forward
		way to plug in copy offload for all the cases. We are doing
		detailed study, will address this future versions.
	- loopback device copy offload support
	- upstream fio to use copy offload

	These are to be taken up after we reach consensus on the
	plumbing of current elements that are part of this series.


Additional links:
=================
	[0] https://lore.kernel.org/linux-nvme/CA+1E3rJ7BZ7LjQXXTdX+-0Edz=zT14mmPGMiVCzUgB33C60tbQ@mail.gmail.com/
	[1] https://lore.kernel.org/lkml/20220426101241.30100-1-nj.shetty@samsung.com/
	[2] https://qemu-project.gitlab.io/qemu/system/devices/nvme.html#simple-copy
	[3] https://github.com/vincentkfu/fio/tree/copyoffload
	[4] https://github.com/nitesh-shetty/zonefs-tools/tree/cfr

Changes since v4:
=================
	- make the offload and emulation design asynchronous (Hannes
	  Reinecke)
	- fabrics loopback support
	- sysfs naming improvements (Damien Le Moal)
	- use kfree() instead of kvfree() in cio_await_completion
	  (Damien Le Moal)
	- use ranges instead of rlist to represent range_entry (Damien
	  Le Moal)
	- change argument ordering in blk_copy_offload suggested (Damien
	  Le Moal)
	- removed multiple copy limit and merged into only one limit
	  (Damien Le Moal)
	- wrap overly long lines (Damien Le Moal)
	- other naming improvements and cleanups (Damien Le Moal)
	- correctly format the code example in description (Damien Le
	  Moal)
	- mark blk_copy_offload as static (kernel test robot)
	
Changes since v3:
=================
	- added copy_file_range support for zonefs
	- added documentation about new sysfs entries
	- incorporated review comments on v3
	- minor fixes

Changes since v2:
=================
	- fixed possible race condition reported by Damien Le Moal
	- new sysfs controls as suggested by Damien Le Moal
	- fixed possible memory leak reported by Dan Carpenter, lkp
	- minor fixes

Nitesh Shetty (10):
  block: Introduce queue limits for copy-offload support
  block: Add copy offload support infrastructure
  block: add emulation for copy
  block: Introduce a new ioctl for copy
  nvme: add copy offload support
  nvmet: add copy command support for bdev and file ns
  dm: Add support for copy offload.
  dm: Enable copy offload for dm-linear target
  dm kcopyd: use copy offload support
  fs: add support for copy file range in zonefs

 Documentation/ABI/stable/sysfs-block |  36 ++
 block/blk-lib.c                      | 597 +++++++++++++++++++++++++++
 block/blk-map.c                      |   4 +-
 block/blk-settings.c                 |  24 ++
 block/blk-sysfs.c                    |  64 +++
 block/blk.h                          |   2 +
 block/ioctl.c                        |  36 ++
 drivers/md/dm-kcopyd.c               |  56 ++-
 drivers/md/dm-linear.c               |   1 +
 drivers/md/dm-table.c                |  42 ++
 drivers/md/dm.c                      |   7 +
 drivers/nvme/host/core.c             | 106 ++++-
 drivers/nvme/host/fc.c               |   5 +
 drivers/nvme/host/nvme.h             |   7 +
 drivers/nvme/host/pci.c              |  28 +-
 drivers/nvme/host/rdma.c             |   7 +
 drivers/nvme/host/tcp.c              |  16 +
 drivers/nvme/host/trace.c            |  19 +
 drivers/nvme/target/admin-cmd.c      |   9 +-
 drivers/nvme/target/io-cmd-bdev.c    |  79 ++++
 drivers/nvme/target/io-cmd-file.c    |  51 +++
 drivers/nvme/target/loop.c           |   6 +
 drivers/nvme/target/nvmet.h          |   2 +
 fs/zonefs/super.c                    | 179 ++++++++
 include/linux/blk_types.h            |  44 ++
 include/linux/blkdev.h               |  18 +
 include/linux/device-mapper.h        |   5 +
 include/linux/nvme.h                 |  43 +-
 include/uapi/linux/fs.h              |  27 ++
 29 files changed, 1502 insertions(+), 18 deletions(-)


base-commit: e4cd8d3ff7f9efeb97330e5e9b99eeb2a68f5cf9
-- 
2.35.1.500.gb896f729e2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

