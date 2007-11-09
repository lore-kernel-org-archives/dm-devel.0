From: "Stefan Bader" <sbader3@googlemail.com>
Subject: Re: Multipath blacklist exceptions issues
Date: Fri, 9 Nov 2007 15:20:08 +0100
Message-ID: <5201e28f0711090620i7f6360dfr3c0ffa6307ab91e0@mail.gmail.com>
References: <20071109002347.GG28113@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2109237426=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071109002347.GG28113@ether.msp.redhat.com>
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

--===============2109237426==
Content-Type: multipart/alternative;
	boundary="----=_Part_41488_33386855.1194618008987"

------=_Part_41488_33386855.1194618008987
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2007/11/9, Benjamin Marzinski <bmarzins@redhat.com>:
>
> <snip>.
>
> If I recall correctly, blacklist exceptions were originally proposed as
> a solution to the problem of not being able to remove the bl_product
> lines from the default device configuration, without reentering the
> whole configuration for that device.  They were specifically designed so
> that you could still blacklist the device by wwid and devnode rules.


The blacklist exceptions originally  were introduced as  both: a solution to
remove a product blacklist without having to specify the other pre-defined
settings and a way to enable some devices specifically without having to
create a blacklist with holes in it.
The way this currently works is a bit surprising. Although there are
comments in the annotated config file these are easily missed and this
probably should be improved. At the moment devnode black and whitelist has a
higher priority than wwid and wwid a higher priority than product blacklist.
This means, if you have a devnode blacklist that matches a device, the wwid
black and whitelist is never considered.
What would work is to blacklist all wwid's and then whitelist the ones that
should be used. Usings wwid's instead of the devnodes has the advantage that
these are consistent, regardless of the order the devices are added.
I am not quite sure which way is better. Should we change the code so a
whitelisting is always preceding a blacklist entry or is there a way to
point out that there is a certain workflow and mixing devnode and wwid black
and whitelists is not working well? Personally I would go for the first
option.


Stefan

------=_Part_41488_33386855.1194618008987
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br><br><div><span class="gmail_quote">2007/11/9, Benjamin Marzinski &lt;<a href="mailto:bmarzins@redhat.com">bmarzins@redhat.com</a>&gt;:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
&lt;snip&gt;.<br><br>If I recall correctly, blacklist exceptions were originally proposed as<br>a solution to the problem of not being able to remove the bl_product<br>lines from the default device configuration, without reentering the
<br>whole configuration for that device.&nbsp;&nbsp;They were specifically designed so<br>that you could still blacklist the device by wwid and devnode rules.</blockquote><div><br>The blacklist exceptions originally&nbsp; were introduced as&nbsp; both: a solution to remove a product blacklist without having to specify the other pre-defined settings and a way to enable some devices specifically without having to create a blacklist with holes in it.
<br>The way this currently works is a bit surprising. Although there are comments in the annotated config file these are easily missed and this probably should be improved. At the moment devnode black and whitelist has a higher priority than wwid and wwid a higher priority than product blacklist. This means, if you have a devnode blacklist that matches a device, the wwid black and whitelist is never considered.
<br>What would work is to blacklist all wwid&#39;s and then whitelist the ones that should be used. Usings wwid&#39;s instead of the devnodes has the advantage that these are consistent, regardless of the order the devices are added.
<br>I am not quite sure which way is better. Should we change the code so a whitelisting is always preceding a blacklist entry or is there a way to point out that there is a certain workflow and mixing devnode and wwid black and whitelists is not working well? Personally I would go for the first option.
<br><br></div></div><br>Stefan

------=_Part_41488_33386855.1194618008987--


--===============2109237426==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2109237426==--
