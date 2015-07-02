From: Ilya Basin <basinilya@gmail.com>
Subject: thin metadata raw backup
Date: Thu, 2 Jul 2015 16:22:21 +0300
Message-ID: <1857391099.20150702162221@gmail.com>
Reply-To: Ilya Basin <basinilya@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello.

Can you help me with creating pool metadata backups (raw, not xml)? I
wanted to simply use `dd if=/dev/mapper/vg_xxx-pool_tmeta`, but the
copies are always dirty on a heavily loaded machine.

Running `thin_check device` prints no error.

Silly attempt:

    [root@oktest-stage-db-1 ~]# dmsetup message /dev/mapper/vg_oktestdb1-pool 0 "reserve_metadata_snap"
    device-mapper: message ioctl on vg_oktestdb1-pool failed: Invalid argument
    Command failed

`dmsetup suspend` didn't help too:

    [root@oktest-stage-db-1 ~]# dev=/dev/mapper/vg_oktestdb1-pool_tmeta
    [root@oktest-stage-db-1 ~]# (
    > dd bs=8192 if="$dev" status=none of=/dev/null
    > dmsetup suspend "$dev"
    > dd bs=8192 if="$dev" status=none of=test1
    > dmsetup resume "$dev"
    > )
    [root@oktest-stage-db-1 ~]# thin_check test1
    examining superblock
    examining devices tree
    examining mapping tree
      thin device 29 is missing mappings [911084, 941316]
        the last key of the previous leaf was 932618 and the first key of this leaf is 912369the last key of the previous leaf was 932618 and the first key of this leaf is 913257the last key of the previous leaf was 932618 and the first key of this leaf is 913401the last key of the previous leaf was 932618 and the first key of this leaf is 919481

        
