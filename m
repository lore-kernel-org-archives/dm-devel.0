From: E V <eliventer@gmail.com>
Subject: 4.4-rc4 multipath not working?
Date: Fri, 11 Dec 2015 12:23:14 -0500
Message-ID: <CAJtFHURrhfUqpqo8RLFRwJV55eAV68q62r71aHpvNH_J_Q=hLA@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Just tried booting 4.4-rc4 on a system with using the mptsas driver:
LSISAS3008: FWVersion(03.00.08.00), ChipRevision(0x02), BiosVersion(05.07.02.00)

And multipath doesn't seem to be working, dmesg has lots of these:

device-mapper: table: 254:2: multipath: unknown path selector type
device-mapper: ioctl: error adding target to table

Is it expected to work? and any suggestions on getting it to work,

Thanks,
-Eli
