From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [git pull] device-mapper patches for 2.6.33-rc1
Date: Tue, 15 Dec 2009 10:42:18 +0200
Message-ID: <20091215084218.GT16033@reaktio.net>
References: <20091211000548.GS6208@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091211000548.GS6208@agk-dp.fab.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 11, 2009 at 12:05:48AM +0000, Alasdair G Kergon wrote:
> Please pull from:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/agk/linux-2.6-dm.git master
> 
> to get device-mapper fixes and enhancements for inclusion in 2.6.33-rc1.
> 
> The main new feature is support for merging the changes held in a
> snapshot back into the original device.  Barriers are now supported
> by all the types of dm devices.
> 

Nice! barrier support is a good thing.
Any plans to backport these to RHEL5 ?

-- Pasi
