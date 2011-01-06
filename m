From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [dm-devel] [PATCH v3 0/8] dm-raid (raid456) target
Date: Thu, 06 Jan 2011 10:56:07 -0500
Message-ID: <4D25E617.70509@cfl.rr.com>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com>	<20101221141443.5aea0b12@notabene.brown>	<20110105223628.GA13164@redhat.com> <20110106214645.2bd321f4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110106214645.2bd321f4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>, linux-raid@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On 1/6/2011 5:46 AM, NeilBrown wrote:
> 3:	<#raid_devs> <meta_dev1> <dev1> .. <meta_devN> <devN>

Let me get this straight.  You specify a separate device to hold the
metadata and write intent bitmap for each data device?  So for a 3 disk
raid 5, lvm will need to create two logical volumes on each of the 3
physical volumes, one of which will only be a single physical extent,
and will hold the raid metadata and write intent bitmap?

Why not just store the metadata on the main device like mdadm does today?
