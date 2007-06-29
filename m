From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: [multipath] SNMP traps on path failures?
Date: Fri, 29 Jun 2007 04:10:17 +0200
Message-ID: <OF1F67B374.28427746-ONC1257311.0023EDCA-C1257311.0025D5C2@de.ibm.com>
References: <1183048699.21973.17.camel@magnus.mirapoint.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1183048699.21973.17.camel@magnus.mirapoint.com>
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

As far as I know path failures generate device-mapper events which a user=
=20
process wait on. In more recent versions
of the library there also is the dmeventd which an application can hook=20
into.

Mit freundlichem Gru=DF / Regards,
Stefan Bader

SW Linux on zSeries Development
Stefan.Bader@de.ibm.com

IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=E4ftsf=FChrung: Herbert Kircher
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
-------------------------------------------------------------------------=
---------
  When all other means of communication fail, try words.

dm-devel-bounces@redhat.com wrote on 28.06.2007 18:38:19:

> So I can look at the log files for path failures, maybe even use
> logsurfer to parse and send a snmp trap. But wouldn't there be nice to
> have som builtin hook to use instead?
>=20
> What's the policy for path failure notifications? Are we simply suppose
> to parse the log files? Are there any enhancements in this field? Or am
> simply missing something very trivial?
>=20
> Using RHEL4u5 if that matters...
>=20
> Best regards,
>  Magnus Hagebris
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
