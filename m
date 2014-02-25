From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] dm-raid: check events in super_validate
Date: Tue, 25 Feb 2014 16:59:18 -0600
Message-ID: <3E58643B-64BF-4A4B-9D44-3D075148FE80@redhat.com>
References: <52ED0628.4030203@stratus.com> <20140225163020.6f299f15@notabene.brown> <DB09A2EA-5D6C-449F-A61A-EFF556F269B8@redhat.com> <530D17BF.7090008@stratus.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530D17BF.7090008@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


On Feb 25, 2014, at 4:22 PM, Nate Dailey wrote:

> Here's what I've done to reproduce this:
> 
> - remove a disk containing one leg of an LVM raid1 mirror
> - do enough IO that a lengthy recovery will be required
> - insert the removed disk
> - let recovery begin, but deactivate the LV before it completes
> - activate the LV
> 
> This is the point where the recovery should start back up, but it doesn't. I haven't tried this in a few weeks, but am happy to try it again if it would help.

Confirmed (test output below).  I'll get started on this.  This code can be a bit tricky and I've been away from it for a while.  It will take me a bit to re-familiarize myself with it and review your patch.

thanks,
 brassow


[root@bp-02 ~]# lvs -a -o name,attr,size,sync_percent vg
  LV               Attr       LSize   Cpy%Sync
  raid1            Rwi-a-r--- 300.00g   100.00
  [raid1_rimage_0] iwi-aor--- 300.00g         
  [raid1_rimage_1] iwi-aor--- 300.00g         
  [raid1_rmeta_0]  ewi-aor---   4.00m         
  [raid1_rmeta_1]  ewi-aor---   4.00m         
[root@bp-02 ~]# off.sh sda
Turning off sda
[root@bp-02 ~]# dd if=/dev/zero of=/dev/vg/raid1 bs=4M count=10000
10000+0 records in
10000+0 records out
41943040000 bytes (42 GB) copied, 147.139 s, 285 MB/s
[root@bp-02 ~]# on.sh sda
Turning on sda
[root@bp-02 ~]# lvs -a -o name,attr,size,sync_percent vg
  LV               Attr       LSize   Cpy%Sync
  raid1            Rwi-a-r-r- 300.00g   100.00
  [raid1_rimage_0] iwi-aor-r- 300.00g         
  [raid1_rimage_1] iwi-aor--- 300.00g         
  [raid1_rmeta_0]  ewi-aor-r-   4.00m         
  [raid1_rmeta_1]  ewi-aor---   4.00m         
[root@bp-02 ~]# lvchange --refresh vg/raid1
[root@bp-02 ~]# lvs -a -o name,attr,size,sync_percent vg
  LV               Attr       LSize   Cpy%Sync
  raid1            Rwi-a-r--- 300.00g     0.00
  [raid1_rimage_0] Iwi-aor--- 300.00g         
  [raid1_rimage_1] iwi-aor--- 300.00g         
  [raid1_rmeta_0]  ewi-aor---   4.00m         
  [raid1_rmeta_1]  ewi-aor---   4.00m         
[root@bp-02 ~]# lvs -a -o name,attr,size,sync_percent vg
  LV               Attr       LSize   Cpy%Sync
  raid1            Rwi-a-r--- 300.00g     0.29
  [raid1_rimage_0] Iwi-aor--- 300.00g         
  [raid1_rimage_1] iwi-aor--- 300.00g         
  [raid1_rmeta_0]  ewi-aor---   4.00m         
  [raid1_rmeta_1]  ewi-aor---   4.00m         
[root@bp-02 ~]# lvchange -an vg
[root@bp-02 ~]# lvchange -ay vg; lvs -a -o name,attr,size,sync_percent vg
  LV               Attr       LSize   Cpy%Sync
  raid1            Rwi-a-r--- 300.00g   100.00
  [raid1_rimage_0] iwi-aor--- 300.00g         
  [raid1_rimage_1] iwi-aor--- 300.00g         
  [raid1_rmeta_0]  ewi-aor---   4.00m         
  [raid1_rmeta_1]  ewi-aor---   4.00m         