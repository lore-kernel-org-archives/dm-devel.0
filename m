From: David Strand <dpstrand@gmail.com>
Subject: fragmented i/o with 2.6.31?
Date: Wed, 16 Sep 2009 08:34:35 -0700
Message-ID: <448b15030909160834j2b127c83jab163e1860fc9aa1@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I am issuing 512 Kbyte reads through the device mapper device node to
a fibre channel disk. With 2.6.30 one read command for the entire 512
Kbyte length is placed on the wire. With 2.6.31 this is being broken
up into 5 smaller read commands placed on the wire, decreasing
performance.

This is especially penalizing on some disks where we have prefetch
turned off via the scsi mode page. Is there any easy way (through
configuration or sysfs) to restore the single read per i/o behavior
that I used to get?
