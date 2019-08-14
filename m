From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
Subject: Re: [PATCH] libmultipath: builtin config for NetApp
	E-Series
Date: Wed, 14 Aug 2019 19:43:21 +0000
Message-ID: <BN8PR06MB5793EA4523DC5D0BBDEB10F98CAD0@BN8PR06MB5793.namprd06.prod.outlook.com>
References: <1565810083-10744-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1565810083-10744-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Nak. We would rather not have this in the builtin config at this time.

Thanks,
Steve

-----Original Message-----
From: Benjamin Marzinski <bmarzins@redhat.com> 
Sent: Wednesday, August 14, 2019 2:15 PM
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>; Schremmer, Steven <Steve.Schremmer@netapp.com>
Subject: [PATCH] libmultipath: builtin config for NetApp E-Series

Cc: Steve Schremmer <sschremm@netapp.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/hwtable.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c index 96e8b25d..94af153d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -780,6 +780,14 @@ static struct hwentry default_hw[] = {
                .pgpolicy      = MULTIBUS,
                .no_path_retry = NO_PATH_RETRY_QUEUE,
        },
+       {
+               /* NetApp E-Series */
+               .vendor        = "NVME",
+               .product       = "NetApp E-Series",
+               .pgpolicy      = GROUP_BY_PRIO,
+               .pgfailback    = -FAILBACK_IMMEDIATE,
+               .no_path_retry = 30,
+       },
        /*
         * Nexenta
         *
--
2.17.2
