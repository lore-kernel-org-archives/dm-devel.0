From: Rudy Gevaert <Rudy.Gevaert@UGent.be>
Subject: unmapping luns doesn't work (good)
Date: Mon, 18 Oct 2010 17:24:19 +0200
Message-ID: <4CBC66A3.7020207@UGent.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
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

Hello list,

This is my first real experience with device mapper and multipath-tools.

I have several luns exported on an IBM 3400 to one host.

I have several problems when I unmap a lun:
1) If I don't remove the multipath (before I unmap) I can not remove (by 
force too) the multipath for that lun. (Note the lun is not mounted.)
2) Removing the multipath and then unmapping the lun works, but then 
doing a rescan of the bus **sometimes** gives me a new lun with name '1'.

Case 1:
-------
multipath -l

mail17r-ds3400-1 (3600a0b80005a67b6000004764cac4912) dm-2 IBM,1726-4xx 
FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=active
| `- 0:0:0:6 sde 8:64  active undef running
`-+- policy='round-robin 0' prio=-1 status=enabled
   `- 5:0:0:6 sdj 8:144 active undef running

root@cyrprd1:~# dmsetup table
mail17r-ds3400-1: 0 1153433600 multipath 1 queue_if_no_path 1 rdac 2 1 
round-robin 0 1 1 8:64 1000 round-robin 0 1 1 8:144 1000

I now remove mapping through the storage software.

root@cyrprd1:~# multipath -f mail14r-ds3400-1
Oct 18 17:07:09 | mail14r-ds3400-1: map in use

root@cyrprd1:~# multipath -l mail14r-ds3400-1
mail14r-ds3400-1 (3600a0b80005a591a000004294cac468b) dm-0 IBM,1726-4xx 
FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=enabled
| `- 5:0:0:2 sdg 8:96  failed undef running
`-+- policy='round-robin 0' prio=-1 status=enabled
   `- 0:0:0:2 sdb 8:16  failed undef running
root@cyrprd1:~#


Case 2:
--------
Sorry couldn't reproduce at the moment...



I'm running
kernel 2.6.32-5
multipath-tools 0.4.9-1
os: Debian Squeeze

Thanks!

Rudy
