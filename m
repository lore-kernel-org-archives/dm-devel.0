From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: LVM2 tools<-->library<-->driver compatibility
Date: Tue, 16 May 2006 20:06:57 +0100
Message-ID: <20060516190657.GH16180@agk.surrey.redhat.com>
References: <4468D003.6010703@dogpad.net> <446A20E3.70500@dogpad.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <446A20E3.70500@dogpad.net>
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

On Tue, May 16, 2006 at 01:58:43PM -0500, Joe Harvell wrote:
> I am suspecting a driver <--> tools incompatibility:
 
> >on console (from dm-mod driver): device-mapper: one of name or uuid must
> >be supplied, cmd (12)

Make sure the device-mapper library version you're using with a 2.4 kernel 
is at least version 1.02.05.  (Some more backwards compatibility got added.)

Alasdair
-- 
agk@redhat.com
