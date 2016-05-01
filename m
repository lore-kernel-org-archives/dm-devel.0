From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 05/57] Add HP MSA 2040 to the hardware table
Date: Sun, 1 May 2016 23:30:55 +0200
Message-ID: <20160501233055.00002b9c@localhost>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-6-git-send-email-hare@suse.de>
	<20160429000605.00006561@localhost> <5722F736.1050404@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5722F736.1050404@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Sebastian Herbszt <herbszt@gmx.de>, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Hannes Reinecke wrote:
> On 04/29/2016 12:06 AM, Sebastian Herbszt wrote:
> > Hannes Reinecke wrote:
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>  libmultipath/hwtable.c | 15 +++++++++++++++
> >>  1 file changed, 15 insertions(+)
> > 
> > You missed adding it to multipath.conf.defaults.
> > 
> Yes, but we're about to phase them out anyway.
> Cf the recent discussion.

Looks like that part hid in the "multipath-0.5.0 still provides broken
udev rules" [1] thread. Thanks for the hint.

[1] https://www.redhat.com/archives/dm-devel/2016-April/msg00458.html

Sebastian
