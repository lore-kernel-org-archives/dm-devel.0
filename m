From: Sverd Johnsen <sverd.johnsen@googlemail.com>
Subject: Re: dmsetup create linear with 4 devices not possible?
Date: Mon, 20 Aug 2018 11:06:08 +0200
Message-ID: <CAGmahrQ_sD6tge+5Hz72za4aagxhbQCwF9P7zRV06OFVgbYfHQ@mail.gmail.com>
References: <CAGmahrTpAxpkq8DYNTC0osANpv6dBOPCHf2=qjXhqEZON=0mZg@mail.gmail.com>
	<b4886914-650c-777c-4210-828e7608b3a4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b4886914-650c-777c-4210-828e7608b3a4@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: zkabelac@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

[40309.478954] device-mapper: table: 254:15: linear: Invalid argument count

root@bar /tmp # vgchange -ay looptest
    Logging initialised at Mon Aug 20 11:00:05 2018
    Activating logical volume looptest/testing.
    activation/volume_list configuration setting not defined: Checking
only host tags for looptest/testing.
    Creating looptest-testing
    Loading table for looptest-testing (254:15).
    Resuming looptest-testing (254:15).
    Activated 1 logical volumes in volume group looptest
  1 logical volume(s) in volume group "looptest" now active

root@bar /tmp # dmsetup table /dev/mapper/looptest-testing
0 2088960 linear 7:0 2048
2088960 2088960 linear 7:1 2048
4177920 2088960 linear 7:2 2048
6266880 2088960 linear 7:3 2048

root@bar /tmp # dmsetup table /dev/mapper/looptest-testing > test.table

root@bar /tmp # vgchange -an looptest
    Logging initialised at Mon Aug 20 11:00:18 2018
    Deactivating logical volume looptest/testing.
    Removing looptest-testing (254:15)
    Deactivated 1 logical volumes in volume group looptest
  0 logical volume(s) in volume group "looptest" now active

root@bar /tmp # dmsetup create test --table test.table
Invalid format on line 1 of table .
Command failed.

root@bar /tmp # dmsetup create test --table "$(cat test.table)"
device-mapper: reload ioctl on test  failed: Invalid argument
Command failed.

root@bar /tmp # dmesg | tac | head -n2
[40309.478958] device-mapper: ioctl: error adding target to table
[40309.478954] device-mapper: table: 254:15: linear: Invalid argument count

root@bar /tmp # cat test.table
0 2088960 linear 7:0 2048
2088960 2088960 linear 7:1 2048
4177920 2088960 linear 7:2 2048
6266880 2088960 linear 7:3 2048
