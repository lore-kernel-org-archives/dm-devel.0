From: christophe.varoqui@free.fr
Subject: Re: [PATCH 0/4] Various small multipath-tools improvements
Date: Sat, 18 Apr 2009 19:41:07 +0200 (CEST)
Message-ID: <1728817154.2681491240076467124.JavaMail.root@zimbra16-e3.priv.proxad.net>
References: <1240006080-27892-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1240006080-27892-1-git-send-email-snitzer@redhat.com>
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

Hi Mike,
thank you for these patches.
Do you happen to have a fetchable git clone to ease integration ?

----- Mail Original -----
De: "Mike Snitzer" <snitzer@redhat.com>
=C3=80: dm-devel@redhat.com
Envoy=C3=A9: Samedi 18 Avril 2009 00h07:56 GMT +01:00 Amsterdam / Berlin =
/ Berne / Rome / Stockholm / Vienne
Objet: [dm-devel] [PATCH 0/4] Various small multipath-tools improvements

Just a few cleanup patches.

Mike Snitzer (4):
  multipath-tools: update scsi_id arguments
  multipath-tools: install libmultipath.so in $syslibdir
  multipath-tools: update multipathd.init.redhat
  multipath-tools: change default location for bindings file

 Makefile.inc                      |    1 +
 libmultipath/Makefile             |    6 +-
 libmultipath/defaults.h           |    4 +-
 libmultipath/hwtable.c            |    6 +-
 multipath.conf.annotated          |    6 +-
 multipath.conf.defaults           |   78 ++++++++++++++++++-------------=
-----
 multipath.conf.synthetic          |    4 +-
 multipath/Makefile                |    1 +
 multipath/multipath.conf.5        |    2 +-
 multipathd/multipathd.init.redhat |   30 +++++++--------
 10 files changed, 69 insertions(+), 69 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
