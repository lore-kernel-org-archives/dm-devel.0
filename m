From: nishant mungse <nishantmungse@gmail.com>
Subject: How to test the read/write flow of dm-target.
Date: Thu, 27 Jan 2011 21:06:05 -0800
Message-ID: <AANLkTimQjYdRqLFpuystxuN5hM=rGirj9XBiA_zDkG7+@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

I've created a device mapper target and I wanna test its read and
write mechanisms. I created a device using this target and tried to
write a filesystem on to the device.

My target is creating roughly two outgoing bios per incoming bio.
Which is maybe why I'm not able to get a proper log after running the
mke2fs command as while writing the filesystem, there are massive
amounts of writes performed on the device.

So, I tried to use the cat command to directly write to the device
file. The write is being performed for sure because I'm able to view
the data written to the underlying device.

But there is no output when I try to read the device file contents using cat.

Is there any other way to test the read/write workflows of a dm target
that can give out a proper log ?

Regards,
Nishant.
