From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: Re: [RFC][PATCH] dm-mirror: fix data corruption
Date: Wed, 09 Sep 2009 16:18:45 -0400
Message-ID: <4AA80DA5.7080709@redhat.com>
References: <4A568333.6090901@redhat.com>	<Pine.LNX.4.64.0907100939060.568@hs20-bc2-1.build.redhat.com>	<Pine.LNX.4.64.0907100947320.2450@hs20-bc2-1.build.redhat.com>	<4A5790C5.90508@redhat.com>	<Pine.LNX.4.64.0907130547530.27968@hs20-bc2-1.build.redhat.com>	<20090830192441.GA641@us.ibm.com>
	<Pine.LNX.4.64.0908311737090.16318@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0908311737090.16318@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas,

On 08/31/09 17:39, Mikulas Patocka wrote:
> I uploaded patches for this bug at: 
> http://people.redhat.com/mpatocka/patches/kernel/mirror-race/
> 
> But note! They were never tried. When I wanted to try them, I found out 
> that dmeventd is totally nonworking in upstream code (it doesn't pass 
> "handle_errors" argument and has some crashes and signal errors), so I 
> didn't test them with dmeventd. Dmeventd must be fixed first, then we can 
> work on this bug.

Thank you for posting the patch set. I roughly looked at your patch and
have several comments.

 - The flag, "handle_errors," won't be passed to dm-raid1 by dmeventd. lvm
   commands (e.g. vgchange) or dmsetup pass "handle_errors" when new mirror
   mapping is created.

 - As I mentioned before, bios which are sent to out-of-sync regions also
   need to be blocked because bios to out-of-sync regions are processed by
   generic_make_request() and would return the "success" to upper layer
   without dm-raid1 notices it. This might cause data corruption.
   https://www.redhat.com/archives/dm-devel/2009-July/msg00118.html

 - The modification of write_callback() looks a little confusing to me.
   Do all bios need to be blocked? When all legs returns error, the bio
   should be returned with -EIO to upper layer without being blocked as
   original code using uptodate flag.

I appreciate your comments.

Thanks,
Taka

-- 
Takahiro Yasui
Hitachi Computer Products (America), Inc.
