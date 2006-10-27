From: "Herr, Manuel" <mher@msc-ge.com>
Subject: AW: dm-0
Date: Fri, 27 Oct 2006 10:36:30 +0200
Message-ID: <C514D40EFDB5C84083DAEB84A1186A8F94CCED@msc-ex02.msc-ge.mscnet>
References: <20061027073451.33894.qmail@web56112.mail.re3.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20061027073451.33894.qmail@web56112.mail.re3.yahoo.com>
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

No, the /dev/dm* devices are recreated every reboot.
Only the wwids in /dev/mapper/ are persistant. (/dev/disk/by-name/<wwid>)
Use them for mountpoint in the fstab.=20

/dev/disk/by-name/data1 /usr/sap reiserfs acl,user_xattr 1 2

You can alias the horrible wwid by logical names in the multipath.conf.
E.g.

multipaths {
        multipath
        {
                #mountpoint /data
                wwid 360060160403219007aa7b461c917db11
                alias data
        }
}
This will create an link /dev/mapper/data1 -> /dev/dm-<actualNumber>

Take a look at the boot.multipath script.

*snip*
# Clear /dev/disk/by-name/ prior to start-up; multipath will
        # recreate them.
        rm -f /dev/disk/by-name/* 2>&1 >/dev/null
*snap*

Regards,
Manuel

> -----Urspr=FCngliche Nachricht-----
> Von: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] Im Auftrag von lnx dm
> Gesendet: Freitag, 27. Oktober 2006 09:35
> An: dm
> Betreff: [dm-devel] dm-0
>=20
> will dm-0 will always point to the same device across reboots=20
> irrespective of the the order in which devices are detected ?
> which is persistent /dev/dm-0 or /dev/mapper/<wwid> ?
>=20
> # ls -l /dev/mpath/
> lrwxrwxrwx  1 root root 7 Mar 24 01:45
> 3600805f300176640a435a927359c0003 -> ../dm-0
>=20
> -lnxdm
>=20
> __________________________________________________
> Do You Yahoo!?
> Tired of spam?  Yahoo! Mail has the best spam protection=20
> around http://mail.yahoo.com=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
