From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-slow , a slow down dm ( dm-error alike )
Date: Tue, 10 Oct 2006 15:01:22 +0100
Message-ID: <20061010140122.GL17654@agk.surrey.redhat.com>
References: <2c53b31c0610061231k8b06a4dxce2cd3a9febed86@mail.gmail.com>
	<2c53b31c0610100644o75fe3d56v261752598faebe20@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2c53b31c0610100644o75fe3d56v261752598faebe20@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 10, 2006 at 03:44:03PM +0200, David Guyon Martin wrote:
> We need to slow down a disk access to be able to monitor some events,
> for testing.
 
Take a look at dm-delay.
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/

Alasdair
-- 
agk@redhat.com
