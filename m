From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: multipath-tools: looking for weird values at hwtable.c
Date: Sat, 11 Jun 2016 23:53:25 +0200
Message-ID: <0e79b203-6005-5b18-d093-2c5ba5f16430@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

Do you see something wrong/weird? (mainly in less repeated patterns)

awk '/{/,/}/' hwtable.c  | grep '\..*=' | egrep -v "\.product|\.vendor|\.bl_product" | sort | uniq -c | sort  -n


      1                 .checker_name  = EMC_CLARIION,
      1                 .checker_name  = NULL,
      1                 .dev_loss      = 60,
      1                 .dev_loss      = MAX_DEV_LOSS_TMO,
      1                 .fast_io_fail  = 10,
      1                 .fast_io_fail  = 5,
      1                 .features      = "3 queue_if_no_path pg_init_retries 50",
      1                 .features      = NULL,
      1                 .flush_on_last_del = FLUSH_ENABLED,
      1                 .hwhandler     = "1 emc",
      1                 .hwhandler     = NULL,
      1                 .minio         = 0,
      1                 .minio         = 15,
      1                 .minio         = DEFAULT_MINIO,
      1                 .minio_rq      = 0,
      1                 .minio_rq      = DEFAULT_MINIO_RQ,
      1                 .no_path_retry = 10,
      1                 .no_path_retry = 5,
      1                 .no_path_retry = 6,
      1                 .pgfailback    = 0,
      1                 .pgfailback    = 15,
      1                 .pgpolicy      = 0,
      1                 .pgpolicy      = FAILOVER,
      1                 .prio_name     = NULL,
      1                 .prio_name     = PRIO_EMC,
      1                 .prio_name     = PRIO_HDS,
      1                 .rr_weight     = 0,
      1                 .selector      = NULL,

      2                 .checker_name  = HP_SW,
      2                 .hwhandler     = "1 hp_sw",
      2                 .no_path_retry = 0,
      2                 .no_path_retry = 30,
      2                 .prio_name     = PRIO_HP_SW,
      2                 .prio_name     = PRIO_ONTAP,
      2                 .selector      = "queue-length 0",
      2                 .uid_attribute = "ID_UID",
      2                 .user_friendly_names = USER_FRIENDLY_NAMES_OFF,

      3                 .checker_name  = DEFAULT_CHECKER,
      3                 .detect_prio   = DETECT_PRIO_ON,
      3                 .minio         = 128,
      3                 .no_path_retry = 300,
      3                 .retain_hwhandler = RETAIN_HWHANDLER_ON,

      4                 .no_path_retry = 18,
      4                 .no_path_retry = (300 / DEFAULT_CHECKINT),

      5                 .no_path_retry = 15,
      5                 .pgpolicy      = GROUP_BY_SERIAL,

      6                 .features      = "2 pg_init_retries 50",
      6                 .hwhandler     = "1 alua",

      7                 .no_path_retry = 12,


     11                 .checker_name  = DIRECTIO,
     11                 .minio         = 100,

     15                 .no_path_retry = NO_PATH_RETRY_QUEUE,
     18                 .prio_name     = PRIO_ALUA,
     19                 .checker_name  = RDAC,
     20                 .features      = "1 queue_if_no_path",
     21                 .hwhandler     = "1 rdac",
     21                 .prio_name     = PRIO_RDAC,
     22                 .pgpolicy      = MULTIBUS,
     24                 .pgfailback    = FAILBACK_UNDEF,
     28                 .no_path_retry = NO_PATH_RETRY_UNDEF,
     28                 .prio_name     = DEFAULT_PRIO,
     38                 .checker_name  = TUR,
     44                 .hwhandler     = DEFAULT_HWHANDLER,
     46                 .pgpolicy      = GROUP_BY_PRIO,
     47                 .features      = DEFAULT_FEATURES,
     49                 .pgfailback    = -FAILBACK_IMMEDIATE,
     71                 .rr_weight     = RR_WEIGHT_NONE,
     73                 .prio_args     = NULL,
