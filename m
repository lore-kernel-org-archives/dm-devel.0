From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Device-mapper-multipath RDAC
Date: Mon, 24 Sep 2007 11:33:32 -0700
Message-ID: <1190658812.1933.141.camel@linuxchandra>
References: <200709241706.26322.npf-mlists@eurotux.com>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200709241706.26322.npf-mlists@eurotux.com>
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

On Mon, 2007-09-24 at 17:06 +0100, Nuno Fernandes wrote:
> hello,
> 
> Just a question:
> 
> With recent support for rdac hardware handler in kernel 2.6.23-rc7, what 
> configuration should be in storage DS4700? AVT (Automatic Volume transfer) 
> turned on or off?

Hardware handler is needed only for RDAC mode, AVT would work without
the hardware handler.

The decision to use RDAC or AVT depends on your configuration.

> 
> When it's turned on, luns keep on jumping from controller to controller..

dm-multipath will use the other path (in AVT mode, IOW, jump) only if
I/O in the current path fails.
> 
> Thanks
> Nuno Fernandes
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
