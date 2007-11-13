From: "Stefan Bader" <sbader3@googlemail.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Wed, 14 Nov 2007 00:17:25 +0100
Message-ID: <5201e28f0711131517p79fc4a8dk1da9bda922c3093e@mail.gmail.com>
References: <20071109002347.GG28113@ether.msp.redhat.com>
	<5201e28f0711090620i7f6360dfr3c0ffa6307ab91e0@mail.gmail.com>
	<20071109202044.GH28113@ether.msp.redhat.com>
	<5201e28f0711091520o3da59658kc41a39bc7e7b855b@mail.gmail.com>
	<20071110014842.GI28113@ether.msp.redhat.com>
	<5201e28f0711101625r19ceaf11yd3727c424f27b7d8@mail.gmail.com>
	<20071113201804.GJ28113@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0236430065=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071113201804.GJ28113@ether.msp.redhat.com>
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

--===============0236430065==
Content-Type: multipart/alternative;
	boundary="----=_Part_1852_11634039.1194995845521"

------=_Part_1852_11634039.1194995845521
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>
>
> Um. Mostly because I just thought up this idea to address the issues you
> had with my first idea.  I though it would be nice if multipath had a
> clearly defined set of devices it didn't need to bother checking, and
> then it would only need to look at the filter rules after all the path
> information had been gathered.  However, you are correct.  Multipath can
> just check the blacklist_driver rules at the beginning of the filter
> section before gathering path information, and the rest of the rules
> afterwards, to achieve the same effect. As a side note, blacklist_driver
> should also allow the special string "*", which blacklists all devices.
> Also, whitelist_driver rules don't make any sense.


I tried to avoid having multiple filter-defining sections but I must admit
having everything in one section might be confusing as well. The problem is,
that there are three stages at which a decission has to be made to continue
or not. First by driver or node name (Kiyoshi has a valid argument there).
Every match at this early stage prevents useless work. Whitelist rules for
driver and devnode make sense if internal rules have to be reversed (e.g.
internal blacklist uses blacklist_driver "*").
Second stage is to check whether it makes sense to continue with a certain
class of devices (from vendor, model). At this point I do not think it makes
sense to look at the driver and devnode rules again.
And finally, if the UID information has been gathered, there would be the
moment to check which of them should be used.

When the current code does the final filtering it goes again through all
stacked filters and by that a whitelist for a devnode(range) cannot be
limited by a wwid blacklist.

There are some minor issues that crop up, if we do away with
> invalid_drivers.
>
> Without the invalid_drivers section, the current default devnode
> blacklist rules would turn into blacklist_driver rules that were
> automatically appended to the beginning of the filter section.  The


Not appended at the beginning, because that could never be changed by
user-specified  rules. Everything pre-defined would have to get appended
after the user defined list.

users' inability to whitelist certain devices seems like it would be
> less obvious in this situation than it would be if there was a specific
> section for invalid devices. But this does seem to be a pretty minor
> fault. As a side note, the product_blacklist rules would still need to
> become blacklist_device rules that are appended to the end of the filter
> section, so it is possible to override them.


Yes.

There is also the issue of how to keep multipath from doing anything.
> Currently, you need to use
>
> blacklist {
>         devnode "*"
> }
>
> to keep multipath from doing anything to your devices. Unfortunately, if
> you use the following
>
> blacklist {
>         wwid "*"
> }
>
> it doesn't keep multipath from touching your devices (for instance, the
> getuid callout is still run on them), although customers might naively
> think that it should. With invalid_drivers, it is obvious how to keep
> multipath from touching the devices. Without it, you are forced to do


Not if devnode (and driver) rules are checked before the other rules.

filter {
>         blacklist_driver "*"
> }





> If I understand what your idea is, I'm not sure that it's what we want
> to do. In my mind, any of the following filters should allow you to
> create a multipath device for the device with the wwid "foo"


I admit my idea had a major flaw. It is just not compatible with the way
device detection is run. It might turn out that the only thing that has to
be changed is to change which filter rules are used at a certain point of
the detection.

Decide which device to ignore at all:
- look at the whitelist entries for devnode (and driver), continue to check
if found
- look at the blacklist entries for devnode (and driver), do not use if
found
- no match, continue
Decide for which devices to call getuid:
- look at the whitelist entries for device, continue to check if found
- look at the blacklist entries for device, do not use if found
- no match, continue
Decide which UIDs should be used:
- look at the whitelist entries for wwid, use if found
- look at the blacklist entries for wwid, do not use if found
- no match, use device


Stefan

------=_Part_1852_11634039.1194995845521
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>Um. Mostly because I just thought up this idea to address the issues you<br>had with my first idea.&nbsp;&nbsp;I though it would be nice if multipath had a
<br>clearly defined set of devices it didn&#39;t need to bother checking, and<br>then it would only need to look at the filter rules after all the path<br>information had been gathered.&nbsp;&nbsp;However, you are correct.&nbsp;&nbsp;Multipath can
<br>just check the blacklist_driver rules at the beginning of the filter<br>section before gathering path information, and the rest of the rules<br>afterwards, to achieve the same effect. As a side note, blacklist_driver<br>
should also allow the special string &quot;*&quot;, which blacklists all devices.<br>Also, whitelist_driver rules don&#39;t make any sense.</blockquote><div><br>I tried to avoid having multiple filter-defining sections but I must admit having everything in one section might be confusing as well. The problem is, that there are three stages at which a decission has to be made to continue or not. First by driver or node name (Kiyoshi has a valid argument there). Every match at this early stage prevents useless work. Whitelist rules for driver and devnode make sense if internal rules have to be reversed (
e.g. internal blacklist uses blacklist_driver &quot;*&quot;).<br>Second stage is to check whether it makes sense to continue with a certain class of devices (from vendor, model). At this point I do not think it makes sense to look at the driver and devnode rules again.
<br>And finally, if the UID information has been gathered, there would be the moment to check which of them should be used.<br><br>When the current code does the final filtering it goes again through all stacked filters and by that a whitelist for a devnode(range) cannot be limited by a wwid blacklist.
<br></div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">There are some minor issues that crop up, if we do away with<br>invalid_drivers.
<br><br>Without the invalid_drivers section, the current default devnode<br>blacklist rules would turn into blacklist_driver rules that were<br>automatically appended to the beginning of the filter section.&nbsp;&nbsp;The</blockquote>
<div><br>Not appended at the beginning, because that could never be changed by&nbsp; user-specified&nbsp; rules. Everything pre-defined would have to get appended after the user defined list.<br></div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
users&#39; inability to whitelist certain devices seems like it would be<br>less obvious in this situation than it would be if there was a specific<br>section for invalid devices. But this does seem to be a pretty minor<br>
fault. As a side note, the product_blacklist rules would still need to<br>become blacklist_device rules that are appended to the end of the filter<br>section, so it is possible to override them.</blockquote><div><br>Yes. 
<br></div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">There is also the issue of how to keep multipath from doing anything.<br>Currently, you need to use
<br><br>blacklist {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;*&quot;<br>}<br><br>to keep multipath from doing anything to your devices. Unfortunately, if<br>you use the following<br><br>blacklist {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wwid &quot;*&quot;<br>}<br><br>
it doesn&#39;t keep multipath from touching your devices (for instance, the<br>getuid callout is still run on them), although customers might naively<br>think that it should. With invalid_drivers, it is obvious how to keep
<br>multipath from touching the devices. Without it, you are forced to do</blockquote><div><br>Not if devnode (and driver) rules are checked before the other rules.<br></div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
filter {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;blacklist_driver &quot;*&quot;<br>}</blockquote><div><br>&nbsp;</div><br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
If I understand what your idea is, I&#39;m not sure that it&#39;s what we want<br>to do. In my mind, any of the following filters should allow you to<br>create a multipath device for the device with the wwid &quot;foo&quot;
</blockquote><div><br>I admit my idea had a major flaw. It is just not compatible with the way device detection is run. It might turn out that the only thing that has to be changed is to change which filter rules are used at a certain point of the detection.
<br><br>Decide which device to ignore at all:<br>- look at the whitelist entries for devnode (and driver), continue to check if found<br>- look at the blacklist entries for devnode (and driver), do not use if found<br>- no match, continue
<br>Decide for which devices to call getuid:<br>- look at the whitelist entries for device, continue to check if found<br>- look at the blacklist entries for device, do not use if found<br>- no match, continue<br>Decide which UIDs should be used:
<br>- look at the whitelist entries for wwid, use if found<br>- look at the blacklist entries for wwid, do not use if found<br>- no match, use device<br><br></div></div><br>Stefan

------=_Part_1852_11634039.1194995845521--


--===============0236430065==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0236430065==--
