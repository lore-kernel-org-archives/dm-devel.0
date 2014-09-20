From: "lilofile" <lilofile@aliyun.com>
Subject: =?utf-8?q?Thinly-Provisioned_Logical_Volumes?=
Date: Sat, 20 Sep 2014 22:19:51 +0800
Message-ID: <b3abf2cc-2219-4b5a-b546-5f71301c40e4@aliyun.com>
Reply-To: lilofile <lilofile@aliyun.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
References: alpine.LRH.2.02.1409171425060.15315@file01.intranet.prod.int.rdu2.redhat.com
In-Reply-To: alpine.LRH.2.02.1409171425060.15315@file01.intranet.prod.int.rdu2.redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Ondrej Kozina <okozina@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

when I test Thinly-Provisioned Logical Volumes(use device thinprovison target),I found the random write performance is very low. What factors will influence the random write performance of  thin volume. how can i quickly understand dm-bufio.c?
