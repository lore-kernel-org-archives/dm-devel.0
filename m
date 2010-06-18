From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipath-tools only binding 2 out of 4 paths,
 bug w/ numerous devices?
Date: Fri, 18 Jun 2010 22:58:12 +0200
Message-ID: <1276894693.2081.1.camel@localhost>
References: <5B2DB4801E21E64BB49494533CCF208A07330E95@CWYMSX02.Corp.Acxiom.net>
	<1276887313.2657.1.camel@localhost>
	<5B2DB4801E21E64BB49494533CCF208A07330EB4@CWYMSX02.Corp.Acxiom.net>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5B2DB4801E21E64BB49494533CCF208A07330EB4@CWYMSX02.Corp.Acxiom.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Costaras Steve - stcost <Steve.Costaras@acxiom.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On ven., 2010-06-18 at 14:17 -0500, Costaras Steve - stcost wrote:
> Sorry, I thought I pasted that into the e-mail. 
> 
> This is ubuntu 10.04LTS server running:
> 
> root@behemoth:/usr/src# uname -a
> Linux behemoth 2.6.32-22-server #36-Ubuntu SMP Thu Jun 3 20:38:33 UTC 2010 x86_64 GNU/Linux   on a Dell 6850 with tw qlogic 2344 cards.
> 
> 
> root@behemoth:/usr/src# dpkg -l | grep -i multipath
> ii  multipath-tools                 0.4.8-14ubuntu4                   maintain multipath block device access
> root@behemoth:/usr/src# dpkg -l | grep -i udev
> ii  libudev0                        151-12                            udev library
> ii  udev                            151-12                            rule-based device node and kernel event mana
> root@behemoth:/usr/src# dpkg -l | grep -i devmapp
> ii  libdevmapper-event1.02.1        2:1.02.39-1ubuntu4                The Linux Kernel Device Mapper userspace lib
> ii  libdevmapper1.02.1              2:1.02.39-1ubuntu4                The Linux Kernel Device Mapper userspace lib
> 
> 
> I have just grabbed 4.9 (2010-05-22) and am compiling it now but didn't see anything in the notes as a direct correlation.
> 
ok, please post your results with this version.

with the current version, you could also down the daemon and post the
output of 'multipath -F ; multipath -v4'.

Regards,
-- 
Christophe Varoqui <christophe.varoqui@opensvc.com>
OpenSVC
