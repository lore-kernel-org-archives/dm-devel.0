From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [lvm-devel] [PATCH] Remove redundant if-before-free
	tests.
Date: Thu, 14 Feb 2008 14:55:26 +0000
Message-ID: <20080214145526.GF29914@agk.fab.redhat.com>
References: <871w7fit3o.fsf@rho.meyering.net> <87lk5nhdob.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87lk5nhdob.fsf@rho.meyering.net>
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

On Thu, Feb 14, 2008 at 02:26:28PM +0100, Jim Meyering wrote:
> Same for dm, but here there are only 3:

2 of which are in obsolete code - don't change those
(the dir will get dropped when we combine the trees);
the other of which is in unfinished & unreviewed code
(yes, change that one)

Alasdair
-- 
agk@redhat.com
