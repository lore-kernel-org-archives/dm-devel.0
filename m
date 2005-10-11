From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: Dm-devel ioctl-skip-lockfs patch
Date: Tue, 11 Oct 2005 16:10:39 +0100
Message-ID: <20051011151039.GC18611@agk.surrey.redhat.com>
References: <434A431C.1060208@poczta.fm> <434A7B35.9030903@poczta.fm>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <434A7B35.9030903@poczta.fm>
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

On Mon, Oct 10, 2005 at 04:31:17PM +0200, Hubert wrote:
> `do_suspend' was declared "int dm_lockfs = 1;" but  after all references 
> are  to the  variable "do_lockfs" whose is course undeclared.
 
Fixed.

Alasdair
-- 
agk@redhat.com
