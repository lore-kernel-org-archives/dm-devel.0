From: "Victoria A Smith" <vasmith@sandia.gov>
Subject: bindings file; rename WWID to mpath alias
Date: Mon, 26 Apr 2010 13:58:50 -0600
Message-ID: <4BD5F07A.7040005@sandia.gov>
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

After a system crash I have filesystem access problems when
the multipathd service is started.  I noticed in the messages file
and in output from multipath -ll that an alias is not being
used:

messages:  [...] rename 350002ac002c506cc to mpath18

# multipath -ll
[...]
350002ac002c506cc dm-12 3PARdata,VV

# ls -1 /dev/mpath/
350002ac002c506cc
mpath10
[...]


The bindings file has:
[...]
mpath18 350002ac002c506cc


Can the apparent failure of the alias-to-WWID mapping cause any problems?


RHEL5.5
2.6.18-194.el5
device-mapper-multipath-0.4.7-34.el5
QLogic Fibre Channel HBA Driver: 8.03.01.04.05.05-k


Thanks,

Victoria
