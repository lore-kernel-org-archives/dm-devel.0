From: Joe Thornber <thornber@redhat.com>
Subject: Re: Possible severe bug in the device mapper?
Date: Tue, 01 Feb 2011 10:03:16 +0000
Message-ID: <1296554596.1366.4.camel@ubuntu>
References: <4D46811C.9050506@gmx.com> <1296472845.2642.2.camel@ubuntu>
	<4D47D29F.5040200@gmx.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D47D29F.5040200@gmx.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Tue, 2011-02-01 at 10:30 +0100, Andreas Heinlein wrote:
> I will continue looking for help, can you point me in some direction?
> 'losetup' is part of util-linux, but I doubt this has actually
> anything
> to do withit. The loopback device code itself is part of the kernel,
> right? 

Yes, you should try and find someone who admits to being the loopback
device maintainer and try and have a chat with them.  Also it would be
interesting to know how OpenSuse are doing a better job of handling
this.  For instance is it a userland solution or have they changed
something in kernel?

- Joe
