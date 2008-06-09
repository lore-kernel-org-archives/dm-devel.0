From: "January Weiner" <january@uni-muenster.de>
Subject: Questin about device mapper, Debian and devices
Date: Mon, 9 Jun 2008 12:08:51 +0200
Message-ID: <454237550806090308j20a29e58w7dc22b89ce055e5@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hello,

I am running a server with Debian stable. After a recent automatic
update and an unrelated reboot suddenly I could not mount some of my
hard disks any more. For example,

mount /dev/sda1 /mnt

gave me

mount: /dev/sda1 already mounted or /mnt busy

It took me quite a while to figure out that it is the device mapper
that makes /dev/sda1 busy. For whatever reason, there are now the
files /dev/dm-0, /dev/dm-1 and /dev/dm-2 that correspond to /dev/sda,
/dev/sda1 and /dev/sda2. I assume they have been created by the dev
mapper. The server has been running for ages, has a relatively complex
setup and has been through a number of configurations. However, I
never really used dev mapper.

My questions are as follows:

1) does dev mapper somehow automatically gets hold of my /dev/sda, or
is there a configuration file somewhere (maybe a stale configuration
that got used after the update? I used to have an lvm, but I got rid
of it. Never on purpose used multipath-tools or dm-crypt). My
suspicion is that it is due to multipath, as multipath -l shows

3600d0230006c1c550bdc214a99d0c000dm-0 Transtec,PV610F16R1B
[size=3D2.7T][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
 \_ 3:0:0:0 sda 8:0   [active][undef]

...but I never told multipath to do that! Running multipath -v 3 -l
shows that there are some disks that are "blacklisted":

cciss!c0d0: blacklisted
cciss!c0d1: blacklisted
dm-0: blacklisted
dm-1: blacklisted
dm-2: blacklisted
fd0: blacklisted
...

Are they blacklisted automatically or is there a way to do it manually?

2) how do I switch off device mapper for /dev/sda*? I just want to use
my plain /dev/sda1 and /dev/sda2. I don't want to change any of my
working configuration, I am happy with what it is now. For now, I have
mounted /dev/dm-1 and /dev/dm-2, but I don't understand them and what
I don't understand I don't want :-). I tried to deinstall dmsetup and
multipath-tools and running /etc/init.d/multipath-tools stop, but
without success.

3) what would be a reason to keep these /dev/dm-* mappings? multipath i/o=
?

4) next time -- how do I find out what is using /dev/sda1? I only
figured out what is going on by looking at /proc/partitions; no
standard tools that I normally use (fuser, lsof, lsmod etc.) did not
report anything curious.

Best regards,

j.


--=20
---------Dr. January Weiner 3 ---------------------+---------------
Division of Bioinformatics, University of Muenster | Schlo=DFplatz 4
(+49)(251)8321634 | D48149 M=FCnster
http://www.uni-muenster.de/Evolution/ebb/ | Germany
