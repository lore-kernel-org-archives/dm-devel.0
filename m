From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Fri, 9 Nov 2007 19:48:42 -0600
Message-ID: <20071110014842.GI28113@ether.msp.redhat.com>
References: <20071109002347.GG28113@ether.msp.redhat.com>
	<5201e28f0711090620i7f6360dfr3c0ffa6307ab91e0@mail.gmail.com>
	<20071109202044.GH28113@ether.msp.redhat.com>
	<5201e28f0711091520o3da59658kc41a39bc7e7b855b@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5201e28f0711091520o3da59658kc41a39bc7e7b855b@mail.gmail.com>
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

On Sat, Nov 10, 2007 at 12:20:31AM +0100, Stefan Bader wrote:
>      Any thoughts on this? Good Idea? Worth doing?
> 
>    To be honest, I do not see the real simplification in that many changes.
>    Spreading black- and/or white-lists over so many places seems rather
>    confusion to me. I agree that using devnode names is not ideal for the
>    reasons you mentioned. That was done mainly to have an internal blacklist
>    of known devices that are known not to work. Potentially this could be a
>    device type (= driver name?). But would this not also be possible as a new
>    element of the blacklist? E.g.:
> 
>    blacklist {
>        driver fd
>        driver device-mapper
>        ...
>    }
> 
>    The problem with the current implementation, in my thinking, is that we
>    have a dependency between two sections (blacklist and
>    blacklist_exceptions) and the keywords within. Without reading any further
>    documentation it seems awkward that it is not possible to blacklist device
>    nodes and punch holes by certain wwid numbers. When I think about it, I
>    guess (any other opinions welcome) that a exception is what is really
>    intended to be used. So that should always have more priority than a
>    blacklist. So if the filter finds a matching entry in the
>    blacklist_exceptions section, the device should be used.
> 
>    So my proposal would be:
> 
>    1. process the blacklist_exceptions (any match enables the device)
>    2. process the blacklist
>    3. any device dropping through is also used.
> 
>    Additionally I like the idea of a match-by-driver extension.

The issue I see with doing this is it messes with the one of the reasons
for having the blacklist_exceptions in the first place.

IBM asked for the ability to let customers do

blacklist_exceptions {
       device {
               vendor  "IBM"
               product "S/390.*"
       }
}

So that they could undo the product_blacklist line in the
"IBM:S/390 DASD ECKD" default device configuration.  With the method you
propose, customers will be able to undo that blacklist line. However,
they will either have to use an exception like the one above, which
makes it impossible to then blacklist any of those devices, or they will
have to use an exceptions like

blacklist_exceptions {
	wwid "foo"
	wwid "bar"
	wwid "xyzzy"
	...
}

To manually allow each device. If you have lots of devices, and you want
almost but not all of them multipathed, you no longer have to freedom to
simply blacklist the ones you don't want. With the original method, the
blacklist_exception simply makes it like the product_blacklist line
didn't exist. I'm not sure how much of a bid deal this is.

I agree that it seems wrong that you can't blacklist devices by
devnode, and then punch some holes through by wwid.  However, you are
perfectly able to blacklist devices by wwid and then puch holes through
by wwid, for instance

blacklist {
	wwid ".*"
}

blacklist_exceptions {
	wwid "foo"
}


Another possible redesign, which can do even more complex filtering than
my last method, does away with any need for product_blacklist lines, and
also keeps all the filtering information in one place is to simply have
a two top level sections in the config file, "invalid_drivers" and
"filter"

invalid_drivers {
	driver "string"
}

filter {
	blacklist_driver "string"
	blacklist_wwid "regexp"
	blacklist_device {
		vendor "regexp"
		product "regexp"
	}
	whitelist_driver "string"
	whitelist_wwid "regexp"
	whitelist_device {
		vendor "regexp"
		product "regexp"
	}
}

devices whose driver matches a rule in "invalid_drivers" are totally
ignored by multipath.

In the "filter" section, the blacklist_* rules blacklist devices just
like you would expect, and the whitelist_* rules whitelist them.  The
important thing is that the rules are checked in order, and the first
one to match is used.  The existing "product_blacklist" lines just turn
into "blacklist_device" lines that are checked after all the lines in
multipath.conf. If a device doesn't match any rules, it's allowed.

This works like the lvm.conf filter line, and makes it easy to either
blacklist a group of devices and then whitelist a few of them, or
whitelist a group devices which were blacklisted by default and then
blacklist a few of them. The only downside is that, with this method,
order suddenly matters. Hopefully a helpful comment in the config file
will keep this from confusing people.

# blacklist all scsi devices except the device with wwid "foo"
filter {
	whitelist_wwid "foo"
	blacklist_driver "sd"
}

# Remove the default blacklist for "IBM:S/390 DASD ECKD" devices, and
# then blacklist only the device named "bar"
filter {
	blacklist_wwid "bar"
	whitelist_device {
		vendor "IBM"
		product "S/390.*"
	}
}

Or we can just leave well enough alone.

-Ben

>    Stefan

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
