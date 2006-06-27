From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: RHEL 4.3 to Sun 6320 storage
Date: Tue, 27 Jun 2006 22:08:51 +0200
Message-ID: <1151438931.15903.11.camel@localhost.localdomain>
References: <1151402657.4766.13.camel@x41ade>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1151402657.4766.13.camel@x41ade>
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
> but the error log is filling up with 
>  kernel: Device sde not ready.
>  kernel: end_request: I/O error, dev sde, sector 2181037632
>  multipathd: 8:64: mark as failed
>  multipathd: cab2a01t2: remaining active paths: 1
>  multipathd: 8:64: tur checker reports path is up
>  multipathd: 8:64: reinstated
>  multipathd: cab2a01t2: remaining active paths: 2
>  kernel: Device sde not ready.
>  kernel: end_request: I/O error, dev sde, sector 3187670215
>  kernel: device-mapper: dm-multipath: Failing path 8:64.
> 

Is the path /dev/sde reliable when used outside the multipath
subsystem ?

Regards,
cvaroqui
