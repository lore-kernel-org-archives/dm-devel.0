From: Mike White <homebrewmike@yahoo.com>
Subject: defining paths with DDN 8500
Date: Wed, 12 Sep 2007 15:38:42 -0700 (PDT)
Message-ID: <43123.80742.qm@web51104.mail.re2.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
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

Hello dm-devel-

I'm working with the multipathing package and a DDN 8500.  I've been able=
 to
successfully configure  failover and failback.  The system is configured =
as
such:

    qla_port_1 ----  ctrl A port 4 ---- LUN 3 (LUN 7)
    qla_port_2 ----  ctrl B port 4 ---- LUN 7 (LUN 3)

Where LUN 3 is on a dedicated port to qla_port_1 and qla_port_2 is dedica=
ted to LUN 7.

The problem that I'm having is all the traffic is going through qla_port_=
1,
qla_port_2 appears to be sitting idle until a failover.

To compensate, I've been using dmsetup to force the qla_port_2 ---- LUN 7
path.

Is there a better way than using dmsetup to do this?  multipath isn't an
option, as it negatively impacts performance.

Thanks-
  -Mike
