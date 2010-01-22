From: Mikulas Patocka <mpatocka@redhat.com>
Subject: lvchange --monitor n uses "block_on_error"
Date: Fri, 22 Jan 2010 10:56:31 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1001221049480.5923@hs20-bc2-1.build.redhat.com>
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi

In RHEL 5.5, when executing "lvchange --monitor n -ay vg2/test_long", 
dmevetd is not started, but lvm still passes "block_on_error" flag to 
dm-raid1 target.

The table looks like this.
vg2-test_long: 0 65536 mirror disk 3 253:4 1024 block_on_error 2 253:5 0 
253:6 0

I think it is a bug that can cause deadlocks, because if dmeventd doesn't 
handle the failure and "block_on_error" flag is used the I/Os are blocked 
forever.

Should I file a RHEL bug for this? Or do you have some other explanation 
for it?

LVM version:     2.02.56(1)-RHEL5 (2009-11-24)
Library version: 1.02.39-RHEL5 (2009-11-11)
Driver version:  4.11.5

Mikulas
