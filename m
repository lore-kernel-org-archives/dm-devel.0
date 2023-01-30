Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86033C38142
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 07:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675151260;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GTwRG2ds2J6X+JCV4IYDe9SC77Fyxlo/r4CphKZL0Oo=;
	b=M9bzQXqcml4+PCMiMWRi14HC/HA+qdiCiq2uXfLGmEWaCqWUibjNZDc6DKNvhaW9Jzp3oq
	jkZUxm2WLKJdb58yV7RJ2vQKjNEjvB7YMewKHWEJVK8yw7NwMQRhNyRPND1LhKWr9AYMLF
	7+GLdfZ3UcrYoDtnrDO0mtMKKSk6lo8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-1bcN7E1VPdem54y0gy0bjg-1; Tue, 31 Jan 2023 02:47:37 -0500
X-MC-Unique: 1bcN7E1VPdem54y0gy0bjg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A22633C10222;
	Tue, 31 Jan 2023 07:47:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8A95340C141B;
	Tue, 31 Jan 2023 07:47:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 76E141946589;
	Tue, 31 Jan 2023 07:47:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 66FCB1946587
 for <dm-devel@listman.corp.redhat.com>; Mon, 30 Jan 2023 09:51:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 56D39C15BAE; Mon, 30 Jan 2023 09:51:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E768C15BAD
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 09:51:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 282A529AB406
 for <dm-devel@redhat.com>; Mon, 30 Jan 2023 09:51:59 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com
 [205.220.180.131]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-362-aL4Z6IOsMFexiVdhA0tw4Q-1; Mon, 30 Jan 2023 04:51:57 -0500
X-MC-Unique: aL4Z6IOsMFexiVdhA0tw4Q-1
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
 by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id
 30U7J079005362; Mon, 30 Jan 2023 09:35:30 GMT
Received: from nasanppmta05.qualcomm.com (i-global254.qualcomm.com
 [199.106.103.254])
 by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ncs2x3qm2-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 30 Jan 2023 09:35:29 +0000
Received: from nasanex01c.na.qualcomm.com (nasanex01c.na.qualcomm.com
 [10.45.79.139])
 by NASANPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 30U9ZSo9010215
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Mon, 30 Jan 2023 09:35:28 GMT
Received: from [10.216.24.235] (10.80.80.8) by nasanex01c.na.qualcomm.com
 (10.45.79.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 01:35:23 -0800
Message-ID: <85c11895-6036-c34b-1134-9103c45fcce3@quicinc.com>
Date: Mon, 30 Jan 2023 15:05:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
To: Randy Dunlap <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>
References: <20230129231053.20863-1-rdunlap@infradead.org>
 <20230129231053.20863-2-rdunlap@infradead.org>
From: Mukesh Ojha <quic_mojha@quicinc.com>
In-Reply-To: <20230129231053.20863-2-rdunlap@infradead.org>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01c.na.qualcomm.com (10.45.79.139)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800
 signatures=585085
X-Proofpoint-ORIG-GUID: mAQ3E3_x1c5yzC8DeBrzCM_Tjes2TWZS
X-Proofpoint-GUID: mAQ3E3_x1c5yzC8DeBrzCM_Tjes2TWZS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-30_07,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 bulkscore=0 clxscore=1011 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301300090
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Tue, 31 Jan 2023 07:47:17 +0000
Subject: Re: [dm-devel] [PATCH 1/9] Documentation: admin-guide: correct
 spelling
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
Cc: linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Mike Snitzer <snitzer@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com,
 Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
 Mauro Carvalho Chehab <mchehab@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 linux-media@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 1/30/2023 4:40 AM, Randy Dunlap wrote:
> Correct spelling problems for Documentation/admin-guide/ as reported
> by codespell.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Zefan Li <lizefan.x@bytedance.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: cgroups@vger.kernel.org
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: dm-devel@redhat.com
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>   Documentation/admin-guide/bcache.rst                       |    2 +-
>   Documentation/admin-guide/cgroup-v1/blkio-controller.rst   |    2 +-
>   Documentation/admin-guide/cgroup-v2.rst                    |   10 +++++-----
>   Documentation/admin-guide/cifs/usage.rst                   |    4 ++--
>   Documentation/admin-guide/device-mapper/cache-policies.rst |    2 +-
>   Documentation/admin-guide/device-mapper/dm-ebs.rst         |    2 +-
>   Documentation/admin-guide/device-mapper/dm-zoned.rst       |    2 +-
>   Documentation/admin-guide/device-mapper/unstriped.rst      |   10 +++++-----
>   Documentation/admin-guide/dynamic-debug-howto.rst          |    2 +-
>   Documentation/admin-guide/gpio/gpio-sim.rst                |    2 +-
>   Documentation/admin-guide/hw-vuln/mds.rst                  |    4 ++--
>   Documentation/admin-guide/kernel-parameters.txt            |    8 ++++----
>   Documentation/admin-guide/laptops/thinkpad-acpi.rst        |    2 +-
>   Documentation/admin-guide/md.rst                           |    2 +-
>   Documentation/admin-guide/media/bttv.rst                   |    2 +-
>   Documentation/admin-guide/media/building.rst               |    2 +-
>   Documentation/admin-guide/media/si476x.rst                 |    2 +-
>   Documentation/admin-guide/media/vivid.rst                  |    2 +-
>   Documentation/admin-guide/mm/hugetlbpage.rst               |    2 +-
>   Documentation/admin-guide/mm/numa_memory_policy.rst        |    4 ++--
>   Documentation/admin-guide/perf/hns3-pmu.rst                |    2 +-
>   Documentation/admin-guide/pm/amd-pstate.rst                |    2 +-
>   Documentation/admin-guide/spkguide.txt                     |    4 ++--
>   Documentation/admin-guide/sysctl/vm.rst                    |    4 ++--
>   Documentation/admin-guide/sysrq.rst                        |    2 +-
>   25 files changed, 41 insertions(+), 41 deletions(-)
> 
> diff -- a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -624,7 +624,7 @@ and is an example of this type.
>   Limits
>   ------
>   
> -A child can only consume upto the configured amount of the resource.
> +A child can only consume up to the configured amount of the resource.
>   Limits can be over-committed - the sum of the limits of children can
>   exceed the amount of resource available to the parent.
>   
> @@ -642,11 +642,11 @@ on an IO device and is an example of thi
>   Protections
>   -----------
>   
> -A cgroup is protected upto the configured amount of the resource
> +A cgroup is protected up to the configured amount of the resource
>   as long as the usages of all its ancestors are under their
>   protected levels.  Protections can be hard guarantees or best effort
>   soft boundaries.  Protections can also be over-committed in which case
> -only upto the amount available to the parent is protected among
> +only up to the amount available to the parent is protected among
>   children.
>   
>   Protections are in the range [0, max] and defaults to 0, which is
> @@ -1079,7 +1079,7 @@ All time durations are in microseconds.
>   
>   	  $MAX $PERIOD
>   
> -	which indicates that the group may consume upto $MAX in each
> +	which indicates that the group may consume up to $MAX in each
>   	$PERIOD duration.  "max" for $MAX indicates no limit.  If only
>   	one number is written, $MAX is updated.
>   
> @@ -2289,7 +2289,7 @@ Cpuset Interface Files
>   	For a valid partition root with the sibling cpu exclusivity
>   	rule enabled, changes made to "cpuset.cpus" that violate the
>   	exclusivity rule will invalidate the partition as well as its
> -	sibiling partitions with conflicting cpuset.cpus values. So
> +	sibling partitions with conflicting cpuset.cpus values. So
>   	care must be taking in changing "cpuset.cpus".
>   
>   	A valid non-root parent partition may distribute out all its CPUs
> diff -- a/Documentation/admin-guide/laptops/thinkpad-acpi.rst b/Documentation/admin-guide/laptops/thinkpad-acpi.rst
> --- a/Documentation/admin-guide/laptops/thinkpad-acpi.rst
> +++ b/Documentation/admin-guide/laptops/thinkpad-acpi.rst
> @@ -1488,7 +1488,7 @@ Example of command to set keyboard langu
>   Text corresponding to keyboard layout to be set in sysfs are: be(Belgian),
>   cz(Czech), da(Danish), de(German), en(English), es(Spain), et(Estonian),
>   fr(French), fr-ch(French(Switzerland)), hu(Hungarian), it(Italy), jp (Japan),
> -nl(Dutch), nn(Norway), pl(Polish), pt(portugese), sl(Slovenian), sv(Sweden),
> +nl(Dutch), nn(Norway), pl(Polish), pt(portuguese), sl(Slovenian), sv(Sweden),
>   tr(Turkey)
>   
>   WWAN Antenna type
> diff -- a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
> --- a/Documentation/admin-guide/md.rst
> +++ b/Documentation/admin-guide/md.rst
> @@ -317,7 +317,7 @@ All md devices contain:
>        suspended (not supported yet)
>            All IO requests will block. The array can be reconfigured.
>   
> -         Writing this, if accepted, will block until array is quiessent
> +         Writing this, if accepted, will block until array is quiescent
>   
>        readonly
>            no resync can happen.  no superblocks get written.
> diff -- a/Documentation/admin-guide/cgroup-v1/blkio-controller.rst b/Documentation/admin-guide/cgroup-v1/blkio-controller.rst
> --- a/Documentation/admin-guide/cgroup-v1/blkio-controller.rst
> +++ b/Documentation/admin-guide/cgroup-v1/blkio-controller.rst
> @@ -106,7 +106,7 @@ Proportional weight policy files
>             see Documentation/block/bfq-iosched.rst.
>   
>     blkio.bfq.weight_device
> -          Specifes per cgroup per device weights, overriding the default group
> +          Specifies per cgroup per device weights, overriding the default group
>             weight. For more details, see Documentation/block/bfq-iosched.rst.
>   
>   	  Following is the format::
> diff -- a/Documentation/admin-guide/pm/amd-pstate.rst b/Documentation/admin-guide/pm/amd-pstate.rst
> --- a/Documentation/admin-guide/pm/amd-pstate.rst
> +++ b/Documentation/admin-guide/pm/amd-pstate.rst
> @@ -403,7 +403,7 @@ Unit Tests for amd-pstate
>   
>    * We can introduce more functional or performance tests to align the result together, it will benefit power and performance scale optimization.
>   
> -1. Test case decriptions
> +1. Test case descriptions
>   
>       1). Basic tests
>   
> diff -- a/Documentation/admin-guide/spkguide.txt b/Documentation/admin-guide/spkguide.txt
> --- a/Documentation/admin-guide/spkguide.txt
> +++ b/Documentation/admin-guide/spkguide.txt
> @@ -1105,8 +1105,8 @@ speakup load
>   Alternatively, you can add the above line to your file
>   ~/.bashrc or ~/.bash_profile.
>   
> -If your system administrator ran himself the script, all the users will be able
> -to change from English to the language choosed by root and do directly
> +If your system administrator himself ran the script, all the users will be able
> +to change from English to the language chosen by root and do directly
>   speakupconf load (or add this to the ~/.bashrc or
>   ~/.bash_profile file). If there are several languages to handle, the
>   administrator (or every user) will have to run the first steps until speakupconf
> diff -- a/Documentation/admin-guide/device-mapper/cache-policies.rst b/Documentation/admin-guide/device-mapper/cache-policies.rst
> --- a/Documentation/admin-guide/device-mapper/cache-policies.rst
> +++ b/Documentation/admin-guide/device-mapper/cache-policies.rst
> @@ -70,7 +70,7 @@ the entries (each hotspot block covers a
>   cache block).
>   
>   All this means smq uses ~25bytes per cache block.  Still a lot of
> -memory, but a substantial improvement nontheless.
> +memory, but a substantial improvement nonetheless.
>   
>   Level balancing
>   ^^^^^^^^^^^^^^^
> diff -- a/Documentation/admin-guide/device-mapper/dm-ebs.rst b/Documentation/admin-guide/device-mapper/dm-ebs.rst
> --- a/Documentation/admin-guide/device-mapper/dm-ebs.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-ebs.rst
> @@ -31,7 +31,7 @@ Mandatory parameters:
>   
>   Optional parameter:
>   
> -    <underyling sectors>:
> +    <underlying sectors>:
>           Number of sectors defining the logical block size of <dev path>.
>           2^N supported, e.g. 8 = emulate 8 sectors of 512 bytes = 4KiB.
>           If not provided, the logical block size of <dev path> will be used.
> diff -- a/Documentation/admin-guide/device-mapper/dm-zoned.rst b/Documentation/admin-guide/device-mapper/dm-zoned.rst
> --- a/Documentation/admin-guide/device-mapper/dm-zoned.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-zoned.rst
> @@ -46,7 +46,7 @@ just like conventional zones.
>   The zones of the device(s) are separated into 2 types:
>   
>   1) Metadata zones: these are conventional zones used to store metadata.
> -Metadata zones are not reported as useable capacity to the user.
> +Metadata zones are not reported as usable capacity to the user.
>   
>   2) Data zones: all remaining zones, the vast majority of which will be
>   sequential zones used exclusively to store user data. The conventional
> diff -- a/Documentation/admin-guide/device-mapper/unstriped.rst b/Documentation/admin-guide/device-mapper/unstriped.rst
> --- a/Documentation/admin-guide/device-mapper/unstriped.rst
> +++ b/Documentation/admin-guide/device-mapper/unstriped.rst
> @@ -35,7 +35,7 @@ An example of undoing an existing dm-str
>   
>   This small bash script will setup 4 loop devices and use the existing
>   striped target to combine the 4 devices into one.  It then will use
> -the unstriped target ontop of the striped device to access the
> +the unstriped target on top of the striped device to access the
>   individual backing loop devices.  We write data to the newly exposed
>   unstriped devices and verify the data written matches the correct
>   underlying device on the striped array::
> @@ -110,8 +110,8 @@ to get a 92% reduction in read latency u
>   Example dmsetup usage
>   =====================
>   
> -unstriped ontop of Intel NVMe device that has 2 cores
> ------------------------------------------------------
> +unstriped on top of Intel NVMe device that has 2 cores
> +------------------------------------------------------
>   
>   ::
>   
> @@ -124,8 +124,8 @@ respectively::
>     /dev/mapper/nvmset0
>     /dev/mapper/nvmset1
>   
> -unstriped ontop of striped with 4 drives using 128K chunk size
> ---------------------------------------------------------------
> +unstriped on top of striped with 4 drives using 128K chunk size
> +---------------------------------------------------------------
>   
>   ::
>   
> diff -- a/Documentation/admin-guide/hw-vuln/mds.rst b/Documentation/admin-guide/hw-vuln/mds.rst
> --- a/Documentation/admin-guide/hw-vuln/mds.rst
> +++ b/Documentation/admin-guide/hw-vuln/mds.rst
> @@ -64,8 +64,8 @@ architecture section: :ref:`Documentatio
>   Attack scenarios
>   ----------------
>   
> -Attacks against the MDS vulnerabilities can be mounted from malicious non
> -priviledged user space applications running on hosts or guest. Malicious
> +Attacks against the MDS vulnerabilities can be mounted from malicious non-
> +privileged user space applications running on hosts or guest. Malicious
>   guest OSes can obviously mount attacks as well.
>   
>   Contrary to other speculation based vulnerabilities the MDS vulnerability
> diff -- a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -356,7 +356,7 @@ The lowmem_reserve_ratio is an array. Yo
>   
>   But, these values are not used directly. The kernel calculates # of protection
>   pages for each zones from them. These are shown as array of protection pages
> -in /proc/zoneinfo like followings. (This is an example of x86-64 box).
> +in /proc/zoneinfo like the following. (This is an example of x86-64 box).
>   Each zone has an array of protection pages like this::
>   
>     Node 0, zone      DMA
> @@ -433,7 +433,7 @@ a 2bit error in a memory module) is dete
>   that cannot be handled by the kernel. In some cases (like the page
>   still having a valid copy on disk) the kernel will handle the failure
>   transparently without affecting any applications. But if there is
> -no other uptodate copy of the data it will kill to prevent any data
> +no other up-to-date copy of the data it will kill to prevent any data
>   corruptions from propagating.
>   
>   1: Kill all processes that have the corrupted and not reloadable page mapped
> diff -- a/Documentation/admin-guide/bcache.rst b/Documentation/admin-guide/bcache.rst
> --- a/Documentation/admin-guide/bcache.rst
> +++ b/Documentation/admin-guide/bcache.rst
> @@ -204,7 +204,7 @@ For example::
>   This should present your unmodified backing device data in /dev/loop0
>   
>   If your cache is in writethrough mode, then you can safely discard the
> -cache device without loosing data.
> +cache device without losing data.
>   
>   
>   E) Wiping a cache device
> diff -- a/Documentation/admin-guide/sysrq.rst b/Documentation/admin-guide/sysrq.rst
> --- a/Documentation/admin-guide/sysrq.rst
> +++ b/Documentation/admin-guide/sysrq.rst
> @@ -138,7 +138,7 @@ Command	    Function
>   ``v``	    Forcefully restores framebuffer console
>   ``v``	    Causes ETM buffer dump [ARM-specific]
>   
> -``w``	    Dumps tasks that are in uninterruptable (blocked) state.
> +``w``	    Dumps tasks that are in uninterruptible (blocked) state.
>   
>   ``x``	    Used by xmon interface on ppc/powerpc platforms.
>               Show global PMU Registers on sparc64.
> diff -- a/Documentation/admin-guide/cifs/usage.rst b/Documentation/admin-guide/cifs/usage.rst
> --- a/Documentation/admin-guide/cifs/usage.rst
> +++ b/Documentation/admin-guide/cifs/usage.rst
> @@ -399,7 +399,7 @@ A partial list of the supported mount op
>     sep
>   		if first mount option (after the -o), overrides
>   		the comma as the separator between the mount
> -		parms. e.g.::
> +		parameters. e.g.::
>   
>   			-o user=myname,password=mypassword,domain=mydom
>   
> @@ -765,7 +765,7 @@ cifsFYI			If set to non-zero value, addi
>   			Some debugging statements are not compiled into the
>   			cifs kernel unless CONFIG_CIFS_DEBUG2 is enabled in the
>   			kernel configuration. cifsFYI may be set to one or
> -			nore of the following flags (7 sets them all)::
> +			more of the following flags (7 sets them all)::
>   
>   			  +-----------------------------------------------+------+
>   			  | log cifs informational messages		  | 0x01 |
> diff -- a/Documentation/admin-guide/dynamic-debug-howto.rst b/Documentation/admin-guide/dynamic-debug-howto.rst
> --- a/Documentation/admin-guide/dynamic-debug-howto.rst
> +++ b/Documentation/admin-guide/dynamic-debug-howto.rst
> @@ -330,7 +330,7 @@ Examples
>   
>     // boot-args example, with newlines and comments for readability
>     Kernel command line: ...
> -    // see whats going on in dyndbg=value processing
> +    // see what's going on in dyndbg=value processing
>       dynamic_debug.verbose=3
>       // enable pr_debugs in the btrfs module (can be builtin or loadable)
>       btrfs.dyndbg="+p"
> diff -- a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation/admin-guide/mm/hugetlbpage.rst
> --- a/Documentation/admin-guide/mm/hugetlbpage.rst
> +++ b/Documentation/admin-guide/mm/hugetlbpage.rst
> @@ -86,7 +86,7 @@ by increasing or decreasing the value of
>   
>   Note: When the feature of freeing unused vmemmap pages associated with each
>   hugetlb page is enabled, we can fail to free the huge pages triggered by
> -the user when ths system is under memory pressure.  Please try again later.
> +the user when the system is under memory pressure.  Please try again later.

My eye almost missed 'ths' :-)

>   
>   Pages that are used as huge pages are reserved inside the kernel and cannot
>   be used for other purposes.  Huge pages cannot be swapped out under
> diff -- a/Documentation/admin-guide/mm/numa_memory_policy.rst b/Documentation/admin-guide/mm/numa_memory_policy.rst
> --- a/Documentation/admin-guide/mm/numa_memory_policy.rst
> +++ b/Documentation/admin-guide/mm/numa_memory_policy.rst
> @@ -246,7 +246,7 @@ MPOL_INTERLEAVED
>   	interleaved system default policy works in this mode.
>   
>   MPOL_PREFERRED_MANY
> -	This mode specifices that the allocation should be preferrably
> +	This mode specifies that the allocation should be preferably
>   	satisfied from the nodemask specified in the policy. If there is
>   	a memory pressure on all nodes in the nodemask, the allocation
>   	can fall back to all existing numa nodes. This is effectively
> @@ -360,7 +360,7 @@ and NUMA nodes.  "Usage" here means one
>   2) examination of the policy to determine the policy mode and associated node
>      or node lists, if any, for page allocation.  This is considered a "hot
>      path".  Note that for MPOL_BIND, the "usage" extends across the entire
> -   allocation process, which may sleep during page reclaimation, because the
> +   allocation process, which may sleep during page reclamation, because the
>      BIND policy nodemask is used, by reference, to filter ineligible nodes.
>   
>   We can avoid taking an extra reference during the usages listed above as
> diff -- a/Documentation/admin-guide/gpio/gpio-sim.rst b/Documentation/admin-guide/gpio/gpio-sim.rst
> --- a/Documentation/admin-guide/gpio/gpio-sim.rst
> +++ b/Documentation/admin-guide/gpio/gpio-sim.rst
> @@ -123,7 +123,7 @@ Each simulated GPIO chip creates a separ
>   directory for each exposed line
>   (e.g. ``/sys/devices/platform/gpio-sim.X/gpiochipY/``). The name of each group
>   is of the form: ``'sim_gpioX'`` where X is the offset of the line. Inside each
> -group there are two attibutes:
> +group there are two attributes:
>   
>       ``pull`` - allows to read and set the current simulated pull setting for
>                  every line, when writing the value must be one of: ``'pull-up'``,
> diff -- a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -676,7 +676,7 @@
>   			Sets the size of kernel per-numa memory area for
>   			contiguous memory allocations. A value of 0 disables
>   			per-numa CMA altogether. And If this option is not
> -			specificed, the default value is 0.
> +			specified, the default value is 0.
>   			With per-numa CMA enabled, DMA users on node nid will
>   			first try to allocate buffer from the pernuma area
>   			which is located in node nid, if the allocation fails,
> @@ -946,7 +946,7 @@
>   			driver code when a CPU writes to (or reads from) a
>   			random memory location. Note that there exists a class
>   			of memory corruptions problems caused by buggy H/W or
> -			F/W or by drivers badly programing DMA (basically when
> +			F/W or by drivers badly programming DMA (basically when
>   			memory is written at bus level and the CPU MMU is
>   			bypassed) which are not detectable by
>   			CONFIG_DEBUG_PAGEALLOC, hence this option will not help
> @@ -1732,7 +1732,7 @@
>   			boot-time allocation of gigantic hugepages is skipped.
>   
>   	hugetlb_free_vmemmap=
> -			[KNL] Reguires CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +			[KNL] Requires CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>   			enabled.
>   			Control if HugeTLB Vmemmap Optimization (HVO) is enabled.
>   			Allows heavy hugetlb users to free up some more
> @@ -3693,7 +3693,7 @@
>   			implementation; requires CONFIG_GENERIC_IDLE_POLL_SETUP
>   			to be effective. This is useful on platforms where the
>   			sleep(SH) or wfi(ARM,ARM64) instructions do not work
> -			correctly or when doing power measurements to evalute
> +			correctly or when doing power measurements to evaluate
>   			the impact of the sleep instructions. This is also
>   			useful when using JTAG debugger.
>   
> diff -- a/Documentation/admin-guide/perf/hns3-pmu.rst b/Documentation/admin-guide/perf/hns3-pmu.rst
> --- a/Documentation/admin-guide/perf/hns3-pmu.rst
> +++ b/Documentation/admin-guide/perf/hns3-pmu.rst
> @@ -53,7 +53,7 @@ two events have same value of bits 0~15
>   event pair. And the bit 16 of config indicates getting counter 0 or
>   counter 1 of hardware event.
>   
> -After getting two values of event pair in usersapce, the formula of
> +After getting two values of event pair in userspace, the formula of
>   computation to calculate real performance data is:::
>   
>     counter 0 / counter 1
> diff -- a/Documentation/admin-guide/media/bttv.rst b/Documentation/admin-guide/media/bttv.rst
> --- a/Documentation/admin-guide/media/bttv.rst
> +++ b/Documentation/admin-guide/media/bttv.rst
> @@ -909,7 +909,7 @@ DE hat diverse Treiber fuer diese Modell
>     - TVPhone98 (Bt878)
>     - AVerTV und TVCapture98 w/VCR (Bt 878)
>     - AVerTVStudio und TVPhone98 w/VCR (Bt878)
> -  - AVerTV GO Serie (Kein SVideo Input)
> +  - AVerTV GO Series (Kein SVideo Input)
>     - AVerTV98 (BT-878 chip)
>     - AVerTV98 mit Fernbedienung (BT-878 chip)
>     - AVerTV/FM98 (BT-878 chip)
> diff -- a/Documentation/admin-guide/media/building.rst b/Documentation/admin-guide/media/building.rst
> --- a/Documentation/admin-guide/media/building.rst
> +++ b/Documentation/admin-guide/media/building.rst
> @@ -137,7 +137,7 @@ The ``LIRC user interface`` option adds
>   from remote controllers.
>   
>   The ``Support for eBPF programs attached to lirc devices`` option allows
> -the usage of special programs (called eBPF) that would allow aplications
> +the usage of special programs (called eBPF) that would allow applications
>   to add extra remote controller decoding functionality to the Linux Kernel.
>   
>   The ``Remote controller decoders`` option allows selecting the
> diff -- a/Documentation/admin-guide/media/si476x.rst b/Documentation/admin-guide/media/si476x.rst
> --- a/Documentation/admin-guide/media/si476x.rst
> +++ b/Documentation/admin-guide/media/si476x.rst
> @@ -142,7 +142,7 @@ The drivers exposes following files:
>   				  indicator
>     0x18		 lassi		  Signed Low side adjacent Channel
>   				  Strength indicator
> -  0x19		 hassi		  ditto fpr High side
> +  0x19		 hassi		  ditto for High side
>     0x20		 mult		  Multipath indicator
>     0x21		 dev		  Frequency deviation
>     0x24		 assi		  Adjacent channel SSI
> diff -- a/Documentation/admin-guide/media/vivid.rst b/Documentation/admin-guide/media/vivid.rst
> --- a/Documentation/admin-guide/media/vivid.rst
> +++ b/Documentation/admin-guide/media/vivid.rst
> @@ -580,7 +580,7 @@ Metadata Capture
>   ----------------
>   
>   The Metadata capture generates UVC format metadata. The PTS and SCR are
> -transmitted based on the values set in vivid contols.
> +transmitted based on the values set in vivid controls.
>   
>   The Metadata device will only work for the Webcam input, it will give
>   back an error for all other inputs.


Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>

-Mukesh

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

