From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Tue, 13 Nov 2007 14:18:04 -0600
Message-ID: <20071113201804.GJ28113@ether.msp.redhat.com>
References: <20071109002347.GG28113@ether.msp.redhat.com>
	<5201e28f0711090620i7f6360dfr3c0ffa6307ab91e0@mail.gmail.com>
	<20071109202044.GH28113@ether.msp.redhat.com>
	<5201e28f0711091520o3da59658kc41a39bc7e7b855b@mail.gmail.com>
	<20071110014842.GI28113@ether.msp.redhat.com>
	<5201e28f0711101625r19ceaf11yd3727c424f27b7d8@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5201e28f0711101625r19ceaf11yd3727c424f27b7d8@mail.gmail.com>
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

On Sun, Nov 11, 2007 at 01:25:51AM +0100, Stefan Bader wrote:
>      Another possible redesign, which can do even more complex filtering than
>      my last method, does away with any need for product_blacklist lines, and
>      also keeps all the filtering information in one place is to simply have
>      a two top level sections in the config file, "invalid_drivers" and
>      "filter"
> 
>      invalid_drivers {
>              driver "string"
>      }
> 
>      filter {
>              blacklist_driver "string"
>              blacklist_wwid "regexp"
>              blacklist_device {
>                      vendor "regexp"
>                      product "regexp"
>              }
>              whitelist_driver "string"
>              whitelist_wwid "regexp"
>              whitelist_device {
>                      vendor "regexp"
>                      product "regexp"
>              }
>      }
> 
>    I do not understand why the invalid_driver section is required. Would it
>    not be the same as putting blacklist_driver entries at the beginning of
>    the filter section? Otherwise I like that idea because it clearly defines
>    the sequence of filtering visible to the user.

Um. Mostly because I just thought up this idea to address the issues you
had with my first idea.  I though it would be nice if multipath had a
clearly defined set of devices it didn't need to bother checking, and
then it would only need to look at the filter rules after all the path
information had been gathered.  However, you are correct.  Multipath can
just check the blacklist_driver rules at the beginning of the filter
section before gathering path information, and the rest of the rules
afterwards, to achieve the same effect. As a side note, blacklist_driver
should also allow the special string "*", which blacklists all devices.
Also, whitelist_driver rules don't make any sense.

There are some minor issues that crop up, if we do away with
invalid_drivers.

Without the invalid_drivers section, the current default devnode
blacklist rules would turn into blacklist_driver rules that were
automatically appended to the beginning of the filter section.  The
users' inability to whitelist certain devices seems like it would be
less obvious in this situation than it would be if there was a specific
section for invalid devices. But this does seem to be a pretty minor
fault. As a side note, the product_blacklist rules would still need to
become blacklist_device rules that are appended to the end of the filter
section, so it is possible to override them.

There is also the issue of how to keep multipath from doing anything.
Currently, you need to use

blacklist {
	devnode "*"
}

to keep multipath from doing anything to your devices. Unfortunately, if
you use the following

blacklist {
	wwid "*"
}

it doesn't keep multipath from touching your devices (for instance, the
getuid callout is still run on them), although customers might naively
think that it should. With invalid_drivers, it is obvious how to keep
multipath from touching the devices. Without it, you are forced to do

filter {
	blacklist_driver "*"
}

>      devices whose driver matches a rule in "invalid_drivers" are totally
>      ignored by multipath.
> 
>      In the "filter" section, the blacklist_* rules blacklist devices just
>      like you would expect, and the whitelist_* rules whitelist them.  The
>      important thing is that the rules are checked in order, and the first
>      one to match is used.  The existing "product_blacklist" lines just turn
>      into "blacklist_device" lines that are checked after all the lines in
>      multipath.conf. If a device doesn't match any rules, it's allowed.
> 
>      This works like the lvm.conf filter line, and makes it easy to either
>      blacklist a group of devices and then whitelist a few of them, or
>      whitelist a group devices which were blacklisted by default and then
>      blacklist a few of them. The only downside is that, with this method,
>      order suddenly matters. Hopefully a helpful comment in the config file
>      will keep this from confusing people.
> 
>    In some way order already mattered before. Just not visible to everybody.
>    A wwid blacklist entry could not blacklist a certain device for which the
>    device node was whitelisted. I think with the filter idea it would be
>    possible to get it all together: having an internal filter, the ability to
>    prevent accessing devices that do not work and also the ability to
>    override the internal filter if that is desired. Internal filter rules
>    would just be appended to the user specified list. The only trick might be
>    that a caller to filter function can specify which specific filters to
>    use.
>    For example when deciding which devices from /sys/block should be
>    processed further, only the driver an devnode entries would be evaluated
>    and the first match is used. Later, if the device vendor and model are
>    known the list of remaining devices would be again filtered. This time by
>    the device entries. And finally, if there is a wwid known for each
>    remaining device, filter those that match a wwid entry.

If I understand what your idea is, I'm not sure that it's what we want
to do. In my mind, any of the following filters should allow you to
create a multipath device for the device with the wwid "foo"

filter {
	whitelist_wwid "foo"		# foo is a scsi device
	blacklist_driver "sd"
}

filter {
	whitelist_wwid "foo"		# foo is an ACME:WIDGET device
	blacklist_device {
		vendor		"ACME"
		product		"WIDGET"
	}
}

filter {
	whitelist_wwid "foo"	# foo is an "IBM:S/390 DASD ECKD" device
}

If you only looked at driver entries when deciding whether to continue
processing a devices in /sys/block, or only looked at device entries
once the vendor/product info was known, you would never get to the wwid.

I think a better way is to have multipath only apply the
blacklist_driver filters at the beginning of the filter section, when it
is deciding whether to process a device in /sys/block. If the device is
not blacklisted by the time multipath hits a non-"blacklist_driver"
rule, then multipath goes ahead and gathers path information.

If we wanted, we could do the same type of thing after multipath gets
the vendor and product information, however multipath doesn't currently
check if the device is blacklisted at this point. But again, I think we
should only apply the blacklist_device rules at the beginning of the
filter list (after any blacklist_driver rules, of course).

The only problem with just checking the beginning rules, is in has the
potential to surprise users.  For instance, if a user changes their
configuration from 

filter {
	blacklist_driver "cciss"
}

to

filter {
	whitelist_wwid "foo"	# foo is NOT a "cciss" device
	blacklist_driver "cciss"
}

suddenly, the user's cciss devices are going to be checked. They will
stay blacklisted, but if the getuid callout wasn't working on them,
multipath will suddenly start spitting out warning messages.  This is
another issue that would be solved by having an invalid_drivers section.


Finally, you mentioned devnode rules.  Do you think that they are
necessary?  The purpose of the driver rules is to replace the devnode
rules with ones that don't allow users to do things like

blacklist {
	devnode "sdc"
}

which can be done other ways, and might end up doing the wrong thing
later if their device names change.

-Ben

> 
>    Stefan

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
