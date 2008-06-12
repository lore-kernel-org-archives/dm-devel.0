From: Guido =?iso-8859-1?Q?G=FCnther?= <agx@sigxcpu.org>
Subject: Re: Questin about device mapper, Debian and devices
Date: Thu, 12 Jun 2008 10:44:49 +0200
Message-ID: <20080612084448.GA12178@bogon.ms20.nix>
References: <454237550806090308j20a29e58w7dc22b89ce055e5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <454237550806090308j20a29e58w7dc22b89ce055e5@mail.gmail.com>
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

On Mon, Jun 09, 2008 at 12:08:51PM +0200, January Weiner wrote:
> I am running a server with Debian stable. After a recent automatic
> update and an unrelated reboot suddenly I could not mount some of my
> hard disks any more. For example,
The automatic update wouldn't pull in multipath-tools. So you either
installed it directly or pulled it in via a dependency (most people
install it since kpartx isn't split into it's own package in etch).
Have a look /etc/init.d/*multipath*. Disabling these should help.
Cheers,
 -- Guido
