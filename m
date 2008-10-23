From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: mulitipath -ll & multiapth -v3 ouput
Date: Thu, 23 Oct 2008 10:34:11 -0400
Message-ID: <20081023143411.GA10858@mars.virtualiron.com>
References: <213666.28497.qm@web94812.mail.in2.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <213666.28497.qm@web94812.mail.in2.yahoo.com>
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

On Thu, Oct 23, 2008 at 03:56:15PM +0530, sriharsha y d wrote:
> Hi,
> 
> Not sure why there is a difference between the  mulitipath -ll & multiapth -v3 ouput ,for  IO queuing features disply,
> 
> i.e 
> multipath  -v3 
> asm1: pgfailback = -2 (controller setting) 
> asm1: pgpolicy = multibus (controller setting) 
> asm1: selector = round-robin 0 (internal default) 
> asm1: features = 0 (internal default) 
> asm1: hwhandler = 0 (internal default) 
> asm1: rr_weight = 2 (config file default) 
> asm1: minio = 100 (config file default) 
> asm1: no_path_retry = 5 (config file default) 
> pg_timeout = NONE (internal default) 
> asm1: set ACT_NOTHING (map unchanged)
> 
>  
> multiapth -ll 
> 
> asm1 (1HITACHI_770100720007) dm-9 HITACHI,DF600F 
> [size=65G][features=1 queue_if_no_path][hwhandler=0] 
> \_ round-robin 0 [prio=0][active] 
>  \_ 0:0:0:7 sdh 8:112 [active][ready] 
>  \_ 1:0:0:7 sdp 8:240 [active][ready]
> 
> 
> So if we look at the features part , v3 output displays the correct info since in the config file  I have disabled queuing, but where as in -ll ouput it says queuing is enabled !!

Did you run 'multipathd -k'reconfigure' after you disabled queuing in your multipath.conf file?

> 
> Can some one provide more info on this ....
> 
> 
> 
>       Add more friends to your messenger and enjoy! Go to http://messenger.yahoo.com/invite/
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
