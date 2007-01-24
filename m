From: devzero@web.de
Subject: Re: bug in dm-loop? - was:Re: Re: device mapper
Date: Wed, 24 Jan 2007 19:24:53 +0100
Message-ID: <1581640279@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
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
To: breeves@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

hi!

>With ~3000 of them active concurrently on a machine with 256M of RAM,
>I'm not that surprised that you hit this limit!

ok, not a problem - my cd-rom server has some more ram and i will probably never reach that big number of CD`s in the near future.

>Again, to keep things simple in the prototype, we grab the biggest
>possible table size when we create a new device and then re-allocate it
>to the correct size when we finish building the map - that's what the
>"Finalized extent map of 56 bytes, 2 entries." messages refer to.

may this be a reason why dmlosetup seems to be much slower than traditional losetup?
i did some tests with some larger images (100m, 1gig and 2,5gig) and dmlosetting them up took quite a while.....


>If debugging was enabled when the module was built, you should also see
>messages like:
>loop: [DEBUG] setup_loop_extents:Allocated initial extent map of 57352
>bytes, 2048 entries.
>
>It's these initial large allocations that are causing the errors you see.

ahh, good to know !

>The code's pretty dumb in this area at the moment - improving memory
>allocation and the time spent looking up entries in the table are our
>current goals for dm-loop.

what you tell is perfectly in sync with what i observed. fine that you want to adress this! :)


>the code will fail if it needs >2048 table entries to describe the file
>- - depending on the filesystem used and how fragmented it is this will
>limit you to files of a few gigabytes. This is another arbitrary limit
>in this version that will go away in later dm-loop releases.

indeed, it looks like there is a real hard 2gb limit - i wasn`t able to dmlosetup the 2,5gig files i created

anyway - good things will need some time.
so i`m just sitting here , waiting for the next versions(s) :)

regards
roland

_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066
