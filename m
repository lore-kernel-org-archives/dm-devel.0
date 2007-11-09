From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Sat, 10 Nov 2007 00:20:31 +0100
Message-ID: <5201e28f0711091520o3da59658kc41a39bc7e7b855b@mail.gmail.com>
References: <20071109002347.GG28113@ether.msp.redhat.com>
	<5201e28f0711090620i7f6360dfr3c0ffa6307ab91e0@mail.gmail.com>
	<20071109202044.GH28113@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1579105731=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071109202044.GH28113@ether.msp.redhat.com>
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
Cc: Cristophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

--===============1579105731==
Content-Type: multipart/alternative;
	boundary="----=_Part_43150_2979414.1194650431531"

------=_Part_43150_2979414.1194650431531
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>
> Any thoughts on this? Good Idea? Worth doing?
>

To be honest, I do not see the real simplification in that many changes.
Spreading black- and/or white-lists over so many places seems rather
confusion to me. I agree that using devnode names is not ideal for the
reasons you mentioned. That was done mainly to have an internal blacklist of
known devices that are known not to work. Potentially this could be a device
type (= driver name?). But would this not also be possible as a new element
of the blacklist? E.g.:

blacklist {
    driver fd
    driver device-mapper
    ...
}

The problem with the current implementation, in my thinking, is that we have
a dependency between two sections (blacklist and blacklist_exceptions) and
the keywords within. Without reading any further
documentation it seems awkward that it is not possible to blacklist device
nodes and punch holes by certain wwid numbers. When I think about it, I
guess (any other opinions welcome) that a exception is what is really
intended to be used. So that should always have more priority than a
blacklist. So if the filter finds a matching entry in the
blacklist_exceptions section, the device should be used.

So my proposal would be:

1. process the blacklist_exceptions (any match enables the device)
2. process the blacklist
3. any device dropping through is also used.

Additionally I like the idea of a match-by-driver extension.

Stefan

------=_Part_43150_2979414.1194650431531
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>Any thoughts on this? Good Idea? Worth doing?<br></blockquote></div><br>To be honest, I do not see the real simplification in that many changes. Spreading black- and/or white-lists over so many places seems rather confusion to me. I agree that using devnode names is not ideal for the reasons you mentioned. That was done mainly to have an internal blacklist of known devices that are known not to work. Potentially this could be a device type (= driver name?). But would this not also be possible as a new element of the blacklist? 
E.g.:<br><br>blacklist {<br>&nbsp;&nbsp;&nbsp; driver fd<br>&nbsp;&nbsp;&nbsp; driver device-mapper<br>&nbsp;&nbsp;&nbsp; ...<br>}<br><br>The problem with the current implementation, in my thinking, is that we have a dependency between two sections (blacklist and blacklist_exceptions) and the keywords within. Without reading any further
<br>documentation it seems awkward that it is not possible to blacklist device nodes and punch holes by certain wwid numbers. When I think about it, I guess (any other opinions welcome) that a exception is what is really intended to be used. So that should always have more priority than a blacklist. So if the filter finds a matching entry in the blacklist_exceptions section, the device should be used.
<br><br>So my proposal would be:<br><br>1. process the blacklist_exceptions (any match enables the device)<br>2. process the blacklist<br>3. any device dropping through is also used.<br><br>Additionally I like the idea of a match-by-driver extension.
<br><br>Stefan<br>

------=_Part_43150_2979414.1194650431531--


--===============1579105731==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1579105731==--
