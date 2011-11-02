From: Milan Broz <mbroz@redhat.com>
Subject: Re: creating two device mapper files for an underline
 blockdevice
Date: Wed, 02 Nov 2011 08:57:35 +0100
Message-ID: <4EB0F7EF.603@redhat.com>
References: <CABMcfaMVsagfFdtg+f1eYR501wWSMbxsEAHTYD_5MTF1bABu0A@mail.gmail.com>
	<4EAFAE7A.7060000@redhat.com>
	<CABMcfaOiMfbz_amLkoSJ-zhRKCGCEhc1Em29NV5-02LiOPJYcQ@mail.gmail.com>
	<CABMcfaM6BuB=5r1Exq-PxuCLDifX7Qfuuq9ZXpF9QNXRbxvupA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABMcfaM6BuB=5r1Exq-PxuCLDifX7Qfuuq9ZXpF9QNXRbxvupA@mail.gmail.com>
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
Cc: Sanjana Shari <sanjana.linux@gmail.com>
List-Id: dm-devel.ids

On 11/01/2011 06:10 PM, Sanjana Shari wrote:
> Using the remaining of first half of the same blockdevice /dev/loop0.
> This seems to work. So I ma confused here how the mapping works..

There is no magic for linear mapping.
Imagine you have this mapping table

0 8 linear /dev/sdb 1000
8 8 linear /dev/sdc 500

It means you created 16 sectors device consisting of two segments.

First half (sectors 0-7) is mapped to /dev/sdb starting at sector 10000.
(IOW sectors 0-7 of newly mapped device is mapped to sectors 10000-10007 of /dev/sdb)

Second half (sectors 8-15) is mapped to /dev/sdc starting at sector 500.

See dmsetup man page, where linear mapping is described.
Just do not confuse source and destination device offset.

Milan
