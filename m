Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D1DAC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 00:51:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-3VSrnsDIP86m7hVoil8fGg-1; Sun, 10 Apr 2022 20:51:08 -0400
X-MC-Unique: 3VSrnsDIP86m7hVoil8fGg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CE6629DD98C;
	Mon, 11 Apr 2022 00:51:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4FCCE417E39;
	Mon, 11 Apr 2022 00:51:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EC54819451F1;
	Mon, 11 Apr 2022 00:51:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 22D2619451F1
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 00:51:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E4CB5404D2CA; Mon, 11 Apr 2022 00:51:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E0D6640C1438
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 00:51:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 359B73C02B89
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 00:51:04 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-232-w2Z_m67rNqCI-ronIN_G0A-2; Sun, 10 Apr 2022 20:51:02 -0400
X-MC-Unique: w2Z_m67rNqCI-ronIN_G0A-2
X-IronPort-AV: E=Sophos;i="5.90,250,1643644800"; d="scan'208";a="196446924"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2022 08:51:01 +0800
IronPort-SDR: AFLovv3loZpJjtTYN3W0Up4Kuayvl5WMnr1jLzZrh73uvlrLJC77JH/WEHerA8fDHRt88u20m1
 0BrQcHNEmh4YSkgDmUEhJT/XUfCfKPWA+pe4EuR/bMCEjUU3WMAccC17axoonD11TClfdYzpPe
 mRI/eZFPOwuc8Lc83pl1cTa9nHrEtABJHN/j612uyEgrKO9v/nKJCJJXxiThZgjewh6QDkRnPH
 /dRtsa7ShpxsoMRAEE+mq1MuWc39wqBG1gPjMtWQ+GneuIKyJfMI5lkcrBhkwiIFuMlKHylIlO
 zrMA4IVbNyClOmVAm9OiqMdP
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Apr 2022 17:22:19 -0700
IronPort-SDR: z+y4b7rArkACZQ9A6nDMxMUghEuu0/R2es+FpuNebktiyc3GMZKp2b/7kPYHdA/JGrK3AHCi5B
 C5FHUMEHCVVyI6ngoaoaMC+W3wXePeEtXECiZUrQqPh7LyT/mxgMjF3cLTzm7/whAa8MojOA9u
 GuIySTb5fzj2OENbYXiErPORPEcPr3U0p2n94m2lLqSbkyq2/8C/e+f1pDJyY5kdjAnhObKN+y
 2Axqry7isCKemTVWQR2WR83sgG7e/NYUV6obaVvkVIMNc0H+fn2epu4DJ/c1jgp3QhDnozZJyu
 bOo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 10 Apr 2022 17:51:01 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kc9Jh3qb5z1SVp1
 for <dm-devel@redhat.com>; Sun, 10 Apr 2022 17:51:00 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id IwjJEBDFqFND for <dm-devel@redhat.com>;
 Sun, 10 Apr 2022 17:50:59 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kc9Jf3yD0z1Rvlx;
 Sun, 10 Apr 2022 17:50:58 -0700 (PDT)
Message-ID: <95d8a8ed-27f8-0d88-a543-16910dca83e3@opensource.wdc.com>
Date: Mon, 11 Apr 2022 09:50:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
To: Ming Lei <ming.lei@redhat.com>
References: <20220408171254.935171-1-ming.lei@redhat.com>
 <20220408171254.935171-2-ming.lei@redhat.com>
 <8b9078c2-7884-a5b5-5aa9-ad284b4068ef@opensource.wdc.com>
 <YlN4BC2qbGODxbVz@T590>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YlN4BC2qbGODxbVz@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 1/3] dm: don't grab target io reference in
 dm_zone_map_bio
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
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>,
 Mike Snitzer <snitzer@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/11/22 09:36, Ming Lei wrote:
> On Mon, Apr 11, 2022 at 09:18:56AM +0900, Damien Le Moal wrote:
>> On 4/9/22 02:12, Ming Lei wrote:
>>> dm_zone_map_bio() is only called from __map_bio in which the io's
>>> reference is grabbed already, and the reference won't be released
>>> until the bio is submitted, so no necessary to do it dm_zone_map_bio
>>> any more.
>>
>> I do not think that this patch is correct. Removing the extra reference on
>> the io can lead to problems if the io is completed in the target
>> ->map(ti, clone) call or before dm_zone_map_bio_end() is called for the
>> DM_MAPIO_SUBMITTED or DM_MAPIO_REMAPPED cases. dm_zone_map_bio_end() needs
> 
> __map_bio():
> 	...
> 	dm_io_inc_pending(io);
> 	...
> 	dm_zone_map_bio(tio);
> 	...

dm-crypt (for instance) may terminate the clone bio immediately in its
->map() function context, resulting in the bio_endio()clone) ->
clone_endio() -> dm_io_dec_pending() call chain.

With that, the io is gone and dm_zone_map_bio_end() will not have a valid
reference on the orig bio.

What am I missing here ?

> 
> dm_submit_bio():
> 	dm_split_and_process_bio
> 		init_clone_info(&ci, md, map, bio)
> 			atomic_set(&io->io_count, 1)
> 		...
> 		__map_bio()
> 		...
> 		dm_io_dec_pending()
> 
> The target io can only be completed after the above line returns,
> so the extra reference in dm_zone_map_bio() doesn't make any difference,
> does it?
> 
> 
> Thanks, 
> Ming
> 


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

