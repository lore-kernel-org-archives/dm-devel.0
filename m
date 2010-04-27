From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: semop failed for cookie?
Date: Tue, 27 Apr 2010 23:33:23 +0100
Message-ID: <20100427223323.GB29708@agk-dp.fab.redhat.com>
References: <4BD74F99.8020605@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4BD74F99.8020605@filteredperception.org>
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
Cc: Sebastian Dziallas <sdz@sugarlabs.org>, satellit@bendbroadband.com
List-Id: dm-devel.ids

On Tue, Apr 27, 2010 at 03:56:57PM -0500, Douglas McClendon wrote:
> I have a user of an installation tool of mine that is hitting this  
> message, with a very recent pre-fedora-13 kernel.

udev is now involved in this process.
Check they have up-to-date lvm2 and udev packages and that they've not
tried to customise their udev rules - if they have, you'll need to
check their changes didn't break things.

Big script.

Debug it by adding lines to dump the state immediately before the problem
command, then immediately after it.

Dump state by running 'dmsetup info -c', 'dmsetup table', 'dmsetup status'
and 'dmsetup udevcookies'.

If that still doesn't help, break the 'dmsetup create' command down into
its three constituent commands (dmsetup create --notable, dmsetup load,
dmsetup resume) and dump the state between each of them and confirm
which is failing.

Alasdair
