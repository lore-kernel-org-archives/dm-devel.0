Return-Path: <SRS0=awJs=ET=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB8DC388F7
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 12:09:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 51E652078B
	for <dm-devel@archiver.kernel.org>; Fri, 13 Nov 2020 12:09:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51E652078B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-WDfS3k-gN9CZanYsagRLCQ-1; Fri, 13 Nov 2020 07:09:46 -0500
X-MC-Unique: WDfS3k-gN9CZanYsagRLCQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20C6F80476E;
	Fri, 13 Nov 2020 12:09:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC2395D9E8;
	Fri, 13 Nov 2020 12:09:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DD5CE58103;
	Fri, 13 Nov 2020 12:09:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ADC9ZXL027887 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 13 Nov 2020 07:09:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0395D115D348; Fri, 13 Nov 2020 12:09:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F3ACD115D347
	for <dm-devel@redhat.com>; Fri, 13 Nov 2020 12:09:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9232185A790
	for <dm-devel@redhat.com>; Fri, 13 Nov 2020 12:09:32 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-47-wdK7_4VpNI2s47OK9yxvXA-1; Fri, 13 Nov 2020 07:09:30 -0500
X-MC-Unique: wdK7_4VpNI2s47OK9yxvXA-1
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	0ADC01Ek001536
	for <dm-devel@redhat.com>; Fri, 13 Nov 2020 12:09:29 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by aserp2130.oracle.com with ESMTP id 34nh3babr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL)
	for <dm-devel@redhat.com>; Fri, 13 Nov 2020 12:09:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	0ADC5ELi142787
	for <dm-devel@redhat.com>; Fri, 13 Nov 2020 12:09:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by userp3020.oracle.com with ESMTP id 34rt57s4p3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <dm-devel@redhat.com>; Fri, 13 Nov 2020 12:09:28 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ADC9Rug021827
	for <dm-devel@redhat.com>; Fri, 13 Nov 2020 12:09:27 GMT
Received: from mwanda (/10.175.206.108)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Fri, 13 Nov 2020 04:09:27 -0800
Date: Fri, 13 Nov 2020 15:09:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: michael.christie@oracle.com
Message-ID: <20201113120921.GA270193@mwanda>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
	bulkscore=0 mlxscore=0
	mlxlogscore=999 suspectscore=10 adultscore=0 phishscore=0
	malwarescore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011130076
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
	lowpriorityscore=0 priorityscore=1501
	clxscore=1011 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=10
	mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2011130075
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [bug report] dm mpath: add IO affinity path selector
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello Mike Christie,

The patch c3d0a31e609e: "dm mpath: add IO affinity path selector"
from Oct 22, 2020, leads to the following static checker warning:

	drivers/md/dm-ps-io-affinity.c:56 ioa_add_path()
	error: uninitialized symbol 'cpu'.

drivers/md/dm-ps-io-affinity.c
    43  static int ioa_add_path(struct path_selector *ps, struct dm_path *path,
    44                          int argc, char **argv, char **error)
    45  {
    46          struct selector *s = ps->context;
    47          struct path_info *pi = NULL;
    48          unsigned int cpu;
                ^^^^^^^^^^^^^^^^

    49          int ret;
    50  
    51          if (argc != 1) {
    52                  *error = "io-affinity ps: invalid number of arguments";
    53                  return -EINVAL;
    54          }
    55  
    56          pi = kzalloc_node(sizeof(*pi), GFP_KERNEL, cpu_to_node(cpu));
                                                                       ^^^
Unintialized

    57          if (!pi) {
    58                  *error = "io-affinity ps: Error allocating path context";
    59                  return -ENOMEM;
    60          }
    61  
    62          pi->path = path;
    63          path->pscontext = pi;
    64          refcount_set(&pi->refcount, 1);
    65  
    66          if (!zalloc_cpumask_var(&pi->cpumask, GFP_KERNEL)) {
    67                  *error = "io-affinity ps: Error allocating cpumask context";
    68                  ret = -ENOMEM;
    69                  goto free_pi;
    70          }
    71  
    72          ret = cpumask_parse(argv[0], pi->cpumask);
    73          if (ret) {
    74                  *error = "io-affinity ps: invalid cpumask";
    75                  ret = -EINVAL;
    76                  goto free_mask;
    77          }
    78  
    79          for_each_cpu(cpu, pi->cpumask) {
    80                  if (cpu >= nr_cpu_ids) {
    81                          DMWARN_LIMIT("Ignoring mapping for CPU %u. Max CPU is %u\n",
    82                                       cpu, nr_cpu_ids);
    83                          break;
    84                  }
    85  
    86                  if (s->path_map[cpu]) {
    87                          DMWARN("CPU mapping for %u exists. Ignoring.", cpu);
    88                          continue;
    89                  }
    90  
    91                  cpumask_set_cpu(cpu, s->path_mask);
    92                  s->path_map[cpu] = pi;
    93                  refcount_inc(&pi->refcount);
    94                  continue;
    95          }
    96  
    97          if (refcount_dec_and_test(&pi->refcount)) {
    98                  *error = "io-affinity ps: No new/valid CPU mapping found";
    99                  ret = -EINVAL;
   100                  goto free_mask;
   101          }
   102  
   103          return 0;
   104  
   105  free_mask:
   106          free_cpumask_var(pi->cpumask);
   107  free_pi:
   108          kfree(pi);
   109          return ret;

regards,
dan carpenter

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

