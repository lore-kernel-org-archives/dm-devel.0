Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E81C2C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 08:48:31 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-3eW3dxLAMYKE8zuDNDmzCg-1; Mon, 14 Feb 2022 03:48:27 -0500
X-MC-Unique: 3eW3dxLAMYKE8zuDNDmzCg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F5BD189DF59;
	Mon, 14 Feb 2022 08:48:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 836D24F86F;
	Mon, 14 Feb 2022 08:48:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3193B1806D2C;
	Mon, 14 Feb 2022 08:48:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21E8aI5f009266 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 03:36:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 817E840E80EA; Mon, 14 Feb 2022 08:36:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CB1B40E80E8
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:36:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 605608011AF
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 08:36:18 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-586-XvJDzsFvNGa6mm7YPG2AkQ-1; Mon, 14 Feb 2022 03:36:14 -0500
X-MC-Unique: XvJDzsFvNGa6mm7YPG2AkQ-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id
	20220214083609epoutp01607522428af862a444d322516ac30c74~TmiRjM7mR1004510045epoutp01e;
	Mon, 14 Feb 2022 08:36:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
	20220214083609epoutp01607522428af862a444d322516ac30c74~TmiRjM7mR1004510045epoutp01e
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20220214083609epcas5p3b54754d3fa83cb27a2fceddb96a6586b~TmiRK3TtR2552125521epcas5p3b;
	Mon, 14 Feb 2022 08:36:09 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4JxyH74RDkz4x9Pr;
	Mon, 14 Feb 2022 08:36:03 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6C.07.06423.3741A026; Mon, 14 Feb 2022 17:36:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20220214080649epcas5p36ab21e7d33b99eac1963e637389c8be4~TmIp4Xabc2239022390epcas5p3K;
	Mon, 14 Feb 2022 08:06:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20220214080649epsmtrp1d094b9eacc8993b8a46c37c4150afd95~TmIp3i47q0046200462epsmtrp1V;
	Mon, 14 Feb 2022 08:06:49 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-91-620a14730caf
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	16.F1.29871.99D0A026; Mon, 14 Feb 2022 17:06:49 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
	[107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20220214080644epsmtip251c38a47e899471516f26528f3ac9dc3~TmIk8FVhf2207122071epsmtip2c;
	Mon, 14 Feb 2022 08:06:43 +0000 (GMT)
From: Nitesh Shetty <nj.shetty@samsung.com>
To: 
Date: Mon, 14 Feb 2022 13:29:58 +0530
Message-Id: <20220214080002.18381-9-nj.shetty@samsung.com>
In-Reply-To: <20220214080002.18381-1-nj.shetty@samsung.com>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta1ATVxidu7vZJHRCl4f0Sm2NsbYCAomG9GJVHMV2UTtDdZzWjiOusCZI
	SNIktNY6UyCVEeShSB2IbY3UMfIoKBVKkVDEoTyCqEOhkhERgVLFBjVVQ0Vo4krrv3POPd/5
	7vfduQLcv40fLEjWGFm9hlFLSB+i7mJIaLgh0Gen1JY9H1V3/oqjxn4XD1UMFJDo6L1JHE1c
	GOahwoJiPuoZ8UU25zEeuuLOwNBwzQyGGksLMVRW0YqhMev3AJ0/cR9D2fYrGJoakqHWmb9I
	VNjSB9BorxlDNkcYarR1EKin4RsSHT81ykcHf68nUdO4DUfWtmkMdZunSFQ/kgFQ3ZPjOLp4
	o5dAVeMTBMo6+xCg/bmTfHT5aRtvtYTu+W0DbR68RNKHTU4+/bN5gE9fvnGWoE2W6wTdcymN
	rinPJukfT35JH7lmBfT5/nSSzuxqxeniB3+TdJ7JSdL3Rx0EPdHUS8YHfZyyQsUySaxezGoS
	tUnJGuVKyYbNCWsTohRSWbgsGr0tEWuYVHalJHZjfPi7yWrP/iTiTxl1mkeKZwwGSeSqFXpt
	mpEVq7QG40oJq0tS6+S6CAOTakjTKCM0rHG5TCpdGuUx7khRNV0b4ukevLrHVZZBpIOxoBwg
	EEBKDo8NEDnAR+BPnQcw86dTgCMPAHSUnvMQoYc8ArA4N3K2wPXUyHlsAFp7b/E4sh+Dednd
	pNdEUmHQPiPw1gZSBCx7/PhZB5xykbC98gnmPQig3oHO6juE109Qi+Af5VqvLKKWQ1NTEe7F
	kFoITwxd4Hmx0GNvHrfinMcPdpSMEF6MU/OhqfYY7s2H1LQQHnF0E9xFY+FkJcHlBMA7bef4
	HA6Gtwuy+Jz/IIDurkGMI8UAmg6ZSM4VA682PsW8QTgVAqsbIjn5Nfh1ZxXGNfaFeU9GME4X
	wfrvZvFCWFlteR4zF/Y9zniOadj81STOLSsfwB9KMolDQGx+YSDzCwOZ/29tAXg5mMvqDKlK
	1hClk2nYz/5740Rtag149qNC4+rBwM17ES0AE4AWAAW4JFC0/ZJwp78oifl8L6vXJujT1Kyh
	BUR5Fn4YD56TqPV8SY0xQSaPlsoVCoU8eplCJnlFZFeeYfwpJWNkU1hWx+pn6zCBMDgdW+to
	zpJ1Fq0+vH5ZsDtuzTQbNHjqtL7z5CP3J31BbW+NYXH7lrZ3zyv1+faotMjSV97uJ+n9U3y9
	LmiXrWuvcrf0F0Un69ix2Y0zqtQDxemu2G3vrftn1/CcdnZCUVK2u/n9rs6N6tDpmDOblNqA
	mhz7R84l64edJcKKkObX5dYiWnpNs+LNxVlTi0Sj87etCdz30pb8rdKYD4uGQsX49JBc+MaC
	kCPT9ti7eduzAzT2qwfm7Mm/W87zRf2Bp80uyzljfm5cjmWRv+lh1p6qDxi/RzM9DfC+uKz2
	9rwvUu5W+XYsdodsWmKNKKwL24XJo+/cutm0KmnHy1u3dKiWmy2166okhEHFyEJxvYH5F+aG
	uCvaBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsWy7bCSvO5MXq4kg5/X+S3WnzrGbLHn5mdW
	i9V3+9kspn34yWzx/uBjVotJ/TPYLS4/4bPY+242q8WFH41MFo83/Wey2LNoEpPFytVHmSye
	L1/MaLF74Ucmi87TF5gs/jw0tDj6/y2bxaRD1xgtnl6dxWSx95a2xZ69J1ksLu+aw2Yxf9lT
	dovu6zvYLPa93stssfz4PyaLc7P+sFnseNLIaLHt93xmi8P3rrJYrHv9nsWibeNXRovWnp/s
	Fuf/Hmd1UPK4fMXbY9b9s2weE5vfsXvsnHWX3eP8vY0sHs0L7rB4XD5b6rFpVSebx+Yl9R6T
	byxn9Nh9s4HNo+nMUWaPGZ++sHn0Nr9j8/j49BaLx/t9V9kCxKK4bFJSczLLUov07RK4Mvbd
	eMha8Em64vPKRpYGxudiXYwcHBICJhKf/5Z0MXJxCAnsZpRofDOPsYuREyguKbHs7xFmCFtY
	YuW/5+wQRc1MEm1vfrCDNLMJaEuc/s8BUiMiwCKx8vt3FpAaZoG57BJnXp9hB0kIC1hLvFv/
	igWknkVAVeLZqnyQMK+AlUTzvilQ85UlFj48yApicwKVH3i9HCwuBFQz4+ohdoh6QYmTM5+w
	gNjMAvISzVtnM09gFJiFJDULSWoBI9MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzg
	JKKluYNx+6oPeocYmTgYDzFKcDArifDGneVMEuJNSaysSi3Kjy8qzUktPsQozcGiJM57oetk
	vJBAemJJanZqakFqEUyWiYNTqoHJp07ar2qOwYSmHZ2P/+kWr1vJmFfjNyvrz/FOfaHGl/u+
	/U5Y7LVyc/iX6HmL9TLSoqqqliarvVKWb8k8U8V96MmpHp0QIaOFjPV7fvc1rfx3bXM/4z/7
	J4fj5aw1XlafuzM5pXLOlsp5ndzyMi+CP59JyjbOXta6/IfN1XXJi8LMdjXdX7I4OMU5/dHm
	A3uCJRmnMR15VvNqRnPl9P9xdu9sPEtKGw/vTFu+8/VRW6lDoa7Mb+Tn3Tr05OfbSJ5SEY6u
	SfU+hgtmXH7E5u8uVyhuPMG9c+eFW49MnvdO2bmLnVl9WmuKzOddFbOL+l9uXrXq7sX20k67
	4md/3ToYDi99JG75dXpkQ/jHGLPjSizFGYmGWsxFxYkAtXupRZEDAAA=
X-CMS-MailID: 20220214080649epcas5p36ab21e7d33b99eac1963e637389c8be4
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220214080649epcas5p36ab21e7d33b99eac1963e637389c8be4
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080649epcas5p36ab21e7d33b99eac1963e637389c8be4@epcas5p3.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21E8aI5f009266
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 14 Feb 2022 03:47:51 -0500
Cc: Nitesh, Snitzer <snitzer@redhat.com>, djwong@kernel.org, Mike,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
	javier@javigon.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
	James Smart <james.smart@broadcom.com>, hch@lst.de, Alexander,
	Shetty <nj.shetty@samsung.com>, chaitanyak@nvidia.com,
	Chaitanya Kulkarni <kch@nvidia.com>, msnitzer@redhat.com,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	dsterba@suse.com, kbusch@kernel.org, Frederick.Knight@netapp.com,
	Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, Viro <viro@zeniv.linux.org.uk>
Subject: [dm-devel] [PATCH v3 08/10] dm: Add support for copy offload.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Before enabling copy for dm target, check if underlying devices and
dm target support copy. Avoid split happening inside dm target.
Fail early if the request needs split, currently splitting copy
request is not supported.

Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
---
 drivers/md/dm-table.c         | 45 +++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |  6 +++++
 include/linux/device-mapper.h |  5 ++++
 3 files changed, 56 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e43096cfe9e2..8dc9ae6a6a86 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1903,6 +1903,38 @@ static bool dm_table_supports_nowait(struct dm_table *t)
 	return true;
 }
 
+static int device_not_copy_capable(struct dm_target *ti, struct dm_dev *dev,
+				      sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return !blk_queue_copy(q);
+}
+
+static bool dm_table_supports_copy(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned int i;
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (!ti->copy_supported)
+			return false;
+
+		/*
+		 * target provides copy support (as implied by setting
+		 * 'copy_supported') and it relies on _all_ data devices having copy support.
+		 */
+		if (ti->copy_supported &&
+		    (!ti->type->iterate_devices ||
+		     ti->type->iterate_devices(ti, device_not_copy_capable, NULL)))
+			return false;
+	}
+
+	return true;
+}
+
 static int device_not_discard_capable(struct dm_target *ti, struct dm_dev *dev,
 				      sector_t start, sector_t len, void *data)
 {
@@ -2000,6 +2032,19 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	} else
 		blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
 
+	if (!dm_table_supports_copy(t)) {
+		blk_queue_flag_clear(QUEUE_FLAG_COPY, q);
+		/* Must also clear discard limits... */
+		q->limits.max_copy_sectors = 0;
+		q->limits.max_hw_copy_sectors = 0;
+		q->limits.max_copy_range_sectors = 0;
+		q->limits.max_hw_copy_range_sectors = 0;
+		q->limits.max_copy_nr_ranges = 0;
+		q->limits.max_hw_copy_nr_ranges = 0;
+	} else {
+		blk_queue_flag_set(QUEUE_FLAG_COPY, q);
+	}
+
 	if (dm_table_supports_secure_erase(t))
 		blk_queue_flag_set(QUEUE_FLAG_SECERASE, q);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ab9cc91931f9..3b4cd49c489d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1372,6 +1372,12 @@ static int __split_and_process_non_flush(struct clone_info *ci)
 	if (__process_abnormal_io(ci, ti, &r))
 		return r;
 
+	if ((unlikely(op_is_copy(ci->bio->bi_opf)) &&
+				max_io_len(ti, ci->sector) < ci->sector_count)) {
+		DMERR("%s: Error IO size(%u) is greater than maximum target size(%llu)\n",
+				__func__, ci->sector_count, max_io_len(ti, ci->sector));
+		return -EIO;
+	}
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
 
 	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index b26fecf6c8e8..acfd4018125a 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -362,6 +362,11 @@ struct dm_target {
 	 * zone append operations using regular writes.
 	 */
 	bool emulate_zone_append:1;
+
+	/*
+	 * copy offload is supported
+	 */
+	bool copy_supported:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);
-- 
2.30.0-rc0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

