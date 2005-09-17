From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: mpath_ctl observation + some novice questions
Date: Sun, 18 Sep 2005 00:41:32 +0200
Message-ID: <1126996892.6268.15.camel@zezette>
References: <20050915132538.GA27752@locust.cns.vt.edu>
	<20050915144209.GL5254@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050915144209.GL5254@agk.surrey.redhat.com>
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

Applied upstream, thanks.

On jeu, 2005-09-15 at 15:42 +0100, Alasdair G Kergon wrote:
> On Thu, Sep 15, 2005 at 09:25:38AM -0400, Ray Stell wrote:
> > I'm not a developer, but I thought I'd throw out this observation.
> > 
> > environment:
> >  - rhas4 U2 Beta - Linux pecan 2.6.9-16.EL #1 Mon Aug 15 19:58:49 EDT 2005 i686 i686 i386 GNU/Linux
> >  - multipath-tools-0.4.5.49.  
> 
> RPM (which?) or built from source tarball?
> 
> > The cpu got eaten up by mpath_ctl and remains that way until reboot:
> 
> The latest RPM is device-mapper-multipath-0.4.5-6.0.RHEL4
> which contains a patch (attached) that should fix this.
> 
> (uxsock.c where this code came from may also have similar issues)
> 
> Alasdair
-- 
christophe varoqui <christophe.varoqui@free.fr>
