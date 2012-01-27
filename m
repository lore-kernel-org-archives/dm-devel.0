From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: dd to a striped device with 9 disks gets much lower
 throughput when oflag=direct used
Date: Thu, 26 Jan 2012 17:06:42 -0800
Message-ID: <CACyXjPzWjBz0=btbL0Gx_qoxRQs7wy9m=dY1--xL29uszTpmFA@mail.gmail.com>
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

Hi,

Perhaps I am doing something stupid, but I would like to understand
why there is a difference in the following situation.

I have defined a stripe device thusly:

     "echo 0 17560535040 striped 9 8 /dev/sdd 0 /dev/sde 0 /dev/sdf 0
/dev/sdg 0 /dev/sdh 0 /dev/sdi 0 /dev/sdj 0 /dev/sdk 0 /dev/sdl 0 |
dmsetup create stripe_dev"

Then is did the following:

    dd if=/dev/zero of=/dev/mapper/stripe_dev bs=262144 count=1000000

and I got 880 MB/s

However, when I changed that command to:

    dd if=/dev/zero of=/dev/mapper/stripe_dev bs=262144 count=1000000
oflag=direct

I get 210 MB/s reliably.

The system in question is a 16 core (probably two CPUs) Intel Xeon
E5620 @2.40Ghz with 64GB of memory and 12 7200PRM SATA drives
connected to an LSI SAS controller but set up as a JBOD of 12 drives.

Why do I see such a big performance difference? Does writing to the
device also use the page cache if I don't specify DIRECT IO?

-- 
Regards,
Richard Sharpe
