From: Andy <genanr@emsphone.com>
Subject: Re: Device Mapper MultiPath
Date: Fri, 3 Apr 2009 10:13:57 -0500
Message-ID: <20090403151357.GA8916@thumper2>
References: <20090402215008.GA14752@thumper2>
	<739475537.2943331238709482966.JavaMail.root@zimbra16-e3.priv.proxad.net>
	<20090403142323.GA26508@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090403142323.GA26508@mars.virtualiron.com>
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

On Fri, Apr 03, 2009 at 10:23:23AM -0400, Konrad Rzeszutek wrote:
> On Thu, Apr 02, 2009 at 11:58:03PM +0200, christophe.varoqui@free.fr wrote:
> > I can reproduce Andy's multipathd behaviour with scsi_debug (symmetrix arrays too)... only with the upstream directio checker. My guess is that the async code in there misbehaves. Needs review.
> 
> I saw this behavior as well on RHEL5U3 with the upstream multipath.
> My fix was to replace all of the libaio calls with syscalls, as I attributed
> the issue to libaio != kernel libaio, and left it at that.
> 
> Andy, are you using a recent version of libaio and kernel? Like
> Fedora Core 10?
> > 

My test system is debian. It has libio 0.3.107-3 installed, and I am using
Linus's .git kernel from a few days ago.

Andy
