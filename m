From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: missing tdata in lvm thin pool after low free space
Date: Sat, 24 Oct 2015 17:47:03 +0300
Message-ID: <CACaajQt_Px6_-b_E=-rJ59oJa6BV9Jecm9JeKkSBmC8oHyXZyw@mail.gmail.com>
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
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi. I'm using 3.19.3 kernel with lvm 2.02.124.
I miss that i'm oversell disk space and yesterday dmesg says that i
don't have free space and pool goes to read only. Server rebooted and
i'm try to extend pv and vg, and activate thin pool, but now i get
errors :
device-mapper: table: 254:55: sdd too small for target:
start=937657345, len=6053888, dev_size=937703088

Also dmsetup table output does not contain tdata volume. Only tmeta.
What steps i can do to to recovery this?
Thanks!

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
