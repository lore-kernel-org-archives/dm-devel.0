From: Niki Waibel <niki.waibel@newlogic.com>
Subject: dmraid / initrd
Date: Thu, 10 Feb 2005 11:45:04 +0100 (CET)
Message-ID: <200502101045.j1AAj466014295@enterprise2.newlogic.at>
Reply-To: Niki Waibel <niki.waibel@newlogic.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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

i am new to this list, and my quest might be off
topic. but pls point me to the right place if this
is the wrong mailinglist.

i've already posted this to the fedora-devel-list,
but i've got no answer / no comment there.

is it planned to integrate dmraid into the initial
ramdisk of fc4? it is necessary to boot from some
serial ata controllers if they have the raid option
activated...

a simple >>dmraid -ay<< at the right position
of the boot script should be sufficient. maybe
some sata_XXX and dmraidXXX modules have to
be loaded before ...

thanks in advance, niki
--=20
niki w. waibel - system administrator @ newlogic technologies ag

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
