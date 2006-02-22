From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 2/3] sysfs representation of stacked devices
	(dm) (rev.2)
Date: Wed, 22 Feb 2006 12:13:56 -0500
Message-ID: <43FC9BD4.1010901@ce.jp.nec.com>
References: <43FC8C00.5020600@ce.jp.nec.com> <43FC8D92.6010006@ce.jp.nec.com>
	<20060222163438.GC31641@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060222163438.GC31641@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>
List-Id: dm-devel.ids

Hi,

Alasdair G Kergon wrote:
 > This patch needs splitting up so that independent changes can be
 > considered separately.
 >
 > c.f. The proposal from Mike Anderson (repeated below) which I prefer
 > because it makes it clear that a table always belongs to exactly one md.

I like his proposed patch.
The interface is useful for my purpose too and moving table
creation inside _hash_lock means I don't need dm_get() neither.

Is it going to be pushed to upstream?
I'll remake my patch based on it.

-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.
