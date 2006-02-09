From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Problem with Multipath (devices not ready)
Date: Thu, 09 Feb 2006 20:23:19 +0100
Message-ID: <1139513000.2915.4.camel@zezette>
References: <!&!AAAAAAAAAAAYAAAAAAAAANNuC7JXowhAhztxsUsdl9nCgAAAEAAAAFrKzybPoitElCE3HsMmQqIBAAAAAA==@est.ips.pt>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <!&!AAAAAAAAAAAYAAAAAAAAANNuC7JXowhAhztxsUsdl9nCgAAAEAAAAFrKzybPoitElCE3HsMmQqIBAAAAAA==@est.ips.pt>
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


> 
>  
> 
> defaults {
> 
>             multipath_tool   "/sbin/multipath -v 0 -S"
> 
>             udev_dir            /dev
> 
>             polling_interval 10
> 
>             default_selector "round-robin 0"
> 
>     #default_path_grouping_policy           failover
> 
>             default_path_grouping_policy     multibus
> 

CX300 is not a multibus-capable hardware.
You should remove this directive and let the in-core defaults apply.

>             default_getuid_callout    "/sbin/scsi_id -g -u -s /block/%
> n"
> 
remove too : the CX need a special flag passed to scsi_id if I
remember ...


>             #default_prio_callout      "/bin/false"
> 
>     failback        immediate
> 
> }
> 
Regards,
cvaroqui
> 
