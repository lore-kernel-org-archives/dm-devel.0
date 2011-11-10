From: Harsha Sabbineni <harsha.kgp@gmail.com>
Subject: device-mapper: table: 253:4: multipath: error attaching
	hardware handler
Date: Wed, 9 Nov 2011 21:40:11 -0800
Message-ID: <CAKeJUxLNMp0u6xmUEpjOoUsLS=sam+TbPY-tDWJexSzRHU4kSg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2589929492030566342=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============2589929492030566342==
Content-Type: multipart/alternative; boundary=14dae93b62c884fbf304b15ad6e5

--14dae93b62c884fbf304b15ad6e5
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I am seeing this error with multipath-tools
device-mapper-multipath-0.4.9-23.0.9.el5 and 2.6.32-200.20.1.el5uek

device-mapper: table: 253:4: *multipath: error attaching hardware handler*
device-mapper: ioctl: *error adding target to table*


multipath.conf has this. I am trying to use rdac.

devices {
  device {
     vendor                  "*"
     product                 "*"
     features                "1 queue_if_no_path"
     hardware_handler        "1 rdac"
     path_selector           "round-robin 0"
     path_grouping_policy    group_by_prio
     failback                immediate
     rr_weight               uniform
     no_path_retry           20
     rr_min_io               1000
     path_checker            rdac
     prio                    rdac
  }
}

I have tried doing multipath -F and then restarting multipathd but the
error does not go away.
Is this a bug thats been fixed in later versions by any chance?

thanks in advance,
Harsha

--14dae93b62c884fbf304b15ad6e5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi, <br><br>I am seeing this error with multipath-tools device-mapper-multi=
path-0.4.9-23.0.9.el5 and 2.6.32-200.20.1.el5uek<br><br>device-mapper: tabl=
e: 253:4: <b>multipath: error attaching hardware handler</b><br>device-mapp=
er: ioctl: <b>error adding target to table</b><br>
<br><br>multipath.conf has this. I am trying to use rdac.<br><br>devices {<=
br>=A0 device {<br>=A0=A0=A0=A0 vendor=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 &quot;*&quot;<br>=A0=A0=A0=A0 product=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 &quot;*&quot;<br>=A0=A0=A0=A0 features=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &quot;1 queue_if_no_path&quot;<br>
=A0=A0=A0=A0 hardware_handler=A0=A0=A0=A0=A0=A0=A0 &quot;1 rdac&quot;<br>=
=A0=A0=A0=A0 path_selector=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &quot;round-robin =
0&quot;<br>=A0=A0=A0=A0 path_grouping_policy=A0=A0=A0 group_by_prio<br>=A0=
=A0=A0=A0 failback=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 immediate<b=
r>=A0=A0=A0=A0 rr_weight=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 uniform<=
br>
=A0=A0=A0=A0 no_path_retry=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 20<br>=A0=A0=A0=A0=
 rr_min_io=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 1000<br>=A0=A0=A0=A0 p=
ath_checker=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rdac<br>=A0=A0=A0=A0 prio=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rdac<br>=A0 }<br>}<b=
r><br>I have tried doing multipath -F and then restarting multipathd but th=
e error does not go away. <br>
Is this a bug thats been fixed in later versions by any chance?<br><br>than=
ks in advance,<br>Harsha<br>

--14dae93b62c884fbf304b15ad6e5--


--===============2589929492030566342==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2589929492030566342==--
