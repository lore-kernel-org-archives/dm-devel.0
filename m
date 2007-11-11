From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Sun, 11 Nov 2007 01:25:51 +0100
Message-ID: <5201e28f0711101625r19ceaf11yd3727c424f27b7d8@mail.gmail.com>
References: <20071109002347.GG28113@ether.msp.redhat.com>
	<5201e28f0711090620i7f6360dfr3c0ffa6307ab91e0@mail.gmail.com>
	<20071109202044.GH28113@ether.msp.redhat.com>
	<5201e28f0711091520o3da59658kc41a39bc7e7b855b@mail.gmail.com>
	<20071110014842.GI28113@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1172838011=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071110014842.GI28113@ether.msp.redhat.com>
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

--===============1172838011==
Content-Type: multipart/alternative;
	boundary="----=_Part_44921_9012862.1194740751165"

------=_Part_44921_9012862.1194740751165
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The flaw in Christophe's approach that I see is, that it makes it hard to
see why a device is blacklisted or not. Because the filter checks group
black- and whitelist for each of the keywords. A user does not know which is
the internal sequence of checking.

The issue I see with doing this is it messes with the one of the reasons
> for having the blacklist_exceptions in the first place.

IBM asked for the ability to let customers do
>
> blacklist_exceptions {
>        device {
>                vendor  "IBM"
>                product "S/390.*"
>        }
> }
>
> So that they could undo the product_blacklist line in the
> "IBM:S/390 DASD ECKD" default device configuration.  With the method you


Yes,  without any exceptions it was impossible to get DASDs working without
an extra device section. And this required knowledge of the complete
required parameters. Which renders the internal hardware table useless.

propose, customers will be able to undo that blacklist line. However,
> they will either have to use an exception like the one above, which
> makes it impossible to then blacklist any of those devices, or they will
> have to use an exceptions like
>
> blacklist_exceptions {
>         wwid "foo"
>         wwid "bar"
>         wwid "xyzzy"
>         ...
> }
>
> To manually allow each device. If you have lots of devices, and you want
> almost but not all of them multipathed, you no longer have to freedom to
> simply blacklist the ones you don't want. With the original method, the
>
blacklist_exception simply makes it like the product_blacklist line
> didn't exist. I'm not sure how much of a bid deal this is.


I think this is a real nutshell. At least the device blacklist for DASDs was
not introduced because there is no UID callout but as an easy way to exclude
the devices by default (probably like the driver idea). This was required
because in most cases DASDs are not used for multipathing.
It would be sufficient, if wwid whitelisting could be used to enable some
DASD devices. The UID for them follows a certain scheme and together with
wwid being a regular expression, it would be an acceptable effort to do.

Another possible redesign, which can do even more complex filtering than
> my last method, does away with any need for product_blacklist lines, and
> also keeps all the filtering information in one place is to simply have
> a two top level sections in the config file, "invalid_drivers" and
> "filter"
>
> invalid_drivers {
>         driver "string"
> }
>
> filter {
>         blacklist_driver "string"
>         blacklist_wwid "regexp"
>         blacklist_device {
>                 vendor "regexp"
>                 product "regexp"
>         }
>         whitelist_driver "string"
>         whitelist_wwid "regexp"
>         whitelist_device {
>                 vendor "regexp"
>                 product "regexp"
>         }
> }


I do not understand why the invalid_driver section is required. Would it not
be the same as putting blacklist_driver entries at the beginning of the
filter section? Otherwise I like that idea because it clearly defines the
sequence of filtering visible to the user.

devices whose driver matches a rule in "invalid_drivers" are totally
> ignored by multipath.
>
> In the "filter" section, the blacklist_* rules blacklist devices just
> like you would expect, and the whitelist_* rules whitelist them.  The
> important thing is that the rules are checked in order, and the first
> one to match is used.  The existing "product_blacklist" lines just turn
> into "blacklist_device" lines that are checked after all the lines in
> multipath.conf. If a device doesn't match any rules, it's allowed.
>
> This works like the lvm.conf filter line, and makes it easy to either
> blacklist a group of devices and then whitelist a few of them, or
> whitelist a group devices which were blacklisted by default and then
> blacklist a few of them. The only downside is that, with this method,
> order suddenly matters. Hopefully a helpful comment in the config file
> will keep this from confusing people.
>

In some way order already mattered before. Just not visible to everybody. A
wwid blacklist entry could not blacklist a certain device for which the
device node was whitelisted. I think with the filter idea it would be
possible to get it all together: having an internal filter, the ability to
prevent accessing devices that do not work and also the ability to override
the internal filter if that is desired. Internal filter rules would just be
appended to the user specified list. The only trick might be that a caller
to filter function can specify which specific filters to use.
For example when deciding which devices from /sys/block should be processed
further, only the driver an devnode entries would be evaluated and the first
match is used. Later, if the device vendor and model are known the list of
remaining devices would be again filtered. This time by the device entries.
And finally, if there is a wwid known for each remaining device, filter
those that match a wwid entry.

Stefan

------=_Part_44921_9012862.1194740751165
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div><div>The flaw in Christophe&#39;s approach that I see is, that it makes it hard to see why a device is blacklisted or not. Because the filter checks group black- and whitelist for each of the keywords. A user does not know which is the internal sequence of checking. 
<br><br></div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">The issue I see with doing this is it messes with the one of the reasons<br>for having the blacklist_exceptions in the first place.
</blockquote><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">IBM asked for the ability to let customers do<br><br>blacklist_exceptions {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; device {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vendor&nbsp;&nbsp;&quot;IBM&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; product &quot;S/390.*&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>}<br><br>So that they could undo the product_blacklist line in the<br>&quot;IBM:S/390 DASD ECKD&quot; default device configuration.&nbsp;&nbsp;With the method you
</blockquote><div><br>Yes,&nbsp; without any exceptions it was impossible to get DASDs working without an extra device section. And this required knowledge of the complete required parameters. Which renders the internal hardware table useless.
<br></div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">propose, customers will be able to undo that blacklist line. However,<br>they will either have to use an exception like the one above, which
<br>makes it impossible to then blacklist any of those devices, or they will<br>have to use an exceptions like<br><br>blacklist_exceptions {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wwid &quot;foo&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wwid &quot;bar&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wwid &quot;xyzzy&quot;
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...<br>}<br><br>To manually allow each device. If you have lots of devices, and you want<br>almost but not all of them multipathed, you no longer have to freedom to<br>simply blacklist the ones you don&#39;t want. With the original method, the
<br></blockquote><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">blacklist_exception simply makes it like the product_blacklist line<br>didn&#39;t exist. I&#39;m not sure how much of a bid deal this is.
</blockquote><div><br>I think this is a real nutshell. At least the device blacklist for DASDs was not introduced because there is no UID callout but as an easy way to exclude the devices by default (probably like the driver idea). This was required because in most cases DASDs are not used for multipathing.
<br>It would be sufficient, if wwid whitelisting could be used to enable some DASD devices. The UID for them follows a certain scheme and together with wwid being a regular expression, it would be an acceptable effort to do.
<br></div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Another possible redesign, which can do even more complex filtering than<br>my last method, does away with any need for product_blacklist lines, and
<br>also keeps all the filtering information in one place is to simply have<br>a two top level sections in the config file, &quot;invalid_drivers&quot; and<br>&quot;filter&quot;<br><br>invalid_drivers {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;driver &quot;string&quot;
<br>}<br><br>filter {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;blacklist_driver &quot;string&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;blacklist_wwid &quot;regexp&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;blacklist_device {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;vendor &quot;regexp&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;product &quot;regexp&quot;
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;whitelist_driver &quot;string&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;whitelist_wwid &quot;regexp&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;whitelist_device {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;vendor &quot;regexp&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;product &quot;regexp&quot;
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>}</blockquote><div><br>I do not understand why the invalid_driver section is required. Would it not be the same as putting blacklist_driver entries at the beginning of the filter section? Otherwise I like that idea because it clearly defines the sequence of filtering visible to the user.
<br></div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">devices whose driver matches a rule in &quot;invalid_drivers&quot; are totally
<br>ignored by multipath.<br><br>In the &quot;filter&quot; section, the blacklist_* rules blacklist devices just<br>like you would expect, and the whitelist_* rules whitelist them.&nbsp;&nbsp;The<br>important thing is that the rules are checked in order, and the first
<br>one to match is used.&nbsp;&nbsp;The existing &quot;product_blacklist&quot; lines just turn<br>into &quot;blacklist_device&quot; lines that are checked after all the lines in<br>multipath.conf. If a device doesn&#39;t match any rules, it&#39;s allowed.
<br><br>This works like the lvm.conf filter line, and makes it easy to either<br>blacklist a group of devices and then whitelist a few of them, or<br>whitelist a group devices which were blacklisted by default and then<br>
blacklist a few of them. The only downside is that, with this method,<br>order suddenly matters. Hopefully a helpful comment in the config file<br>will keep this from confusing people.<br></blockquote></div><br>In some way order already mattered before. Just not visible to everybody. A wwid blacklist entry could not blacklist a certain device for which the device node was whitelisted. I think with the filter idea it would be possible to get it all together: having an internal filter, the ability to prevent accessing devices that do not work and also the ability to override the internal filter if that is desired. Internal filter rules would just be appended to the user specified list. The only trick might be that a caller to filter function can specify which specific filters to use.
<br>For example when deciding which devices from /sys/block should be processed further, only the driver an devnode entries would be evaluated and the first match is used. Later, if the device vendor and model are known the list of remaining devices would be again filtered. This time by the device entries. And finally, if there is a wwid known for each remaining device, filter those that match a wwid entry.
<br><br>Stefan<br>

------=_Part_44921_9012862.1194740751165--


--===============1172838011==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1172838011==--
