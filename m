From: Hubert <hubgor@poczta.fm>
Subject: Progress on LVM2 snapshots - kernel 2.6.x
Date: Tue, 06 Sep 2005 18:52:43 +0200
Message-ID: <431DC95B.7070102@poczta.fm>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
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

Hello,

What is latest status of  LVM2 lvcreate/lvremove snapshots with kernel 
2.6.x series ?
Why if i'm under copying some data from remote host to smb share on my 
server with lvm2 logical volume and 1 or 2 snashots which is/are filled 
 > 1% and at the same time lvremove snapshot then it cause "segmentation 
fault" and after that all read/write commands to that lv e.g. cp hangs up ?

With reference to:
"
In the meantime, you can apply the snapshot patches in the -udm
tree and use 'dmsetup' manually to activate and deactivate snapshots
when lvm2 fails.

Patches 8 and 9 at:

ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/2.6.12-rc2/2.6.12-rc2-udm1/ 

(Further patches are needed, but those two plus correct dmsetup use
should avoid machine lockups.)

Alasdair
"
what does it mean "correct use of dmsetup tool" and when it should be 
used: before and after lvcreate or lvremove snapshot or with both ?

Thanks all for any response,
Best regards,

Hubert
hubgor@poczta.fm


----------------------------------------------------------------------
Startuj z INTERIA.PL! >>> http://link.interia.pl/f186c 
