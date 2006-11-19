From: devzero@web.de
Subject: Re: device mapper integrated loops - and one more year !
Date: Sun, 19 Nov 2006 12:30:05 +0100
Message-ID: <1439173022@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
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

Hello !

after desparately seeking for a solution to have more than 256 loop devic=
es (for a huge cd-rom server), i have recently come across dm-loop, which=
 looks very promising (to replace loop.c)

can i have more than 256 devices which this?

our cd-rom server is going to have more than 256 iso-images soon and i ne=
ed to upgrade to a more recent OS, anyway, so this won`t be a problem tha=
t dm-loop is so brand new.

but - any timeline for dm-loop mainline inclusion ?

should i wait for 2.6.19 or 2.6.20 ?

is it already useable with less recent kernels, i.e. can i download dm-lo=
op patch and recent dmsetup tool and use with older kernel ?

i really would like to give it a try - no problem if there are still bugs=
 inside, because i`d happily test and report if there are bugs left.

regards
Roland K.
systems engineer


_______________________________________________________________________
Viren-Scan f=FCr Ihren PC! Jetzt f=FCr jeden. Sofort, online und kostenlo=
s.
Gleich testen! http://www.pc-sicherheit.web.de/freescan/?mc=3D022222
