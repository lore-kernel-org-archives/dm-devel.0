From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-raid: check events in super_validate
Date: Sat, 1 Mar 2014 07:54:13 -0600
Message-ID: <989868B6-C039-401E-96AA-F64B441A6E10@redhat.com>
References: <52ED0628.4030203@stratus.com> <20140225163020.6f299f15@notabene.brown> <DB09A2EA-5D6C-449F-A61A-EFF556F269B8@redhat.com> <530D17BF.7090008@stratus.com> <3E58643B-64BF-4A4B-9D44-3D075148FE80@redhat.com> <4A643D2E-04C2-462A-8CF8-9BB2A4DC38AE@redhat.com> <530E8418.50707@stratus.com> <7D5F856A-768B-458C-9ED2-812D49A635F3@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7D5F856A-768B-458C-9ED2-812D49A635F3@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Nate Dailey <nate.dailey@stratus.com>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>, Jonathan Brassow <jbrassow@redhat.com>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids


On Feb 28, 2014, at 2:40 PM, Brassow Jonathan wrote:

> The commit that fixed the problem was:
> f466722ca614edcd14f3337373f33132117c7612
> f466722 md: Change handling of save_raid_disk and metadata update during recover
> 
> I don't know if this is safe to independently apply to previous kernels or not yet.  Neil, do you know?
> 
> I have applied it directly to the 3.13 kernel and it solves the problem.  However, applying it to the 3.12 kernel does not solve the problem.  There is obviously something else I'm missing or the fuzziness of the patch on 3.12 is causing things to not behave as expected.

I was wrong.  After retesting, this commit /does/ fix the problem.  I've tested it all the way back to 3.10 and it fixes the problem.

Neil, would you be willing to have this patch go to stable?

 brassow