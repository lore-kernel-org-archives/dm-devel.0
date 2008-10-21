From: "Hofmeister, James (WTEC Linux)" <james.hofmeister@hp.com>
Subject: RHEL-5.1-ia64 gfs/rhcs clvm pvcreate to wrong multipath
	device names
Date: Tue, 21 Oct 2008 19:55:56 +0000
Message-ID: <EC61DD7B6048464AB0E1B713AF7521BC1656C2EA11@GVW0676EXC.americas.hpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Folks,

RE: RHEL-5.1-ia64 gfs/rhcs clvm pvcreate to wrong multipath device names.

I have a customer who did their pvcreate to the /dev/dm-n device names in=
stead of the /dev/mapper/mpathN device names which is incorrect as per ht=
tp://kbase.redhat.com/faq/FAQ_96_11196.shtm.

After some investigation, I believe this leads to cases where 'some" of t=
he gfs file system built on the lvols can't be mounted in this cluster.

We are also seeing cases where a cluster node rhcs startup will stall sho=
rtly after starting cman on bootup or manually once the node is up.

The question is:  Is there a procedure to modify an existing clvm physica=
l volume to replace the /dev/dm-n device name with the correct /dev/mappe=
r/mpathN device name?

I have had this same question come up for customers who are migrating fro=
m a non-multipath or QLogic failover solution where they have specified /=
dev/sd[*] and now need to use the /dev/mapper/mpathN device name's.

My customer is looking for a solution that is less painful than to backup=
 their data, purge and rebuild the lvm2 PV's, VG's, LV's & gfs and then r=
estore their data.  In my search I have not found a solution, I am hoping=
 I am just lacking in sufficient caffeine and that some one out here will=
 have quick (obvious) answer that I missed.

Regards,
James Hofmeister
Hewlett Packard Linux Solutions Engineer
