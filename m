From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/3] dm: a basic support for using the	select
	or poll function
Date: Thu, 11 May 2017 22:38:46 +0100
Message-ID: <20170511213846.GH6155@agk-dp.fab.redhat.com>
References: <20170509191028.6898-1-agrover@redhat.com>
	<20170509191028.6898-2-agrover@redhat.com>
	<1494495579.6093.10.camel@suse.com>
	<1494495801.6093.12.camel@suse.com>
	<20170511132134.GA10709@redhat.com>
	<01517603-ba44-bc02-8b70-96feef8050ed@redhat.com>
	<1494532154.6093.30.camel@suse.com>
	<20170511202103.GG6155@agk-dp.fab.redhat.com>
	<1494535527.6093.42.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1494535527.6093.42.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, Andy Grover <agrover@redhat.com>, mpatocka@redhat.com, snitzer@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, May 11, 2017 at 10:45:27PM +0200, Martin Wilck wrote:
> Except that it can cause userspace to miss events, as I tried to point
> out in my reply to Mike.

It should never miss new events.  Because the calls are separate,
occasionally it might trigger when it didn't need to, but userspace will
see nothing new happened and just go back into poll.  Combining the two
calls would avoid this, but the authors decided on balance it was
unnecessary.

I've already requested a libdevmapper/dmsetup implementation as a matter
of urgency so that everyone has easy command-line access to the new
features and example code and can test them - normally patches like
these shouldn't go upstream until a supported userspace implementation
is available.  Once we have this, questions like the ones you pose can
be checked practically.

Alasdair
