From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: PATCH - pvmove doesn't terminate sometimes on 64-bit
	bigendian machines
Date: Fri, 16 Sep 2005 18:32:40 +0100
Message-ID: <20050916173240.GF18976@agk.surrey.redhat.com>
References: <17191.43003.616513.15285@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <17191.43003.616513.15285@cse.unsw.edu.au>
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

On Wed, Sep 14, 2005 at 02:32:59PM +1000, Neil Brown wrote:
>  As these bitsets are host-endian and host-sized,
>  this means that they cannot safely be moved between computers with
>  different architectures.  

That needs to be fixed.

Alasdair
-- 
agk@redhat.com
