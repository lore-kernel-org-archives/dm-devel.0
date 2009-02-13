From: "Allen, Jack" <Jack.Allen@mckesson.com>
Subject: RE: Changing SAN vendors
Date: Fri, 13 Feb 2009 16:47:32 -0600
Message-ID: <4905EFD192EEDF4A9A19EEE98C32B7F70F48AE12@DBQV3005.na.corp.mckesson.com>
References: <4905EFD192EEDF4A9A19EEE98C32B7F70EFB4A29@DBQV3005.na.corp.mckesson.com>	<4905EFD192EEDF4A9A19EEE98C32B7F70F0DC22D@DBQV3005.na.corp.mckesson.com><4905EFD192EEDF4A9A19EEE98C32B7F70F3EB744@DBQV3005.na.corp.mckesson.com>
	<49954B5F.5080209@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <49954B5F.5080209@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <49954B5F.5080209@redhat.com>
References: <4905EFD192EEDF4A9A19EEE98C32B7F70EFB4A29@DBQV3005.na.corp.mckesson.com>	<4905EFD192EEDF4A9A19EEE98C32B7F70F0DC22D@DBQV3005.na.corp.mckesson.com><4905EFD192EEDF4A9A19EEE98C32B7F70F3EB744@DBQV3005.na.corp.mckesson.com>
	<49954B5F.5080209@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bmr@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

=20

-----Original Message-----
From: Bryn M. Reeves [mailto:bmr@redhat.com]=20
Sent: Friday, February 13, 2009 5:29 AM
To: device-mapper development
Subject: Re: [dm-devel] Changing SAN vendors

Allen, Jack wrote:
> Hello:
>     Still looking for an answer for RH AS 4.7.
> =20
>     No body has any ideas?

The mpath names change because the XP is exporting the storage with=20
new WWIDs (multipath-tools name binding is all based on LUN WWIDs).=20
The bindings are stored in a file that is normally automatically=20
generated and maintained.

I think in your stiuation if you need to preserve the old names, your=20
best option is to manually edit the bindings file and copy it between=20
the hosts that need to have a common view of the storage.

The default location for the file is /var/lib/multipath/bindings,=20
although if you have /var configured as a separate file system you=20
should move it to /etc and configure the bindings_file option in=20
multipath.conf to avoid problems when initialising multipath devices=20
before /var is mounted.

You could also take the steps that Tore suggested and configure=20
multipath entries in multipath.conf to map the devices but unless you=20
are happy with giving them new names this isn't going to work as the=20
current multipath-tools will give undefined behaviour if you use=20
"mpathN" style names for aliases defined in multipath.conf.

Regards,
Bryn.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Thanks.

I do have /var as a separate file system and as you said it may not be
mounted when multipathd first starts. I will mv the bindings file to
/etc and make the change in multipath.conf.

-----
Thanks:
Jack Allen
