From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 17/24] dm cache: use a boolean when setting
 cache->quiescing
Date: Wed, 6 Nov 2013 10:25:52 -0500
Message-ID: <20131106152551.GA409@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-18-git-send-email-snitzer@redhat.com>
	<20131106150205.GB30597@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131106150205.GB30597@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 06 2013 at 10:02am -0500,
Alasdair G Kergon <agk@redhat.com> wrote:

> On Thu, Oct 24, 2013 at 02:30:30PM -0400, Mike Snitzer wrote:
> > From: Heinz Mauelshagen <heinzm@redhat.com>
> > 
> > Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> Please could we drop this one?
> 
> It looks pointless to me, with this one following:
>   dm cache: improve effciency of quiescing flag management

It was just a change for consistency that happened during the natural
flow of development.  Really didn't see a problem with preserving the
evolution of the code...

But sure, I can drop it.
