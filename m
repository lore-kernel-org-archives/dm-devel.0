From: "David Strand" <dpstrand@gmail.com>
Subject: fdisk on a multipath device fails kernel partition re-read
Date: Fri, 28 Sep 2007 13:28:06 -0700
Message-ID: <448b15030709281328i104c04f0te6dd1ef333b825a3@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
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

When I perform an fdisk or sfdisk on a /dev/mapper/ multipath device I
get a warning about it failing to re-read the partition information.
With fdisk it warns that I'll need to reboot before using the device,
with sfdisk it just complains about the ioctl that failed:

Re-reading the partition table ...
BLKRRPART: Invalid argument

Is it possible I have something configured wrong? Or is this a problem
with the way /dev/mapper nodes work? I get the same result when using
/dev/dm-* nodes. With the raw device nodes such as /dev/sd* it works
ok.
