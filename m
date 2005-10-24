From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: User friendly names patch.
Date: Mon, 24 Oct 2005 11:49:02 -0500
Message-ID: <20051024164902.GB19176@phlogiston.msp.redhat.com>
References: <20051021233521.GA32160@phlogiston.msp.redhat.com>
	<1129967524.7313.65.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1129967524.7313.65.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Oct 22, 2005 at 09:52:04AM +0200, Christophe Varoqui wrote:
> On ven, 2005-10-21 at 18:35 -0500, Benjamin Marzinski wrote:
> > This is a patch to add the option of more user friendly names for the
> > multipath maps, in the form of mpath<n>.  It adds a configuration option
> > "user_friendly_names". If set, it will cause multipath to check a bindings
> > file for the names. The bindings file (/var/lib/multipath/bindings) has
> > alias to wwid mappings. If multipath finds its wwid in the file, it uses
> > the associated alias. If not, it creates a new alias, and adds the binding
> > to the bindings file. If the config option is not set, multipath defaults
> > to it's regular behavior. Specific aliases in /etc/multipath.conf override
> > this behavior.
> > 
> On eof my worry is that /var/lib/multipath/bindings is not available in
> early userspace. Is this taken care of. Also remember not relying on
> hotplug to execute multipath in early userspace is a redhat choice.
> Others strategy may differ.

To make this work seamlessly with early userspace, You would need to add
the correct /var/lib/multipath/bindings file to the initrd. The easiest work
around to to simply stick the alias for that device in /etc/multipath.conf.

To make this work without editing the initrd or forcing people to have
aliases in their config files, you would need to change multipath behavior.
Currently, if multipath finds a device with the same wwid and a different
alias, it removes the device and recreates it.  If it simply just left the
device with the old name, then you would not get the benefit of user friendly
names for devices that were started in early userspace, but you would not
be any worse off than before. (Well, not quite. A binding would exist for the
device in the bindings file, and if on some other boot, that multipath wasn't
created in early userspace, when it got created it would use the name from
the bindings file). This method would also require a command line option to
override the "user_friendly_names" config file option in early userspace.

 
> Regards,
> cvaroqui
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
