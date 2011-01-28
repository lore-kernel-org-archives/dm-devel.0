From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: Doubt regarding dm-raid1
Date: Fri, 28 Jan 2011 11:38:41 -0800
Message-ID: <20110128193841.GA4616@us.ibm.com>
References: <AANLkTi=ryfEU9VOBE7qBaecWnJ93h9tdYt0cNb388vXC@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <AANLkTi=ryfEU9VOBE7qBaecWnJ93h9tdYt0cNb388vXC@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

nishant mungse [nishantmungse@gmail.com] wrote:
>    Hi Malahal
> 
>     Thanks for reply. I am not able to understand what  this
>     "INIT_WORK(&ms->kmirrord_work, do_mirror)" function does. It  is written
>     in mirror_ctr of dm-raid1. What i think is whenever a bio comes dm_mirror
>     will be called if that is case then why this is written in mirror_ctr.

INIT_WORK just initializes the work structure. When it is queued by calling
queue_work() (e.g. from wakeup_mirrord) the actual function do_mirror() gets
called. It is called in a different thread context though!

The following article is a bit outdated, but it gives what a work queue
is and its API:

http://lwn.net/Articles/23634/

Hope that helps,
Malahal.
