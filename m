From: "Nath, Varun" <varun.nath@amd.com>
Subject: RE: Need Help
Date: Thu, 17 Jan 2008 15:37:16 -0600
Message-ID: <EEBC5C82F965344199BFA3E6047FE13302E8FF@SAUSEXMB2.amd.com>
References: <1200605663.7183.81.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1200605663.7183.81.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Default boot level is 3

[root@x ~]# chkconfig multipathd --list
multipathd      0:off   1:off   2:on    3:on    4:on    5:on    6:off
[root@x ~]# who -r
         run-level 3  Jan 17 15:04                   last=3DS
[root@ausb3ndadbp02 ~]#

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Chandra Seetharaman
Sent: Thursday, January 17, 2008 3:34 PM
To: device-mapper development
Subject: RE: [dm-devel] Need Help

On Thu, 2008-01-17 at 15:10 -0600, Nath, Varun wrote:
> This is what is happening as soon as the system comes up.=20
>=20
> There are no multipathing devices created. Once I run the multipath
> command only then the /dev/mpath/mpath# devices get created. It looks
> like I am missing some thing when the system boots up. The system has
> the multipathd start up script in /etc/rc3.d.=20

What does "chkconfig --list multipathd" show ?

And what is default level you boot to (i.e what is initdefault
in /etc/inittab) ?

>=20
> Any suggestions?
>=20

<snip>

--=20

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
