From: Milan Broz <mbroz@redhat.com>
Subject: Re: [patch 2/3] dm-netlink: Add support for event functions
Date: Fri, 09 Feb 2007 18:16:59 +0100
Message-ID: <45CCAC8B.7080207@redhat.com>
References: <20070122181718.377495483@us.ibm.com>>
	<20070122181742.893385495@us.ibm.com>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070122181742.893385495@us.ibm.com>>
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

Mike Anderson wrote:
> This patch adds support for the dm_path_event dm_send_event funtions which
> create and send netlink attribute events.
> 
> Signed-off-by: Mike Anderson <andmike@us.ibm.com>

>  int __init dm_netlink_init(void)
>  {
>  	int err;
>  
> +	err = netlink_register_notifier(&dm_netlink_notifier);

Hello Mike,

Just small oversight in code:
modification of destructor missing here
(dm_mod will not load second time after rmmod now)

@@ -94,4 +288,6 @@ int __init dm_netlink_init(void)
 void dm_netlink_exit(void)
 {
 	dme_cache_destroy(&dme_cache);
+	sock_release(dm_netlink_sock->sk_socket);
+	netlink_unregister_notifier(&dm_netlink_notifier);
 }

Milan
--
mbroz@redhat.com
