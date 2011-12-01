From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Thu, 1 Dec 2011 14:12:36 +0000
Message-ID: <20111201141236.GB7595@agk-dp.fab.redhat.com>
References: <4EABE131.8010706@googlemail.com>
	<20111029204947.GU23336@agk-dp.fab.redhat.com>
	<CAEcBt+Ux+GVmm7zBeFA7k5PHOQoSKLTKcifB95ne5dBtX400dQ@mail.gmail.com>
	<4ED2DF0F.1070108@filteredperception.org>
	<CAEcBt+UEJXSY7oK+j0gw9fkzjnWOUcBFhPdXCVFe3HZNh6zOTw@mail.gmail.com>
	<4ED59040.50406@filteredperception.org>
	<CAEcBt+XxVh8b=TJu-Z+3XBL=K6LUhs2QZyeZKGMGh_Lp+UBGbA@mail.gmail.com>
	<20111130220259.GA7595@agk-dp.fab.redhat.com>
	<4ED6BD81.4090609@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4ED6BD81.4090609@filteredperception.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Douglas McClendon <dmc.lists@filteredperception.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 30, 2011 at 05:34:25PM -0600, Douglas McClendon wrote:
> So wouldn't it be much better as far as the user is concerned if, the  
> instant a snapshot reached capacity, it fell over into a read-only state  
> (instead of being marked invalid?), such that further corruption beyond  

That would mean your *origin* device becoming read-only as well.

It's been discussed before.  Nobody has been motivated to write the code,
as there's no need for it on a properly-managed system.

If you care enough about your snapshot contents, then surely you
would be monitoring it to make sure it doesn't fill up - and if you're
going to run out of space and can't expand, you would shut down your system
yourself in a *controlled* way *before* running out of space!

Alasdair
