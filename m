From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Fri, 9 Nov 2007 14:20:44 -0600
Message-ID: <20071109202044.GH28113@ether.msp.redhat.com>
References: <20071109002347.GG28113@ether.msp.redhat.com>
	<5201e28f0711090620i7f6360dfr3c0ffa6307ab91e0@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5201e28f0711090620i7f6360dfr3c0ffa6307ab91e0@mail.gmail.com>
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

On Fri, Nov 09, 2007 at 03:20:08PM +0100, Stefan Bader wrote:
>    2007/11/9, Benjamin Marzinski <[1]bmarzins@redhat.com>:
> 
>      <snip>.
> 
>      If I recall correctly, blacklist exceptions were originally proposed as
>      a solution to the problem of not being able to remove the bl_product
>      lines from the default device configuration, without reentering the
>      whole configuration for that device.  They were specifically designed so
>      that you could still blacklist the device by wwid and devnode rules.
> 
>    The blacklist exceptions originally  were introduced as  both: a solution
>    to remove a product blacklist without having to specify the other
>    pre-defined settings and a way to enable some devices specifically without
>    having to create a blacklist with holes in it.
>    The way this currently works is a bit surprising. Although there are
>    comments in the annotated config file these are easily missed and this
>    probably should be improved.

The comments from the annotated config file say
## name    : blacklist_exceptions
## scope   : multipath & multipathd
## desc    : list of device names to be treated as multipath candidates
##           even if they are on the blacklist.
##           Note: blacklist exceptions are only valid in the same class.
##           It is not possible to blacklist devices using the devnode keyword
##           and to exclude some devices of them using the wwid keyword.

My patch changes the behavior back to match this description.

>    At the moment devnode black and whitelist has
>    a higher priority than wwid and wwid a higher priority than product
>    blacklist. This means, if you have a devnode blacklist that matches a
>    device, the wwid black and whitelist is never considered.
>    What would work is to blacklist all wwid's and then whitelist the ones
>    that should be used. Usings wwid's instead of the devnodes has the
>    advantage that these are consistent, regardless of the order the devices
>    are added.
>    I am not quite sure which way is better. Should we change the code so a
>    whitelisting is always preceding a blacklist entry or is there a way to
>    point out that there is a certain workflow and mixing devnode and wwid
>    black and whitelists is not working well? Personally I would go for the
>    first option.

Personally, I'd love to see the blacklisting system redesigned to make
it more powerful and initutive

The two big drawbacks with the current system are:
1. That it encourages people to blacklist by devnode, when it's possible
that their devices might come up with different device nodes on future
reboots.
2. If you have many devices but only want to multipath a few of them, it's
more confusing to set up than it needs to be.

One solution would be the following:

1. Drop the existing blacklist config options (blacklist,
blacklist_exceptions). Alternatively, deprecate them, and disallow
mixing the old style and the new style.

2. Add two new sections to the top level of multipath.conf, "invalid_types"
and "blklist" (or "blacklist", if you want to completely drop support
for the current style).

invalid_types {
	type "str"
}

Where "str" is a string of all the device types that multipath will not
do anything with.  This is only used to remove whole types of devices.
Ideally, each line would be a comma seperated list of device types, with
no regular expressions used at all. Something like

invald_types {
	type "ram,raw,loop,fd,md,dm-,sr,sdc,st,hd"
}

When multipath or multipathd sees a device of one of these types, it
just skips it, with no further work, like devnode blacklisted devices
are treated now.

blklist {
	type "str"
}

Where "str" is a string of all the device types to blacklist.  I think
that this string should also only be used to remove whole types of
devices, and not allow regular expressions if possible. Blacklisting a
single device node name, for example "sdc", is really not a good idea,
because sdc is not a persistent name.

When multipath encounters a device of a type listed in this section, it
would continue to collect path information on it, to see if it should
really be blacklisted. This means that multipath would need to run path
discovery on devices which were previously just blacklisted by devnode,
but this should be o.k.

3. Add two new subsections to the devices section, "blklist" and
"whitelist"

devices {
	blklist {
		device {
			vendor "regexp"
			product "regexp"
		}
	}
	whitelist {
		device {
			vendor "regexp"
			product "regexp"
		}
	}
}

Where "regexp" is a regular expression like we currently have for all
the blacklist rules. The devices whitelist overrides the devices
blklist, and both rules override the top level blklist. The
product_blacklist lines (which are retained in this design) will be
converted by multipath to a devices blklist.

4. Add two new subsections to the multipaths section, "blklist" and
"whitelist"

multipaths {
	blklist {
		wwid "regexp"
	}
	whitelist {
		wwid "regexp"
	}
}

Where "regexp" is a regular expression. The multipaths whitelist
overrides the multipaths blacklist, and both rules override the device
rules and the top level rules.


Doing things this way means that blacklisting devices works the same as
the other configuration parameters do, with the multipaths section rules
taking precedence over the devices section rules, and the devices
section rules taking precedence over the default rules.

It easily allows you to do things like

blklist {
	type "sd"
}

devices {
	whitelist {
		vendor "WINSYS"
		product "SF2372"
	}
}

multipaths {
	blklist {
		wwid "3600d0230000000000e13955cc3757803"
	}
}

which blacklists all scsi devices except ones a vendor string of
"WINSYS" and a product string of "SF2372".  From those, only the device
with the wwid of 3600d0230000000000e13955cc3757803 is blacklisted.

The only loss of functionality is that without blacklist_exceptions, you
can't simply negate a product_blacklist line. You will instead be
whitelisting that device, which is not what you might want.  However, I
think that there is a better solution to this problem than
blacklist_exceptions.  Instead, multipath could have a new parameter in
the devices section, "keep_defaults". If users have

keep_defaults	yes

in their multipath.conf device configuration, and there is already a
default device configuration with matching "vendor" and "product"
values, only the fields that the users specificially set will be
changed. The other fields will retain their default values. So, if a
user had the configuration

devices {
	device {
		keep_defaults		yes
		vendor			"IBM"
		product			"S/390 DASD ECKD"
		product_blacklist	""
	}
}

That would only remove the existing product_blacklist, and leave the
rest of the configuration the same.

Any thoughts on this? Good Idea? Worth doing?

-Ben

>    Stefan
> 
> References
> 
>    Visible links
>    1. mailto:bmarzins@redhat.com

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
