From: "jean Diallo" <diallo.jean@gmail.com>
Subject: hardware_handler error with HP MSA1000
Date: Tue, 12 Aug 2008 11:47:24 +0200
Message-ID: <e368f40808120247q2c4eed53hc8f527e4a69e1992@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0880806398=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============0880806398==
Content-Type: multipart/alternative;
	boundary="----=_Part_33867_28951856.1218534444255"

------=_Part_33867_28951856.1218534444255
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi
I have been strugling with an HP MSA1000 for a few weeks now.
I am using the old active/passive firmware.
Here is the device section of my multipath.conf :

devices {
	device {
		vendor 		"COMPAQ"
		product		"MSA1000"
		hardware_handler	"1 hp_sw"
		path_grouping_policy	group_by_prio
		path_checker	hp_sw
 			 		
 	}
}


I am under RHEL5.2 and this is the rpm package of dm-multipath 0.4.7-16.el5.
Here is my /var/log/messages when i start multipathd daemon :
Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
to table
Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath:
unknown hardware handler type
Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
to table
Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath:
unknown hardware handler type
Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
to table
Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath:
unknown hardware handler type
Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
to table
Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath:
unknown hardware handler type
Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
to table
Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath:
unknown hardware handler type
Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
to table
Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath:
unknown hardware handler type
Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target
to table
Aug 12 13:48:33 cluster3 multipathd: path checkers start up

If anyone can help, thanks in advance.

------=_Part_33867_28951856.1218534444255
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi<br>I have been strugling with an HP MSA1000 for a few weeks now.<br>I am using the old active/passive firmware.<br>Here is the device section of my multipath.conf :<br><br><pre>devices {<br>	device {<br>		vendor 		&quot;COMPAQ&quot;<br>
		product		&quot;MSA1000&quot;<br>		hardware_handler	&quot;1 hp_sw&quot;<br>		path_grouping_policy	group_by_prio<br>		path_checker	hp_sw<br> 			 		<br> 	}<br>}</pre><br>I am under RHEL5.2 and this is the rpm package of dm-multipath 0.4.7-16.el5.<br>
Here is my /var/log/messages when i start multipathd daemon :<br>Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table<br>Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath: unknown hardware handler type<br>
Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table<br>Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath: unknown hardware handler type<br>Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table<br>
Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath: unknown hardware handler type<br>Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table<br>Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath: unknown hardware handler type<br>
Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table<br>Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath: unknown hardware handler type<br>Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table<br>
Aug 12 13:48:33 cluster3 kernel: device-mapper: table: 253:19: multipath: unknown hardware handler type<br>Aug 12 13:48:33 cluster3 kernel: device-mapper: ioctl: error adding target to table<br>Aug 12 13:48:33 cluster3 multipathd: path checkers start up<br>
<br>If anyone can help, thanks in advance.<br><br></div>

------=_Part_33867_28951856.1218534444255--


--===============0880806398==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0880806398==--
