From: Changwei Ge <ge.changwei@h3c.com>
Subject: Re: [RFC PATCH] multipath: flush workqueue only in
 necessary
Date: Thu, 22 Mar 2018 08:02:48 +0000
Message-ID: <63ADC13FD55D6546B7DECE290D39E373F2950F63@H3CMLB12-EX.srv.huawei-3com.com>
References: <6e0de469.6172.1621928673a.Coremail.wuzhouhui14@mails.ucas.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: wuzhouhui <wuzhouhui14@mails.ucas.ac.cn>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Zhouhui,

Your patch is not a formatted one.
At least, it should include Signed-off-by

Thanks,
Changwei

On 2018/3/12 15:47, wuzhouhui wrote:
> When flush works belong a specific multipath, we flush workqueue only
> in necessary.
> 
> (That's my first time to send a patch, please remind me if anything
> wrong)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index f7810cc..0f14732 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1154,9 +1154,10 @@ static void flush_multipath_work(struct multipath *m)
>   	set_bit(MPATHF_PG_INIT_DISABLED, &m->flags);
>   	smp_mb__after_atomic();
>   
> -	flush_workqueue(kmpath_handlerd);
> +	if (atomic_read(&m->pg_init_in_progress))
> +		flush_workqueue(kmpath_handlerd);
>   	multipath_wait_for_pg_init_completion(m);
> -	flush_workqueue(kmultipathd);
> +	flush_work(&m->process_queued_bios);
>   	flush_work(&m->trigger_event);
>   
>   	clear_bit(MPATHF_PG_INIT_DISABLED, &m->flags);
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
