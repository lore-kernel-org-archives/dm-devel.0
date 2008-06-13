From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: NetBSD libdevmapper port
Date: Fri, 13 Jun 2008 18:34:13 +0100
Message-ID: <20080613173413.GO20826@agk.fab.redhat.com>
References: <7F5B52C7-1511-49C8-B81A-D4D58E6B12F3@gmail.com>
	<Pine.LNX.4.64.0806131236500.32455@engineering.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806131236500.32455@engineering.redhat.com>
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
Cc: tech-kern@netbsd.org, Adam Hamsik <haaaad@gmail.com>
List-Id: dm-devel.ids

On Fri, Jun 13, 2008 at 12:51:48PM -0400, Mikulas Patocka wrote:
> This suspend thing was a big misdesign and if you are writing it from 
> scratch, try to avoid it.
 
Despite how things might seem, we gained some substantial
simplifications by doing things this way and I reject the term
'misdesign':-)  If writing this from scratch under similar time
constraints, we would still handle this a similar way.

But this suspend/resume mechanism was never intended to last as long as
it has - it was meant to be a stepping stone to a more-sophisticated
transaction mechanism that we have still not found time to develop,
mostly because this existing mechanism is "good enough" most of the
time.

Alasdair
-- 
agk@redhat.com
