From: Greg Stark <stark@mit.edu>
Subject: lvconvert leaves devices unsynced and unpolled?
Date: Fri, 31 Jul 2015 02:58:54 +0100
Message-ID: <CAM-w4HNTNmipaB6sqEjQReT_KbuQLL=NLJz6pv2V0-JaJxOUMQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Is this list the right place to report LVM bugs? I know dm is not LVM
but I'm not clear whether there's a separate reporting channel.

I've used lvconvert a few times to do --replace and also -m to add
addtional raid mirrors. And now I'm left with some drives 0% synced.
The 0% doesn't seem to be increasing. Doing lvchange --poll y on these
volumes doesn't cause anything to happen either. Is this normal? Is
this just some missing feedback and the sync is happening (it doesn't
sound like it listening to the drives) or is there some incantation I
should do to get the sync to happen? I even tried lvchange --resync on
one of the volumes and I didn't see any progress.


# lvs  -o +lv_image_synced,lv_merging,lv_converting,raid_sync_action
  LV        VG   Attr       LSize   Pool Origin Data%  Meta%  Move Log
Cpy%Sync Convert ImgSynced  Merging    Converting SyncAction
  bits      bits rwi-aor---  50.00g
0.00                                              idle
  boot      bits rwi-a-r---   1.00g
100.00                                            idle
  home      bits rwi-aor--- 200.00g
100.00                                            idle
  music     bits rwi-aor---  75.00g
100.00                                            idle
  oldroot   bits rwi-a-r---   2.00g
100.00                                            idle
  ox2_fat32 bits rwi-aor--- 149.05g
0.00                                              idle
  ox_fat16  bits rwi-a-r---  80.00m
0.00                                              idle
  ox_linux1 bits rwi-aor---  30.65g
0.00                                              idle
  ox_linux2 bits rwi-aor---  76.29g
0.00                                              idle
  ox_ntfs   bits rwi-a-r---  38.31g
0.00                                              idle
  swapc     bits -wi-ao----   4.00g
  tmp       bits rwi-aor---   1.00g
100.00                                            idle
  usr       bits rwi-aor---  16.00g
100.00                                            idle
  var       bits rwi-aor---   8.00g
100.00                                            idle



-- 
greg
