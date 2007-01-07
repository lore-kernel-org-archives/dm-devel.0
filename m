From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [Patch] mp-tools: exception list handling
Date: Mon, 08 Jan 2007 00:08:13 +0100
Message-ID: <1168211293.29097.11.camel@localhost.localdomain>
References: <20061207150313.8b4c4f5b.sameske@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061207150313.8b4c4f5b.sameske@de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Volker Sameske <sameske@de.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Le jeudi 07 d=C3=A9cembre 2006 =C3=A0 15:03 +0100, Volker Sameske a =C3=A9=
crit :

> On IBM System z we often have the problem that we have attached
> several hundred devices. In case we want to use only a few of them
> with mp-tools, we have to blacklist all others. For that reason I have
> introduced a blacklist_exception keyword for the multipath.conf  which
> fills an internal exception list.
>=20
> Additionally this patch adds two commands to the multipathd cli to=20
> display blacklist rules and blacklisted devices.
>=20
> ------------------- snip --------------------
> blacklist {
>         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>         devnode "^hd[a-z][[0-9]*]"
>         devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
>         devnode "^dasd[a-z]+[0-9]*"
> }
> blacklist_exceptions {
>         devnode "^dasd[c-d]+[0-9]*"
> }
...
> multipathd> show blacklist
> device node rules:
> - blacklist:
>         (config file rule) ^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*
>         (config file rule) ^hd[a-z][[0-9]*]
>         (config file rule) ^cciss!c[0-9]d[0-9]*[p[0-9]*]
>         (config file rule) ^dasd[a-z]+[0-9]*
>         (default rule)     ^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*
>         (default rule)     ^hd[a-z]
>         (default rule)     ^cciss!c[0-9]d[0-9]*
> - exceptions:
>         (config file rule) ^dasd[c-d]+[0-9]*
> wwid rules:
> - blacklist:
>         <empty>
> - exceptions:
>         <empty>
> device rules:
> - blacklist:
>         (default rule)     DGC:LUNZ
> multipathd>
>=20
> multipathd> show devices
> available block devices:
>     dasda (blacklisted)
>     dasdb (blacklisted)
>     dasdc
>     dasdd
>     dm-0 (blacklisted)
...
> =20
> ------------------- snap --------------------
>=20
Hello,

I merged the latest version of your patch.

Minor mangling : I had to rename your snprint_blacklist() rewrite to
snprint_blacklist_report() because the "show config" CLI command purpose
is to dump a config file in sync with the daemon actual configuration.
Your stealing the snprint_blacklist() fn name made for your blacklist
"report" to be included in this dump in place of the correct "blacklist
{}" block.

I also implemented the missing snprint_blacklist_exceptions() for config
dump completeness.

Please verify everything is still working for you.

Thanks for this nicely crafted work.
Regards,
cvaroqui
