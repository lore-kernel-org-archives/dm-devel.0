From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS without commits in the last 3 years
Date: Wed, 24 Aug 2016 16:33:45 -0700
Message-ID: <1472081625.3746.217.camel__36713.0559556701$1472110352$gmane$org@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
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
To: LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

Many email addresses in MAINTAINERS no longer work so many
sections in
MAINTAINERS could likely be considered either
obsolete or unmaintained.

Marking these sections appropriately or simply removing the
sections would make MAINTAINERS and get_maintainer.pl more
useful.

These M: entries in MAINTAINERS haven't authored or had any
<foo>-by: signature entries in git log for the last 3 years.

Some of these, like stable@kernel.org=A0and trivial@kernel.org, are
obviously addresses that should not be deleted from MAINTAINERS,
but most of them are candidates for removal or update.

The email addresses below are also bcc'd here to see what bounces.
The list of the bounces will be collected.

Thoughts?

aacraid@adaptec.com
aacraid@microsemi.com
achim_leubner@adaptec.com
adaplas@gmail.com
adilger.kernel@dilger.ca
aeb@cwi.nl
agraf@suse.com
ajk@comnets.uni-bremen.de
al@alarsen.net
aliakc@web.de
alistair@devzero.co.uk
aloisio.almeida@openbossa.org
andrew.d.henroid@intel.com
andrew.hendry@gmail.com
andrewtv@usa.net
anil.s.keshavamurthy@intel.com
arhuaco@freaks-unidos.net
arvino55@gmail.com
ath9k-devel@qca.qualcomm.com
ballabio_dario@emc.com
bcm-kernel-feedback-list@broadcom.com
bernie@plugable.com
billm@melbpc.org.au
brijohn@gmail.com
brking@us.ibm.com
brucechang@via.com.tw
castet.matthieu@free.fr
ccaulfie@redhat.com
cezary.jackiewicz@gmail.com
chaoming_li@realsil.com.cn
charrer@alacritech.com
chessman@tux.org
chrisw@sous-sol.org
coda@cs.cmu.edu
colin@colino.net
courmisch@gmail.com
dept-gelinuxnicdev@qlogic.com
dept-hsglinuxnicdev@qlogic.com
device@lanana.org
dh.herrmann@googlemail.com
dirk@opfer-online.de
dm-devel@redhat.com
dmitry.tarnyagin@lockless.no
don@syst.com.br
dot@dotat.at
douglas_warzecha@dell.com
dougthompson@xmission.com
drwyrm@gmail.com
dsaxena@plexity.net
dsd@gentoo.org
duncan.sands@free.fr
egor@pasemi.com
eibach@gdsys.de
eparis@parisplace.org
erik.andren@gmail.com
everest-linux-l2@qlogic.com
faith@cs.unc.edu
fero@drama.obuda.kando.hu
fischer@norbit.de
fizban@tin.it
florian.c.schilhabel@googlemail.com
florianschandinat@gmx.de
forest@alittletooquiet.net
frank@f-seidel.de
fujita.tomonori@lab.ntt.co.jp
funaho@jurai.org
gilles.muller@lip6.fr
gotom@debian.or.jp
guillaume.ligneul@gmail.com
gustavo@padovan.org
hal.rosenstock@gmail.com
haraldwelte@viatech.com
henk.vergonet@gmail.com
herton@canonical.com
hlhung3i@gmail.com
hskinnemoen@gmail.com
hswong3i@gmail.com
hubert.feurstein@contec.at
ibm-acpi@hmh.eng.br
inaky.perez-gonzalez@intel.com
infinipath@intel.com
ink@jurassic.park.msu.ru
intel-linux-scu@intel.com
ionut@badula.org
jansimon.moeller@gmx.de
jarkko.lavinen@nokia.com
jarod@wilsonet.com
jayakumar.alsa@gmail.com
jayalk@intworks.biz
jcliburn@gmail.com
jdike@addtoit.com
j.dumon@option.com
jejb@parisc-linux.org
jens.taprogge@taprogge.org
jeremy@goop.org
jes@trained-monkey.org
jic23@cam.ac.uk
jirislaby@gmail.com
jjciarla@raiz.uncu.edu.ar
jochen@scram.de
joern@lazybastard.org
johan.hedberg@gmail.com
john@johnmccutchan.com
jonathan@buzzard.org.uk
jon.nettleton@gmail.com
josh.h.morris@us.ibm.com
jpr@f6fbb.org
jreuter@yaina.de
jrv@vanzandt.mv.com
jtp.park@samsung.com
juergh@gmail.com
juhlenko@akamai.com
kas@fi.muni.cz
kernel@savoirfairelinux.com
kevin.curtis@farsite.co.uk
khnz@gmx.de
kirk@reisers.ca
klassert@mathematik.tu-chemnitz.de
kou.ishizaki@toshiba.co.jp
kune@deine-taler.de
kuznet@ms2.inr.ac.ru
laforge@gnumonks.org
laforge@openezx.org
lauro.venancio@openbossa.org
lcostantino@gmail.com
ldm@flatcap.org
lenb@kernel.org
lenehan@twibble.org
linasvepstas@gmail.com
linux-driver@qlogic.com
linuxdrivers@attotech.com
linux-graphics-maintainer@vmware.com
linux-kernel@hansmi.ch
linux-net-drivers@solarflare.com
linuxraid@lsi.com
linux@simtec.co.uk
linuxwifi@intel.com
linux-wimax@intel.com
liodot@gmail.com
liqin.linux@gmail.com
mac@melware.de
maintainers@bluecherrydvr.com
malidp@foss.arm.com
manohar.vanga@gmail.com
mark.brown314@gmail.com
matthew@wil.cx
maxk@qti.qualcomm.com
mbroemme@plusserver.de
mcgrof@gmail.com
mchehab@kernel.org
mdharm-usb@one-eyed-alien.net
mdr@sgi.com
m.hulsman@tudelft.nl
miguel.ojeda.sandonis@gmail.com
mike@compulab.co.il
miquel@df.uba.ar
mitch@sfgoth.com
mitr@volny.cz
mj@ucw.cz
mkpetch@internode.on.net
mostrows@earthlink.net
mpm@selenic.com
mporter@kernel.crashing.org
mr.swami.reddy@ti.com
neepatel@cisco.com
nic_swsd@realtek.com
ning.sun@intel.com
nyc@holomorphy.com
oakad@yahoo.com
ok@artecdesign.ee
o.lorin@laposte.net
osst@riede.org
pantelis.antoniou@gmail.com
paulus@au.ibm.com
petr@vandrovec.name
pfg@sgi.com
pgaikwad@nvidia.com
philb@gnu.org
pleb@gelato.unsw.edu.au
pof@eslack.org
pv-drivers@vmware.com
qla2xxx-upstream@qlogic.com
qlogic-storage-upstream@qlogic.com
ravi@jetztechnologies.com
riverful.kim@samsung.com
riyer@nvidia.com
rlove@rlove.org
rminnich@sandia.gov
rml@tech9.net
ron.mercer@qlogic.com
royale@zerezo.com
rubini@unipv.it
safford@us.ibm.com
sakoman@gmail.com
samuel@sortiz.org
santosh@chelsio.com
scott@spiteful.org
security@kernel.org
sfrench@samba.org
shiraz.linux.kernel@gmail.com
shuah@kernel.org
simon@thekelleys.org.uk
slapin@ossfans.org
spock@gentoo.org
spyro@f2s.com
starblue@users.sourceforge.net
stefan.eletzhofer@eletztrick.de
stefan@openezx.org
sujith.thomas@intel.com
support.opensource@diasemi.com
takedakn@nttdata.co.jp
t-bone@parisc-linux.org
thomas@winischhofer.net
tie-fei.zang@freescale.com
tigran@aivazian.fsnet.co.uk
till@harbaum.org
tim@cyberelk.net
tony.olech@elandigitalsystems.com
tpmdd@selhorst.net
unglinuxdriver@microchip.com
vbordug@ru.mvista.com
vegardno@ifi.uio.no
venza@brownhat.org
vishwas.a.deshpande@ti.com
vitb@kernel.crashing.org
wanlong.gao@gmail.com
w.d.hubbs@gmail.com
wensong@linux-vs.org
xeb@mail.ru
xfs@oss.sgi.com
xiubo.lee@gmail.com
yokota@netlab.is.tsukuba.ac.jp
zaga@fly.cc.fer.hr
zambrano@broadcom.com
zwanem@gmail.com
zw@zh-kernel.org
