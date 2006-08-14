From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH and question]: dm-table should check for valid
	queue
Date: Mon, 14 Aug 2006 19:12:20 +0100
Message-ID: <20060814181220.GT18633@agk.surrey.redhat.com>
References: <44DB1884.7070800@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <44DB1884.7070800@de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stefan Bader <Stefan.Bader@de.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 10, 2006 at 01:29:08PM +0200, Stefan Bader wrote:
> But what effect should a missing queue have? Same
> as device is congested or not or let the call fail somehow?
 
I'm curious - under what circumstances is this missing:
Is it intentional, or is it perhaps a race that needs fixing?

Alasdair
-- 
agk@redhat.com
