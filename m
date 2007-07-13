From: Brian De Wolf <bldewolf@csupomona.edu>
Subject: dm-mpath-rdac.patch problem
Date: Thu, 12 Jul 2007 18:35:07 -0700
Message-ID: <4696D6CB.6050504@csupomona.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

Hello All,

I'm not sure if this is the right place for this, but it seems to be the only
mailing list related to dm, multipath, and rdac, as far as I can tell.  I've
been trying out the dm-mpath-rdac patch (both yesterday's and previous) with
gentoo's unstable 2.6.22 kernel, on a Sun x4100 through a QLA2422 HBA (firmware
ql2400_fw.bin.4.00.27) to an IBM DS4000.  I am using a version of
multipath-tools that I got with git a few days ago.

I've got multipath working, it reports the hwhandler correctly ([hwhandler=1
rdac]), and the volume is mountable, etc.  It also shows one link as active, the
other as ghost.  However, once the active link dies, the volume becomes read
only, and both connections are listed as failed.  Most importantly, something
like this shows up in the logs:

Jul 12 17:11:15 jimbo kernel: device-mapper: multipath rdac: queueing
MODE_SELECT command on 8:32
Jul 12 17:11:15 jimbo kernel: qla2xxx 0000:02:01.1: ISP System Error - mbx1=0h
mbx2=8012h mbx3=8002h.
Jul 12 17:11:15 jimbo kernel: qla2xxx 0000:02:01.1: Firmware has been previously
dumped (ffffc2000171d000) -- ignoring request...
Jul 12 17:11:16 jimbo kernel: qla2xxx 0000:02:01.1: Performing ISP error
recovery - ha= ffff81007e85c530.
Jul 12 17:11:16 jimbo kernel: device-mapper: multipath: Failing path 8:32.
Jul 12 17:11:16 jimbo kernel: Buffer I/O error on device dm-6, logical block 0
Jul 12 17:11:16 jimbo kernel: Buffer I/O error on device dm-6, logical block 1
Jul 12 17:11:16 jimbo kernel: Buffer I/O error on device dm-6, logical block 2
Jul 12 17:11:16 jimbo kernel: Buffer I/O error on device dm-6, logical block 3
Jul 12 17:11:16 jimbo kernel: Buffer I/O error on device dm-6, logical block 0
Jul 12 17:11:16 jimbo multipathd: 8:32: mark as failed
Jul 12 17:11:16 jimbo multipathd: test: remaining active paths: 0

While this may be something for the maintainer of the qla2xxx module (I can't
figure out where I'd send it, in that case...) I think it may be of interest
that the dm_rdac module tries to push something over the HBA that causes it to
bail completely and start from scratch (it starts init processes and loading
firmware again).

Not to say that I'm not interested in any help getting this working, that is.
If you have any suggestions on how to get this working, I'd love to hear them.
I'm also willing to guinea pig some testing if you need it (This box still has a
bit before it will have to be put in use).  I may use redhat to ensure that it's
not just a broken HBA, but for the long run we would like it to join our gentoo
environment.

Thanks!
Brian De Wolf

PS- If the subject mislead you because you feel that this is just a qla2xxx
problem, I'm sorry for wasting your time.
