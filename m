From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [patch 2/3] dm-netlink: Add support for event functions
Date: Mon, 12 Feb 2007 20:41:17 -0800
Message-ID: <20070213044117.GA4652@us.ibm.com>
References: <20070122181718.377495483@us.ibm.com>>
	<20070122181742.893385495@us.ibm.com>>
	<45CCAC8B.7080207@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <45CCAC8B.7080207@redhat.com>
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

Milan Broz <mbroz@redhat.com> wrote:
> Hello Mike,
> 
> Just small oversight in code:
> modification of destructor missing here
> (dm_mod will not load second time after rmmod now)
> 
> @@ -94,4 +288,6 @@ int __init dm_netlink_init(void)
>  void dm_netlink_exit(void)
>  {
>  	dme_cache_destroy(&dme_cache);
> +	sock_release(dm_netlink_sock->sk_socket);
> +	netlink_unregister_notifier(&dm_netlink_notifier);
>  }

I updated the patch. Thank you. I will add the unload to my testing and
resubmit the series once I get the test run.

-andmike
--
Michael Anderson
andmike@us.ibm.com
