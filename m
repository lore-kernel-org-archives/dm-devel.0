From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: further testing w/ multipath ... and bugs
Date: Mon, 13 Jun 2005 14:36:01 -0500
Message-ID: <42ADE021.6050902@cs.wisc.edu>
References: <20050613081154.GA28251@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050613081154.GA28251@averon.dyndns.org>
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

Christophe Varoqui wrote:
> 
>  rport-0:0-0: blocked FC remote port time out: removing target
>  rport-0:0-1: blocked FC remote port time out: removing target

I think if we end up doing this to all the devices paths we are going to 
be screwed. If all the paths suddenly fail and then those devices are 
freed when trying to readd/create devices when the ports come back is 
going to take a lot of GFP_KERNELs.
