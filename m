From: "Charlie Sharkey" <charlie.sharkey@bustech.com>
Subject: multipathd  dead
Date: Mon, 23 Mar 2009 15:06:38 -0400
Message-ID: <03FB5D708BE3C8448E8079186A56CDE60111F3FE@BTIBURMAIL.bustech.com>
References: <d1392840903230844pe310cceya9160bcbe274b735@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <d1392840903230844pe310cceya9160bcbe274b735@mail.gmail.com>
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

=20

I have a question about multipathd. It starts up ok,
but later it's status says it is dead. It does show
an error (see below), but would this be enough to kill it ?

Also, is there any other log files besides the messages and
the boot.log files it logs to ?

Thank you,
 charlie

boot.msg file
<6>device-mapper: multipath: version 1.0.4 loaded
<6>device-mapper: multipath round-robin: version 1.0.0 loaded
<3>device-mapper: table: 253:9: multipath: error getting device
<4>device-mapper: ioctl: error adding target to table
