From: "--[ UxBoD ]--" <uxbod@splatnix.net>
Subject: Re: How to change alias name
Date: Wed, 3 Feb 2010 14:32:14 +0000 (GMT)
Message-ID: <15161420.813.1265207534823.JavaMail.root@office.splatnix.net>
References: <1265207029.26432.3.camel@zezette>
Reply-To: "--\[ UxBoD \]--" <uxbod@splatnix.net>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1265207029.26432.3.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

----- "Christophe Varoqui" <christophe.varoqui@opensvc.com> wrote:

> You could also start with changing the aliases in
> /etc/multipath.conf,
> run multipath, and reload multipathd config through the CLI or
> restart
> it altogether (which is not risky if there is no degraded situation).
> 
> Works with recent multipath tools versions at least.
> 
> regards,
> cvaroqui
> http://www.opensvc.com
> 
> On mer., 2010-02-03 at 14:16 +0000, --[ UxBoD ]-- wrote:
> > ----- "--[ UxBoD ]--" <uxbod@splatnix.net> wrote:
> > 
> > > Hi,
> > > 
> > > we have a situation where we need to rename a server and would
> also
> > > like to change the associate multipath alias.  Is this possible
> > > without restarting the whole multipath daemon and killing all our
> > > other mounted partitions ?  The server we need to work on is in a
> > > shutdown state so the associated partitions are not active.
> > > 
> > Reading through the documentation if I do:
> > 
> > dmsetup -v status insguest01
> > 
> > I see the following with the Name being the alias.
> > 
> > Name:              insguest01
> > State:             ACTIVE
> > Read Ahead:        1024
> > Tables present:    LIVE
> > Open count:        4
> > Event number:      1
> > Major, minor:      253, 4
> > Number of targets: 1
> > UUID: mpath-3600144f0e2824900000049df899b0002
> > 
> > I can then perform the same command on each of its partitions.  If I
> wanted to rename this guest's devices to insguest02 would I do:
> > 
> > dmsetup rename insguest01 insguest02
> > 
> > then update /etc/multipath.conf so that the alias name reflects the
> new name at boot time ? and would I need to perform the same operation
> on all the partitions as well ?
> >

Thank you Christophe.  We are using device-mapper-multipath-0.4.7-30.el5 under CentOS 5.4 X86_64 so I presume we would be okay ?

-- 
Thanks - Phil
