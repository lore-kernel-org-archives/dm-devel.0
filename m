From: Thomas Witzel <witzel.thomas@gmail.com>
Subject: configure MD3000 episode 2
Date: Fri, 20 Mar 2009 20:54:27 -0400
Message-ID: <d1392840903201754g119199d1u5b3863ba3a96abad@mail.gmail.com>
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

I have a Dell NX1950 with a MD3000 running ubuntu server 8.04 . With
the help of this list I managed to configure the RAID etc. However
there is one remaining problem. udev doesn't seem to recognize this
setup. After every reboot I have to manually create the /dev/dm-*
devices with mknod and run kpartx to make the partitions show up. Can
someone please hint to me where I get the appropriate udev scripts ?
Ubuntu does have dmapper and multipath related scripts in the udev
directory, but they don't seem to be working for me.

Thank you so much,
Thomas Witzel
