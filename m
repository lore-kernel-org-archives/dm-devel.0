From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: User friendly names patch.
Date: Tue, 25 Oct 2005 10:41:21 +0200
Message-ID: <20051025084121.GA17494@free.fr>
References: <20051021233521.GA32160@phlogiston.msp.redhat.com>
	<1129967524.7313.65.camel@zezette>
	<20051024164902.GB19176@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20051024164902.GB19176@phlogiston.msp.redhat.com>
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

> > One of my worry is that /var/lib/multipath/bindings is not available in
> > early userspace. Is this taken care of. Also remember not relying on
> > hotplug to execute multipath in early userspace is a redhat choice.
> > Others strategy may differ.
> 
> To make this work seamlessly with early userspace, You would need to add
> the correct /var/lib/multipath/bindings file to the initrd. The easiest work
> around to to simply stick the alias for that device in /etc/multipath.conf.
> 
> To make this work without editing the initrd or forcing people to have
> aliases in their config files, you would need to change multipath behavior.
> Currently, if multipath finds a device with the same wwid and a different
> alias, it removes the device and recreates it.  If it simply just left the
> device with the old name, then you would not get the benefit of user friendly
> names for devices that were started in early userspace, but you would not
> be any worse off than before. (Well, not quite. A binding would exist for the
> device in the bindings file, and if on some other boot, that multipath wasn't
> created in early userspace, when it got created it would use the name from
> the bindings file). This method would also require a command line option to
> override the "user_friendly_names" config file option in early userspace.
> 
ok,

let me know what you think of the following early userspace scenario sketch.
It aleviates the bindings sync issues between early and normal userspace.

Pre-requisites :
- no multipath config or binding files packaged in early userspace
- move bindings from /var to /etc

early userspace trace :
- load storage drivers
- path nodes are created
- lookup the rootdev wwid in a config file created at system install time or
  by init{ramfs,rd} rebuild script
- exec "multipath $wwid" : the scope limiting is the trick as only root dev
  map gets created. All defaults will apply : failover policy, etc ...
- mount /dev/mapper/$wwid
- pump config and bindings in early userspace namespace
- umount root fs
- exec "multipath $wwid" again
- deduce $alias from {bindings file & $wwid}
- mount /dev/mapper/$alias

Regards,
cvaroqui
