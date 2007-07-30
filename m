From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: CVS pull of device mapper
Date: Mon, 30 Jul 2007 12:03:03 -0700
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC012B36D4@orsmsx418.amr.corp.intel.com>
References: <1185821641.4547.5.camel@linux-cxyg>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1185821641.4547.5.camel@linux-cxyg>
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

Hello everyone, I've just built a test system with Fedora 7 and am
having a problem with running dmeventd after getting the latest pull
from the CVS tree. From the "make" and "make install" commands
everything is error free, but when I run the dmeventd daemon I get this
error:

/sbin/dmeventd: error while loading shared libraries:
libdevmapper-event.so.1.02: cannot open shared object file: No such file
or directory

I've looked in /lib and there is an instance of
libdevmapper-event.so.1.02 (and a symbolic link named
libdevmapper-event.so), so I'm confused as to why the daemon can't find
them? When I run configure the only parameters I'm passing in are
"--enable-debug" and "--enable-dmeventd"

Thank you,=20

Brian Wood
Intel Corporation=20
Digital Enterprise Group
Manageability & Platform Software Division
brian.j.wood@intel.com
