From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: device mapper integrated loops - and one more year !
Date: Thu, 5 Oct 2006 20:40:05 +0100
Message-ID: <20061005194005.GO17654@agk.surrey.redhat.com>
References: <2c53b31c0610050726o47e6784en417de93b98d15e50@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2c53b31c0610050726o47e6784en417de93b98d15e50@mail.gmail.com>
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

On Thu, Oct 05, 2006 at 04:26:54PM +0200, David Guyon Martin wrote:
> Do you think dm could have a loop target instead of seting loops with
> losetup ?

Something like:
  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-loop.patch
now perhaps?

(And there are patches for dmsetup to become a drop-in losetup replacement.)

Alasdair
-- 
agk@redhat.com
