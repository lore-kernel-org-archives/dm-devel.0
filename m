From: Martin George <marting@netapp.com>
Subject: Re: NetApp Ontap
Date: Mon, 27 Jun 2016 20:14:36 +0530
Message-ID: <57713BD4.1020903@netapp.com>
References: <1465156471-20249-1-git-send-email-xose.vazquez@gmail.com>
	<5769FA0F.9030307@netapp.com>
	<86788d57-d39a-2618-8078-0f5342c92af0@gmail.com>
	<576D7369.4000101@netapp.com>
	<70702f9d-a3b8-fb4b-ce6a-cf66cb2ba8e8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <70702f9d-a3b8-fb4b-ce6a-cf66cb2ba8e8@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 6/24/2016 11:41 PM, Xose Vazquez Perez wrote:
> On 06/24/2016 07:52 PM, Martin George wrote:
>
>> On 6/24/2016 1:12 AM, Xose Vazquez Perez wrote:
>>>
>>> And one question, should NETAPP/LUN.* and IBM/Nseries.* share the same options?
>>>
>> Yes, let them share the same options for now. I have some further updates on
>> this which I will share later. Thanks.
>
> Right now they are different:
>
> --- netapp-ontap        2016-06-24 20:05:35.182539928 +0200
> +++ ibm-ontap   2016-06-24 20:05:26.750552635 +0200
> @@ -1,18 +1,14 @@
>          {
> -               .vendor        = "NETAPP",
> -               .product       = "LUN.*",
> -               .features      = "3 queue_if_no_path pg_init_retries 50",
> +               .vendor        = "IBM",
> +               .product       = "Nseries.*",
> +               .features      = "1 queue_if_no_path",
>                  .hwhandler     = DEFAULT_HWHANDLER,
>                  .pgpolicy      = GROUP_BY_PRIO,
>                  .pgfailback    = -FAILBACK_IMMEDIATE,
> -               .flush_on_last_del = FLUSH_ENABLED,
>                  .rr_weight     = RR_WEIGHT_NONE,
>                  .no_path_retry = NO_PATH_RETRY_UNDEF,
>                  .minio         = 128,
> -               .dev_loss      = MAX_DEV_LOSS_TMO,
> -               .checker_name  = TUR,
> +               .checker_name  = DIRECTIO,
>                  .prio_name     = PRIO_ONTAP,
>                  .prio_args     = NULL,
> -               .retain_hwhandler = RETAIN_HWHANDLER_ON,
> -               .detect_prio   = DETECT_PRIO_ON,
>

Yes, I know. I actually meant keeping these settings as it is for now. I 
will send a patch for NSeries later. Thanks.

-Martin George
