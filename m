From: Daire Byrne <daire.byrne@gmail.com>
Subject: Re: Shared snapshot tests
Date: Mon, 10 May 2010 12:39:21 +0100
Message-ID: <AANLkTikVrvzk1YWXjfS_vGcHsp_R9jyclFgT31H6F2z9@mail.gmail.com>
References: <20100415182356.GN13021@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.1004200207170.24170@hs20-bc2-1.build.redhat.com>
	<h2l131780341004211054p6e3cb893xb5dcb38ed2a9fceb@mail.gmail.com>
	<Pine.LNX.4.64.1005042334530.16138@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1005042334530.16138@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, May 5, 2010 at 4:39 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> See the patch that I sent you. Does it improve performance for NON-shared
> snapshots? (eventually, I'll make the same change to shared snapshots too)

The server and RAID I had for testing has now been used for something
else so I am unable to do any more tests atm.

> BTW. what disks and raid array do you use? Is it a hardware or software
> raid?

Hardware (Infortrend) RAID.

> I have found that with Maxtor disks (IDE, SATA and SCSI), you have to
> limit the request size to 256kB, or you get unpredictable performance
> drops.

I played with the request size but it made little difference.

>> Out of interest what are Redhat's plans for this feature? Will it be
>> in RHEL6 or is it going to wait until it is accepted upstream and then
>> make it into some later Fedora release? Could it be easily backported
>> to RHEL5 do you think?
>
> Not in RHEL 6.0. Maybe in 6.1.
>
> It's not planned to backport to 5.x.

Okay. Thanks. I will try and test this again when I get some hardware.

Daire
