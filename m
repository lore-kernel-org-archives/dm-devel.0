From: Nuno Fernandes <npf-mlists@eurotux.com>
Subject: Re: Device-mapper-multipath RDAC
Date: Tue, 25 Sep 2007 08:50:22 +0100
Message-ID: <200709250850.23018.npf-mlists@eurotux.com>
References: <200709241706.26322.npf-mlists@eurotux.com>
	<1190658812.1933.141.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1190658812.1933.141.camel@linuxchandra>
Content-Disposition: inline
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

On Monday 24 September 2007 19:33:32 Chandra Seetharaman wrote:
> On Mon, 2007-09-24 at 17:06 +0100, Nuno Fernandes wrote:
> > hello,
> >
> > Just a question:
> >
> > With recent support for rdac hardware handler in kernel 2.6.23-rc7, what
> > configuration should be in storage DS4700? AVT (Automatic Volume
> > transfer) turned on or off?
>
> Hardware handler is needed only for RDAC mode, AVT would work without
> the hardware handler.
>
> The decision to use RDAC or AVT depends on your configuration.
>
> > When it's turned on, luns keep on jumping from controller to controller..
>
> dm-multipath will use the other path (in AVT mode, IOW, jump) only if
> I/O in the current path fails.
Yes, but it keeps on jumping because of the multipathd monitoring of alive 
paths.

I'm was already in the process of using
linux-2.6-md-add-dm-rdac-hardware-handler.patch from 
kernel-2.6.18-36.el5.src.rpm (from RHEL5U1 Beta) to rebuild RHEL5.0 stable 
kernel.. Hope it works..

Best rgds
Nuno Fernandes

>
> > Thanks
> > Nuno Fernandes
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
