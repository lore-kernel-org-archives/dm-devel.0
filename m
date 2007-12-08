From: Bob Bell <Bell_Robert@emc.com>
Subject: dmsetup load not working?
Date: Sat, 8 Dec 2007 11:24:40 -0500
Message-ID: <20071208162439.GA3964@newbie.thebellsplace.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

I'm using a SLES10 SP1 x86_64 system, and I'm been using dmsetup 
intensively for the first time.  From what I can tell, `dmsetup load` 
just doesn't seem to work; it doesn't seem to have any effect.

Below is the simplest case I could think to come up with to illustrate 
this issue.  Could anyone help me here?  Am I doing something wrong?

brick14b:~ # dd if=/dev/zero of=loopfile bs=1M count=100
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 0.269968 seconds, 388 MB/s
brick14b:~ # losetup /dev/loop1 loopfile
brick14b:~ # dmsetup create loop --table "0 $(blockdev --getsize /dev/loop1) linear /dev/loop1 0"
brick14b:~ # dmsetup create loop2 --notable
brick14b:~ # dmsetup table loop
0 204800 linear 7:1 0
brick14b:~ # dmsetup table loop2

brick14b:~ # dmsetup table loop | dmsetup load loop2
brick14b:~ # echo $?
0
brick14b:~ # dmsetup table loop2

brick14b:~ # dmsetup info loop2
Name:              loop2
State:             ACTIVE
Tables present:    INACTIVE
Open count:        0
Event number:      0
Major, minor:      253, 11
Number of targets: 0

brick14b:~ # 

-- 
Bob Bell
