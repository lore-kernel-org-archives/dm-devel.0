Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AAED26E
	for <dm-devel@lists.linux.dev>; Mon, 30 Oct 2023 08:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ea1R4fPa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698653883;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PdPtRHF28y+jheXa9F9xKtZI086xGDcJ24wwm0ofuvE=;
	b=ea1R4fPaJmA5BNGKh1pGhm5KxEKpNcPP6CoO5p2fE3z11TJRHDieJTcBTcAWQhcSnc8nVZ
	ZbirmfoJLIOiu2yozevgv1X4envUp4NmLDoonwTNRgbWc0fnuo0GbWtCECtaN9k3TxH3Mz
	WhRpgvM1aM/MGDONgdYrHDIJA34kRPc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-637-Jp8Ncmn8MPW-7po6Fke4-A-1; Mon,
 30 Oct 2023 04:18:02 -0400
X-MC-Unique: Jp8Ncmn8MPW-7po6Fke4-A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAD273811F27
	for <dm-devel@lists.linux.dev>; Mon, 30 Oct 2023 08:18:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E01DCC1596C
	for <dm-devel@lists.linux.dev>; Mon, 30 Oct 2023 08:18:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 893031946588
	for <dm-devel@lists.linux.dev>; Mon, 30 Oct 2023 08:18:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AC9A71946587
 for <dm-devel@listman.corp.redhat.com>; Sun, 29 Oct 2023 16:18:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6DA4C2026D66; Sun, 29 Oct 2023 16:18:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 64E562026D4C
 for <dm-devel@redhat.com>; Sun, 29 Oct 2023 16:18:38 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3519E29AA39B
 for <dm-devel@redhat.com>; Sun, 29 Oct 2023 16:18:38 +0000 (UTC)
Received: from EUR02-AM0-obe.outbound.protection.outlook.com
 (mail-am0eur02on2106.outbound.protection.outlook.com [40.107.247.106]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-oZkzHXE7Nv6J8LxutZaqRA-1; Sun, 29 Oct 2023 12:18:36 -0400
X-MC-Unique: oZkzHXE7Nv6J8LxutZaqRA-1
Received: from PAXPR04MB8781.eurprd04.prod.outlook.com (2603:10a6:102:20c::22)
 by PAXPR04MB8912.eurprd04.prod.outlook.com (2603:10a6:102:20f::22)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.14; Sun, 29 Oct
 2023 16:18:32 +0000
Received: from PAXPR04MB8781.eurprd04.prod.outlook.com
 ([fe80::de8:96a6:690e:746c]) by PAXPR04MB8781.eurprd04.prod.outlook.com
 ([fe80::de8:96a6:690e:746c%4]) with mapi id 15.20.6954.014; Sun, 29 Oct 2023
 16:18:32 +0000
From: Yarden Maymon <yarden.maymon@volumez.com>
To: dm-devel@redhat.com
Subject: [PATCH] dm-thin: Improve performance of O_SYNC IOs to mapped data
Date: Sun, 29 Oct 2023 18:17:56 +0200
Message-ID: <20231029161756.27025-1-yarden.maymon@volumez.com>
X-ClientProxiedBy: DO2P289CA0007.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:6::11) To PAXPR04MB8781.eurprd04.prod.outlook.com
 (2603:10a6:102:20c::22)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB8781:EE_|PAXPR04MB8912:EE_
X-MS-Office365-Filtering-Correlation-Id: ea2b7379-f7f9-4572-e352-08dbd89ab1c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: K7zm4zAjOQDfTJN3/tDvu/CnXQVh9Ho7EApgitlsJ1olDsEAbTgtDxLJmFgiyIdoh4IMD/LnCQ+bv8OsNBlx+ZFhYHIRsUKCX4aUKUwzhL0Tn6tZSfStWyvh0WstXnmSRPf97EG/tjrfIiKWUxWAliHKhK9ZDLXoVjTrYxs0JsFPA/6bf/b9KwtONd2VQPIOxLpWcWE3vGnGLn/mS3vRYlLISCq6EwCHk1yG0vpswmKS59yd5AsLPrWCRI7nHGsKWDQmyKdnHqes1y4zIsLJjPvXuos/uGLiDJPrX33rnR2Qg8WB5WcdtEppLN/58m8+Ur5LwySs4wQx0l3OI92AVMOwYJxU8E3C8h8keFHtE5AsMIQdfzZKGPs4MitZ42MiLJhKKPWGdnb9OQSJba0nyjrBnGmonVRz6bEW/OEsE8kMEEyl0zAOsF6vPszlNoHbEFfe8qA79d/z86ZKYDMkZlLeHdU/k9ys7YhoFG0JIcSuKCD0wKkii98NhDawD9g1ekQRQVoAXqQpCGEykPHynr4gOBAgz4APDv52Zsra3Yg=
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PAXPR04MB8781.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(396003)(346002)(366004)(39830400003)(376002)(136003)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(6506007)(52116002)(6666004)(6512007)(966005)(6486002)(478600001)(83380400001)(2616005)(1076003)(2906002)(5660300002)(66946007)(41300700001)(66476007)(66556008)(6916009)(316002)(8936002)(44832011)(8676002)(4326008)(86362001)(36756003)(38100700002);
 DIR:OUT; SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9RBaS0e2XG5UEodL0jPbOrn4uq/UAbX071y+2MlZKAHC3QUh1DNQDTxj/Zye?=
 =?us-ascii?Q?Dd2d1qSQbums7pCJRQXSxvmWMFw2fsxZax/6rH4My0Z3FGnUZVzWnyg3CaJz?=
 =?us-ascii?Q?1iJB5CaOfwsjn4/kEKbZofVMk6k5JY7FIp03EK8Z0bIvgePepdLVrz3mmDTH?=
 =?us-ascii?Q?tKcTGST12jECxC/Sez5RT++TEblDH+aPiqL92iGxQpL5EC6A7BTpN+gEHOU9?=
 =?us-ascii?Q?0a1EmhL1eCoquBQVmt6LiHjNg3GyGksolXeBCE6+sRaGwa2LBuGGEGYu4hWt?=
 =?us-ascii?Q?h8XTo4NSH01vLj6VYRvWmAlF0jXzJezm4c2XNr4tiije5gUwTpRB46L2qyTU?=
 =?us-ascii?Q?TziWkoQFJrPX7xecnP6FnoYTOyIEAX9cCfCuLxzAJqaIaNUydcykUgaP2517?=
 =?us-ascii?Q?ooezAcTTzaLaCIrBTfLFJiM9M2qRmDrI18kfkaFT37Um64y6H8QLoHaT50uT?=
 =?us-ascii?Q?sr9shNoHQbNaXe4BBCHjCaQOkoYk7LApiwRAMDQ9JD8uWE/iELZYuZ5edPyy?=
 =?us-ascii?Q?/O+bBxH7Mk1puhnodbUEtMW/6s9DHWYsgC1cncajFi176thDJUZ3W9KT312X?=
 =?us-ascii?Q?3rkLGZhsx2Y4/cY5AnZbIKNv9+nE49Td+HAQwz4loaU292OYOUJohtm9P0Kt?=
 =?us-ascii?Q?1YbP8+AEKv4qHJfX76DcGoaZEov1qCDl/HnDm3krJ4yLXHmgC1WmoiuR3xtF?=
 =?us-ascii?Q?QbBYaT9iiE+hf9BZ++k00gxF4R4+Q0QOU4gM9OF+daEJrC0hYfsh1YxYtwwd?=
 =?us-ascii?Q?9EMVmcubZsBoQSsq9dYhWvke1QKWcKCk+gvm5mnef9oiV4MctcfmR2IePAo5?=
 =?us-ascii?Q?AWZnMenycMiGjmO93W0xoNwpESfglwepIE77om2jjysGCVG5p3cPMP20AwBw?=
 =?us-ascii?Q?YnHEH7QI9sJJXOMO7fRXwp6VU+JqMWhCingvG+c5hQXFfDpIZmO1vBRQDdK7?=
 =?us-ascii?Q?dmfeQ3dm57AoTwb1vzb/4Zy7+YgOLZ9atSly6bLuOjE9GfJBsrdwiOEMGOXj?=
 =?us-ascii?Q?671NtWZltCARo3lOYEy2GGYdpop0+7KHMvDgACWMhtm3knOGJOnXOfiFU3Jx?=
 =?us-ascii?Q?KGpTyQSKlEhGWABeAe/SL1yyCAQ9j8U6AD4UmCkctw0/OSveOeh+2aWwaOD+?=
 =?us-ascii?Q?MutWWIs73fbEi2GNElngcnzOqaVAG5u1FLBWLHOz+WTAqqpnFCwxXB0yQQ76?=
 =?us-ascii?Q?Vg4BS4LeATi5ZScq1+ZhNEFjGNOnyNgjdISoGDfrpmXVkHj1fpSnMyp/hZWd?=
 =?us-ascii?Q?dpw9Ilhhble/Ks7MkSujdo0XzL8RgT30K+L6Z0tuMCK++Vnau4j7C3T5syat?=
 =?us-ascii?Q?/+Vv7EHZFI2ffw3CXB00oZLmlOylC0DB8Cf+38NU5nNfMAB31D8qjVILpri6?=
 =?us-ascii?Q?MRONRT+y9KN/n4ghjQA8nbn25hZNbf5rffr0BX896WmjzkjHbWhS3qYSLIcp?=
 =?us-ascii?Q?UYyuAV9o/hBzb3X+UeR7i7F/xjGckkut2Jx36lgFb387lsNdqfA8XaUhfdCL?=
 =?us-ascii?Q?OJyvFJ3MdRkwcpB2XGoFPcdbT+pqZHdiFf51oCBdDiOwHoNCEZizaZVAVhr4?=
 =?us-ascii?Q?SIU7C2aJsUmPb1HeMyl3EVeJDUtH65FMyp/ASAwy8nFFfgwsIbxoyrU/VFTv?=
 =?us-ascii?Q?79QtWqc14d5MlvI3mHRuObCGWCgaMapTjfUpBhWfot9734UevSLw77lu0lyG?=
 =?us-ascii?Q?THkGeQ=3D=3D?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea2b7379-f7f9-4572-e352-08dbd89ab1c0
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8781.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2023 16:18:32.4343 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2EjNb9TNyAmT61HiEu8zFNdeApiF1QHXeLrUx30mAwb3SEZaYmsKDsOEEIYfY6Hcy3fSpX7GmUae9AA//yCQ2KNX5S9hjKw896qBuZMBPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8912
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mailman-Approved-At: Mon, 30 Oct 2023 08:18:00 +0000
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
Cc: thornber@redhat.com, Yarden Maymon <yarden.maymon@volumez.com>,
 snitzer@kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: volumez.com
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain

Running random write fio benchmarks on dm-thin with mapped data
there is 50% degradation when using O_SYNC.
* dm-thin without O_SYNC - 438k iops
* dm-thin with O_SYNC on mapped data - 204k iops
* directly on the underlying disk with O_SYNC - 451k iops, showing the
  problem is not the disk.

The data is mapped so the same results are expected with O_SYNC.

Currently, all O_SYNC IOs are routed to a slower path (deferred).
This action is taken early in the procedure, prior to assessing other
ongoing IOs or verifying if the IO is already mapped.

Remove the early test, and move O_SYNC to the regular data path.
O_SYNC io to a mapped space, that does not conflict with other inflight
will be remapped and routed to the faster path.
All the other O_SYNC io's behavior is maintained (deferred).

The O_SYNC IO will be deferred if :

* It is not mapped - dm_thin_find_block will return -ENODATA, the cell
  is deferred.

* There is an inflight to the same virtual key - bio_detain will
  add the io to a cell and defer it.

    build_virtual_key(tc->td, block, &key);
    if (bio_detain(tc->pool, &key, bio, &virt_cell))
        return DM_MAPIO_SUBMITTED;

* There is an inflight to the same physical key - bio_detain will
  add the io to a cell and defer it.

    build_data_key(tc->td, result.block, &key);
    if (bio_detain(tc->pool, &key, bio, &data_cell)) {
        cell_defer_no_holder(tc, virt_cell);
        return DM_MAPIO_SUBMITTED;
    }

-----------------------------------------------------

Benchmark results :

The benchmark was done on top of ubuntu's 6.2.0-1008 with commit
450e8dee51aa ("dm bufio: improve concurrent IO performance") backported.

fio params: --bs=3D4k --direct=3D1 --iodepth=3D32 --numjobs=3D8m --time_bas=
ed
--runtime=3D5m.
dm-thin chunksize is 128k and allocation/thin_pool_zero=3D0 is set.
The results are in IOPs and represented as: avg_iops (max_iops).

Performance test on the underlying nvme device for baseline:
+-------------------+-----------------------+
| randwrite         | 446k (455k)           |
| randwrite sync    | 451k (455k)           |
| randrw 50/50      | 227k/227k (300k/300k) |
| randrw sync 50/50 | 227k/227k (300k/300k) |
| randread          | 773k (866k)           |
| randread sync     | 773k (861k)           |
+-------------------+-----------------------+

dm-thin blkdev with all data allocated (16GiB):
+-------------------+-----------------------+-----------------------+
|                   | Pre Patch             | Post Patch            |
+-------------------+-----------------------+-----------------------+
| randwrite         | 438k (442k)           | 450k (453k)           |
| randwrite sync    | 204k (228k)           | 450k (454k)           |
| randrw 50/50      | 224k/224k (236k/235k) | 225k/225k (234k/234k) |
| randrw sync 50/50 | 191k/191k (199k/197k) | 225k/225k (235k/235k) |
| randread          | 650k (703k)           | 661k (705k)           |
| randread sync     | 659k (705k)           | 661k (707k)           |
+-------------------+-----------------------+-----------------------+
There's a notable enhancement in random write performance with sync
compared to previous results. In the 50/50 sync test, there's also a
boost in random read due to the availability of extra resources for
reading. Furthermore, no other aspects appear to be impacted.

dm-thin blkdev without allocated data with capacity of 1.6TB (to
increase the random chance of hitting a non allocated block):
+-------------------+-------------------------+------------------------+
|                   | Pre Patch               | Post Patch             |
+-------------------+-------------------------+------------------------+
| randwrite         | 116k (253k)             | 112k (240k)            |
| randwrite sync    | 100k (121k)             | 182k (266k)            |
| randrw 50/50      | 66.7k/66.7k (109k/109k) | 67k/67k (109k/109k)    |
| randrw sync 50/50 | 76.9k/76.8k (101k/101k) | 77.6k/77.6k (122k/122k)|
| randread          | 336k (349k)             | 335k (352k)            |
| randread sync     | 334k (351k)             | 336k (348k)            |
+-------------------+-------------------------+------------------------+
In this case, there isn't a marked difference, with the exception of
random write sync, since the unmapped data path has stayed the same. The
boost in random write sync performance can be explained from random IOs
hitting the same space twice within the test (The second time they are
already mapped).

-----------------------------------------------------

Tests:
I have ran thin tests of https://github.com/jthornber/dmtest-python.
I have ran xfstests on top of thin lvm https://github.com/kdave/xfstests

I conducted a manual data integrity test :
* Constructed a layout with nvme target -> dm-thin -> nvme device.
* Using vdbench from an initiator host writing to this remote nvme
  device, using journal to a local drive.
* Initiated a reboot on the media host.
* Verified the data using vdbench once the reboot process finished.

Signed-off-by: Yarden Maymon <yarden.maymon@volumez.com>
---
 drivers/md/dm-thin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 07c7f9795b10..ecd429260bee 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2743,7 +2743,7 @@ static int thin_bio_map(struct dm_target *ti, struct =
bio *bio)
 =09=09return DM_MAPIO_SUBMITTED;
 =09}
=20
-=09if (op_is_flush(bio->bi_opf) || bio_op(bio) =3D=3D REQ_OP_DISCARD) {
+=09if (bio_op(bio) =3D=3D REQ_OP_DISCARD) {
 =09=09thin_defer_bio_with_throttle(tc, bio);
 =09=09return DM_MAPIO_SUBMITTED;
 =09}
--=20
2.25.1

