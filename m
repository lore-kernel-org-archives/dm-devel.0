From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 8/9] dm crypt: offload writes to thread
Date: Tue, 01 Apr 2014 21:08:56 +0200
Message-ID: <533B0EC8.3090004@gmail.com>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>	<1396037476-26595-9-git-send-email-snitzer@redhat.com>	<533AE8DC.5080004@redhat.com>
	<alpine.LRH.2.02.1404011355500.12362@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1404011355500.12362@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids

On 04/01/2014 08:01 PM, Mikulas Patocka wrote:
>> 1) mdadm -C -l 5 -n 3 -c 64 --assume-clean /dev/md0 /dev/sd[xyz]
>> 2) run 2/dmcrypt-all-verify.sh
> 
> I tried to run "./dmcrypt-all-verify.sh --dev /dev/md0 --testdir 
> /mnt/test" and the result was this.
> 
> That script is somehow buggy because it attempts to copy files that I have 
> in /usr/src to the test filesystem. It fills up the test filesystem and 
> fails. I don't know why is it trying to copy files not related to the test.

Hi Mikulas,

if it is the test I wrote years ago, it was in principle a hack,
I need some filesystem with a lot files of different sizes.

So I simply packed /usr and checked hash of all files before
and after unpacking to test dmcrypt device.

IMHO there should be some prepared archive which is just unpacked,
not that it uses live /usr.
(Obviously it need large enough device :-)

But anyway, despite it is quite stupid test, it already proved
to be very useful (I remember it discovered bugs in various patches
several times).

A IIRC it used several fs types and several encryption types
(including null encryption which removes crypto layer influence,
testing pure dmcrypt bio handling).

Milan
