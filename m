From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: StorageWorks multipath support
Date: Wed, 15 Jun 2005 15:20:52 +0100
Message-ID: <20050615142052.GT4195@agk.surrey.redhat.com>
References: <20050615085634.GA16446@averon.dyndns.org>
	<20050615131520.GC11423@marowsky-bree.de>
	<20050615134536.GC16446@averon.dyndns.org>
	<20050615135337.GG11423@marowsky-bree.de>
	<20050615140740.GD16446@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050615140740.GD16446@averon.dyndns.org>
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

On Wed, Jun 15, 2005 at 04:07:40PM +0200, christophe varoqui wrote:
> Can you elaborate on what you have in mind ?
 
Listen on a socket in the filesystem?  [cf. what screen does]
And have a separate helper program that sends messages down it
similar to the uevent messages.

Alasdair
-- 
agk@redhat.com
