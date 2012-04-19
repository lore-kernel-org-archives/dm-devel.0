From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [dm-devel] [PATCH 0 of 4] dm-raid: various bug fixes
Date: Wed, 18 Apr 2012 21:42:17 -0500
Message-ID: <A45751FA-10B9-4D1D-9D0B-3DA50E9BE1B1@redhat.com>
References: <1334716219.23908.14.camel@f14.redhat.com> <20120418134843.1376cc7e@notabene.brown> <3F107DB9-0ED6-47C5-9F5A-DF485017EA92@redhat.com> <A71FAACD-D1A7-4452-BDD3-5156DB9E5497@redhat.com> <20120419095808.323b01b0@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120419095808.323b01b0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids


On Apr 18, 2012, at 6:58 PM, NeilBrown wrote:

> On Wed, 18 Apr 2012 16:32:00 -0500 Brassow Jonathan <jbrassow@redhat.com>
> wrote:
> 
>> 
>> On Apr 18, 2012, at 9:05 AM, Brassow Jonathan wrote:
>> 
>>> 
>>> 5-of-5: changing the check to 'saved_raid_disk >= 0' would be fine, but I think I should initialize 'saved_raid_disk' to -1 in dm-raid.c then normally.  Right now, an nominal initial value is not set - meaning it is '0'.  (When a device comes back from a failure, 'saved_raid_disk' is assigned its old position.)
>> 
>> ... that's not quite right.  I do call 'md_rdev_init' which sets 'saved_raid_disk' to -1.  Then, if the device has returned after a disappearance, I set 'saved_raid_disk' to it's old position.  Therefore, 'saved_raid_disk >= 0' would be fine and wouldn't require me to set -1 in dm-raid.c.
>> 
>> brassow
>> 
> 
> Excellent.  I've taken the liberty of making that change in the patch you
> sent me and converted your RFC-by: to Signed-off-by:
> 
> Result can be viewed at or near the top of
> 
> http://neil.brown.name/git?p=md;a=shortlog;h=refs/heads/for-next
> 
> Please confirm that is OK to submit (eventually for 3.5).

Perfect, thank-you.

 brassow