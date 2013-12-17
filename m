From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: multipath-tools 0.5.0 release
Date: Tue, 17 Dec 2013 23:48:15 +0100
Message-ID: <CABr-GndXSLfbpTZNVCEY9FEdd8kFSsTN1QonhORFqfVPXfL2Uw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0090643322634144883=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0090643322634144883==
Content-Type: multipart/alternative; boundary=001a11c2fafe5b369604edc2b98c

--001a11c2fafe5b369604edc2b98c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

List,

multipath-tools 0.5.0 is released.

The tarball can be fetched at
http://christophe.varoqui.free.fr/multipath-tools/multipath-tools-0.5.0.tar=
.bz2

I won't try to list 3 years of commits since the last release. Anyway, most
changes are old news since distributors provide recent master snapshots.

Major features include:

- scsi3 persistent reservations on multipaths
- systemd integration
- better udev integration (get device events and ids from udev)
- kpartx support for non-512b blocksize disks
- multipathd maintenance of important kernel tunable like oom_score_adj,
dev_loss_tmo and fast_io_fail
- followover failback mode
- handle offline paths and quiesced rports
- more synthetic and informative logs
- better threading and performance
- tons of bugfixes and stability improvements

Thanks to the numerous contributors of this release :

1 Anton Blanchard
1 Arkadiusz Miskiewicz
1 Bart Van Assche
1 Cedric Buissart
1 Chaskiel Grundman
1 Craig
1 Eli Qiao
1 Gerhard Wichert
1 glevand
1 Guangyu Sun
1 Guido G=C3=BCnther
1 Heath Kehoe
1 Jerome Levy
1 Kacper Kowalik
1 Konrad Rzeszutek
1 Leonardo Chiquitto
1 Martin George
1 Mateusz P=C3=B3=C5=82rola
1 Mike Snitzer
1 Olivier Lambert
1 Peter Gervai
1 Phileas Fogg
1 Sven Joachim
1 Tim Harder
1 Vijay Chauhan
1 Wang Sheng-Hui
1 Xinghai Yu
1 Xose Vazquez Perez
1 Zheng Huai Cheng
2 Ankit Jain
2 Aruna Balakrishnaiah
2 Christof Schmitt
2 hegdevasant
2 Mike Christie
2 Oren Held
2 Stewart, Sean
3 Malahal Naineni
3 Phillip Susi
3 Sean Stewart
4 bmarzins@sourceware.org
4 Chauhan, Vijay
4 Petr Uzel
4 Ritesh Raj Sarraf
5 Jun'ichi Nomura
5 Michael Witten
11 Moger, Babu
33 Christophe Varoqui
111 Benjamin Marzinski
282 Hannes Reinecke

Christophe Varoqui
www.opensvc.com

--001a11c2fafe5b369604edc2b98c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">List,<div><br></div><div>multipath-tools 0.5.0 is released=
.</div><div><br></div><div>The tarball can be fetched at=C2=A0<a href=3D"ht=
tp://christophe.varoqui.free.fr/multipath-tools/multipath-tools-0.5.0.tar.b=
z2">http://christophe.varoqui.free.fr/multipath-tools/multipath-tools-0.5.0=
.tar.bz2</a></div>
<div><br></div><div>I won&#39;t try to list 3 years of commits since the la=
st release. Anyway, most changes are old news since distributors provide re=
cent master snapshots.</div><div><br></div><div>Major features include:</di=
v>
<div><br></div><div>- scsi3 persistent reservations on multipaths</div><div=
>- systemd integration</div><div>- better udev integration (get device even=
ts and ids from udev)</div><div>- kpartx support for non-512b blocksize dis=
ks</div>
<div>- multipathd maintenance of important kernel tunable like=C2=A0oom_sco=
re_adj, dev_loss_tmo and=C2=A0fast_io_fail</div><div>- followover failback =
mode</div><div>- handle offline paths and quiesced rports</div><div>- more =
synthetic and informative logs</div>
<div>- better threading and performance</div><div>- tons of bugfixes and st=
ability improvements</div><div><br></div><div>Thanks to the numerous contri=
butors of this release :</div><div><br></div><div><div>1 Anton Blanchard</d=
iv>
<div>1 Arkadiusz Miskiewicz</div><div>1 Bart Van Assche</div><div>1 Cedric =
Buissart</div><div>1 Chaskiel Grundman</div><div>1 Craig</div><div>1 Eli Qi=
ao</div><div>1 Gerhard Wichert</div><div>1 glevand</div><div>1 Guangyu Sun<=
/div>
<div>1 Guido G=C3=BCnther</div><div>1 Heath Kehoe</div><div>1 Jerome Levy</=
div><div>1 Kacper Kowalik</div><div>1 Konrad Rzeszutek</div><div>1 Leonardo=
 Chiquitto</div><div>1 Martin George</div><div>1 Mateusz P=C3=B3=C5=82rola<=
/div><div>1 Mike Snitzer</div>
<div>1 Olivier Lambert</div><div>1 Peter Gervai</div><div>1 Phileas Fogg</d=
iv><div>1 Sven Joachim</div><div>1 Tim Harder</div><div>1 Vijay Chauhan</di=
v><div>1 Wang Sheng-Hui</div><div>1 Xinghai Yu</div><div>1 Xose Vazquez Per=
ez</div>
<div>1 Zheng Huai Cheng</div><div>2 Ankit Jain</div><div>2 Aruna Balakrishn=
aiah</div><div>2 Christof Schmitt</div><div>2 hegdevasant</div><div>2 Mike =
Christie</div><div>2 Oren Held</div><div>2 Stewart, Sean</div><div>3 Malaha=
l Naineni</div>
<div>3 Phillip Susi</div><div>3 Sean Stewart</div><div>4 <a href=3D"mailto:=
bmarzins@sourceware.org">bmarzins@sourceware.org</a></div><div>4 Chauhan, V=
ijay</div><div>4 Petr Uzel</div><div>4 Ritesh Raj Sarraf</div><div>5 Jun&#3=
9;ichi Nomura</div>
<div>5 Michael Witten</div><div>11 Moger, Babu</div><div>33 Christophe Varo=
qui</div><div>111 Benjamin Marzinski</div><div>282 Hannes Reinecke</div></d=
iv><div><br></div><div>Christophe Varoqui</div><div><a href=3D"http://www.o=
pensvc.com">www.opensvc.com</a></div>
<div><br></div></div>

--001a11c2fafe5b369604edc2b98c--


--===============0090643322634144883==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0090643322634144883==--
