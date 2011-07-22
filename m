From: Milan Broz <mbroz@redhat.com>
Subject: Re: dm-crypt: add mapping table option to allowing
	discard requests
Date: Fri, 22 Jul 2011 12:58:31 +0200
Message-ID: <4E2957D7.3080709@redhat.com>
References: <1310644590-14438-1-git-send-email-mbroz@redhat.com>
	<4E1F9023.5020801@deserettechnology.com>
	<20110715011311.GA27697@redhat.com>
	<4E2945B8.10303@deserettechnology.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4E2945B8.10303@deserettechnology.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jeff@deserettechnology.com
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 07/22/2011 11:41 AM, Jeff Cook wrote:
> First of all, I attempted to apply these patches to 3.0-rc6 and HEAD
> (slightly after 3.0-rc7) and they did not apply cleanly. I was able to
> get a correct application once, but then the compile failed, assumedly
> due to a mispatching. Now that 3.0 has been tagged, should I assume that
> the patches will apply cleanly to that tree? I tried both manual patch
> via /usr/bin/patch and git apply. I suppose I can just wait for 3.1-rc1
> if I must.

So better wait for rc1, patch is already in linux-next.
My original patch was not using new table parsing function so I have
no idea which patches need to be backported now.

> Secondly, I am not sure how I go about modifying the crypt table mapping
> to activate the discard pass-through option.

You can compile upstream cryptsetup, I already added flag to support discard.

But there is intentional library version bump because I removed old api symbols
and also I want to implement some features before new version is released,
so use with care - it is not stable code yet.
 
> I recognize that Milan's commit message indicates support is missing in
> cryptsetup -- does this mean that a patch must be written to cryptsetup
> before the new option can be activated or can this be accessed by the
> lower-level dmsetup tool?

You can use dmsetup for now, I sent description how to do that to dmcrypt
list. http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/5166

> I almost didn't buy a SSD due to the lack of TRIM support in
> dm-crypt. :)

TRIM is incredibly overrated:-)

Milan
