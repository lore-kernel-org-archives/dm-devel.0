From: <Harald_Jensas@Dell.com>
Subject: RE: Trying to blacklist a USB memory stick
Date: Tue, 30 Sep 2008 12:47:34 +0200
Message-ID: <87C820D35C176D428A1A8A3B34F6FB86C274D4@uppx3m1.upp.emea.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

I just subscribed to the list, I am an enterprise deployment engineer at =
Dell and do frequently work with device-mapper-multipath. A few weeks bac=
k I configured the SAN storage for 4 RHEL 5 servers that will be an Oracl=
e RAC cluster. Now the customer plugged an USB key into 2 of the systems,=
 and he noticed that device-mapper-multipath creates a device and adds a =
binding to /var/lib/multipath/bindings.=20

Att: Mark Bruen
Did you ever solve your problem?

=09
I was thinking of doing something like this as a solution:

blacklist {
       wwid *
	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
	devnode "^hd[a-z]"
}
blacklist_exceptions {
	wwid <WWID>
	wwid <WWID>
	wwid <WWID>
}

E.g blacklist all wwid's as default, then specifically add an exception f=
or each wwid that go with a "storage address space" that I want to use Mu=
ltipath to manage. It is a bit more administrative overhead, but it will =
allow strict control of what devices dm-mp is controlling.


Another idea is to blacklist all devices, and make exceptions for the dev=
ice I want Multipath to control:

blacklist {
	device {
		vendor 	"*"
		product 	"*"
	}=09
	devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
	devnode "^hd[a-z]"
}
blacklist_exceptions {
	device {
		vendor		"DGC"
		product 	"*"
	}
}


Comments appreciated.

Thanks!



--
Harald Jens=E5s
Dell EDT | NER (Sweden)





-------------------------------------------------------------------------=
------------
    * From: "Bruen, Mark" <mbruen trilegiant com>
    * To: device-mapper development <dm-devel redhat com>
    * Subject: [dm-devel] Trying to blacklist a USB memory stick
    * Date: Fri, 14 Jul 2006 10:38:33 -0400

I'm trying to blacklist a USB memory stick in /etc/multipath.conf. The ou=
tput of multipath -v4:

=3D=3D=3D=3D=3D path sdar =3D=3D=3D=3D=3D
bus =3D 1
dev_t =3D 66:176
size =3D 126976

vendor =3D product =3D USB DISK 2.0 rev =3D 1.16

h:b:t:l =3D 3:0:0:0
tgt_node_name =3D
failed to open /dev/sdar


I've tried this with the "h:b:t:l" alone and with the "product" alone (ne=
ither work):

devnode_blacklist {
#   devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|sda|sdb|hdc)[0-9]*"
   devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|hdc)[0-9]*"
   devnode "sda "
   devnode "sdb "
   wwid 350002ac0001302c6
   wwid 350002ac0002502c6
   device {
       h:b:t:l =3D 3:0:0:0
       product "USB DISK 2.0"
   }
}

Any ideas? Thanks.
-Mark
