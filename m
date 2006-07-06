From: ganja <ganja@0x63.nu>
Subject: Problem with cryptsetup/device-mapper
Date: Thu, 06 Jul 2006 09:52:04 +0200
Message-ID: <44ACC124.2040609@0x63.nu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Hello all, I am having some problems setting up a crypted device, and to=20
me it seems to have with device mapper to do. I have loaded what modules=20
I know is necessary as you can see below and I have tried different=20
devices and pure files (ex /tmp/myimage which I created with dd=20
if=3D/dev/urandom).

I am running Debian Unstable and I have tested it with 1-2 week old=20
packages and fully upgraded. I also talked to google for an hour, be he=20
wasnt very nice to me, found no valuable information at all.

Any help appreciated.
(please CC me, I am not subscribed)


thor:/tmp# cryptsetup -y -c aes -s 256 create hda1aes /dev/hda1
Enter passphrase:
Verify passphrase:
Command failed: device-mapper: reload ioctl failed: Invalid argument

thor:/tmp# lsmod
Module                  Size  Used by
dm_crypt               10056  0
aes                    28736  0
hptmv                 198660  14
nvidia               4543700  12
sr_mod                 13476  0
dm_mod                 50200  3 dm_crypt
raid5                  32448  4
xor                    16072  1 raid5
raid1                  21824  0
raid0                   8064  0
md_mod                 70612  7 raid5,raid1,raid0
loop                   13576  0
sata_promise            9348  12
ata_piix                9668  12
libata                 60300  2 sata_promise,ata_piix
uhci_hcd               20552  0
e1000                 109624  0
sd_mod                 16832  41

thor:/tmp# uname -a
Linux thor 2.6.17 #1 SMP PREEMPT Mon Jun 19 15:51:08 CEST 2006 i686=20
GNU/Linux

thor:/tmp# dmesg|tail -n3
device-mapper: crypt: Device lookup failed
device-mapper: error adding target to table
device-mapper: device doesn't appear to be in the dev hash table.

thor:/tmp# tail /var/log/messages -n2
Jul  6 09:45:50 localhost kernel: device-mapper: error adding target to=20
table
Jul  6 09:45:50 localhost kernel: device-mapper: device doesn't appear=20
to be in the dev hash table.

--
Magnus M=E5nsson
