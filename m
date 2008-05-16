From: "Craig Simpson" <csimpson@visto.com>
Subject: RE: multipathd: error calling out mpath_prio_hds_modular
Date: Fri, 16 May 2008 16:34:23 -0700
Message-ID: <ABFD05FF09D13E4883B757E75603624D011E9515@ex-sea1.vistocorp.com>
References: <1210966544.12901.51.camel@plop><ABFD05FF09D13E4883B757E75603624D011E94FF@ex-sea1.vistocorp.com><20080516210137.GA1286@us.ibm.com>
	<ABFD05FF09D13E4883B757E75603624D011E9514@ex-sea1.vistocorp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <ABFD05FF09D13E4883B757E75603624D011E9514@ex-sea1.vistocorp.com>
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


The symlink didn't work, but coping the file to / worked.=20

YES!!!

Thank You!
Craig

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Craig Simpson
Sent: Friday, May 16, 2008 4:19 PM
To: device-mapper development
Subject: RE: [dm-devel] multipathd: error calling out
mpath_prio_hds_modular



I put a symlink in /=20
ln -s  /sbin/mpath_prio_hds_modular mpath_prio_hds_modular

But it still has the error.=20

Where would I edit my /etc/multipath.conf to set this?=20

Thanks!
Craig

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of malahal@us.ibm.com
Sent: Friday, May 16, 2008 2:02 PM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] multipathd: error calling out
mpath_prio_hds_modular

The multipathd tried calling mpath_prio_hds_modular program but it could
not find it! There is a bug in some version of RHEL where multipath has
"mpath_prio_hds_modular" instead of "/sbin/mpath_prio_hds_modular".
Update your multipath tools package or fix it in your
/etc/multipath.conf (this requires some careful modifications!)

--Malahal.
PS: since execv looks for your executable file in the 'cwd', you can
probably make it work by just copying /sbin/mpath_prio_hds_modular to
/mpath_prio_hds_modular (I am assuming that multipathd daemon makes "/"
as it ***home*** before calling this.)

Craig Simpson [csimpson@visto.com] wrote:
>=20
> My RedHat 5.1 ES server (actually it is that but rebranded as Oracles
> latest Linux) is  logging this in /var/log/message all the time.=20
>=20
> It is attached to a Hitachi SAN device.=20
>=20
> All seems to be working OK, but these errors go on and on.=20
>=20
> Don't get what they mean?
>=20
> May 16 19:48:01 wpe01 multipathd: error calling out
> mpath_prio_hds_modular 65:0
> May 16 19:48:01 wpe01 multipathd: error calling out
> mpath_prio_hds_modular 65:16
> May 16 19:48:01 wpe01 multipathd: error calling out
> mpath_prio_hds_modular 65:32
> May 16 19:48:01 wpe01 multipathd: error calling out
> mpath_prio_hds_modular 65:48
> May 16 19:48:01 wpe01 multipathd: error calling out
> mpath_prio_hds_modular 65:64
> May 16 19:48:01 wpe01 multipathd: error calling out
> mpath_prio_hds_modular 65:80
> May 16 19:48:01 wpe01 multipathd: error calling out
> mpath_prio_hds_modular 8:0
> May 16 19:48:01 wpe01 multipathd: error calling out
> mpath_prio_hds_modular 8:16
> May 16 19:48:01 wpe01 multipathd: error calling out
> mpath_prio_hds_modular 8:32
> May 16 19:48:01 wpe01 multipathd: error calling out
> mpath_prio_hds_modular 8:48
>=20
>=20
> Craig
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
