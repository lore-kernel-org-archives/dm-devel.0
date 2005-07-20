From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: race bugs
Date: Wed, 20 Jul 2005 11:06:59 +0200
Message-ID: <20050720090659.GB24444@averon.dyndns.org>
References: <20050718225603.GF24376@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050718225603.GF24376@phlogiston.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

applied, thanks.

On Mon, Jul 18, 2005 at 05:56:04PM -0500, Benjamin Marzinski wrote:
> I was looking at the waitevent thread, and I noticed some issues. Since the
> cancellation type is asynchronous, the thread can get cancelled at any
> moment. This can cause bugs. For instance, the double removal of the dm task
> structure that just got fixed can still show up if the thread were cancelled
> after it was freed but before it was set to NULL, there were other issues
> like this in update_multpath. It seems like the easiest way to fix this is to
> set some defined cancellation points. So that's what this does.
> 
> 
> -Ben

> diff -urpN mp-devel/multipathd/main.c mp-devel-patched/multipathd/main.c
> --- mp-devel/multipathd/main.c	2005-07-18 10:21:17.000000000 -0500
> +++ mp-devel-patched/multipathd/main.c	2005-07-18 17:52:46.385426160 -0500
> @@ -350,7 +350,6 @@ waiteventloop (struct event_thread * wai
>  
>  	dm_task_no_open_count(waiter->dmt);
>  
> -	pthread_testcancel();
>  	dm_task_run(waiter->dmt);
>  	pthread_testcancel();
>  	dm_task_destroy(waiter->dmt);
> @@ -404,7 +403,6 @@ waitevent (void * et)
>  	mlockall(MCL_CURRENT | MCL_FUTURE);
>  
>  	waiter = (struct event_thread *)et;
> -	pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);
>  	pthread_cleanup_push(free_waiter, et);
>  
>  	while (1) {
> @@ -413,7 +411,9 @@ waitevent (void * et)
>  		if (r < 0)
>  			break;
>  
> +		pthread_testcancel();
>  		sleep(r);
> +		pthread_testcancel();
>  	}
>  
>  	pthread_cleanup_pop(1);

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
