From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Dumb question
Date: Mon, 11 Apr 2005 20:07:22 +0100
Message-ID: <20050411190722.GP9049@agk.surrey.redhat.com>
References: <200504111501.40423.phillips@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200504111501.40423.phillips@redhat.com>
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

On Mon, Apr 11, 2005 at 03:01:40PM -0400, Daniel Phillips wrote:
> Here is a dumb question:  Why does dmsetup use (start, length) for each 
> target line instead of just (length)?  

We decided to require this:
  (a) to make the tables more readable in their raw form
  (b) as additional validation against bugs

> Is it useful to leave some parts 
> of a virtual device unmapped, and if so, why not require them to be 
> mapped explicitly to zero or error?
 
They must be.  Each line has to start where the previous one
ended or you are supposed to get an error.

Alasdair
-- 
agk@redhat.com
